#!/usr/bin/env python3
"""Inventory player-visible literal text embedded in prototype YAML.

The report is intentionally conservative and heuristic. It does not rewrite YAML.
Entity ``name`` and ``description`` fields are considered localized when an
``ent-<prototype>`` Fluent message (and ``.desc`` attribute respectively) exists
in ``Resources/Locale/es-ES``. Other literal fields remain review candidates.
Generated custom-construction prototypes are excluded by design.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import re
import unicodedata
from dataclasses import asdict, dataclass
from pathlib import Path
from typing import Iterable

import yaml

REPO_ROOT = Path(__file__).resolve().parents[1]
PROTOTYPES = REPO_ROOT / "Resources" / "Prototypes"
SPANISH = REPO_ROOT / "Resources" / "Locale" / "es-ES"
DEFAULT_OWNERS = ("_CMU14", "_AU14", "_RMC14")

VISIBLE_KEYS = {
    "briefing",
    "description",
    "desc",
    "displayName",
    "deployPopup",
    "femalePrefix",
    "initialPopup",
    "label",
    "malePrefix",
    "message",
    "name",
    "objective",
    "packedPopup",
    "panelPopup",
    "popup",
    "prefix",
    "reason",
    "rules",
    "text",
    "title",
    "toolPopup",
}
REVIEWED_NON_VISIBLE_FIELDS = {
    ("announcementPreset", "description"),
    ("inventoryTemplate", "displayName"),
    ("inventoryTemplate", "name"),
    ("microwaveMealRecipe", "name"),
}
REVIEWED_NON_VISIBLE_COMPONENT_FIELDS = {
    ("GiveHands", "name"),
}
RANK_FIELDS = {
    "name": "value",
    "prefix": "prefix",
    "malePrefix": "prefix-male",
    "femalePrefix": "prefix-female",
}
SCOPED_LITERAL_COMPONENTS = {
    "AdminLog",
    "ANPRCRadio",
    "ANPRCAntenna",
    "AttachableToggleablePreventShoot",
    "AU14CashVendor",
    "BlackfootDeployableSupport",
    "BlackfootPackableSupport",
    "CMAutomatedVendor",
    "DamageOverTime",
    "FaxMachine",
    "GhostRole",
    "IntelTechTree",
    "ItemSlots",
    "NavMapBeacon",
    "RequisitionsComputer",
    "Scope",
    "TechAnnounceEvent",
    "UniversalPaperTool",
    "VehicleSupplyConsole",
}
LITERAL_COMPONENT_ALIASES = {
    "CMItemSlots": "ItemSlots",
    "intelTechTree": "IntelTechTree",
}

BLOCK_RE = re.compile(r"(?m)^- type:\s*([^\s#]+).*$")
ID_RE = re.compile(r"(?m)^  id:\s*([^\s#]+)\s*(?:#.*)?$")
ABSTRACT_RE = re.compile(r"(?m)^  abstract:\s*true\s*(?:#.*)?$")
TYPED_CONTAINER_RE = re.compile(
    r"^(?P<indent>\s*)-\s*(?:type:\s*|!type:)(?P<type>[^\s#]+)"
)
SCALAR_RE = re.compile(
    r"^(?P<indent>\s+)(?:-\s+)?(?P<key>"
    + "|".join(map(re.escape, sorted(VISIBLE_KEYS)))
    + r"):\s*(?P<value>.+?)\s*$"
)
MESSAGE_RE = re.compile(r"^ent-([A-Za-z0-9_-]+)\s*=", re.MULTILINE)
FLUENT_MESSAGE_RE = re.compile(
    r"^(-?[A-Za-z][A-Za-z0-9_-]*)\s*=\s*(?P<value>.*)$",
    re.MULTILINE,
)
ATTRIBUTE_RE = re.compile(r"^\s+\.([A-Za-z][A-Za-z0-9_-]*)\s*=", re.MULTILINE)
LOCALE_KEY_RE = re.compile(r"[a-z][a-z0-9]*(?:-[a-z0-9]+)+$")
ENTITY_FIELD_RE = re.compile(
    r"^  (?P<key>id|parent|abstract|name|description|suffix|localizationId):"
    r"\s*(?P<value>.*?)\s*$"
)
PARENT_ITEM_RE = re.compile(r"^  -\s*(?P<value>[^#]+?)\s*(?:#.*)?$")


@dataclass(frozen=True)
class EntityPrototypeRecord:
    prototype_id: str
    parents: tuple[str, ...]
    abstract: bool
    set_name: str | None
    set_description: str | None
    set_suffix: str | None
    localization_id: str | None
    path: str
    has_name: bool = False
    has_description: bool = False
    has_suffix: bool = False


@dataclass(frozen=True)
class EntityFieldCandidate:
    prototype_id: str
    field: str
    value: str
    owner_path: str
    inherited_from: str
    source_path: str


@dataclass(frozen=True)
class VisibleYamlFinding:
    path: str
    line: int
    prototype_type: str
    prototype_id: str | None
    key: str
    value: str
    top_level: bool
    component: str | None = None
    localization_id: str | None = None


@dataclass(frozen=True)
class AuditReport:
    total_literals: int
    localized: tuple[VisibleYamlFinding, ...]
    unlocalized: tuple[VisibleYamlFinding, ...]
    entity_fields: tuple[EntityFieldCandidate, ...]


class RobustYamlLoader(yaml.SafeLoader):
    """Safe loader that ignores RobustToolbox's application-specific tags."""


