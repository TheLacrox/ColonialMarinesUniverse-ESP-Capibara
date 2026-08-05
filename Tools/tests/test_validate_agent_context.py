from __future__ import annotations

import tempfile
import unittest
from pathlib import Path

from Tools.validate_agent_context import MAX_CONTEXT_CHARS, validate_repository


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


def valid_context() -> str:
    return "\n\n".join(
        (*REQUIRED_SECTIONS, *REQUIRED_FACTS, *REQUIRED_GIT_POLICY_FACTS)
    ) + "\n"


class ValidateAgentContextTests(unittest.TestCase):
    def make_repo(self, context: str | None = None) -> Path:
        temporary = tempfile.TemporaryDirectory()
        self.addCleanup(temporary.cleanup)
        root = Path(temporary.name)
        if context is not None:
            (root / "AGENTS.md").write_text(context, encoding="utf-8", newline="\n")

            guide = root / SUPPORT_GUIDE
            guide.parent.mkdir(parents=True, exist_ok=True)
            guide.write_text(
                "\n\n".join((*REQUIRED_GUIDE_SECTIONS, *REQUIRED_GUIDE_FACTS)) + "\n",
                encoding="utf-8",
                newline="\n",
            )

            workflow = root / CI_WORKFLOW
            workflow.parent.mkdir(parents=True, exist_ok=True)
            workflow.write_text(
                "name: CI\n"
                "jobs:\n"
                "  source-guards:\n"
                "    steps:\n"
                + "".join(
                    f"      - name: {name}\n"
                    f"        run: {command}\n"
                    for name, command in REQUIRED_CI_STEPS
                ),
                encoding="utf-8",
                newline="\n",
            )
        return root

    def test_valid_contract_passes(self) -> None:
        root = self.make_repo(valid_context())

        self.assertEqual(validate_repository(root), [])

    def test_missing_contract_fails(self) -> None:
        root = self.make_repo()

        errors = validate_repository(root)

        self.assertTrue(any("AGENTS.md" in error for error in errors))

    def test_higher_priority_context_fails(self) -> None:
        root = self.make_repo(valid_context())
        (root / ".hermes.md").write_text("shadow\n", encoding="utf-8")

        errors = validate_repository(root)

        self.assertTrue(any(".hermes.md" in error and "prioridad" in error for error in errors))

    def test_duplicate_lower_priority_context_fails(self) -> None:
        root = self.make_repo(valid_context())
        (root / "CLAUDE.md").write_text("duplicate\n", encoding="utf-8")

        errors = validate_repository(root)

        self.assertTrue(any("CLAUDE.md" in error and "duplic" in error for error in errors))

    def test_contract_over_repository_budget_fails(self) -> None:
        root = self.make_repo(valid_context() + "x" * MAX_CONTEXT_CHARS)

        errors = validate_repository(root)

        self.assertTrue(any("20,000" in error for error in errors))

    def test_missing_operational_fact_fails(self) -> None:
        root = self.make_repo(valid_context().replace("BuildChecker/git_helper.py", ""))

        errors = validate_repository(root)

        self.assertTrue(any("BuildChecker/git_helper.py" in error for error in errors))

    def test_missing_unidirectional_git_section_fails(self) -> None:
        root = self.make_repo(
            valid_context().replace("## Flujo Git unidireccional del fork", "")
        )

        errors = validate_repository(root)

        self.assertTrue(any("## Flujo Git unidireccional del fork" in error for error in errors))

    def test_softened_upstream_pull_request_rule_fails(self) -> None:
        root = self.make_repo(
            valid_context().replace(
                "Nunca crees, prepares, sugieras ni abras un pull request desde este fork hacia upstream.",
                "Evita normalmente abrir pull requests desde este fork hacia upstream.",
            )
        )

        errors = validate_repository(root)

        self.assertTrue(any("pull request desde este fork hacia upstream" in error for error in errors))

    def test_missing_upstream_push_rule_fails(self) -> None:
        root = self.make_repo(
            valid_context().replace("Nunca hagas push a ramas o remotos de upstream.", "")
        )

        errors = validate_repository(root)

        self.assertTrue(any("push a ramas o remotos de upstream" in error for error in errors))

    def test_upstream_policy_inside_fenced_code_fails(self) -> None:
        context = valid_context()
        for fact in REQUIRED_GIT_POLICY_FACTS:
            context = context.replace(fact, "")
        context += "```text\n" + "\n".join(REQUIRED_GIT_POLICY_FACTS) + "\n```\n"
        root = self.make_repo(context)

        errors = validate_repository(root)

        self.assertTrue(any("política Git" in error for error in errors))

    def test_missing_required_section_fails(self) -> None:
        root = self.make_repo(valid_context().replace("## Arquitectura y propiedad", ""))

        errors = validate_repository(root)

        self.assertTrue(any("## Arquitectura y propiedad" in error for error in errors))

    def test_crlf_contract_fails(self) -> None:
        root = self.make_repo(valid_context())
        (root / "AGENTS.md").write_bytes(valid_context().replace("\n", "\r\n").encode("utf-8"))

        errors = validate_repository(root)

        self.assertTrue(any("CRLF" in error for error in errors))

    def test_bare_cr_contract_fails(self) -> None:
        root = self.make_repo(valid_context())
        (root / "AGENTS.md").write_bytes(valid_context().replace("\n", "\r").encode("utf-8"))

        errors = validate_repository(root)

        self.assertTrue(any("línea LF" in error for error in errors))

    def test_invalid_utf8_contract_fails(self) -> None:
        root = self.make_repo(valid_context())
        (root / "AGENTS.md").write_bytes(b"\xff")

        errors = validate_repository(root)

        self.assertTrue(any("UTF-8" in error for error in errors))

    def test_contract_anchors_inside_html_comment_fail(self) -> None:
        root = self.make_repo(f"<!--\n{valid_context()}-->\n")

        errors = validate_repository(root)

        self.assertTrue(any("sección obligatoria" in error for error in errors))

    def test_contract_sections_inside_fenced_code_fail(self) -> None:
        root = self.make_repo(f"```markdown\n{valid_context()}```\n")

        errors = validate_repository(root)

        self.assertTrue(any("sección obligatoria" in error for error in errors))

    def test_cursor_rule_duplicate_fails(self) -> None:
        root = self.make_repo(valid_context())
        cursor_rules = root / ".cursor" / "rules"
        cursor_rules.mkdir(parents=True)
        (cursor_rules / "duplicate.mdc").write_text("duplicate\n", encoding="utf-8")

        errors = validate_repository(root)

        self.assertTrue(any(".cursor/rules/duplicate.mdc" in error for error in errors))

    def test_missing_supporting_guide_fails(self) -> None:
        root = self.make_repo(valid_context())
        (root / SUPPORT_GUIDE).unlink()

        errors = validate_repository(root)

        self.assertTrue(any(SUPPORT_GUIDE.as_posix() in error for error in errors))

    def test_blank_supporting_guide_fails(self) -> None:
        root = self.make_repo(valid_context())
        (root / SUPPORT_GUIDE).write_text("", encoding="utf-8")

        errors = validate_repository(root)

        self.assertTrue(any("vacía" in error for error in errors))

    def test_supporting_guide_sections_inside_fenced_code_fail(self) -> None:
        root = self.make_repo(valid_context())
        (root / SUPPORT_GUIDE).write_text(
            "```markdown\n" + "\n\n".join(REQUIRED_GUIDE_SECTIONS) + "\n```\n",
            encoding="utf-8",
            newline="\n",
        )

        errors = validate_repository(root)

        self.assertTrue(any(SUPPORT_GUIDE.as_posix() in error for error in errors))

    def test_missing_supporting_guide_upstream_policy_fails(self) -> None:
        root = self.make_repo(valid_context())
        guide = root / SUPPORT_GUIDE
        guide.write_text(
            guide.read_text(encoding="utf-8").replace(
                "Queda prohibido crear, preparar, sugerir o abrir pull requests dirigidos a upstream.",
                "",
            ),
            encoding="utf-8",
            newline="\n",
        )

        errors = validate_repository(root)

        self.assertTrue(any("pull requests dirigidos a upstream" in error for error in errors))

    def test_supporting_guide_upstream_policy_inside_fenced_code_fails(self) -> None:
        root = self.make_repo(valid_context())
        guide = root / SUPPORT_GUIDE
        guide_content = guide.read_text(encoding="utf-8")
        for fact in REQUIRED_GUIDE_FACTS:
            guide_content = guide_content.replace(fact, "")
        guide.write_text(
            guide_content + "```text\n" + "\n".join(REQUIRED_GUIDE_FACTS) + "\n```\n",
            encoding="utf-8",
            newline="\n",
        )

        errors = validate_repository(root)

        self.assertTrue(any("política operativa" in error for error in errors))

    def test_missing_ci_integration_fails(self) -> None:
        root = self.make_repo(valid_context())
        (root / CI_WORKFLOW).unlink()

        errors = validate_repository(root)

        self.assertTrue(any(CI_WORKFLOW.as_posix() in error for error in errors))

    def test_incomplete_ci_integration_fails(self) -> None:
        root = self.make_repo(valid_context())
        (root / CI_WORKFLOW).write_text("name: CI\n", encoding="utf-8", newline="\n")

        errors = validate_repository(root)

        self.assertTrue(any(REQUIRED_CI_COMMANDS[0] in error for error in errors))

    def test_ci_commands_outside_source_guards_fail(self) -> None:
        root = self.make_repo(valid_context())
        (root / CI_WORKFLOW).write_text(
            "name: CI\n"
            "jobs:\n"
            "  unrelated:\n"
            "    steps:\n"
            + "".join(f"      - run: {command}\n" for command in REQUIRED_CI_COMMANDS),
            encoding="utf-8",
            newline="\n",
        )

        errors = validate_repository(root)

        self.assertTrue(any("source-guards" in error for error in errors))

    def test_ci_commands_in_comments_fail(self) -> None:
        root = self.make_repo(valid_context())
        (root / CI_WORKFLOW).write_text(
            "name: CI\n"
            "jobs:\n"
            "  source-guards:\n"
            "    steps:\n"
            + "".join(f"      # run: {command}\n" for command in REQUIRED_CI_COMMANDS),
            encoding="utf-8",
            newline="\n",
        )

        errors = validate_repository(root)

        self.assertTrue(any(REQUIRED_CI_COMMANDS[0] in error for error in errors))

    def test_ci_commands_inside_block_scalar_fail(self) -> None:
        root = self.make_repo(valid_context())
        (root / CI_WORKFLOW).write_text(
            "name: CI\n"
            "jobs:\n"
            "  source-guards:\n"
            "    steps:\n"
            "      - name: Simulated commands\n"
            "        run: |\n"
            + "".join(f"          run: {command}\n" for command in REQUIRED_CI_COMMANDS),
            encoding="utf-8",
            newline="\n",
        )

        errors = validate_repository(root)

        self.assertTrue(any(REQUIRED_CI_COMMANDS[0] in error for error in errors))

    def test_ci_commands_in_disabled_steps_fail(self) -> None:
        root = self.make_repo(valid_context())
        (root / CI_WORKFLOW).write_text(
            "name: CI\n"
            "jobs:\n"
            "  source-guards:\n"
            "    steps:\n"
            + "".join(
                f"      - name: {name}\n"
                "        if: false\n"
                f"        run: {command}\n"
                for name, command in REQUIRED_CI_STEPS
            ),
            encoding="utf-8",
            newline="\n",
        )

        errors = validate_repository(root)

        self.assertTrue(any(REQUIRED_CI_COMMANDS[0] in error for error in errors))


if __name__ == "__main__":
    unittest.main()
