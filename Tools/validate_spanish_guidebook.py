#!/usr/bin/env python3
"""Validate structural parity of the es-ES Guidebook mirror.

Guidebook documents live at ``Resources/ServerInfo/Guidebook`` and are resolved
per culture by ``GuidebookDocumentResolver``: a document at
``Resources/ServerInfo/<culture>/Guidebook/<path>`` overrides the base one, and
a missing mirror silently falls back to English.

Translating a document must change visible prose only. Tag names, attributes,
inline markup, link targets and heading structure are contracts with the
renderer and with prototype data, so this tool compares them token by token.

The base tree is not strict XML (26 documents carry raw ``&`` or ``<`` in
prose), so parity is computed with tokenizers rather than an XML parser.

Pass --require-complete to require a Spanish mirror for every base document.
"""

from __future__ import annotations

import argparse
import re
import sys
from collections import Counter
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[1]
SERVER_INFO = REPO_ROOT / "Resources" / "ServerInfo"
BASE = SERVER_INFO / "Guidebook"
SPANISH = SERVER_INFO / "es-ES" / "Guidebook"

TAG_RE = re.compile(
    r"<\s*(?P<closing>/?)\s*(?P<name>[A-Za-z][\w.:-]*)"
    r"(?P<attrs>(?:\s+[\w.:-]+\s*=\s*\"[^\"]*\")*)"
    r"\s*(?P<selfclosing>/?)\s*>"
)
ATTR_RE = re.compile(r"(?P<name>[\w.:-]+)\s*=\s*\"(?P<value>[^\"]*)\"")
MARKUP_RE = re.compile(r"\[(?P<body>/?[A-Za-z][^\]]*)\]")
MARKUP_NAME_RE = re.compile(r"/?[A-Za-z][\w-]*")
HEADING_RE = re.compile(r"^\s*(?P<level>#{1,6})\s")
LINK_TARGET_RE = re.compile(r"(?<![\w-])link\s*=\s*\"(?P<target>[^\"]*)\"")

# Derived from the 300 mirrors the maintainer already translated: these two
# carry player-visible prose and legitimately diverge from the base document.
# Every other attribute and markup key is a renderer or prototype identifier
# and must survive translation byte for byte.
DISPLAY_ATTRIBUTES = frozenset({"Caption"})
DISPLAY_MARKUP_KEYS = frozenset({"textlink"})

# Rich-text tags the renderer understands. Anything else in square brackets is
# prose -- the base tree contains bracketed author notes such as
# "[INSERT HOW TO DO SO ...]" that translators are expected to render.
MARKUP_TAGS = frozenset({
    "bold",
    "bolditalic",
    "bolt",
    "bullet",
    "click",
    "color",
    "comp",
    "font",
    "head",
    "italic",
    "keybind",
    "member",
    "protodata",
    "textlink",
})


def tag_tokens(text: str) -> tuple[str, ...]:
    """Return the ordered element tokens, identifier attributes included."""

    tokens: list[str] = []
    for match in TAG_RE.finditer(text):
        attributes = sorted(
            f"{attr['name']}={attr['value']!r}"
            for attr in ATTR_RE.finditer(match.group("attrs"))
            if attr["name"] not in DISPLAY_ATTRIBUTES
        )
        shape = "/" if match.group("closing") else ("&" if match.group("selfclosing") else "")
        tokens.append(f"{shape}{match.group('name')}({' '.join(attributes)})")
    return tuple(tokens)


def markup_tokens(text: str) -> tuple[str, ...]:
    """Return the ordered inline markup tags, dropping their visible text."""

    tokens: list[str] = []
    for match in MARKUP_RE.finditer(text):
        body = match.group("body").strip()
        name_match = MARKUP_NAME_RE.match(body)
        if name_match is None:
            continue
        name = name_match.group(0)
        if name.lstrip("/").lower() not in MARKUP_TAGS:
            continue
        pairs = [
            f"{attr['name']}={attr['value']!r}"
            for attr in ATTR_RE.finditer(body)
            if attr["name"] not in DISPLAY_MARKUP_KEYS
        ]
        if pairs:
            tokens.append(f"{name}({' '.join(sorted(pairs))})")
            continue
        remainder = body[name_match.end():].strip()
        # Unquoted parameters such as [color=red] are renderer arguments.
        tokens.append(f"{name}{remainder}" if remainder and name not in DISPLAY_MARKUP_KEYS else name)
    return tuple(tokens)