def _construct_robust_tag(
    loader: RobustYamlLoader,
    _suffix: str,
    node: yaml.Node,
) -> object:
    if isinstance(node, yaml.MappingNode):
        return loader.construct_mapping(node, deep=True)
    if isinstance(node, yaml.SequenceNode):
        return loader.construct_sequence(node, deep=True)
    return loader.construct_scalar(node)


RobustYamlLoader.add_multi_constructor("!", _construct_robust_tag)


def _optional_string(value: object) -> str | None:
    return value if isinstance(value, str) and value else None


def _parents(value: object) -> tuple[str, ...]:
    if isinstance(value, str):
        return (value,) if value else ()
    if isinstance(value, list):
        return tuple(parent for parent in value if isinstance(parent, str) and parent)
    return ()


def load_entity_prototypes(prototype_root: Path) -> dict[str, EntityPrototypeRecord]:
    """Load localization-relevant entity fields through a real YAML parser."""

    entities: dict[str, EntityPrototypeRecord] = {}
    paths = sorted(
        path
        for path in prototype_root.rglob("*")
        if path.suffix.casefold() in {".yml", ".yaml"}
        and not any(part.casefold() == "generated" for part in path.relative_to(prototype_root).parts)
    )
    for path in paths:
        text = path.read_text(encoding="utf-8-sig").replace("\t", "  ")
        for document in yaml.load_all(text, Loader=RobustYamlLoader):
            if not isinstance(document, list):
                continue
            for prototype in document:
                if not isinstance(prototype, dict) or prototype.get("type") != "entity":
                    continue
                prototype_id = prototype.get("id")
                if not isinstance(prototype_id, str) or not prototype_id:
                    continue
                abstract = prototype.get("abstract", False)
                entities[prototype_id] = EntityPrototypeRecord(
                    prototype_id=prototype_id,
                    parents=_parents(prototype.get("parent")),
                    abstract=abstract is True or (
                        isinstance(abstract, str) and abstract.casefold() == "true"
                    ),
                    set_name=_optional_string(prototype.get("name")),
                    set_description=_optional_string(prototype.get("description")),
                    set_suffix=_optional_string(prototype.get("suffix")),
                    localization_id=_optional_string(prototype.get("localizationId")),
                    path=path.relative_to(prototype_root).as_posix(),
                    has_name="name" in prototype and prototype.get("name") is not None,
                    has_description=(
                        "description" in prototype
                        and prototype.get("description") is not None
                    ),
                    has_suffix="suffix" in prototype and prototype.get("suffix") is not None,
                )
    return entities


