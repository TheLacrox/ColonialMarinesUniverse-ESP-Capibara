import re
import tempfile
from pathlib import Path
import unittest
from unittest.mock import patch

import Tools.validate_spanish_locale as validator
from Tools.audit_spanish_visible_yaml import (
    collect_scoped_literal_override_ids,
    EntityPrototypeRecord,
    literal_override_id,
)
from Tools.validate_spanish_locale import (
    compare,
    structure,
    validate_prototype_override,
)


class ValidateSpanishLocaleTest(unittest.TestCase):
    def test_prototype_override_accepts_live_stack_flavor_tile_job_and_rank_fields_only(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            override = root / "prototype-overrides" / "_CMU14" / "special.ftl"
            override.parent.mkdir(parents=True)
            override.write_text(
                "stack-HealingGel-name = gel curativo\n"
                "flavor-SpicedApples-description = a manzanas especiadas\n"
                "tile-HunterFloor-name = suelo de cazador Yautja\n"
                "job-Marine-name = marine\n"
                "job-Marine-description = Soldado de primera línea.\n"
                "rank-RMCRankPrivate = soldado\n"
                "    .prefix = Sdo.\n"
                "    .prefix-male = Sdo.\n"
                "    .prefix-female = Sdo.\n"
                "guide-entry-MedicalBasics-name = medicina básica\n",
                encoding="utf-8",
                newline="\n",
            )

            errors = validate_prototype_override(
                Path("prototype-overrides/_CMU14/special.ftl"),
                override,
                {},
                {
                    ("stack", "HealingGel"): "_CMU14",
                    ("flavor", "SpicedApples"): "_CMU14",
                    ("tile", "HunterFloor"): "_CMU14",
                    ("job", "Marine"): "_CMU14",
                    ("rank", "RMCRankPrivate"): "_CMU14",
                    ("guideEntry", "MedicalBasics"): "_CMU14",
                },
            )

        self.assertEqual(errors, [])

    def test_prototype_override_rejects_unknown_job(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            override = root / "prototype-overrides" / "_CMU14" / "jobs.ftl"
            override.parent.mkdir(parents=True)
            override.write_text(
                "job-MissingJob-name = trabajo inexistente\n",
                encoding="utf-8",
                newline="\n",
            )

            errors = validate_prototype_override(
                Path("prototype-overrides/_CMU14/jobs.ftl"),
                override,
                {},
                {("job", "RealJob"): "_CMU14"},
            )

        self.assertTrue(any("does not map to a live job prototype" in error for error in errors))

    def test_prototype_override_rejects_unknown_rank(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            override = root / "prototype-overrides" / "_CMU14" / "ranks.ftl"
            override.parent.mkdir(parents=True)
            override.write_text(
                "rank-MissingRank = rango inexistente\n",
                encoding="utf-8",
                newline="\n",
            )

            errors = validate_prototype_override(
                Path("prototype-overrides/_CMU14/ranks.ftl"),
                override,
                {},
                {("rank", "RealRank"): "_CMU14"},
            )

        self.assertTrue(any("references unknown rank prototype" in error for error in errors))

    def test_prototype_override_rejects_unknown_guide_entry(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            override = root / "prototype-overrides" / "_CMU14" / "guides.ftl"
            override.parent.mkdir(parents=True)
            override.write_text(
                "guide-entry-MissingGuide-name = guía inexistente\n",
                encoding="utf-8",
                newline="\n",
            )

            errors = validate_prototype_override(
                Path("prototype-overrides/_CMU14/guides.ftl"),
                override,
                {},
                {("guideEntry", "RealGuide"): "_CMU14"},
            )

        self.assertTrue(any("does not map to a live guideEntry prototype" in error for error in errors))

    def test_prototype_override_accepts_live_alert_fields(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            override = root / "prototype-overrides" / "_CMU14" / "alerts.ftl"
            override.parent.mkdir(parents=True)
            override.write_text(
                "alert-LowOxygen-name = Oxígeno bajo\n"
                "alert-LowOxygen-description = No puedes respirar.\n",
                encoding="utf-8",
                newline="\n",
            )

            errors = validate_prototype_override(
                Path("prototype-overrides/_CMU14/alerts.ftl"),
                override,
                {},
                {("alert", "LowOxygen"): "_CMU14"},
            )

        self.assertEqual(errors, [])

    def test_prototype_override_accepts_live_visible_metadata_fields_only(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            override = root / "prototype-overrides" / "_CMU14" / "visible.ftl"
            override.parent.mkdir(parents=True)
            override.write_text(
                "npc-faction-GOVFOR-name = Fuerzas gubernamentales\n"
                "third-party-Relief-display-name = Grupo de socorro\n"
                "platoon-USCM-name = Marines Coloniales\n"
                "announcement-preset-Alert-name = Alerta\n"
                "announcement-preset-Alert-title = ALERTA\n"
                "game-preset-Distress-name = Señal de socorro\n"
                "game-preset-Distress-description = Investiga la señal.\n"
                "custom-holiday-Founding-name = Día de la Fundación\n"
                "custom-holiday-Founding-description = Una conmemoración.\n"
                "objective-intel-tier-Tier0-title = Vista exterior\n"
                "objective-intel-tier-Tier0-description = Información básica.\n"
                "material-Dollar-name = billete de un dólar\n",
                encoding="utf-8",
                newline="\n",
            )
            owners = {
                ("npcFaction", "GOVFOR"): "_CMU14",
                ("thirdParty", "Relief"): "_CMU14",
                ("platoon", "USCM"): "_CMU14",
                ("announcementPreset", "Alert"): "_CMU14",
                ("gamePreset", "Distress"): "_CMU14",
                ("customHoliday", "Founding"): "_CMU14",
                ("objectiveIntelTier", "Tier0"): "_CMU14",
                ("material", "Dollar"): "_CMU14",
            }

            errors = validate_prototype_override(
                Path("prototype-overrides/_CMU14/visible.ftl"),
                override,
                {},
                owners,
            )

            unknown = root / "prototype-overrides" / "_CMU14" / "unknown.ftl"
            unknown.write_text(
                "game-preset-Missing-name = Inexistente\n",
                encoding="utf-8",
                newline="\n",
            )
            unknown_errors = validate_prototype_override(
                Path("prototype-overrides/_CMU14/unknown.ftl"),
                unknown,
                {},
                owners,
            )

        self.assertEqual(errors, [])
        self.assertTrue(any("does not map to a live gamePreset prototype" in error for error in unknown_errors))

    def test_prototype_override_rejects_unknown_alert(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            override = root / "prototype-overrides" / "_CMU14" / "alerts.ftl"
            override.parent.mkdir(parents=True)
            override.write_text(
                "alert-Missing-name = Inexistente\n",
                encoding="utf-8",
                newline="\n",
            )

            errors = validate_prototype_override(
                Path("prototype-overrides/_CMU14/alerts.ftl"),
                override,
                {},
                {("alert", "LowOxygen"): "_CMU14"},
            )

        self.assertTrue(any("does not map to a live alert prototype" in error for error in errors))

    def test_prototype_override_accepts_live_access_names(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            override = root / "prototype-overrides" / "_CMU14" / "access.ftl"
            override.parent.mkdir(parents=True)
            override.write_text(
                "access-level-Command-name = Mando\n"
                "access-group-MarineMain-name = Marines\n",
                encoding="utf-8",
                newline="\n",
            )

            errors = validate_prototype_override(
                Path("prototype-overrides/_CMU14/access.ftl"),
                override,
                {},
                {
                    ("accessLevel", "Command"): "_CMU14",
                    ("accessGroup", "MarineMain"): "_CMU14",
                },
            )

        self.assertEqual(errors, [])

    def test_prototype_override_rejects_unknown_access(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            override = root / "prototype-overrides" / "_CMU14" / "access.ftl"
            override.parent.mkdir(parents=True)
            override.write_text(
                "access-level-Missing-name = Inexistente\n",
                encoding="utf-8",
                newline="\n",
            )

            errors = validate_prototype_override(
                Path("prototype-overrides/_CMU14/access.ftl"),
                override,
                {},
                {("accessLevel", "Command"): "_CMU14"},
            )

        self.assertTrue(any("does not map to a live accessLevel prototype" in error for error in errors))

    def test_require_complete_accepts_declared_intentional_fallback(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            content_en = root / "content-en"
            engine_en = root / "engine-en"
            spanish = root / "es-ES"
            prototypes = root / "Prototypes"
            source = content_en / "datasets" / "names" / "first.ftl"
            source.parent.mkdir(parents=True)
            source.write_text("names-first-dataset-1 = Alice\n", encoding="utf-8", newline="\n")
            engine_en.mkdir()
            spanish.mkdir()
            prototypes.mkdir()
            manifest = spanish / "intentional-fallbacks.txt"
            manifest.write_text(
                "# Proper-name corpora remain in en-US.\n"
                "datasets/names/first.ftl\n",
                encoding="utf-8",
                newline="\n",
            )

            with (
                patch.object(validator, "CONTENT_EN", content_en),
                patch.object(validator, "ENGINE_EN", engine_en),
                patch.object(validator, "SPANISH", spanish),
                patch.object(validator, "PROTOTYPES", prototypes),
                patch.object(validator, "FALLBACK_MANIFEST", manifest, create=True),
            ):
                errors = validator.validate(require_complete=True)

        self.assertEqual(errors, [])

    def test_validate_rejects_locale_wide_duplicate_override_id(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            content_en = root / "content-en"
            engine_en = root / "engine-en"
            spanish = root / "es-ES"
            prototypes = root / "Prototypes"
            content_en.mkdir()
            engine_en.mkdir()
            source_locale = content_en / "entities.ftl"
            source_locale.write_text("ent-OwnedDoor = owned door\n", encoding="utf-8", newline="\n")
            translated_locale = spanish / "entities.ftl"
            translated_locale.parent.mkdir(parents=True)
            translated_locale.write_text("ent-OwnedDoor = puerta\n", encoding="utf-8", newline="\n")
            override = spanish / "prototype-overrides" / "_CMU14" / "entities.ftl"
            override.parent.mkdir(parents=True)
            override.write_text("ent-OwnedDoor = otra puerta\n", encoding="utf-8", newline="\n")
            prototype = prototypes / "_CMU14" / "entities.yml"
            prototype.parent.mkdir(parents=True)
            prototype.write_text(
                "- type: entity\n  id: OwnedDoor\n  name: owned door\n",
                encoding="utf-8",
            )

            with (
                patch.object(validator, "CONTENT_EN", content_en),
                patch.object(validator, "ENGINE_EN", engine_en),
                patch.object(validator, "SPANISH", spanish),
                patch.object(validator, "PROTOTYPES", prototypes),
                patch.object(
                    validator,
                    "FALLBACK_MANIFEST",
                    spanish / "intentional-fallbacks.txt",
                ),
            ):
                errors = validator.validate()

        self.assertIn(
            "locale-wide duplicate message ID ent-OwnedDoor: "
            "entities.ftl, prototype-overrides/_CMU14/entities.ftl",
            errors,
        )

    def test_validate_accepts_live_target_only_prototype_override(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            content_en = root / "content-en"
            engine_en = root / "engine-en"
            spanish = root / "es-ES"
            prototypes = root / "Prototypes"
            content_en.mkdir()
            engine_en.mkdir()
            override = spanish / "prototype-overrides" / "_CMU14" / "entities.ftl"
            override.parent.mkdir(parents=True)
            override.write_text(
                "ent-OwnedDoor = puerta propia\n",
                encoding="utf-8",
                newline="\n",
            )
            source = prototypes / "_CMU14" / "entities.yml"
            source.parent.mkdir(parents=True)
            source.write_text(
                "- type: entity\n  id: OwnedDoor\n  name: owned door\n",
                encoding="utf-8",
            )

            with (
                patch.object(validator, "CONTENT_EN", content_en),
                patch.object(validator, "ENGINE_EN", engine_en),
                patch.object(validator, "SPANISH", spanish),
                patch.object(validator, "PROTOTYPES", prototypes, create=True),
                patch.object(
                    validator,
                    "FALLBACK_MANIFEST",
                    spanish / "intentional-fallbacks.txt",
                ),
            ):
                errors = validator.validate()

        self.assertEqual(errors, [])

    def test_validate_accepts_live_scoped_yaml_literal_override(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            content_en = root / "content-en"
            engine_en = root / "engine-en"
            spanish = root / "es-ES"
            prototypes = root / "Prototypes"
            content_en.mkdir()
            engine_en.mkdir()
            override = spanish / "_CMU14" / "yaml-literal-overrides.ftl"
            override.parent.mkdir(parents=True)
            message_id = literal_override_id(
                "CMAutomatedVendor",
                "name",
                "Weapons",
            )
            override.write_text(
                f"{message_id} = Armas\n",
                encoding="utf-8",
                newline="\n",
            )
            source = prototypes / "_CMU14" / "vendors.yml"
            source.parent.mkdir(parents=True)
            source.write_text(
                "- type: entity\n"
                "  id: TestVendor\n"
                "  components:\n"
                "  - type: CMAutomatedVendor\n"
                "    sections:\n"
                "    - name: Weapons\n",
                encoding="utf-8",
                newline="\n",
            )

            with (
                patch.object(validator, "CONTENT_EN", content_en),
                patch.object(validator, "ENGINE_EN", engine_en),
                patch.object(validator, "SPANISH", spanish),
                patch.object(validator, "PROTOTYPES", prototypes),
                patch.object(
                    validator,
                    "FALLBACK_MANIFEST",
                    spanish / "intentional-fallbacks.txt",
                ),
            ):
                errors = validator.validate()

        self.assertEqual(errors, [])

    def test_validate_rejects_unknown_scoped_yaml_literal_override(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            translated = Path(directory) / "yaml-literal-overrides.ftl"
            translated.write_text(
                "cmu-yaml-unknown-name-text-deadbeef00 = texto\n",
                encoding="utf-8",
                newline="\n",
            )

            errors = validator.validate_scoped_literal_override(
                Path("_CMU14/yaml-literal-overrides.ftl"),
                translated,
                frozenset(),
            )

        self.assertTrue(any(
            "does not map to a live scoped YAML literal" in error
            for error in errors
        ))

    def test_validate_accepts_declared_target_only_catalog(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            content_en = root / "content-en"
            engine_en = root / "engine-en"
            spanish = root / "es-ES"
            prototypes = root / "Prototypes"
            content_en.mkdir()
            engine_en.mkdir()
            prototypes.mkdir()
            catalog = spanish / "_CMU14" / "intel-target-only.ftl"
            catalog.parent.mkdir(parents=True)
            catalog.write_text(
                "cmu-intel-clf-fax-title = Informe de inteligencia\n",
                encoding="utf-8",
                newline="\n",
            )

            with (
                patch.object(validator, "CONTENT_EN", content_en),
                patch.object(validator, "ENGINE_EN", engine_en),
                patch.object(validator, "SPANISH", spanish),
                patch.object(validator, "PROTOTYPES", prototypes),
                patch.object(
                    validator,
                    "FALLBACK_MANIFEST",
                    spanish / "intentional-fallbacks.txt",
                ),
            ):
                errors = validator.validate()

        self.assertEqual(errors, [])

    def test_validate_rejects_target_only_catalog_with_undeclared_message(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            content_en = root / "content-en"
            engine_en = root / "engine-en"
            spanish = root / "es-ES"
            prototypes = root / "Prototypes"
            content_en.mkdir()
            engine_en.mkdir()
            prototypes.mkdir()
            catalog = spanish / "_CMU14" / "intel-target-only.ftl"
            catalog.parent.mkdir(parents=True)
            catalog.write_text(
                "cmu-intel-clf-fax-title = Informe de inteligencia\n"
                "cmu-intel-not-declared = texto\n",
                encoding="utf-8",
                newline="\n",
            )

            with (
                patch.object(validator, "CONTENT_EN", content_en),
                patch.object(validator, "ENGINE_EN", engine_en),
                patch.object(validator, "SPANISH", spanish),
                patch.object(validator, "PROTOTYPES", prototypes),
                patch.object(
                    validator,
                    "FALLBACK_MANIFEST",
                    spanish / "intentional-fallbacks.txt",
                ),
            ):
                errors = validator.validate()

        expected = Path("_CMU14/intel-target-only.ftl")
        self.assertEqual(
            errors,
            [f"{expected}: no matching en-US source file"],
        )

    def test_target_only_catalog_rejects_cross_owner_message(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            translated = Path(directory) / "aegis-event.ftl"
            translated.write_text(
                "cmu-aegis-marine-announcement = anuncio\n",
                encoding="utf-8",
                newline="\n",
            )

            errors = validator.validate_target_only_catalog(
                Path("_CMU14/aegis-event.ftl"),
                translated,
            )

        self.assertEqual(
            errors,
            [
                "_CMU14/aegis-event.ftl: cmu-aegis-marine-announcement "
                "belongs to _RMC14, not _CMU14"
            ],
        )

    def test_target_only_catalog_rejects_attributes(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            translated = Path(directory) / "intel-target-only.ftl"
            translated.write_text(
                "cmu-intel-clf-fax-title = Informe\n    .desc = descripcion\n",
                encoding="utf-8",
                newline="\n",
            )

            errors = validator.validate_target_only_catalog(
                Path("_CMU14/intel-target-only.ftl"),
                translated,
            )

        self.assertEqual(
            errors,
            [
                "_CMU14/intel-target-only.ftl: cmu-intel-clf-fax-title "
                "has unsupported attribute(s): desc"
            ],
        )

    def test_prototype_override_uses_vanilla_owner_for_unprefixed_entities(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            translated = Path(directory) / "entities.ftl"
            translated.write_text(
                "ent-VanillaMeal = comida vanilla\n",
                encoding="utf-8",
                newline="\n",
            )
            entities = {
                "VanillaMeal": EntityPrototypeRecord(
                    prototype_id="VanillaMeal",
                    parents=(),
                    abstract=False,
                    set_name="vanilla meal",
                    set_description=None,
                    set_suffix=None,
                    localization_id=None,
                    path="Entities/Food/meals.yml",
                ),
            }

            accepted = validate_prototype_override(
                Path("prototype-overrides/_Vanilla/entities.ftl"),
                translated,
                entities,
            )
            rejected = validate_prototype_override(
                Path("prototype-overrides/_RMC14/entities.ftl"),
                translated,
                entities,
            )

        self.assertEqual(accepted, [])
        self.assertEqual(
            rejected,
            [
                "prototype-overrides/_RMC14/entities.ftl: "
                "ent-VanillaMeal belongs to _Vanilla, not _RMC14"
            ],
        )

    def test_prototype_override_rejects_unknown_entity(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            translated = Path(directory) / "entities.ftl"
            translated.write_text(
                "ent-OwnedDoor = puerta propia\n"
                "    .desc = Una puerta propia.\n"
                "ent-MissingDoor = puerta inexistente\n",
                encoding="utf-8",
            )
            entities = {
                "OwnedDoor": EntityPrototypeRecord(
                    prototype_id="OwnedDoor",
                    parents=(),
                    abstract=False,
                    set_name="owned door",
                    set_description="An owned door.",
                    set_suffix=None,
                    localization_id=None,
                    path="_CMU14/Entities/doors.yml",
                ),
            }

            errors = validate_prototype_override(
                Path("prototype-overrides/_CMU14/entities.ftl"),
                translated,
                entities,
            )

        self.assertEqual(
            errors,
            [
                "prototype-overrides/_CMU14/entities.ftl: "
                "ent-MissingDoor does not map to a live entity prototype",
            ],
        )

    def test_prototype_override_accepts_explicit_entity_localization_id(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            translated = Path(directory) / "entities.ftl"
            translated.write_text(
                "ent-OwnedDoor = puerta propia\n"
                "    .desc = Una puerta propia.\n",
                encoding="utf-8",
            )
            entities = {
                "OwnedDoor=": EntityPrototypeRecord(
                    prototype_id="OwnedDoor=",
                    parents=(),
                    abstract=False,
                    set_name="owned door",
                    set_description="An owned door.",
                    set_suffix=None,
                    localization_id="ent-OwnedDoor",
                    path="_CMU14/Entities/doors.yml",
                ),
            }

            errors = validate_prototype_override(
                Path("prototype-overrides/_CMU14/entities.ftl"),
                translated,
                entities,
            )

        self.assertEqual(errors, [])

    def test_prototype_override_accepts_live_construction_types_only(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            translated = Path(directory) / "construction.ftl"
            translated.write_text(
                "construction-LiveRecipe-name = receta viva\n"
                "construction-LiveRecipe-description = Una receta viva.\n"
                "rmc-construction-LiveRMCRecipe-name = receta RMC viva\n"
                "construction-MissingRecipe-name = receta inexistente\n",
                encoding="utf-8",
            )
            prototype_owners = {
                ("construction", "LiveRecipe"): "_CMU14",
                ("rmcConstruction", "LiveRMCRecipe"): "_CMU14",
            }

            errors = validate_prototype_override(
                Path("prototype-overrides/_CMU14/construction.ftl"),
                translated,
                {},
                prototype_owners,
            )

        self.assertEqual(
            errors,
            [
                "prototype-overrides/_CMU14/construction.ftl: "
                "construction-MissingRecipe-name does not map to a live construction prototype",
            ],
        )

    def test_prototype_override_accepts_live_nested_construction_step_only(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            override = Path(directory) / "construction-steps.ftl"
            override.write_text(
                "construction-step-rack-parts-name = piezas de estantería\n"
                "construction-step-missing-parts-name = piezas inexistentes\n",
                encoding="utf-8",
                newline="\n",
            )

            errors = validate_prototype_override(
                Path("prototype-overrides/_RMC14/construction-steps.ftl"),
                override,
                {},
                {("constructionStep", "rack-parts"): "_RMC14"},
            )

        self.assertEqual(
            errors,
            [
                "prototype-overrides/_RMC14/construction-steps.ftl: "
                "construction-step-missing-parts-name does not map to a live "
                "construction step"
            ],
        )

    def test_prototype_override_accepts_live_surgery_metadata_and_steps_only(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            override = Path(directory) / "surgery.ftl"
            override.write_text(
                "cmu-medical-surgery-procedure-live = Reducir fractura\n"
                "cmu-medical-surgery-step-live-label = Cerrar incisión\n"
                "cmu-medical-surgery-procedure-missing = Procedimiento inexistente\n"
                "cmu-medical-surgery-step-missing-label = Paso inexistente\n",
                encoding="utf-8",
                newline="\n",
            )

            errors = validate_prototype_override(
                Path("prototype-overrides/_CMU14/surgery.ftl"),
                override,
                {},
                {
                    (
                        "surgeryLocalization",
                        "cmu-medical-surgery-procedure-live",
                    ): "_CMU14",
                    (
                        "surgeryLocalization",
                        "cmu-medical-surgery-step-live-label",
                    ): "_CMU14",
                },
            )

        self.assertEqual(
            errors,
            [
                "prototype-overrides/_CMU14/surgery.ftl: "
                "cmu-medical-surgery-procedure-missing does not map to a live "
                "surgery localization sidecar",
                "prototype-overrides/_CMU14/surgery.ftl: "
                "cmu-medical-surgery-step-missing-label does not map to a live "
                "surgery localization sidecar",
            ],
        )

    def test_load_prototype_owners_indexes_live_surgery_metadata_and_steps(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            prototypes = Path(directory) / "Prototypes"
            source = prototypes / "_RMC14" / "surgery.yml"
            source.parent.mkdir(parents=True)
            source.write_text(
                "- type: cmuSurgeryStepMetadata\n"
                "  id: LiveMetadata\n"
                "  surgery: LiveSurgery\n"
                "  displayName: Live Surgery\n"
                "  displayNameLocId: cmu-medical-surgery-procedure-live\n"
                "  steps:\n"
                "  - stepId: LiveStep\n"
                "    label: Live Step\n"
                "    labelLocId: cmu-medical-surgery-step-live-label\n",
                encoding="utf-8",
                newline="\n",
            )

            with patch.object(validator, "PROTOTYPES", prototypes):
                owners = validator.load_prototype_owners(
                    {
                        "cmuSurgeryStepMetadata",
                        "surgeryLocalization",
                        "surgeryStep",
                    },
                )

        self.assertEqual(
            owners,
            {
                ("cmuSurgeryStepMetadata", "LiveMetadata"): "_RMC14",
                (
                    "surgeryLocalization",
                    "cmu-medical-surgery-procedure-live",
                ): "_RMC14",
                (
                    "surgeryLocalization",
                    "cmu-medical-surgery-step-live-label",
                ): "_RMC14",
                ("surgeryStep", "LiveStep"): "_RMC14",
            },
        )

    def test_prototype_override_accepts_live_rank_fields_only(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            translated = Path(directory) / "ranks.ftl"
            translated.write_text(
                "rank-Officer = Oficial\n"
                "    .prefix = Of.\n"
                "    .prefix-male = Sr.\n"
                "    .prefix-female = Sra.\n"
                "    .desc = No permitida\n"
                "rank-MissingRank = Ausente\n",
                encoding="utf-8",
            )

            errors = validate_prototype_override(
                Path("prototype-overrides/_CMU14/ranks.ftl"),
                translated,
                {},
                {("rank", "Officer"): "_CMU14"},
            )

        self.assertEqual(len(errors), 2)
        self.assertIn("unsupported attributes: desc", errors[0])
        self.assertIn("unknown rank prototype 'MissingRank'", errors[1])

    def test_prototype_override_accepts_declared_cmu_xaml_fallback(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            translated = Path(directory) / "xaml.ftl"
            translated.write_text(
                "cmu-body-part-picker-title = Elige una parte del cuerpo que vendar\n",
                encoding="utf-8",
            )

            errors = validate_prototype_override(
                Path("prototype-overrides/_CMU14/xaml.ftl"),
                translated,
                {},
                {},
            )

        self.assertEqual(errors, [])

    def test_structure_preserves_fluent_syntax(self) -> None:
        source = """message = Hello { $name }\n    [color=red]Warning[/color] { NATURALPERCENT($value, 2) }\n"""
        translated = """message = Hola { $name }\n    [color=red]Aviso[/color] { NATURALPERCENT($value, 2) }\n"""

        self.assertEqual(structure(source), structure(translated))

    def test_compare_reports_changed_placeholder(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            source = root / "source.ftl"
            translated = root / "translated.ftl"
            source.write_text("message = Hello { $name }\n", encoding="utf-8")
            translated.write_text("message = Hola { $nombre }\n", encoding="utf-8")

            errors = compare(Path("example.ftl"), source, translated)

        self.assertTrue(any("variables differ" in error for error in errors))

    def test_compare_accepts_only_declared_target_only_ui_message_for_owner(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            source = root / "source.ftl"
            translated = root / "translated.ftl"
            source.write_text("message = Hello { $name }\n", encoding="utf-8")
            translated.write_text(
                "message = Hola { $name }\n"
                "cmu-test-target-only = Coste: { $cost }\n",
                encoding="utf-8",
                newline="\n",
            )

            with patch.dict(
                validator.TARGET_ONLY_MESSAGE_OVERRIDES,
                {"cmu-test-target-only": "_RMC14"},
            ):
                accepted = compare(Path("_RMC14/example.ftl"), source, translated)
                rejected = compare(Path("_CMU14/example.ftl"), source, translated)

        self.assertEqual(accepted, [])
        self.assertTrue(any("belongs to _RMC14, not _CMU14" in error for error in rejected))

    def test_anprc_target_only_manifest_matches_live_consumers(self) -> None:
        root = Path(__file__).resolve().parents[2]
        consumers = (
            root / "Content.Client/_AU14/Radio/ANPRCRadioWindow.xaml",
            root / "Content.Client/_AU14/Radio/ANPRCRadioWindow.xaml.cs",
        )
        consumer_ids = {
            message_id
            for consumer in consumers
            for message_id in re.findall(
                r"\bcmu-anprc-ui-[a-z0-9-]+\b",
                consumer.read_text(encoding="utf-8-sig"),
            )
        }

        self.assertEqual(len(consumer_ids), 134)
        self.assertEqual(consumer_ids, validator.ANPRC_UI_TARGET_ONLY_MESSAGES)
        self.assertTrue(all(
            validator.TARGET_ONLY_MESSAGE_OVERRIDES[message_id] == "_AU14"
            for message_id in consumer_ids
        ))

    def test_rmc_roadmap_target_only_manifest_matches_live_consumers(self) -> None:
        root = Path(__file__).resolve().parents[2]
        consumers = (
            root / "Content.Client/_RMC14/Roadmap/RoadmapWindow.xaml",
            root / "Content.Client/_RMC14/Roadmap/RoadmapWindow.xaml.cs",
            root / "Content.Client/_RMC14/Roadmap/RoadmapItem.xaml.cs",
        )
        consumer_ids = {
            message_id
            for consumer in consumers
            for message_id in re.findall(
                r"\bcmu-rmc-roadmap-[a-z0-9-]+\b",
                consumer.read_text(encoding="utf-8-sig"),
            )
        }

        self.assertEqual(len(consumer_ids), 141)
        self.assertEqual(consumer_ids, validator.RMC_ROADMAP_TARGET_ONLY_MESSAGES)
        self.assertTrue(all(
            validator.TARGET_ONLY_MESSAGE_OVERRIDES[message_id] == "_RMC14"
            for message_id in consumer_ids
        ))

    def test_cmu_intel_target_only_manifest_matches_live_consumers(self) -> None:
        root = Path(__file__).resolve().parents[2]
        consumers = (
            root / "Content.Server/_CMU14/Intel/IntelConsoleClaimFax.cs",
            root / "Content.Server/_CMU14/Intel/IntelConsoleClaimSystem.cs",
        )
        consumer_ids = {
            message_id
            for consumer in consumers
            for message_id in re.findall(
                r"\bcmu-intel-clf-[a-z0-9-]+\b",
                consumer.read_text(encoding="utf-8-sig"),
            )
        }

        self.assertEqual(len(consumer_ids), 7)
        self.assertEqual(
            consumer_ids,
            getattr(validator, "CMU_INTEL_TARGET_ONLY_MESSAGES", frozenset()),
        )
        self.assertTrue(all(
            validator.TARGET_ONLY_MESSAGE_OVERRIDES[message_id] == "_CMU14"
            for message_id in consumer_ids
        ))

    def test_rmc_aegis_target_only_manifest_matches_live_consumers(self) -> None:
        root = Path(__file__).resolve().parents[2]
        consumer = root / "Content.Shared/_RMC14/AegisEvent/AegisSharedAnnouncement.cs"
        consumer_ids = set(re.findall(
            r"\bcmu-aegis-[a-z0-9-]+\b",
            consumer.read_text(encoding="utf-8-sig"),
        ))

        self.assertEqual(len(consumer_ids), 2)
        self.assertEqual(
            consumer_ids,
            getattr(validator, "RMC_AEGIS_TARGET_ONLY_MESSAGES", frozenset()),
        )
        self.assertTrue(all(
            validator.TARGET_ONLY_MESSAGE_OVERRIDES[message_id] == "_RMC14"
            for message_id in consumer_ids
        ))

    def test_cmu_round_statistics_target_only_manifest_matches_live_consumer(self) -> None:
        root = Path(__file__).resolve().parents[2]
        consumer = root / "Content.Client/_CMU14/RoundStatistics/CMURoundStatisticsWindow.cs"
        consumer_ids = set(re.findall(
            r"\bcmu-round-statistics-[a-z0-9-]+\b",
            consumer.read_text(encoding="utf-8-sig"),
        ))

        self.assertEqual(len(consumer_ids), 59)
        self.assertEqual(
            consumer_ids,
            getattr(validator, "CMU_ROUND_STATISTICS_TARGET_ONLY_MESSAGES", frozenset()),
        )
        self.assertTrue(all(
            validator.TARGET_ONLY_MESSAGE_OVERRIDES[message_id] == "_CMU14"
            for message_id in consumer_ids
        ))

    def test_cmu_insurgency_tools_target_only_manifest_matches_live_consumers(self) -> None:
        root = Path(__file__).resolve().parents[2]
        consumers = (
            root / "Content.Client/_AU14/Insurgency/Editor/InsurgencyEditorHelpWindow.cs",
            root / "Content.Client/_AU14/Insurgency/Editor/InsurgencyFactionEditorWindow.cs",
            root / "Content.Client/_AU14/Insurgency/Sapper/SapperWorkbenchWindow.cs",
        )
        consumer_ids = {
            message_id
            for consumer in consumers
            for message_id in re.findall(
                r"\bcmu-insfor-tools-[a-z0-9-]+\b",
                consumer.read_text(encoding="utf-8-sig"),
            )
        }
        required_ids = {
            "cmu-insfor-tools-editor-window-title",
            "cmu-insfor-tools-help-window-title",
            "cmu-insfor-tools-sapper-window-title",
        }

        self.assertTrue(required_ids.issubset(consumer_ids))
        self.assertEqual(
            consumer_ids,
            getattr(validator, "CMU_INSURGENCY_TOOLS_TARGET_ONLY_MESSAGES", frozenset()),
        )
        self.assertTrue(all(
            validator.TARGET_ONLY_MESSAGE_OVERRIDES[message_id] == "_AU14"
            for message_id in consumer_ids
        ))

        target = root / "Resources/Locale/es-ES/_AU14/insurgency/insurgency-tools.ftl"
        self.assertTrue(target.is_file())
        target_ids = set(re.findall(
            r"(?m)^([a-z][a-z0-9-]*)\s*=",
            target.read_text(encoding="utf-8-sig"),
        ))
        self.assertEqual(target_ids, consumer_ids)

        raw_patterns = (
            re.compile(r'\b(?:Text|Title|PlaceHolder)\s*=\s*"([^"\r\n]+)"'),
            re.compile(
                r'\b(?:Header|LabeledLine|LabeledMultiline|EntityField|IconField|'
                r'PlatoonListEditor|EntityListEditor|PickerListEditor|CreatePanel)\(\s*"([^"\r\n]+)"'
            ),
        )
        direct_literals: list[str] = []
        for consumer in consumers:
            text = consumer.read_text(encoding="utf-8-sig")
            for pattern in raw_patterns:
                for match in pattern.finditer(text):
                    if match.group(1) == "X":
                        continue
                    line = text.count("\n", 0, match.start()) + 1
                    direct_literals.append(f"{consumer.relative_to(root)}:{line}: {match.group(1)}")

        self.assertEqual(direct_literals, [])

    def test_cmu_blackfoot_target_only_manifest_matches_live_consumers(self) -> None:
        root = Path(__file__).resolve().parents[2]
        consumers = (
            root / "Content.Server/_CMU14/Blackfoot/BlackfootDoorGunSystem.cs",
            root / "Content.Server/_CMU14/Blackfoot/BlackfootFlightSystem.cs",
            root / "Content.Server/_CMU14/Blackfoot/BlackfootLandingPadSystem.cs",
            root / "Content.Server/_CMU14/Blackfoot/BlackfootRearDoorSystem.cs",
            root / "Content.Server/_CMU14/Blackfoot/BlackfootSupportDeploySystem.cs",
            root / "Content.Server/_CMU14/Blackfoot/BlackfootTowSystem.cs",
        )
        consumer_ids = {
            message_id
            for consumer in consumers
            for message_id in re.findall(
                r"\bcmu-blackfoot-[a-z0-9-]+\b",
                consumer.read_text(encoding="utf-8-sig"),
            )
        }
        required_ids = {
            "cmu-blackfoot-door-gun-open-rear-door",
            "cmu-blackfoot-flight-engines-idling",
            "cmu-blackfoot-landing-pad-cycle-started",
            "cmu-blackfoot-rear-door-opened",
            "cmu-blackfoot-support-pack-wrench",
            "cmu-blackfoot-tow-attached",
        }

        self.assertTrue(required_ids.issubset(consumer_ids))
        self.assertGreater(len(consumer_ids), 80)
        self.assertEqual(
            consumer_ids,
            getattr(validator, "CMU_BLACKFOOT_TARGET_ONLY_MESSAGES", frozenset()),
        )
        self.assertTrue(all(
            validator.TARGET_ONLY_MESSAGE_OVERRIDES[message_id] == "_CMU14"
            for message_id in consumer_ids
        ))

        target = root / "Resources/Locale/es-ES/_CMU14/blackfoot.ftl"
        self.assertTrue(target.is_file())
        target_ids = set(re.findall(
            r"(?m)^([a-z][a-z0-9-]*)\s*=",
            target.read_text(encoding="utf-8-sig"),
        ))
        self.assertEqual(target_ids, consumer_ids)

        direct_literals: list[str] = []

        def is_inside_localization_call(text: str, offset: int) -> bool:
            for call in ("Ui(", "YamlUi("):
                call_start = text.rfind(call, 0, offset)
                if call_start < 0:
                    continue

                open_call = text[call_start:offset]
                if open_call.count("(") > open_call.count(")"):
                    return True

            return False

        for consumer in consumers:
            text = consumer.read_text(encoding="utf-8-sig")
            for match in re.finditer(r'\$?"((?:\\.|[^"\\])*)"', text):
                literal = match.group(1)
                if " " not in literal or not re.search(r"[A-Za-z]", literal):
                    continue
                line_start = text.rfind("\n", 0, match.start()) + 1
                line_end = text.find("\n", match.end())
                if line_end < 0:
                    line_end = len(text)
                line_text = text[line_start:line_end]
                if "Ui(" in line_text or is_inside_localization_call(text, match.start()):
                    continue
                line = text.count("\n", 0, match.start()) + 1
                direct_literals.append(
                    f"{consumer.relative_to(root)}:{line}: {literal}"
                )

        self.assertEqual(direct_literals, [])

    def test_cmu_blackfoot_yaml_popup_overrides_match_live_component_fields(self) -> None:
        root = Path(__file__).resolve().parents[2]
        support_source = (
            root / "Content.Server/_CMU14/Blackfoot/BlackfootSupportDeploySystem.cs"
        ).read_text(encoding="utf-8-sig")
        runtime_fields = {
            ("BlackfootDeployableSupport", "toolPopup", "ent.Comp.ToolPopup"),
            ("BlackfootDeployableSupport", "deployPopup", "ent.Comp.DeployPopup"),
            ("BlackfootPackableSupport", "initialPopup", "ent.Comp.InitialPopup"),
            ("BlackfootPackableSupport", "panelPopup", "ent.Comp.PanelPopup"),
            ("BlackfootPackableSupport", "packedPopup", "ent.Comp.PackedPopup"),
        }
        for component, field, access in runtime_fields:
            self.assertRegex(
                support_source,
                rf'YamlUi\(\s*"{component}"\s*,\s*"{field}"\s*,\s*{re.escape(access)}\s*\)',
            )

        configured = {
            ("BlackfootPackableSupport", "initialPopup", "The landing pad anchor bolts are loosened."),
            ("BlackfootPackableSupport", "panelPopup", "The landing pad service panel is opened."),
            ("BlackfootPackableSupport", "packedPopup", "The Blackfoot landing pad is folded and packed."),
            ("BlackfootPackableSupport", "initialPopup", "The flight computer anchor bolts are loosened."),
            ("BlackfootPackableSupport", "panelPopup", "The flight computer service panel is opened."),
            ("BlackfootPackableSupport", "packedPopup", "The Blackfoot flight computer is packed into its case."),
            ("BlackfootPackableSupport", "initialPopup", "The fuel pump anchor bolts are loosened."),
            ("BlackfootPackableSupport", "panelPopup", "The fuel pump service panel is opened."),
            ("BlackfootPackableSupport", "packedPopup", "The Blackfoot fuel pump is packed into its case."),
            ("BlackfootDeployableSupport", "toolPopup", "Use a wrench to unfold the Blackfoot landing pad."),
            ("BlackfootDeployableSupport", "deployPopup", "The folded Blackfoot landing pad is set in place."),
            ("BlackfootDeployableSupport", "toolPopup", "Place this case on a deployed Blackfoot landing pad, then wrench it into the fuel pump mount."),
            ("BlackfootDeployableSupport", "deployPopup", "The Blackfoot fuel pump is mounted to the landing pad."),
            ("BlackfootDeployableSupport", "toolPopup", "Place this case on a deployed Blackfoot landing pad, then wrench it into the flight computer mount."),
            ("BlackfootDeployableSupport", "deployPopup", "The Blackfoot flight computer is mounted to the landing pad."),
        }
        expected = frozenset(
            literal_override_id(component, field, fallback)
            for component, field, fallback in configured
        )
        live_ids = collect_scoped_literal_override_ids(validator.PROTOTYPES)
        ftl_text = (
            validator.SPANISH / validator.SCOPED_LITERAL_OVERRIDE_PATH
        ).read_text(encoding="utf-8")
        ftl_ids = frozenset(
            match.group(1)
            for match in re.finditer(r"^(-?[A-Za-z][A-Za-z0-9_-]*)\s*=", ftl_text, re.MULTILINE)
        )

        self.assertEqual(len(expected), 15)
        self.assertTrue(expected.issubset(live_ids), expected - live_ids)
        self.assertTrue(expected.issubset(ftl_ids), expected - ftl_ids)

    def test_cmu_ambassador_target_only_manifest_matches_live_consumers(self) -> None:
        root = Path(__file__).resolve().parents[2]
        consumers = (
            root / "Content.Client/AU14/Ambassador/AmbassadorConsoleWindow.xaml",
            root / "Content.Client/AU14/Ambassador/AmbassadorConsoleWindow.xaml.cs",
            root / "Content.Client/AU14/Ambassador/AmbassadorThirdPartyWindow.xaml",
            root / "Content.Client/AU14/Ambassador/AmbassadorThirdPartyWindow.xaml.cs",
            root / "Content.Server/AU14/Ambassador/AmbassadorConsoleSystem.cs",
        )
        consumer_ids = {
            message_id
            for consumer in consumers
            for message_id in re.findall(
                r"\bcmu-ambassador-[a-z0-9-]+\b",
                consumer.read_text(encoding="utf-8-sig"),
            )
        }
        manifest = getattr(
            validator,
            "CMU_AMBASSADOR_TARGET_ONLY_MESSAGES",
            frozenset(),
        )

        self.assertGreater(len(consumer_ids), 50)
        self.assertEqual(consumer_ids, manifest)
        self.assertTrue(all(
            validator.TARGET_ONLY_MESSAGE_OVERRIDES[message_id] == "_AU14"
            for message_id in consumer_ids
        ))

        target = root / "Resources/Locale/es-ES/_AU14/ambassador/ambassador-ui.ftl"
        self.assertTrue(target.is_file())
        target_ids = set(re.findall(
            r"(?m)^([a-z][a-z0-9-]*)\s*=",
            target.read_text(encoding="utf-8-sig") if target.is_file() else "",
        ))
        self.assertEqual(target_ids, consumer_ids)

        direct_literals: list[str] = []
        for consumer in consumers:
            text = consumer.read_text(encoding="utf-8-sig")
            if consumer.suffix == ".xaml":
                for match in re.finditer(
                    r'\b(?:Title|Text|PlaceHolder)="([^"]*)"',
                    text,
                ):
                    literal = match.group(1)
                    if not re.search(r"[A-Za-z]", literal):
                        continue
                    if literal.startswith("{loc:CMULoc "):
                        continue
                    line = text.count("\n", 0, match.start()) + 1
                    direct_literals.append(
                        f"{consumer.relative_to(root)}:{line}: {literal}"
                    )
                continue

            for match in re.finditer(r'\$?"((?:\\.|[^"\\])*)"', text):
                literal = match.group(1)
                visible_literal = re.sub(r"\{[^{}]*\}", "", literal)
                if " " not in visible_literal or not re.search(r"[A-Za-z]", visible_literal):
                    continue

                localized = False
                for call in ("Target(", "Ui(", "CMUPrototypeLocalization.GetPrototypeText("):
                    call_start = text.rfind(call, 0, match.start())
                    if call_start >= 0:
                        open_call = text[call_start:match.start()]
                        if open_call.count("(") > open_call.count(")"):
                            localized = True
                            break
                if localized:
                    continue

                line = text.count("\n", 0, match.start()) + 1
                direct_literals.append(
                    f"{consumer.relative_to(root)}:{line}: {literal}"
                )

        self.assertEqual(direct_literals, [])

    def test_cmu_colony_economy_target_only_manifest_matches_live_consumers(self) -> None:
        root = Path(__file__).resolve().parents[2]
        client_root = root / "Content.Client" / "AU14" / "ColonyEconomy"
        server_root = root / "Content.Server" / "AU14" / "ColonyEconomy"
        consumer_paths = sorted(client_root.glob("*.xaml")) + [
            client_root / name
            for name in (
                "AdminConsoleThirdPartyWindow.xaml.cs",
                "AdminConsoleWindow.xaml.cs",
                "AU14CashVendorWindow.xaml.cs",
                "AU14ShopkeeperVendorWindow.xaml.cs",
                "BudgetConsoleBui.cs",
                "ColonyAtmBui.cs",
                "CorporateConsoleThirdPartyWindow.xaml.cs",
                "CorporateConsoleWindow.xaml.cs",
                "DepartmentConsoleWindow.xaml.cs",
            )
        ] + [
            server_root / name
            for name in (
                "AdminConsoleSystem.cs",
                "CashVendorSystem.cs",
                "CorporateConsoleSystem.cs",
                "DepartmentConsoleSystem.cs",
            )
        ]
        consumer_pattern = re.compile(r"\bcmu-colony-economy-[a-z0-9-]+\b")
        consumers: set[str] = set()
        for path in consumer_paths:
            consumers.update(consumer_pattern.findall(path.read_text(encoding="utf-8-sig")))

        manifest = getattr(
            validator,
            "CMU_COLONY_ECONOMY_TARGET_ONLY_MESSAGES",
            frozenset(),
        )
        self.assertEqual(consumers, manifest)
        self.assertGreaterEqual(len(manifest), 80)

        target = (
            root
            / "Resources"
            / "Locale"
            / "es-ES"
            / "_AU14"
            / "colony-economy"
            / "colony-economy-ui.ftl"
        )
        self.assertTrue(target.is_file())
        target_ids = (
            set(re.findall(
                r"(?m)^([a-z0-9][a-z0-9-]*)\s*=",
                target.read_text(encoding="utf-8-sig"),
            ))
            if target.is_file()
            else set()
        )
        self.assertEqual(target_ids, consumers)

        direct_xaml: list[str] = []
        for path in client_root.glob("*.xaml"):
            text = path.read_text(encoding="utf-8-sig")
            for match in re.finditer(
                r'\b(?:Title|Text|PlaceHolder)\s*=\s*"([^"]*)"',
                text,
            ):
                value = match.group(1)
                if not re.search(r"[A-Za-z]", value):
                    continue
                if value.startswith("{loc:CMULoc "):
                    continue
                direct_xaml.append(f"{path.relative_to(root).as_posix()}:{value}")

        self.assertEqual(
            direct_xaml,
            [],
            "Colony Economy XAML still contains visible direct literals outside CMULoc.",
        )

    def test_cmu_rmc_vehicle_target_only_manifest_matches_live_consumers(self) -> None:
        root = Path(__file__).resolve().parents[2]
        roots = (
            root / "Content.Client" / "_RMC14" / "Vehicle",
            root / "Content.Shared" / "_RMC14" / "Vehicle",
            root / "Content.Server" / "_RMC14" / "Vehicle",
        )
        consumer_paths = sorted(
            path
            for consumer_root in roots
            for pattern in ("*.cs", "*.xaml")
            for path in consumer_root.rglob(pattern)
        )
        consumer_pattern = re.compile(r"\bcmu-rmc-vehicle-[a-z0-9-]+\b")
        consumers = {
            message_id
            for path in consumer_paths
            for message_id in consumer_pattern.findall(
                path.read_text(encoding="utf-8-sig")
            )
        }
        manifest = getattr(
            validator,
            "CMU_RMC_VEHICLE_TARGET_ONLY_MESSAGES",
            frozenset(),
        )

        self.assertEqual(consumers, manifest)
        self.assertGreaterEqual(len(manifest), 50)
        self.assertTrue(all(
            validator.TARGET_ONLY_MESSAGE_OVERRIDES[message_id] == "_RMC14"
            for message_id in consumers
        ))

        target = (
            root
            / "Resources"
            / "Locale"
            / "es-ES"
            / "_RMC14"
            / "vehicle-target-only.ftl"
        )
        self.assertTrue(target.is_file())
        target_ids = (
            set(re.findall(
                r"(?m)^([a-z0-9][a-z0-9-]*)\s*=",
                target.read_text(encoding="utf-8-sig"),
            ))
            if target.is_file()
            else set()
        )
        self.assertEqual(target_ids, consumers)

        direct_xaml: list[str] = []
        for path in roots[0].rglob("*.xaml"):
            text = path.read_text(encoding="utf-8-sig")
            for match in re.finditer(
                r'\b(?:Title|Text|PlaceHolder|LabelText|ToolTip)\s*=\s*"([^"]*)"',
                text,
            ):
                value = match.group(1)
                if not re.search(r"[A-Za-z]", value):
                    continue
                if value.startswith("{loc:CMULoc "):
                    continue
                direct_xaml.append(f"{path.relative_to(root).as_posix()}:{value}")

        self.assertEqual(
            direct_xaml,
            [],
            "RMC Vehicle XAML still contains visible direct literals outside CMULoc.",
        )

    def test_compare_accepts_only_declared_message_function_divergence(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            source = root / "source.ftl"
            translated = root / "translated.ftl"
            source.write_text(
                "construction-presenter-arbitrary-step = { LOC($name) }\n"
                "construction-presenter-stack-step = { LOC($stack) }\n",
                encoding="utf-8",
                newline="\n",
            )
            translated.write_text(
                "construction-presenter-arbitrary-step = { $name }\n"
                "construction-presenter-stack-step = { LOC($stack) }\n",
                encoding="utf-8",
                newline="\n",
            )

            accepted = compare(
                Path("construction/ui/construction-menu-presenter.ftl"),
                source,
                translated,
            )

            translated.write_text(
                "construction-presenter-arbitrary-step = { $name }\n"
                "construction-presenter-stack-step = { $stack }\n",
                encoding="utf-8",
                newline="\n",
            )
            rejected = compare(
                Path("construction/ui/construction-menu-presenter.ftl"),
                source,
                translated,
            )

        self.assertEqual(accepted, [])
        self.assertTrue(any("functions differ" in error for error in rejected))

    def test_compare_reports_placeholder_moved_between_messages(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            source = root / "source.ftl"
            translated = root / "translated.ftl"
            source.write_text(
                "first = One { $one }\nsecond = Two { $two }\n",
                encoding="utf-8",
            )
            translated.write_text(
                "first = Uno { $two }\nsecond = Dos { $one }\n",
                encoding="utf-8",
            )

            errors = compare(Path("example.ftl"), source, translated)

        self.assertTrue(any("message_syntax differ" in error for error in errors))

    def test_compare_reports_unparsed_top_level_text(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            source = root / "source.ftl"
            translated = root / "translated.ftl"
            source.write_text("first = One\nsecond = Two\n", encoding="utf-8")
            translated.write_text("first = Uno\n501|\nsecond = Dos\n", encoding="utf-8")

            errors = compare(Path("example.ftl"), source, translated)

        self.assertTrue(any("invalid top-level Fluent text" in error for error in errors))

    def test_compare_reports_invalid_fluent_string_escape(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            source = root / "source.ftl"
            translated = root / "translated.ftl"
            source.write_text(
                r'message = { TOSTRING($left, "m\\:ss") }' + "\n",
                encoding="utf-8",
            )
            translated.write_text(
                r'message = { TOSTRING($left, "m\:ss") }' + "\n",
                encoding="utf-8",
            )

            errors = compare(Path("example.ftl"), source, translated)

        self.assertTrue(any("invalid Fluent string escape" in error for error in errors))

    def test_compare_accepts_fluent_unicode_escape(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            source = root / "source.ftl"
            translated = root / "translated.ftl"
            source.write_text(r'message = First{"\u000A"}Second' + "\n", encoding="utf-8")
            translated.write_text(r'message = Primero{"\u000A"}Segundo' + "\n", encoding="utf-8")

            errors = compare(Path("example.ftl"), source, translated)

        self.assertEqual(errors, [])

    def test_single_capital_before_parenthesis_is_not_a_function(self) -> None:
        text = "message = Pulsa Z (predeterminado) y únete a GOVFOR (fuerzas gubernamentales).\n"

        self.assertFalse(structure(text).functions)

    def test_plain_dollar_text_is_not_a_fluent_variable(self) -> None:
        text = "message = { $minutes } minutos, not a variable: $minutes\n"

        self.assertEqual(structure(text).variables, {"$minutes": 1})

    def test_visible_command_placeholders_may_be_localized(self) -> None:
        source = "message = Usage: command [player] <username>\n"
        translated = "message = Uso: command [jugador] <nombre de usuario>\n"

        self.assertEqual(structure(source), structure(translated))

    def test_validate_rejects_unresolved_accent_localization_reference(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            content_en = root / "content-en"
            engine_en = root / "engine-en"
            spanish = root / "es-ES"
            prototypes = root / "Prototypes"
            content_en.mkdir()
            engine_en.mkdir()
            spanish.mkdir()
            prototypes.mkdir()
            (content_en / "speech.ftl").write_text(
                "accent-test-trigger = test\n",
                encoding="utf-8",
                newline="\n",
            )
            (spanish / "speech.ftl").write_text(
                "accent-test-trigger = prueba\n",
                encoding="utf-8",
                newline="\n",
            )
            (prototypes / "accents.yml").write_text(
                "- type: accent\n"
                "  id: TestAccent\n"
                "  wordReplacements:\n"
                "    accent-test-trigger: accent-test-missing\n",
                encoding="utf-8",
                newline="\n",
            )

            with (
                patch.object(validator, "CONTENT_EN", content_en),
                patch.object(validator, "ENGINE_EN", engine_en),
                patch.object(validator, "SPANISH", spanish),
                patch.object(validator, "PROTOTYPES", prototypes),
                patch.object(
                    validator,
                    "FALLBACK_MANIFEST",
                    spanish / "intentional-fallbacks.txt",
                ),
            ):
                errors = validator.validate()

        self.assertIn(
            "accents.yml: accent TestAccent references unresolved localization ID "
            "accent-test-missing",
            errors,
        )

    def test_compare_rejects_unknown_spanish_grammar_mode(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            source = root / "source.ftl"
            translated = root / "translated.ftl"
            source.write_text(
                "example = { POSS-ADJ($entity) } hands\n",
                encoding="utf-8",
                newline="\n",
            )
            translated.write_text(
                'example = { POSS-ADJ($entity, "plurla") } manos\n',
                encoding="utf-8",
                newline="\n",
            )

            errors = compare(Path("example.ftl"), source, translated)

        self.assertTrue(any("unsupported Spanish grammar mode" in error for error in errors), errors)

    def test_engine_grammar_may_add_spanish_selector(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            source = root / "source.ftl"
            translated = root / "translated.ftl"
            source.write_text("zzzz-the = the { $ent }\n", encoding="utf-8")
            translated.write_text(
                "zzzz-the = { GENDER($ent) ->\n"
                "    [female] la { $ent }\n"
                "   *[other] el { $ent }\n"
                "}\n",
                encoding="utf-8",
            )

            errors = compare(Path("_engine_lib.ftl"), source, translated)

        self.assertEqual(errors, [])


if __name__ == "__main__":
    unittest.main()