def link_targets(text: str) -> tuple[str, ...]:
    """Return the ordered ``link="..."`` targets used by inline markup.

    The negative lookbehind keeps ``textlink="..."`` -- which is prose -- from
    being mistaken for a navigation target.
    """

    return tuple(
        match.group("target")
        for markup in MARKUP_RE.finditer(text)
        for match in LINK_TARGET_RE.finditer(markup.group("body"))
    )


def heading_levels(text: str) -> tuple[int, ...]:
    """Return the ordered heading depths declared in prose."""

    return tuple(
        len(match.group("level"))
        for line in text.splitlines()
        if (match := HEADING_RE.match(line)) is not None
    )


def compare_document(relative: Path, base: Path, translated: Path) -> list[str]:
    """Return every structural divergence between a base document and its mirror."""

    errors: list[str] = []
    display = relative.as_posix()
    raw = translated.read_bytes()
    if b"\r\n" in raw:
        errors.append(f"{display}: CRLF line endings are not allowed")
    try:
        actual = raw.decode("utf-8-sig")
    except UnicodeDecodeError as exc:
        errors.append(f"{display}: invalid UTF-8: {exc}")
        return errors

    expected = base.read_text(encoding="utf-8-sig")

    for field, extract in (
        ("elements", tag_tokens),
        ("inline markup", markup_tokens),
        ("link targets", link_targets),
        ("headings", heading_levels),
    ):
        expected_value = extract(expected)
        actual_value = extract(actual)
        if expected_value == actual_value:
            continue
        missing = sorted((Counter(expected_value) - Counter(actual_value)).elements())
        added = sorted((Counter(actual_value) - Counter(expected_value)).elements())
        if missing or added:
            errors.append(
                f"{display}: {field} differ: missing {missing!r}, unexpected {added!r}"
            )
        else:
            errors.append(f"{display}: {field} reordered relative to the base document")

    return errors


def validate(require_complete: bool = False) -> list[str]:
    """Return every Guidebook mirror violation found under the repository."""

    errors: list[str] = []
    if not BASE.is_dir():
        return [f"Falta el árbol base {BASE.relative_to(REPO_ROOT).as_posix()}."]

    base_documents = {path.relative_to(BASE): path for path in BASE.rglob("*.xml")}
    mirrors = {
        path.relative_to(SPANISH): path for path in SPANISH.rglob("*.xml")
    } if SPANISH.is_dir() else {}

    for relative, path in sorted(mirrors.items()):
        base = base_documents.get(relative)
        if base is None:
            errors.append(f"{relative.as_posix()}: no matching base document")
            continue
        errors.extend(compare_document(relative, base, path))

    if require_complete:
        missing = sorted(set(base_documents) - set(mirrors))
        errors.extend(
            f"{relative.as_posix()}: missing Spanish document" for relative in missing
        )

    return errors


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--require-complete",
        action="store_true",
        help="fail when a base Guidebook document lacks an es-ES mirror",
    )
    args = parser.parse_args()

    errors = validate(require_complete=args.require_complete)
    if errors:
        print("Spanish Guidebook validation failed:", file=sys.stderr)
        for error in errors:
            print(f"- {error}", file=sys.stderr)
        return 1

    base_documents = list(BASE.rglob("*.xml"))
    mirrors = list(SPANISH.rglob("*.xml")) if SPANISH.is_dir() else []
    print(
        "Spanish Guidebook structure is valid "
        f"({len(mirrors)} mirrored documents, {len(base_documents)} base documents)."
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