def _strip_inline_comment(value: str) -> str:
    value = value.strip()
    if not value:
        return value

    quote: str | None = None
    escaped = False
    for index, char in enumerate(value):
        if escaped:
            escaped = False
            continue
        if char == "\\" and quote == '"':
            escaped = True
            continue
        if quote:
            if char == quote:
                quote = None
            continue
        if char in {'"', "'"}:
            quote = char
        elif char == "#" and (index == 0 or value[index - 1].isspace()):
            value = value[:index].rstrip()
            break

    if len(value) >= 2 and value[0] == value[-1] and value[0] in {'"', "'"}:
        value = value[1:-1]
    return value.strip()


def collect_fluent_message_coverage(locale_root: Path) -> dict[str, set[str]]:
    """Return message values and attributes that are genuinely present."""

    coverage: dict[str, set[str]] = {}
    for path in sorted(locale_root.rglob("*.ftl")):
        text = path.read_text(encoding="utf-8-sig")
        matches = list(FLUENT_MESSAGE_RE.finditer(text))
        for index, match in enumerate(matches):
            message_id = match.group(1)
            fields = coverage.setdefault(message_id, set())
            end = matches[index + 1].start() if index + 1 < len(matches) else len(text)
            block = text[match.start():end]
            if match.group("value").strip():
                fields.add("value")
            else:
                for line in block.splitlines()[1:]:
                    stripped = line.strip()
                    if stripped and not stripped.startswith((".", "#")):
                        fields.add("value")
                        break
            fields.update(ATTRIBUTE_RE.findall(block))
    return coverage


def _entity_lineage(
    prototype_id: str,
    entities: dict[str, EntityPrototypeRecord],
) -> tuple[EntityPrototypeRecord, ...]:
    result: list[EntityPrototypeRecord] = []
    visited: set[str] = set()

    def visit(current_id: str) -> None:
        if current_id in visited:
            return
        visited.add(current_id)
        current = entities.get(current_id)
        if current is None:
            return
        result.append(current)
        for parent in current.parents:
            visit(parent)

    visit(prototype_id)
    return tuple(result)


def find_unlocalized_entity_fields(
    entities: dict[str, EntityPrototypeRecord],
    locale_root: Path,
    *,
    owners: Iterable[str] = DEFAULT_OWNERS,
) -> tuple[EntityFieldCandidate, ...]:
    """Find concrete owned entities whose effective YAML text remains visible."""

    owner_set = set(owners)
    coverage = collect_fluent_message_coverage(locale_root)
    candidates: list[EntityFieldCandidate] = []
    for prototype_id, entity in sorted(entities.items()):
        parts = Path(entity.path).parts
        owner = parts[0] if parts else ""
        if entity.abstract or owner not in owner_set:
            continue
        lineage = _entity_lineage(prototype_id, entities)
        for field, attribute in (
            ("name", "value"),
            ("description", "desc"),
            ("suffix", "suffix"),
        ):
            for inherited in lineage:
                loc_id = inherited.localization_id or f"ent-{prototype_id}"
                if attribute in coverage.get(loc_id, set()):
                    break
                has_value = getattr(inherited, f"has_{field}") or getattr(
                    inherited,
                    f"set_{field}",
                ) is not None
                value = {
                    "name": inherited.set_name,
                    "description": inherited.set_description,
                    "suffix": inherited.set_suffix,
                }[field]
                if has_value and value is None:
                    break
                if value is None:
                    continue
                candidates.append(
                    EntityFieldCandidate(
                        prototype_id=prototype_id,
                        field=field,
                        value=value,
                        owner_path=entity.path,
                        inherited_from=inherited.prototype_id,
                        source_path=inherited.path,
                    )
                )
                break

    return tuple(sorted(candidates, key=lambda item: (item.prototype_id, item.field)))


