import tempfile
from pathlib import Path
import unittest
from unittest.mock import patch

import Tools.validate_spanish_guidebook as validator


class ValidateSpanishGuidebookTest(unittest.TestCase):
    def _run(self, base_text: str, spanish_text: str, require_complete: bool = False):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            base = root / "Guidebook"
            spanish = root / "es-ES" / "Guidebook"
            base.mkdir(parents=True)
            (base / "Doc.xml").write_text(base_text, encoding="utf-8", newline="\n")
            if spanish_text is not None:
                spanish.mkdir(parents=True)
                (spanish / "Doc.xml").write_text(
                    spanish_text, encoding="utf-8", newline="\n"
                )

            with (
                patch.object(validator, "BASE", base),
                patch.object(validator, "SPANISH", spanish),
            ):
                return validator.validate(require_complete=require_complete)

    def test_accepts_translated_prose(self) -> None:
        errors = self._run(
            "<Document>\n  # Minor Crimes\n  - Low severity offences.\n</Document>\n",
            "<Document>\n  # Delitos leves\n  - Infracciones de gravedad baja.\n</Document>\n",
        )
        self.assertEqual(errors, [])

    def test_accepts_translated_caption_and_textlink(self) -> None:
        errors = self._run(
            "<Document>\n"
            '  <GuideEntityEmbed Caption="Field Headset" Entity="AU14Headset"/>\n'
            '  [textlink="Voice Procedure" link="AU14CommsVoiceProcedure"]\n'
            "</Document>\n",
            "<Document>\n"
            '  <GuideEntityEmbed Caption="Auriculares de campana" Entity="AU14Headset"/>\n'
            '  [textlink="Procedimiento radiotelefonico" link="AU14CommsVoiceProcedure"]\n'
            "</Document>\n",
        )
        self.assertEqual(errors, [])

    def test_rejects_changed_identifier_attribute(self) -> None:
        errors = self._run(
            '<Document>\n  <GuideReagentEmbed Reagent="CMBicaridine"/>\n</Document>\n',
            '<Document>\n  <GuideReagentEmbed Reagent="CMBicaridina"/>\n</Document>\n',
        )
        self.assertEqual(len(errors), 1)
        self.assertIn("Doc.xml: elements differ", errors[0])

    def test_rejects_changed_link_target(self) -> None:
        errors = self._run(
            '<Document>\n  [textlink="Crimes" link="RMCMarineLawCrimes"]\n</Document>\n',
            '<Document>\n  [textlink="Delitos" link="RMCDelitos"]\n</Document>\n',
        )
        self.assertTrue(any("link targets differ" in error for error in errors))

    def test_rejects_dropped_inline_markup(self) -> None:
        errors = self._run(
            "<Document>\n  The [bold]Commander[/bold] decides.\n</Document>\n",
            "<Document>\n  El Comandante decide.\n</Document>\n",
        )
        self.assertTrue(any("inline markup differ" in error for error in errors))

    def test_rejects_changed_heading_depth(self) -> None:
        errors = self._run(
            "<Document>\n# Rules\n</Document>\n",
            "<Document>\n## Normas\n</Document>\n",
        )
        self.assertTrue(any("headings differ" in error for error in errors))

    def test_bracketed_prose_is_not_inline_markup(self) -> None:
        errors = self._run(
            "<Document>\n  [INSERT THE KEY HERE WHEN I FIGURE IT OUT]\n</Document>\n",
            "<Document>\n  [INSERTA LA TECLA CUANDO LA AVERIGUE]\n</Document>\n",
        )
        self.assertEqual(errors, [])

    def test_rejects_crlf_line_endings(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            base = root / "Guidebook"
            spanish = root / "es-ES" / "Guidebook"
            base.mkdir(parents=True)
            spanish.mkdir(parents=True)
            (base / "Doc.xml").write_text(
                "<Document>\n  Text.\n</Document>\n", encoding="utf-8", newline="\n"
            )
            (spanish / "Doc.xml").write_bytes(b"<Document>\r\n  Texto.\r\n</Document>\r\n")

            with (
                patch.object(validator, "BASE", base),
                patch.object(validator, "SPANISH", spanish),
            ):
                errors = validator.validate()

        self.assertIn("Doc.xml: CRLF line endings are not allowed", errors)

    def test_require_complete_reports_missing_mirror(self) -> None:
        errors = self._run(
            "<Document>\n  Text.\n</Document>\n",
            None,
            require_complete=True,
        )
        self.assertEqual(errors, ["Doc.xml: missing Spanish document"])

    def test_mirror_without_base_document_is_reported(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            base = root / "Guidebook"
            spanish = root / "es-ES" / "Guidebook"
            base.mkdir(parents=True)
            spanish.mkdir(parents=True)
            (spanish / "Orphan.xml").write_text(
                "<Document>\n  Texto.\n</Document>\n", encoding="utf-8", newline="\n"
            )

            with (
                patch.object(validator, "BASE", base),
                patch.object(validator, "SPANISH", spanish),
            ):
                errors = validator.validate()

        self.assertEqual(errors, ["Orphan.xml: no matching base document"])


if __name__ == "__main__":
    unittest.main()
