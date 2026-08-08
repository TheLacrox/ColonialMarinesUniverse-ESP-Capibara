import tempfile
from pathlib import Path
import unittest

from Tools.audit_spanish_visible_yaml import (
    all_owners,
    find_unlocalized_entity_fields,
    literal_override_id,
    load_entity_prototypes,
    scan_prototype_tree,
)


class AuditSpanishVisibleYamlTest(unittest.TestCase):
    def test_default_scan_audits_vanilla_directories_too(self) -> None:
        """A fork-only default silently hides the whole vanilla corpus."""

        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            prototypes = root / "Prototypes"
            fork = prototypes / "_CMU14" / "fork.yml"
            fork.parent.mkdir(parents=True)
            fork.write_text(
                "- type: entity\n  id: ForkThing\n  name: fork thing\n",
                encoding="utf-8",
                newline="\n",
            )
            vanilla = prototypes / "Entities" / "vanilla.yml"
            vanilla.parent.mkdir(parents=True)
            vanilla.write_text(
                "- type: entity\n  id: WaterTank\n  name: water tank\n",
                encoding="utf-8",
                newline="\n",
            )
            locale = root / "Locale"
            locale.mkdir()

            self.assertEqual(all_owners(prototypes), ("Entities", "_CMU14"))

            everything = scan_prototype_tree(prototypes, locale)
            fork_only = scan_prototype_tree(prototypes, locale, owners=("_CMU14",))

        self.assertEqual(
            sorted(finding.prototype_id for finding in everything.unlocalized),
            ["ForkThing", "WaterTank"],
        )
        self.assertEqual(
            [finding.prototype_id for finding in fork_only.unlocalized],
            ["ForkThing"],
        )

    def test_scan_recognizes_surgery_display_and_step_label_sidecars(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            prototypes = root / "Prototypes"
            source = prototypes / "_CMU14" / "surgery.yml"
            source.parent.mkdir(parents=True)
            source.write_text(
                "- type: cmuSurgeryStepMetadata\n"
                "  id: TestSurgeryMetadata\n"
                "  surgery: TestSurgery\n"
                "  displayName: Set Fracture\n"
                "  displayNameLocId: cmu-medical-surgery-procedure-set-fracture\n"
                "  steps:\n"
                "  - stepId: TestStep\n"
                "    label: Prepare Prosthesis\n"
                "    labelLocId: cmu-medical-surgery-step-prepare-prosthesis-label\n",
                encoding="utf-8",
                newline="\n",
            )
            locale = root / "Locale"
            locale.mkdir()
            (locale / "surgery.ftl").write_text(
                "cmu-medical-surgery-procedure-set-fracture = Reducir fractura\n"
                "cmu-medical-surgery-step-prepare-prosthesis-label = Preparar prótesis\n",
                encoding="utf-8",
                newline="\n",
            )

            report = scan_prototype_tree(prototypes, locale, owners=("_CMU14",))

        surgery_findings = [
            finding
            for finding in report.localized
            if finding.prototype_type == "cmuSurgeryStepMetadata"
        ]
        self.assertEqual(report.unlocalized, ())
        self.assertEqual(
            [(finding.key, finding.localization_id) for finding in surgery_findings],
            [
                ("displayName", "cmu-medical-surgery-procedure-set-fracture"),
                ("label", "cmu-medical-surgery-step-prepare-prosthesis-label"),
            ],
        )

    def test_scan_recognizes_tile_name_and_ignores_abstract_prototypes(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            prototypes = root / "Prototypes"
            source = prototypes / "_CMU14" / "tiles.yml"
            source.parent.mkdir(parents=True)
            source.write_text(
                "- type: entity\n"
                "  abstract: true\n"
                "  id: AbstractEntity\n"
                "  name: abstract entity name\n"
                "- type: tile\n"
                "  abstract: true\n"
                "  id: AbstractFloor\n"
                "  name: abstract floor name\n"
                "- type: tile\n"
                "  id: HunterFloor\n"
                "  name: hunter floor\n",
                encoding="utf-8",
                newline="\n",
            )
            locale = root / "Locale"
            locale.mkdir()
            (locale / "tiles.ftl").write_text(
                "tile-HunterFloor-name = suelo Yautja\n",
                encoding="utf-8",
                newline="\n",
            )

            report = scan_prototype_tree(prototypes, locale, owners=("_CMU14",))

        self.assertEqual(report.unlocalized, ())
        self.assertEqual(
            [(item.prototype_type, item.prototype_id, item.key) for item in report.localized],
            [("tile", "HunterFloor", "name")],
        )

    def test_scan_recognizes_job_override_and_existing_localization_key(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            prototypes = root / "Prototypes"
            source = prototypes / "_CMU14" / "jobs.yml"
            source.parent.mkdir(parents=True)
            source.write_text(
                "- type: job\n"
                "  id: RawJob\n"
                "  name: Raw job\n"
                "  description: A raw description.\n"
                "- type: job\n"
                "  id: KeyedJob\n"
                "  name: au14-job-name-keyedJob\n"
                "- type: guideEntry\n"
                "  id: RawGuide\n"
                "  name: Raw guide\n"
                "  text: /ServerInfo/Guidebook/RawGuide.xml\n",
                encoding="utf-8",
                newline="\n",
            )

            locale = root / "Locale"
            locale.mkdir()
            (locale / "jobs.ftl").write_text(
                "job-RawJob-name = trabajo directo\n"
                "job-RawJob-description = Una descripción directa.\n"
                "au14-job-name-keyedJob = trabajo con clave\n"
                "guide-entry-RawGuide-name = guía directa\n",
                encoding="utf-8",
                newline="\n",
            )

            report = scan_prototype_tree(prototypes, locale)

        self.assertEqual(report.unlocalized, ())
        self.assertEqual(
            [(item.prototype_type, item.prototype_id, item.key) for item in report.localized],
            [
                ("job", "RawJob", "name"),
                ("job", "RawJob", "description"),
                ("job", "KeyedJob", "name"),
                ("guideEntry", "RawGuide", "name"),
            ],
        )

    def test_scan_recognizes_alert_overrides(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            prototypes = root / "Prototypes"
            source = prototypes / "_CMU14" / "alerts.yml"
            source.parent.mkdir(parents=True)
            source.write_text(
                "- type: alert\n"
                "  id: LowOxygen\n"
                "  name: Low oxygen\n"
                "  description: You cannot breathe.\n",
                encoding="utf-8",
                newline="\n",
            )
            locale = root / "Locale"
            locale.mkdir()
            (locale / "alerts.ftl").write_text(
                "alert-LowOxygen-name = Oxígeno bajo\n"
                "alert-LowOxygen-description = No puedes respirar.\n",
                encoding="utf-8",
                newline="\n",
            )

            report = scan_prototype_tree(prototypes, locale, owners=("_CMU14",))

        self.assertEqual(report.unlocalized, ())
        self.assertEqual(
            [(item.prototype_type, item.prototype_id, item.key) for item in report.localized],
            [("alert", "LowOxygen", "name"), ("alert", "LowOxygen", "description")],
        )

    def test_scan_recognizes_visible_metadata_overrides(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            prototypes = root / "Prototypes"
            source = prototypes / "_CMU14" / "visible.yml"
            source.parent.mkdir(parents=True)
            source.write_text(
                "- type: npcFaction\n  id: GOVFOR\n  name: Government Forces\n"
                "- type: thirdParty\n  id: Relief\n  displayName: Relief Party\n"
                "- type: platoon\n  id: USCM\n  name: Colonial Marines\n"
                "- type: announcementPreset\n  id: Alert\n  name: Alert\n  style:\n    title:\n      title: ALERT\n"
                "- type: gamePreset\n  id: Distress\n  name: Distress Signal\n  description: Investigate the signal.\n"
                "- type: customHoliday\n  id: Founding\n  name: Founding Day\n  description: A commemoration.\n"
                "- type: objectiveIntelTier\n  id: Tier0\n  title: Exterior\n  description: Basic information.\n"
                "- type: material\n  id: Dollar\n  name: one dollar bill\n",
                encoding="utf-8",
                newline="\n",
            )
            locale = root / "Locale"
            locale.mkdir()
            (locale / "visible.ftl").write_text(
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

            report = scan_prototype_tree(prototypes, locale, owners=("_CMU14",))

        self.assertEqual(report.unlocalized, ())
        self.assertEqual(len(report.localized), 12)

    def test_scan_recognizes_access_overrides(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            prototypes = root / "Prototypes"
            source = prototypes / "_CMU14" / "access.yml"
            source.parent.mkdir(parents=True)
            source.write_text(
                "- type: accessLevel\n"
                "  id: Command\n"
                "  name: Command\n"
                "- type: accessGroup\n"
                "  id: MarineMain\n"
                "  name: Marines\n"
                "  tags: [Command]\n",
                encoding="utf-8",
                newline="\n",
            )
            locale = root / "Locale"
            locale.mkdir()
            (locale / "access.ftl").write_text(
                "access-level-Command-name = Mando\n"
                "access-group-MarineMain-name = Marines\n",
                encoding="utf-8",
                newline="\n",
            )

            report = scan_prototype_tree(prototypes, locale, owners=("_CMU14",))

        self.assertEqual(report.unlocalized, ())
        self.assertEqual(
            [(item.prototype_type, item.prototype_id, item.key) for item in report.localized],
            [("accessLevel", "Command", "name"), ("accessGroup", "MarineMain", "name")],
        )

    def test_scan_uses_nested_name_loc_id_and_ignores_technical_body_name(self) -> None:
        with tempfile.TemporaryDirectory() as temp_dir:
            root = Path(temp_dir)
            prototypes = root / "Prototypes"
            locale = root / "Locale"
            prototype = prototypes / "_CMU14" / "slots.yml"
            prototype.parent.mkdir(parents=True)
            prototype.write_text(
                """- type: entity
  id: LocalizedBelt
  components:
  - type: ItemSlots
    slots:
      item:
        name: assault shotgun
        nameLocId: cmu-item-slot-assault-shotgun
- type: body
  id: TechnicalBody
  name: technical species name
  root: torso
  slots: {}
""",
                encoding="utf-8",
            )
            localized = locale / "_CMU14" / "slots.ftl"
            localized.parent.mkdir(parents=True)
            localized.write_text(
                "cmu-item-slot-assault-shotgun = escopeta de asalto\n",
                encoding="utf-8",
            )

            report = scan_prototype_tree(prototypes, locale, owners=("_CMU14",))

            self.assertEqual(report.unlocalized, ())
            self.assertEqual(
                [(finding.value, finding.localization_id) for finding in report.localized],
                [("assault shotgun", "cmu-item-slot-assault-shotgun")],
            )

    def test_scan_recognizes_scoped_literal_override_without_cross_component_leakage(self) -> None:
        with tempfile.TemporaryDirectory() as temp_dir:
            root = Path(temp_dir)
            prototypes = root / "Prototypes"
            locale = root / "Locale"
            prototype = prototypes / "_CMU14" / "vendors.yml"
            prototype.parent.mkdir(parents=True)
            prototype.write_text(
                """- type: entity
  id: LocalizedVendor
  components:
  - type: CMAutomatedVendor
    sections:
    - name: Weapons
  - type: RequisitionsComputer
    categories:
    - name: Weapons
  - type: ANPRCRadio
    slots:
    - label: CELL
  - type: Scope
    zoomLevels:
    - name: 2x
- type: entity
  id: UnrelatedPrototype
  components:
  - type: OtherVisibleComponent
    name: Weapons
""",
                encoding="utf-8",
            )
            localized = locale / "_CMU14" / "nested.ftl"
            localized.parent.mkdir(parents=True)
            localized.write_text(
                f"{literal_override_id('CMAutomatedVendor', 'name', 'Weapons')} = Armas\n"
                f"{literal_override_id('RequisitionsComputer', 'name', 'Weapons')} = Armas\n"
                f"{literal_override_id('ANPRCRadio', 'label', 'CELL')} = CELL\n"
                f"{literal_override_id('Scope', 'name', '2x')} = 2x\n",
                encoding="utf-8",
            )

            report = scan_prototype_tree(prototypes, locale, owners=("_CMU14",))

            self.assertEqual(
                [(finding.component, finding.value) for finding in report.localized],
                [
                    ("CMAutomatedVendor", "Weapons"),
                    ("RequisitionsComputer", "Weapons"),
                    ("ANPRCRadio", "CELL"),
                    ("Scope", "2x"),
                ],
            )
            self.assertEqual(
                [(finding.component, finding.value) for finding in report.unlocalized],
                [("OtherVisibleComponent", "Weapons")],
            )

    def test_scan_recognizes_localized_stack_flavor_and_language_fields(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            prototypes = root / "Prototypes"
            source = prototypes / "_CMU14" / "special.yml"
            source.parent.mkdir(parents=True)
            source.write_text(
                "- type: stack\n"
                "  id: HealingGel\n"
                "  name: healing gel\n"
                "- type: flavor\n"
                "  id: SpicedApples\n"
                "  description: like spiced apples\n"
                "- type: language\n"
                "  id: English\n"
                "  name: English\n"
                "  description: A global language.\n",
                encoding="utf-8",
                newline="\n",
            )
            locale = root / "Locale"
            locale.mkdir()
            (locale / "special.ftl").write_text(
                "stack-HealingGel-name = gel curativo\n"
                "flavor-SpicedApples-description = a manzanas especiadas\n"
                "language-English-name = Inglés\n"
                "language-English-description = Un idioma global.\n",
                encoding="utf-8",
                newline="\n",
            )

            report = scan_prototype_tree(prototypes, locale)

        self.assertEqual(report.unlocalized, ())
        self.assertEqual(
            [(item.prototype_type, item.prototype_id, item.key) for item in report.localized],
            [
                ("stack", "HealingGel", "name"),
                ("flavor", "SpicedApples", "description"),
                ("language", "English", "name"),
                ("language", "English", "description"),
            ],
        )

    def test_scan_recognizes_localized_construction_fields_only(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            prototypes = root / "Prototypes"
            source = prototypes / "_CMU14" / "construction.yml"
            source.parent.mkdir(parents=True)
            source.write_text(
                "- type: construction\n"
                "  id: BuildThing\n"
                "  name: visible recipe\n"
                "  description: A visible recipe.\n"
                "  nested:\n"
                "    name: nested text\n"
                "- type: rmcConstruction\n"
                "  id: CraftThing\n"
                "  name: visible craft\n",
                encoding="utf-8",
            )
            locale = root / "Locale"
            locale.mkdir()
            (locale / "construction.ftl").write_text(
                "construction-BuildThing-name = receta visible\n"
                "construction-BuildThing-description = Una receta visible.\n"
                "rmc-construction-CraftThing-name = fabricación visible\n",
                encoding="utf-8",
            )

            report = scan_prototype_tree(prototypes, locale)

        self.assertEqual(
            [(item.prototype_type, item.prototype_id, item.key) for item in report.localized],
            [
                ("construction", "BuildThing", "name"),
                ("construction", "BuildThing", "description"),
                ("rmcConstruction", "CraftThing", "name"),
            ],
        )
        self.assertEqual(
            [(item.prototype_type, item.prototype_id, item.key) for item in report.unlocalized],
            [("construction", "BuildThing", "name")],
        )

    def test_scan_recognizes_localized_nested_construction_step_name(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            prototypes = root / "Prototypes"
            source = prototypes / "_RMC14" / "graph.yml"
            source.parent.mkdir(parents=True)
            source.write_text(
                "- type: constructionGraph\n"
                "  id: RackGraph\n"
                "  start: start\n"
                "  graph:\n"
                "  - node: start\n"
                "    edges:\n"
                "    - to: rack\n"
                "      steps:\n"
                "      - tag: RackParts\n"
                "        name: rack parts\n",
                encoding="utf-8",
                newline="\n",
            )
            locale = root / "Locale"
            locale.mkdir()
            (locale / "construction.ftl").write_text(
                "construction-step-rack-parts-name = piezas de estantería\n",
                encoding="utf-8",
                newline="\n",
            )

            report = scan_prototype_tree(prototypes, locale, owners=("_RMC14",))

        self.assertEqual(report.unlocalized, ())
        self.assertEqual(
            [(item.prototype_type, item.key, item.value) for item in report.localized],
            [("constructionGraph", "name", "rack parts")],
        )

    def test_scan_excludes_reviewed_non_visible_prototype_fields(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            prototypes = root / "Prototypes"
            source = prototypes / "_CMU14" / "reviewed_fields.yml"
            source.parent.mkdir(parents=True)
            source.write_text(
                "- type: microwaveMealRecipe\n"
                "  id: TestRecipe\n"
                "  name: internal recipe sort key\n"
                "- type: announcementPreset\n"
                "  id: TestAnnouncement\n"
                "  name: Visible announcement name\n"
                "  description: unused announcement metadata\n"
                "- type: inventoryTemplate\n"
                "  id: TestInventory\n"
                "  name: internal slot identifier\n"
                "  displayName: unused slot metadata\n"
                "- type: entity\n"
                "  id: TestGivenHands\n"
                "  components:\n"
                "  - type: GiveHands\n"
                "    hands:\n"
                "    - name: Left Hand\n"
                "- type: gamePreset\n"
                "  id: TestGameMode\n"
                "  name: Visible game mode\n"
                "  description: Visible game mode description\n",
                encoding="utf-8",
                newline="\n",
            )
            locale = root / "Locale"
            locale.mkdir()

            report = scan_prototype_tree(prototypes, locale)

        self.assertEqual(
            [(item.prototype_type, item.prototype_id, item.key) for item in report.unlocalized],
            [
                ("announcementPreset", "TestAnnouncement", "name"),
                ("gamePreset", "TestGameMode", "name"),
                ("gamePreset", "TestGameMode", "description"),
            ],
        )

    def test_scan_recognizes_localized_rank_name(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            prototypes = root / "Prototypes"
            source = prototypes / "_CMU14" / "ranks.yml"
            source.parent.mkdir(parents=True)
            source.write_text(
                "- type: rank\n"
                "  id: Officer\n"
                "  name: Officer\n"
                "  prefix: Off.\n"
                "  malePrefix: Mr.\n"
                "  femalePrefix: Ms.\n",
                encoding="utf-8",
            )
            locale = root / "Locale"
            locale.mkdir()
            (locale / "ranks.ftl").write_text(
                "rank-Officer = Oficial\n"
                "    .prefix = Of.\n"
                "    .prefix-male = Sr.\n"
                "    .prefix-female = Sra.\n",
                encoding="utf-8",
            )

            report = scan_prototype_tree(prototypes, locale)

        self.assertEqual(report.unlocalized, ())
        self.assertEqual(
            [(item.prototype_type, item.prototype_id, item.key) for item in report.localized],
            [
                ("rank", "Officer", "name"),
                ("rank", "Officer", "prefix"),
                ("rank", "Officer", "malePrefix"),
                ("rank", "Officer", "femalePrefix"),
            ],
        )

    def test_scan_treats_localized_entity_suffix_as_effectively_covered(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            prototypes = root / "Prototypes"
            source = prototypes / "_CMU14" / "entities.yml"
            source.parent.mkdir(parents=True)
            source.write_text(
                "- type: entity\n"
                "  id: LocalizedThing\n"
                "  name: visible thing\n"
                "  description: A visible thing.\n"
                "  suffix: Debug\n",
                encoding="utf-8",
            )
            locale = root / "Locale"
            locale.mkdir()
            (locale / "entities.ftl").write_text(
                "ent-LocalizedThing = objeto visible\n"
                "    .desc = Un objeto visible.\n"
                "    .suffix = Depuración\n",
                encoding="utf-8",
            )

            report = scan_prototype_tree(prototypes, locale)

        self.assertEqual(report.unlocalized, ())
        self.assertEqual(
            [item.key for item in report.localized],
            ["name", "description"],
        )
        self.assertEqual(report.entity_fields, ())

    def test_scan_report_includes_inherited_entity_candidates(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            prototypes = root / "Prototypes"
            source = prototypes / "_CMU14" / "entities.yml"
            source.parent.mkdir(parents=True)
            source.write_text(
                "- type: entity\n"
                "  id: BaseThing\n"
                "  abstract: true\n"
                "  name: base thing\n"
                "- type: entity\n"
                "  id: ChildThing\n"
                "  parent: BaseThing\n",
                encoding="utf-8",
            )
            locale = root / "Locale"
            locale.mkdir()

            report = scan_prototype_tree(prototypes, locale)

        self.assertEqual(
            [(item.prototype_id, item.field) for item in report.entity_fields],
            [("ChildThing", "name")],
        )

    def test_loader_accepts_robust_tags_and_excludes_generated_tree(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            source = root / "_CMU14" / "Entities" / "example.yml"
            source.parent.mkdir(parents=True)
            source.write_text(
                "- type: entity\n"
                "  id: VisibleEntity\n"
                "  name: Visible name\n"
                "  description: >-\n"
                "    A visible description\n"
                "    continued on another line.\n"
                "  components:\n"
                "  - type: Example\n"
                "    value: !type:SoundPathSpecifier\n"
                "\t      path: /Audio/example.ogg\n",
                encoding="utf-8",
            )
            generated = root / "_AU14" / "CustomConstruction" / "Generated" / "generated.yml"
            generated.parent.mkdir(parents=True)
            generated.write_text(
                "- type: entity\n  id: GeneratedEntity\n  name: Generated name\n",
                encoding="utf-8",
            )

            entities = load_entity_prototypes(root)

        self.assertIn("VisibleEntity", entities)
        self.assertNotIn("GeneratedEntity", entities)
        self.assertEqual(entities["VisibleEntity"].set_name, "Visible name")
        self.assertEqual(
            entities["VisibleEntity"].set_description,
            "A visible description continued on another line.",
        )

    def test_entity_audit_resolves_inheritance_and_localization_ids(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            prototypes = root / "Prototypes"
            source = prototypes / "_CMU14" / "entities.yml"
            source.parent.mkdir(parents=True)
            source.write_text(
                "- type: entity\n"
                "  id: BaseDoor\n"
                "  abstract: true\n"
                "  name: steel door\n"
                "  description: A sturdy door.\n"
                "  suffix: Debug\n"
                "- type: entity\n"
                "  id: InheritedDoor\n"
                "  parent: BaseDoor\n"
                "- type: entity\n"
                "  id: LocalizedDoor\n"
                "  parent: BaseDoor\n"
                "- type: entity\n"
                "  id: EmptyDescriptionDoor\n"
                "  parent: BaseDoor\n"
                "  description: \"\"\n"
                "  suffix: \"\"\n"
                "- type: entity\n"
                "  id: NullDescriptionDoor\n"
                "  parent: BaseDoor\n"
                "  description:\n"
                "- type: entity\n"
                "  id: NumericSuffixDoor\n"
                "  parent: BaseDoor\n"
                "  suffix: 10\n"
                "- type: entity\n"
                "  id: CustomBase\n"
                "  abstract: true\n"
                "  localizationId: shared-custom-door\n"
                "  name: custom door\n"
                "  description: A custom door.\n"
                "- type: entity\n"
                "  id: CustomChild\n"
                "  parent: CustomBase\n",
                encoding="utf-8",
            )
            locale = root / "Locale"
            locale.mkdir()
            (locale / "entities.ftl").write_text(
                "ent-LocalizedDoor = puerta localizada\n"
                "    .desc = Una puerta localizada.\n"
                "    .suffix = Depuración\n"
                "shared-custom-door = puerta compartida\n"
                "    .desc = Una puerta compartida.\n"
                "    .suffix = Compartida\n",
                encoding="utf-8",
            )

            entities = load_entity_prototypes(prototypes)
            candidates = find_unlocalized_entity_fields(entities, locale)

        self.assertEqual(
            [(item.prototype_id, item.field, item.value, item.inherited_from) for item in candidates],
            [
                ("EmptyDescriptionDoor", "name", "steel door", "BaseDoor"),
                ("InheritedDoor", "description", "A sturdy door.", "BaseDoor"),
                ("InheritedDoor", "name", "steel door", "BaseDoor"),
                ("InheritedDoor", "suffix", "Debug", "BaseDoor"),
                ("NullDescriptionDoor", "description", "A sturdy door.", "BaseDoor"),
                ("NullDescriptionDoor", "name", "steel door", "BaseDoor"),
                ("NullDescriptionDoor", "suffix", "Debug", "BaseDoor"),
                ("NumericSuffixDoor", "description", "A sturdy door.", "BaseDoor"),
                ("NumericSuffixDoor", "name", "steel door", "BaseDoor"),
            ],
        )


if __name__ == "__main__":
    unittest.main()