def _is_literal(value: str) -> bool:
    if not value:
        return False
    lowered = value.casefold()
    if lowered in {"null", "true", "false", "none", "~"}:
        return False
    if value[0] in "[{|>!$&*/":
        return False
    if re.fullmatch(r"[-+]?\d+(?:\.\d+)?", value):
        return False
    if LOCALE_KEY_RE.fullmatch(value):
        return False
    return bool(re.search(r"[A-Za-zÀ-ÖØ-öø-ÿ]", value))


def normalize_override_segment(value: str) -> str:
    """Convert a visible ASCII literal into a stable Fluent ID segment."""

    return re.sub(r"[^a-z0-9]+", "-", value.casefold()).strip("-")


def normalize_literal_segment(value: str) -> str:
    """Mirror CMUPrototypeLocalization.NormalizeLiteralSegment."""

    decomposed = unicodedata.normalize("NFD", value)
    without_marks = "".join(
        character
        for character in decomposed
        if unicodedata.category(character) != "Mn"
    )
    segment = re.sub(r"[^A-Za-z0-9]+", "-", without_marks).strip("-").lower()
    return segment or "text"


def literal_override_id(component: str, key: str, value: str) -> str:
    component_segment = normalize_literal_segment(component)
    key_segment = normalize_literal_segment(key)
    value_segment = normalize_literal_segment(value)
    if len(value_segment) > 48:
        value_segment = value_segment[:48].rstrip("-")
    digest = hashlib.sha256(f"{component}\0{key}\0{value}".encode()).hexdigest()[:10]
    return f"cmu-yaml-{component_segment}-{key_segment}-{value_segment}-{digest}"


def collect_scoped_literal_override_ids(
    prototype_root: Path = PROTOTYPES,
    *,
    owners: Iterable[str] = DEFAULT_OWNERS,
) -> frozenset[str]:
    """Return deterministic IDs for live YAML literals with wired consumers."""

    message_ids: set[str] = set()
    for owner in owners:
        owner_root = prototype_root / owner
        if not owner_root.exists():
            continue
        for path in owner_root.rglob("*.yml"):
            relative = path.relative_to(prototype_root)
            if any(part.casefold() == "generated" for part in relative.parts):
                continue
            text = path.read_text(encoding="utf-8-sig")
            blocks = list(BLOCK_RE.finditer(text))
            abstract_prototypes: set[tuple[str, str]] = set()
            for index, block in enumerate(blocks):
                end = blocks[index + 1].start() if index + 1 < len(blocks) else len(text)
                block_text = text[block.start():end]
                prototype_id = ID_RE.search(block_text)
                if prototype_id is not None and ABSTRACT_RE.search(block_text):
                    abstract_prototypes.add((block.group(1), prototype_id.group(1)))
            for finding in extract_visible_yaml(relative, text):
                if (
                    finding.prototype_id is not None
                    and (finding.prototype_type, finding.prototype_id) in abstract_prototypes
                ):
                    continue
                if finding.component not in SCOPED_LITERAL_COMPONENTS:
                    continue
                message_ids.add(literal_override_id(
                    finding.component,
                    finding.key,
                    finding.value,
                ))
    return frozenset(message_ids)


def _typed_container(lines: list[str], offset: int, indent: int) -> str | None:
    for previous in reversed(lines[:offset]):
        match = TYPED_CONTAINER_RE.match(previous)
        if match is None or len(match.group("indent")) >= indent:
            continue
        component = match.group("type")
        return LITERAL_COMPONENT_ALIASES.get(component, component)
    return None


