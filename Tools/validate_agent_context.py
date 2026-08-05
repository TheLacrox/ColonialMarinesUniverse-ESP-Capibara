#!/usr/bin/env python3
"""Validate the repository's authoritative agent context contract."""

from __future__ import annotations

import argparse
import re
from pathlib import Path
from typing import Sequence

MAX_CONTEXT_CHARS = 20_000
CONTEXT_FILE = "AGENTS.md"
HIGHER_PRIORITY_CONTEXTS = (".hermes.md", "HERMES.md")
DUPLICATE_CONTEXTS = ("agents.md", "CLAUDE.md", "claude.md", ".cursorrules")
REQUIRED_SECTIONS = (
    "# CMU-14: contrato operativo para agentes",
    "## Inicio y comandos canónicos",
    "## Flujo Git unidireccional del fork",
    "## Arquitectura y propiedad",
    "## Límites generados y externos",
    "## Disciplina de cambios",
    "## Verificación por tipo de cambio",
)
REQUIRED_FACTS = (
    "python3 Tools/validate_agent_context.py",
    "Content.Shared/_CMU14",
    "Resources/Audio/_CMU14/Private/",
    "BuildChecker/git_helper.py",
)
REQUIRED_GIT_POLICY_FACTS = (
    "El flujo autorizado es únicamente `upstream → fork`.",
    "Nunca crees, prepares, sugieras ni abras un pull request desde este fork hacia upstream.",
    "Nunca hagas push a ramas o remotos de upstream.",
    "Todas las ramas, commits, pushes y pull requests de trabajo deben permanecer dentro del fork.",
)
SUPPORT_GUIDE = Path("docs/agent-development.md")
REQUIRED_GUIDE_SECTIONS = (
    "# Guía de desarrollo asistido por IA en CMU-14",
    "## 1. Cómo recibe contexto un agente",
    "### 2.1. Flujo Git unidireccional del fork",
    "## 7. Cierre de una tarea de agente",
)
REQUIRED_GUIDE_FACTS = (
    "El repositorio original es una fuente de cambios entrantes, no un destino de contribuciones.",
    "Queda prohibido crear, preparar, sugerir o abrir pull requests dirigidos a upstream.",
    "Queda prohibido hacer push a cualquier rama o remoto de upstream.",
    "Todo trabajo colaborativo se publica y revisa exclusivamente dentro del fork.",
)
CI_WORKFLOW = Path(".github/workflows/ci.yml")
REQUIRED_CI_COMMANDS = (
    "python3 -m unittest Tools.tests.test_validate_agent_context -v",
    "python3 Tools/validate_agent_context.py",
)
REQUIRED_CI_STEPS = (
    ("Test agent context validator", REQUIRED_CI_COMMANDS[0]),
    ("Validate agent context", REQUIRED_CI_COMMANDS[1]),
)


def _strip_html_comments(text: str) -> str:
    return re.sub(r"<!--.*?(?:-->|$)", "", text, flags=re.DOTALL)


def _markdown_outside_fences(text: str) -> str:
    visible_lines: list[str] = []
    fence_character: str | None = None
    fence_length = 0

    for line in _strip_html_comments(text).splitlines():
        stripped = line.lstrip()
        fence = re.match(r"(`{3,}|~{3,})", stripped)
        if fence is not None:
            marker = fence.group(1)
            if fence_character is None:
                fence_character = marker[0]
                fence_length = len(marker)
            elif marker[0] == fence_character and len(marker) >= fence_length:
                fence_character = None
                fence_length = 0
            continue

        if fence_character is None:
            visible_lines.append(line)

    return "\n".join(visible_lines)


def _markdown_headings(text: str) -> set[str]:
    headings: set[str] = set()

    for line in _markdown_outside_fences(text).splitlines():
        stripped = line.lstrip()
        if stripped.startswith("#"):
            headings.add(stripped.rstrip())

    return headings