def extract_visible_yaml(path: Path, text: str) -> list[VisibleYamlFinding]:
    """Extract likely visible scalar literals without requiring a YAML parser."""

    starts = list(BLOCK_RE.finditer(text))
    findings: list[VisibleYamlFinding] = []
    for index, start in enumerate(starts):
        end = starts[index + 1].start() if index + 1 < len(starts) else len(text)
        block = text[start.start():end]
        prototype_type = start.group(1)
        id_match = ID_RE.search(block)
        prototype_id = id_match.group(1) if id_match else None
        first_line = text.count("\n", 0, start.start()) + 1

        lines = block.splitlines()
        for offset, line in enumerate(lines):
            scalar = SCALAR_RE.match(line)
            if not scalar:
                continue
            key = scalar.group("key")
            if (prototype_type, key) in REVIEWED_NON_VISIBLE_FIELDS:
                continue
            if prototype_type == "body" and key == "name":
                continue
            if key in {"prefix", "malePrefix", "femalePrefix"} and prototype_type != "rank":
                continue
            value = _strip_inline_comment(scalar.group("value"))
            if not _is_literal(value):
                continue
            localization_id: str | None = None
            indent = len(scalar.group("indent"))
            sidecar_key: str | None = None
            if key == "name":
                sidecar_key = "nameLocId"
            elif prototype_type == "cmuSurgeryStepMetadata":
                sidecar_key = {
                    "displayName": "displayNameLocId",
                    "label": "labelLocId",
                }.get(key)

            if sidecar_key is not None:
                for sibling in lines[offset + 1:]:
                    if not sibling.strip() or sibling.lstrip().startswith("#"):
                        continue
                    sibling_indent = len(sibling) - len(sibling.lstrip())
                    if sibling_indent < indent:
                        break
                    if sibling_indent == indent:
                        match = re.match(
                            rf"\s*{re.escape(sidecar_key)}:\s*(\S+)",
                            sibling,
                        )
                        if match:
                            localization_id = _strip_inline_comment(match.group(1))
                        break
            component = _typed_container(lines, offset, indent)
            if (component, key) in REVIEWED_NON_VISIBLE_COMPONENT_FIELDS:
                continue
            findings.append(
                VisibleYamlFinding(
                    path=path.as_posix(),
                    line=first_line + offset,
                    prototype_type=prototype_type,
                    prototype_id=prototype_id,
                    key=key,
                    value=value,
                    top_level=indent == 2,
                    component=component,
                    localization_id=localization_id,
                )
            )
    return findings


def collect_fluent_entity_coverage(locale_root: Path) -> tuple[set[str], set[str]]:
    coverage = collect_fluent_message_coverage(locale_root)
    names = {
        message_id.removeprefix("ent-")
        for message_id, fields in coverage.items()
        if message_id.startswith("ent-") and "value" in fields
    }
    descriptions = {
        message_id.removeprefix("ent-")
        for message_id, fields in coverage.items()
        if message_id.startswith("ent-") and "desc" in fields
    }
    return names, descriptions


def _is_covered(
    finding: VisibleYamlFinding,
    coverage: dict[str, set[str]],
    entity_names: set[str],
    entity_descriptions: set[str],
) -> bool:
    if finding.localization_id is not None:
        return "value" in coverage.get(finding.localization_id, set())
    if "value" in coverage.get(finding.value, set()):
        return True
    if finding.component in SCOPED_LITERAL_COMPONENTS:
        message_id = literal_override_id(finding.component, finding.key, finding.value)
        if "value" in coverage.get(message_id, set()):
            return True

    if (
        finding.prototype_type == "constructionGraph"
        and finding.key == "name"
        and not finding.top_level
    ):
        segment = normalize_override_segment(finding.value)
        return "value" in coverage.get(
            f"construction-step-{segment}-name",
            set(),
        )

    if (
        finding.prototype_type == "announcementPreset"
        and finding.prototype_id is not None
        and finding.key == "title"
        and not finding.top_level
    ):
        return "value" in coverage.get(
            f"announcement-preset-{finding.prototype_id}-title",
            set(),
        )

    if not finding.top_level or finding.prototype_id is None:
        return False

    if finding.prototype_type == "entity":
        if finding.key in {"description", "desc"}:
            return finding.prototype_id in entity_descriptions
        if finding.key == "name":
            return finding.prototype_id in entity_names

    if finding.prototype_type == "rank" and finding.key in RANK_FIELDS:
        return RANK_FIELDS[finding.key] in coverage.get(
            f"rank-{finding.prototype_id}",
            set(),
        )

    message_id: str | None = None
    if finding.prototype_type == "stack" and finding.key == "name":
        message_id = f"stack-{finding.prototype_id}-name"
    elif finding.prototype_type == "tile" and finding.key == "name":
        message_id = f"tile-{finding.prototype_id}-name"
    elif finding.prototype_type == "flavor" and finding.key == "description":
        message_id = f"flavor-{finding.prototype_id}-description"
    elif finding.prototype_type == "language" and finding.key in {"name", "description"}:
        message_id = f"language-{finding.prototype_id}-{finding.key}"
    elif finding.prototype_type == "job" and finding.key in {"name", "description"}:
        message_id = f"job-{finding.prototype_id}-{finding.key}"
    elif finding.prototype_type == "guideEntry" and finding.key == "name":
        message_id = f"guide-entry-{finding.prototype_id}-name"
    elif finding.prototype_type == "alert" and finding.key in {"name", "description"}:
        message_id = f"alert-{finding.prototype_id}-{finding.key}"
    elif finding.prototype_type == "accessLevel" and finding.key == "name":
        message_id = f"access-level-{finding.prototype_id}-name"
    elif finding.prototype_type == "accessGroup" and finding.key == "name":
        message_id = f"access-group-{finding.prototype_id}-name"
    elif finding.prototype_type == "construction" and finding.key in {"name", "description"}:
        message_id = f"construction-{finding.prototype_id}-{finding.key}"
    elif finding.prototype_type == "rmcConstruction" and finding.key == "name":
        message_id = f"rmc-construction-{finding.prototype_id}-name"
    elif finding.prototype_type == "npcFaction" and finding.key == "name":
        message_id = f"npc-faction-{finding.prototype_id}-name"
    elif finding.prototype_type == "thirdParty" and finding.key == "displayName":
        message_id = f"third-party-{finding.prototype_id}-display-name"
    elif finding.prototype_type == "platoon" and finding.key == "name":
        message_id = f"platoon-{finding.prototype_id}-name"
    elif finding.prototype_type == "announcementPreset" and finding.key in {"name", "title"}:
        message_id = f"announcement-preset-{finding.prototype_id}-{finding.key}"
    elif finding.prototype_type == "gamePreset" and finding.key in {"name", "description"}:
        message_id = f"game-preset-{finding.prototype_id}-{finding.key}"
    elif finding.prototype_type == "customHoliday" and finding.key in {"name", "description"}:
        message_id = f"custom-holiday-{finding.prototype_id}-{finding.key}"
    elif finding.prototype_type == "objectiveIntelTier" and finding.key in {"title", "description"}:
        message_id = f"objective-intel-tier-{finding.prototype_id}-{finding.key}"
    elif finding.prototype_type == "material" and finding.key == "name":
        message_id = f"material-{finding.prototype_id}-name"

    if message_id is not None:
        return "value" in coverage.get(message_id, set())
    return False


def all_owners(prototype_root: Path = PROTOTYPES) -> tuple[str, ...]:
    """Return every top-level prototype directory, fork layers and vanilla alike.

    Restricting the audit to the fork layers hides the vanilla SS14 corpus,
    which is by far the largest body of player-visible YAML text. Auditing
    everything by default keeps that number honest.
    """

    if not prototype_root.is_dir():
        return ()
    return tuple(sorted(path.name for path in prototype_root.iterdir() if path.is_dir()))