def validate_repository(repo_root: Path) -> list[str]:
    """Return every context-contract violation found under ``repo_root``."""
    root_entries = {entry.name: entry for entry in repo_root.iterdir()}
    errors: list[str] = []

    for name in HIGHER_PRIORITY_CONTEXTS:
        if name in root_entries:
            errors.append(
                f"{name} tiene prioridad sobre {CONTEXT_FILE}; elimínalo o consolida sus reglas."
            )

    for name in DUPLICATE_CONTEXTS:
        if name in root_entries:
            errors.append(
                f"{name} duplica o compite con el contrato canónico {CONTEXT_FILE}."
            )

    cursor_rules = repo_root / ".cursor" / "rules"
    if cursor_rules.is_dir():
        for rule in sorted(cursor_rules.glob("*.mdc")):
            relative_rule = rule.relative_to(repo_root).as_posix()
            errors.append(
                f"{relative_rule} duplica o compite con el contrato canónico {CONTEXT_FILE}."
            )

    support_guide = repo_root / SUPPORT_GUIDE
    if not support_guide.is_file():
        errors.append(f"Falta la guía complementaria {SUPPORT_GUIDE.as_posix()}.")
    else:
        try:
            guide_content = support_guide.read_text(encoding="utf-8")
        except UnicodeDecodeError as exc:
            errors.append(f"{SUPPORT_GUIDE.as_posix()} no es UTF-8 válido: {exc}.")
        else:
            visible_guide = _strip_html_comments(guide_content)
            guide_policy_prose = _markdown_outside_fences(guide_content)
            guide_headings = _markdown_headings(guide_content)
            if not visible_guide.strip():
                errors.append(f"La guía complementaria {SUPPORT_GUIDE.as_posix()} está vacía.")
            for section in REQUIRED_GUIDE_SECTIONS:
                if section not in guide_headings:
                    errors.append(
                        f"Falta la sección obligatoria en {SUPPORT_GUIDE.as_posix()}: {section}"
                    )
            for fact in REQUIRED_GUIDE_FACTS:
                if fact not in guide_policy_prose:
                    errors.append(
                        f"Falta la política operativa obligatoria en "
                        f"{SUPPORT_GUIDE.as_posix()}: {fact}"
                    )

    ci_workflow = repo_root / CI_WORKFLOW
    if not ci_workflow.is_file():
        errors.append(f"Falta la integración de CI {CI_WORKFLOW.as_posix()}.")
    else:
        try:
            ci_content = ci_workflow.read_text(encoding="utf-8")
        except UnicodeDecodeError as exc:
            errors.append(f"{CI_WORKFLOW.as_posix()} no es UTF-8 válido: {exc}.")
        else:
            ci_lines = ci_content.splitlines()
            try:
                source_guards_start = ci_lines.index("  source-guards:")
            except ValueError:
                source_guards_lines: list[str] = []
                errors.append(
                    f"Falta el job source-guards en {CI_WORKFLOW.as_posix()}."
                )
            else:
                source_guards_end = len(ci_lines)
                for index in range(source_guards_start + 1, len(ci_lines)):
                    line = ci_lines[index]
                    if (
                        line.startswith("  ")
                        and not line.startswith("    ")
                        and line.rstrip().endswith(":")
                    ):
                        source_guards_end = index
                        break
                source_guards_lines = ci_lines[source_guards_start:source_guards_end]

            for step_name, command in REQUIRED_CI_STEPS:
                required_name = f"      - name: {step_name}"
                required_run = f"        run: {command}"
                executable_step_found = False

                for index, line in enumerate(source_guards_lines):
                    if line != required_name:
                        continue

                    step_end = len(source_guards_lines)
                    for candidate in range(index + 1, len(source_guards_lines)):
                        if source_guards_lines[candidate].startswith("      - "):
                            step_end = candidate
                            break

                    step_lines = source_guards_lines[index:step_end]
                    has_condition = any(
                        step_line.strip().startswith("if:") for step_line in step_lines
                    )
                    ignores_failure = any(
                        step_line.strip().lower() == "continue-on-error: true"
                        for step_line in step_lines
                    )
                    if required_run in step_lines and not has_condition and not ignores_failure:
                        executable_step_found = True
                        break

                if not executable_step_found:
                    errors.append(
                        f"Falta el step ejecutable del contrato dentro de source-guards en "
                        f"{CI_WORKFLOW.as_posix()}: {step_name} — {command}"
                    )

    context_path = root_entries.get(CONTEXT_FILE)
    if context_path is None or not context_path.is_file():
        errors.append(f"Falta el contrato canónico {CONTEXT_FILE} en la raíz del repositorio.")
        return errors

    raw = context_path.read_bytes()
    try:
        context = raw.decode("utf-8")
    except UnicodeDecodeError as exc:
        errors.append(f"{CONTEXT_FILE} no es UTF-8 válido: {exc}.")
        return errors

    visible_context = _strip_html_comments(context)
    context_policy_prose = _markdown_outside_fences(context)
    context_headings = _markdown_headings(context)

    if len(context) > MAX_CONTEXT_CHARS:
        errors.append(
            f"{CONTEXT_FILE} supera el presupuesto conservador del repositorio de 20,000 caracteres "
            f"({len(context):,})."
        )

    if b"\r" in raw:
        errors.append(
            f"{CONTEXT_FILE} debe usar finales de línea LF; se detectaron bytes CR/CRLF."
        )

    for section in REQUIRED_SECTIONS:
        if section not in context_headings:
            errors.append(f"Falta la sección obligatoria en {CONTEXT_FILE}: {section}")

    for fact in REQUIRED_FACTS:
        if fact not in visible_context:
            errors.append(f"Falta el hecho operativo obligatorio en {CONTEXT_FILE}: {fact}")

    for fact in REQUIRED_GIT_POLICY_FACTS:
        if fact not in context_policy_prose:
            errors.append(f"Falta la política Git obligatoria en {CONTEXT_FILE}: {fact}")

    return errors


def main(argv: Sequence[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--repo-root",
        type=Path,
        default=Path(__file__).resolve().parent.parent,
        help="Raíz del repositorio que se debe validar.",
    )
    args = parser.parse_args(argv)

    errors = validate_repository(args.repo_root.resolve())
    if errors:
        print("Contrato de agentes inválido:")
        for error in errors:
            print(f"  - {error}")
        return 1

    print(f"Contrato de agentes válido: {args.repo_root.resolve() / CONTEXT_FILE}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