def scan_prototype_tree(
    prototype_root: Path = PROTOTYPES,
    locale_root: Path = SPANISH,
    *,
    owners: Iterable[str] | None = None,
) -> AuditReport:
    owners = tuple(owners) if owners is not None else all_owners(prototype_root)
    coverage = collect_fluent_message_coverage(locale_root)
    entity_names, entity_descriptions = collect_fluent_entity_coverage(locale_root)
    entities = load_entity_prototypes(prototype_root)
    localized: list[VisibleYamlFinding] = []
    unlocalized: list[VisibleYamlFinding] = []

    for owner in owners:
        owner_root = prototype_root / owner
        if not owner_root.exists():
            continue
        for path in owner_root.rglob("*.yml"):
            relative = path.relative_to(prototype_root)
            if any(part.casefold() == "generated" for part in relative.parts):
                continue
            text = path.read_text(encoding="utf-8-sig")
            blocks = list(BLOCK_RE.finditer(text))
            abstract_prototypes: set[tuple[str, str]] = set()
            for index, block in enumerate(blocks):
                end = blocks[index + 1].start() if index + 1 < len(blocks) else len(text)
                block_text = text[block.start():end]
                prototype_id = ID_RE.search(block_text)
                if prototype_id is not None and ABSTRACT_RE.search(block_text):
                    abstract_prototypes.add((block.group(1), prototype_id.group(1)))
            for finding in extract_visible_yaml(relative, text):
                if (
                    finding.prototype_id is not None
                    and (finding.prototype_type, finding.prototype_id) in abstract_prototypes
                ):
                    continue
                target = localized if _is_covered(
                    finding,
                    coverage,
                    entity_names,
                    entity_descriptions,
                ) else unlocalized
                target.append(finding)

    localized.sort(key=lambda item: (item.path, item.line, item.key))
    unlocalized.sort(key=lambda item: (item.path, item.line, item.key))
    entity_fields = find_unlocalized_entity_fields(
        entities,
        locale_root,
        owners=owners,
    )
    return AuditReport(
        total_literals=len(localized) + len(unlocalized),
        localized=tuple(localized),
        unlocalized=tuple(unlocalized),
        entity_fields=entity_fields,
    )


def _text_report(report: AuditReport) -> str:
    lines = [
        f"Visible YAML literal candidates: {report.total_literals}",
        f"Covered by Spanish entity Fluent: {len(report.localized)}",
        f"Unlocalized/review candidates: {len(report.unlocalized)}",
        f"Effective entity fields requiring overrides: {len(report.entity_fields)}",
    ]
    for finding in report.unlocalized:
        prototype = finding.prototype_id or "<no-id>"
        lines.append(
            f"{finding.path}:{finding.line}: {finding.prototype_type}/{prototype} "
            f"{finding.key} = {finding.value}"
        )
    for finding in report.entity_fields:
        lines.append(
            f"{finding.owner_path}: entity/{finding.prototype_id} {finding.field} = "
            f"{finding.value} (inherited from {finding.inherited_from})"
        )
    return "\n".join(lines) + "\n"


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--owners",
        nargs="+",
        default=None,
        help="Prototype directories to audit (default: every directory, vanilla included)",
    )
    parser.add_argument("--json", action="store_true", help="Emit machine-readable JSON")
    parser.add_argument("--output", type=Path, help="Write the report to this path")
    parser.add_argument(
        "--fail-on-unlocalized",
        action="store_true",
        help="Return exit code 1 when review candidates remain",
    )
    args = parser.parse_args()

    report = scan_prototype_tree(owners=args.owners)
    if args.json:
        payload = {
            "total_literals": report.total_literals,
            "localized": [asdict(item) for item in report.localized],
            "unlocalized": [asdict(item) for item in report.unlocalized],
            "entity_fields": [asdict(item) for item in report.entity_fields],
        }
        output = json.dumps(payload, ensure_ascii=False, indent=2) + "\n"
    else:
        output = _text_report(report)

    if args.output:
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(output, encoding="utf-8", newline="\n")
    else:
        print(output, end="")

    remaining = report.unlocalized or report.entity_fields
    return 1 if args.fail_on_unlocalized and remaining else 0


if __name__ == "__main__":
    raise SystemExit(main())
