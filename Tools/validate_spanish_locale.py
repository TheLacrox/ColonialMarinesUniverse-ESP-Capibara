#!/usr/bin/env python3
"""Validate structural compatibility and declared coverage of es-ES Fluent.

Pass --require-complete to require every en-US source route to have either a
Spanish target or a validated declaration in intentional-fallbacks.txt.
"""

from __future__ import annotations

import argparse
from collections import Counter, defaultdict
from dataclasses import dataclass
from pathlib import Path, PurePosixPath
import re
import sys
from typing import Mapping

if __package__ in {None, ""}:
    sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

from Tools.audit_spanish_visible_yaml import (
    collect_scoped_literal_override_ids,
    EntityPrototypeRecord,
    extract_visible_yaml,
    load_entity_prototypes,
    normalize_override_segment,
)


REPO_ROOT = Path(__file__).resolve().parents[1]
CONTENT_EN = REPO_ROOT / "Resources" / "Locale" / "en-US"
ENGINE_EN = REPO_ROOT / "RobustToolbox" / "Resources" / "Locale" / "en-US"
SPANISH = REPO_ROOT / "Resources" / "Locale" / "es-ES"
PROTOTYPES = REPO_ROOT / "Resources" / "Prototypes"
FALLBACK_MANIFEST = SPANISH / "intentional-fallbacks.txt"
PROTOTYPE_OVERRIDE_ROOT = "prototype-overrides"
SCOPED_LITERAL_OVERRIDE_PATH = Path("_CMU14/yaml-literal-overrides.ftl")
PROTOTYPE_OVERRIDE_ATTRIBUTES = {"desc", "suffix"}
PROTOTYPE_OWNER_LAYERS = {"_AU14", "_CMU14", "_RMC14"}
ANPRC_UI_TARGET_ONLY_MESSAGES = frozenset({
    "cmu-anprc-ui-add",
    "cmu-anprc-ui-add-net",
    "cmu-anprc-ui-all-nets",
    "cmu-anprc-ui-anchor",
    "cmu-anprc-ui-anchor-active",
    "cmu-anprc-ui-anchor-offline",
    "cmu-anprc-ui-anchor-standby",
    "cmu-anprc-ui-antenna",
    "cmu-anprc-ui-antenna-placeholder",
    "cmu-anprc-ui-band",
    "cmu-anprc-ui-band-idle",
    "cmu-anprc-ui-band-placeholder",
    "cmu-anprc-ui-bit-no-net",
    "cmu-anprc-ui-bit-not-seated",
    "cmu-anprc-ui-bit-offline",
    "cmu-anprc-ui-bit-pass",
    "cmu-anprc-ui-bypass-armed",
    "cmu-anprc-ui-bypass-no",
    "cmu-anprc-ui-callsign",
    "cmu-anprc-ui-callsign-auto",
    "cmu-anprc-ui-callsign-directory",
    "cmu-anprc-ui-callsign-help",
    "cmu-anprc-ui-callsign-placeholder",
    "cmu-anprc-ui-cancel",
    "cmu-anprc-ui-channel",
    "cmu-anprc-ui-channel-placeholder",
    "cmu-anprc-ui-clear",
    "cmu-anprc-ui-clear-short",
    "cmu-anprc-ui-close",
    "cmu-anprc-ui-contact",
    "cmu-anprc-ui-contact-own-net",
    "cmu-anprc-ui-contact-partial",
    "cmu-anprc-ui-contacts",
    "cmu-anprc-ui-delete-short",
    "cmu-anprc-ui-destroy",
    "cmu-anprc-ui-direct-frequency",
    "cmu-anprc-ui-direct-net",
    "cmu-anprc-ui-empty",
    "cmu-anprc-ui-entry-count",
    "cmu-anprc-ui-equipped",
    "cmu-anprc-ui-fault-no-net",
    "cmu-anprc-ui-fault-none",
    "cmu-anprc-ui-fault-not-worn",
    "cmu-anprc-ui-fault-off",
    "cmu-anprc-ui-fill-loaded",
    "cmu-anprc-ui-fill-none",
    "cmu-anprc-ui-fill-superseded",
    "cmu-anprc-ui-filtered-entry-count",
    "cmu-anprc-ui-footer-status",
    "cmu-anprc-ui-frequency",
    "cmu-anprc-ui-frequency-direct",
    "cmu-anprc-ui-frequency-placeholder",
    "cmu-anprc-ui-frequency-short",
    "cmu-anprc-ui-frequency-unknown-net",
    "cmu-anprc-ui-idle",
    "cmu-anprc-ui-link-no-net",
    "cmu-anprc-ui-link-not-worn",
    "cmu-anprc-ui-link-placeholder",
    "cmu-anprc-ui-link-ready",
    "cmu-anprc-ui-link-retrans",
    "cmu-anprc-ui-link-standby",
    "cmu-anprc-ui-log-entry",
    "cmu-anprc-ui-log-entry-intercept",
    "cmu-anprc-ui-log-filter-placeholder",
    "cmu-anprc-ui-mode",
    "cmu-anprc-ui-mode-button",
    "cmu-anprc-ui-mode-button-fh",
    "cmu-anprc-ui-mode-fh",
    "cmu-anprc-ui-monitor-off",
    "cmu-anprc-ui-monitor-on",
    "cmu-anprc-ui-monitor-short",
    "cmu-anprc-ui-net",
    "cmu-anprc-ui-net-label-placeholder",
    "cmu-anprc-ui-net-list-entry",
    "cmu-anprc-ui-net-list-intercept",
    "cmu-anprc-ui-net-log",
    "cmu-anprc-ui-nets-dropped",
    "cmu-anprc-ui-new-net-label",
    "cmu-anprc-ui-no-cell",
    "cmu-anprc-ui-no-contacts",
    "cmu-anprc-ui-no-filter-matches",
    "cmu-anprc-ui-no-net",
    "cmu-anprc-ui-no-net-loaded",
    "cmu-anprc-ui-no-net-sentence",
    "cmu-anprc-ui-no-slot-active",
    "cmu-anprc-ui-not-set",
    "cmu-anprc-ui-off",
    "cmu-anprc-ui-offline",
    "cmu-anprc-ui-on",
    "cmu-anprc-ui-planted",
    "cmu-anprc-ui-power-high",
    "cmu-anprc-ui-power-low",
    "cmu-anprc-ui-power-medium",
    "cmu-anprc-ui-power-off",
    "cmu-anprc-ui-power-on",
    "cmu-anprc-ui-power-placeholder",
    "cmu-anprc-ui-preset-nets",
    "cmu-anprc-ui-presets",
    "cmu-anprc-ui-print-intercepts",
    "cmu-anprc-ui-print-log",
    "cmu-anprc-ui-radio-check",
    "cmu-anprc-ui-relay",
    "cmu-anprc-ui-retrans-station",
    "cmu-anprc-ui-role",
    "cmu-anprc-ui-rto-relay",
    "cmu-anprc-ui-scan-off",
    "cmu-anprc-ui-scan-on",
    "cmu-anprc-ui-search",
    "cmu-anprc-ui-search-head",
    "cmu-anprc-ui-search-warning",
    "cmu-anprc-ui-searching",
    "cmu-anprc-ui-secured",
    "cmu-anprc-ui-set",
    "cmu-anprc-ui-signal-short",
    "cmu-anprc-ui-slot-empty",
    "cmu-anprc-ui-squelch",
    "cmu-anprc-ui-stale",
    "cmu-anprc-ui-standby",
    "cmu-anprc-ui-start-search",
    "cmu-anprc-ui-stop-search",
    "cmu-anprc-ui-subtitle",
    "cmu-anprc-ui-transmit-hint",
    "cmu-anprc-ui-transmit-power",
    "cmu-anprc-ui-tune",
    "cmu-anprc-ui-tune-slot",
    "cmu-anprc-ui-tune-slot-label",
    "cmu-anprc-ui-unequipped",
    "cmu-anprc-ui-unknown-station",
    "cmu-anprc-ui-unsecured",
    "cmu-anprc-ui-waveform",
    "cmu-anprc-ui-waveform-los",
    "cmu-anprc-ui-waveform-placeholder",
    "cmu-anprc-ui-zero-entries",
    "cmu-anprc-ui-zeroize",
})
RMC_ROADMAP_TARGET_ONLY_MESSAGES = frozenset({
    "cmu-rmc-roadmap-almayer-description",
    "cmu-rmc-roadmap-ares-description",
    "cmu-rmc-roadmap-autodoc-and-body-scanners-description",
    "cmu-rmc-roadmap-autodoc-and-body-scanners-name",
    "cmu-rmc-roadmap-berserker-ravager-strain-name",
    "cmu-rmc-roadmap-blood-types-name",
    "cmu-rmc-roadmap-boiler-name",
    "cmu-rmc-roadmap-bullet-damage-fall-off-name",
    "cmu-rmc-roadmap-burrower-description",
    "cmu-rmc-roadmap-burrower-name",
    "cmu-rmc-roadmap-carrier-description",
    "cmu-rmc-roadmap-carrier-name",
    "cmu-rmc-roadmap-charger-crusher-strain-name",
    "cmu-rmc-roadmap-chemical-research-description",
    "cmu-rmc-roadmap-chemical-research-name",
    "cmu-rmc-roadmap-clone-damage-and-cryo-cells-description",
    "cmu-rmc-roadmap-clone-damage-and-cryo-cells-name",
    "cmu-rmc-roadmap-close-air-support-name",
    "cmu-rmc-roadmap-communications-objective-name",
    "cmu-rmc-roadmap-construction-skill-description",
    "cmu-rmc-roadmap-construction-skill-name",
    "cmu-rmc-roadmap-cpr-and-ivs-name",
    "cmu-rmc-roadmap-crusher-name",
    "cmu-rmc-roadmap-dropship-modifications-name",
    "cmu-rmc-roadmap-eggsac-carrier-strain-name",
    "cmu-rmc-roadmap-emergency-response-teams-description",
    "cmu-rmc-roadmap-emergency-response-teams-name",
    "cmu-rmc-roadmap-engineering-skill-description",
    "cmu-rmc-roadmap-engineering-skill-name",
    "cmu-rmc-roadmap-engineering-staff-description",
    "cmu-rmc-roadmap-engineering-staff-name",
    "cmu-rmc-roadmap-fire-missions-description",
    "cmu-rmc-roadmap-fire-missions-name",
    "cmu-rmc-roadmap-firearms-skill-description",
    "cmu-rmc-roadmap-firearms-skill-name",
    "cmu-rmc-roadmap-fireteam-leader-description",
    "cmu-rmc-roadmap-fireteam-leader-name",
    "cmu-rmc-roadmap-flamethrowers-description",
    "cmu-rmc-roadmap-flamethrowers-name",
    "cmu-rmc-roadmap-fractures-and-internal-bleeding-description",
    "cmu-rmc-roadmap-fractures-and-internal-bleeding-name",
    "cmu-rmc-roadmap-hedgehog-ravager-strain-name",
    "cmu-rmc-roadmap-hivelord-description",
    "cmu-rmc-roadmap-hivelord-name",
    "cmu-rmc-roadmap-intelligence-officer-name",
    "cmu-rmc-roadmap-larva-removal-surgery-description",
    "cmu-rmc-roadmap-larva-removal-surgery-name",
    "cmu-rmc-roadmap-limb-damage-description",
    "cmu-rmc-roadmap-limb-damage-name",
    "cmu-rmc-roadmap-lurker-description",
    "cmu-rmc-roadmap-lurker-name",
    "cmu-rmc-roadmap-lv-624-description",
    "cmu-rmc-roadmap-lv-759-hybrisa-prospera-planet-description",
    "cmu-rmc-roadmap-lv-759-hybrisa-prospera-planet-name",
    "cmu-rmc-roadmap-marine-squad-orders-description",
    "cmu-rmc-roadmap-marine-squad-orders-name",
    "cmu-rmc-roadmap-medical-skill-description",
    "cmu-rmc-roadmap-medical-skill-name",
    "cmu-rmc-roadmap-mess-technician-description",
    "cmu-rmc-roadmap-mess-technician-name",
    "cmu-rmc-roadmap-more-lobby-art-and-music-description",
    "cmu-rmc-roadmap-more-lobby-art-and-music-name",
    "cmu-rmc-roadmap-more-surgeries-description",
    "cmu-rmc-roadmap-more-surgeries-name",
    "cmu-rmc-roadmap-mortars-name",
    "cmu-rmc-roadmap-mounted-weapons-description",
    "cmu-rmc-roadmap-mounted-weapons-name",
    "cmu-rmc-roadmap-new-varadero-description",
    "cmu-rmc-roadmap-note-not-exhaustive",
    "cmu-rmc-roadmap-nuke-and-king-endgame-name",
    "cmu-rmc-roadmap-oppressor-praetorian-strain-name",
    "cmu-rmc-roadmap-orbital-bombardment-name",
    "cmu-rmc-roadmap-ordnance-technician-description",
    "cmu-rmc-roadmap-ordnance-technician-name",
    "cmu-rmc-roadmap-organ-damage-description",
    "cmu-rmc-roadmap-organ-damage-name",
    "cmu-rmc-roadmap-pain-and-painkillers-description",
    "cmu-rmc-roadmap-pain-and-painkillers-name",
    "cmu-rmc-roadmap-plasma-and-flamethrower-sentries-name",
    "cmu-rmc-roadmap-power-and-evacuation-description",
    "cmu-rmc-roadmap-power-and-evacuation-name",
    "cmu-rmc-roadmap-praetorian-description",
    "cmu-rmc-roadmap-praetorian-name",
    "cmu-rmc-roadmap-pve-description",
    "cmu-rmc-roadmap-ravager-name",
    "cmu-rmc-roadmap-requisitions-description",
    "cmu-rmc-roadmap-requisitions-name",
    "cmu-rmc-roadmap-smart-gun-operator-description",
    "cmu-rmc-roadmap-smart-gun-operator-name",
    "cmu-rmc-roadmap-smoke-grenades-name",
    "cmu-rmc-roadmap-solaris-ridge-description",
    "cmu-rmc-roadmap-sorokyne-strata-description",
    "cmu-rmc-roadmap-specialist-s-amr-kit-description",
    "cmu-rmc-roadmap-specialist-s-amr-kit-name",
    "cmu-rmc-roadmap-specialist-s-demolitionist-kit-name",
    "cmu-rmc-roadmap-specialist-s-grenadier-kit-name",
    "cmu-rmc-roadmap-specialist-s-pyrotechnician-kit-description",
    "cmu-rmc-roadmap-specialist-s-pyrotechnician-kit-name",
    "cmu-rmc-roadmap-specialist-s-scout-kit-name",
    "cmu-rmc-roadmap-specialist-s-sniper-kit-description",
    "cmu-rmc-roadmap-specialist-s-sniper-kit-name",
    "cmu-rmc-roadmap-spitter-description",
    "cmu-rmc-roadmap-spitter-name",
    "cmu-rmc-roadmap-squad-automated-vendors-description",
    "cmu-rmc-roadmap-squad-automated-vendors-name",
    "cmu-rmc-roadmap-squad-leader-description",
    "cmu-rmc-roadmap-squad-leader-name",
    "cmu-rmc-roadmap-state-complete",
    "cmu-rmc-roadmap-state-in-progress",
    "cmu-rmc-roadmap-state-partial",
    "cmu-rmc-roadmap-state-planned",
    "cmu-rmc-roadmap-survivors-description",
    "cmu-rmc-roadmap-survivors-name",
    "cmu-rmc-roadmap-synthetics-name",
    "cmu-rmc-roadmap-tactical-map-description",
    "cmu-rmc-roadmap-tactical-map-name",
    "cmu-rmc-roadmap-tesla-comtech-deployable-name",
    "cmu-rmc-roadmap-tier-0-xenos-name",
    "cmu-rmc-roadmap-tier-1-xenos-name",
    "cmu-rmc-roadmap-title",
    "cmu-rmc-roadmap-trapper-boiler-strain-name",
    "cmu-rmc-roadmap-treatable-wounds-name",
    "cmu-rmc-roadmap-uss-lcs-14-savannah-description",
    "cmu-rmc-roadmap-vampire-lurker-strain-name",
    "cmu-rmc-roadmap-vehicles-the-tank-and-the-arc-description",
    "cmu-rmc-roadmap-vehicles-the-tank-and-the-arc-name",
    "cmu-rmc-roadmap-version-current",
    "cmu-rmc-roadmap-version-future",
    "cmu-rmc-roadmap-version-upcoming",
    "cmu-rmc-roadmap-warrior-description",
    "cmu-rmc-roadmap-warrior-name",
    "cmu-rmc-roadmap-weapon-attachments-description",
    "cmu-rmc-roadmap-weapon-attachments-name",
    "cmu-rmc-roadmap-weather-description",
    "cmu-rmc-roadmap-weather-name",
    "cmu-rmc-roadmap-whiskey-outpost-gamemode-description",
    "cmu-rmc-roadmap-whiskey-outpost-gamemode-name",
    "cmu-rmc-roadmap-xeno-queen-description",
    "cmu-rmc-roadmap-xeno-queen-name",
    "cmu-rmc-roadmap-xeno-strains-description",
    "cmu-rmc-roadmap-xeno-strains-name",
})
CMU_INTEL_TARGET_ONLY_MESSAGES = frozenset({
    "cmu-intel-clf-colony-announcement",
    "cmu-intel-clf-fax-content",
    "cmu-intel-clf-fax-stamp",
    "cmu-intel-clf-fax-title",
    "cmu-intel-clf-govfor-announcement-empty",
    "cmu-intel-clf-govfor-announcement-identified",
    "cmu-intel-clf-roster-empty",
})
RMC_AEGIS_TARGET_ONLY_MESSAGES = frozenset({
    "cmu-aegis-marine-announcement",
    "cmu-aegis-xeno-announcement",
})
CMU_ROUND_STATISTICS_TARGET_ONLY_MESSAGES = frozenset({
    "cmu-round-statistics-average-duration",
    "cmu-round-statistics-average-suffix",
    "cmu-round-statistics-current-streak",
    "cmu-round-statistics-decided-endings",
    "cmu-round-statistics-distress-split",
    "cmu-round-statistics-draws",
    "cmu-round-statistics-draws-suffix",
    "cmu-round-statistics-excluded",
    "cmu-round-statistics-faction",
    "cmu-round-statistics-header-title",
    "cmu-round-statistics-longest-streak",
    "cmu-round-statistics-manual-detail",
    "cmu-round-statistics-manual-ending-reasons",
    "cmu-round-statistics-manual-reason",
    "cmu-round-statistics-matchup",
    "cmu-round-statistics-mode-summary",
    "cmu-round-statistics-no-data",
    "cmu-round-statistics-no-outcomes",
    "cmu-round-statistics-no-planet",
    "cmu-round-statistics-no-recent-rounds",
    "cmu-round-statistics-no-threat",
    "cmu-round-statistics-no-tracked-rounds",
    "cmu-round-statistics-none",
    "cmu-round-statistics-outcome",
    "cmu-round-statistics-outcome-breakdown",
    "cmu-round-statistics-outcome-detail",
    "cmu-round-statistics-planet-breakdown",
    "cmu-round-statistics-planet-unknown",
    "cmu-round-statistics-platoon-matchups",
    "cmu-round-statistics-platoon-unknown",
    "cmu-round-statistics-player-band",
    "cmu-round-statistics-player-count-bands",
    "cmu-round-statistics-preset",
    "cmu-round-statistics-recent-form",
    "cmu-round-statistics-recent-form-record",
    "cmu-round-statistics-recent-ten",
    "cmu-round-statistics-recorded-source",
    "cmu-round-statistics-refresh",
    "cmu-round-statistics-round-metadata",
    "cmu-round-statistics-round-title",
    "cmu-round-statistics-share-of-endings",
    "cmu-round-statistics-source",
    "cmu-round-statistics-source-detail",
    "cmu-round-statistics-source-objective",
    "cmu-round-statistics-source-withdrawal",
    "cmu-round-statistics-streak",
    "cmu-round-statistics-summary",
    "cmu-round-statistics-tab-overview",
    "cmu-round-statistics-tab-recent-rounds",
    "cmu-round-statistics-threat-breakdown",
    "cmu-round-statistics-threat-unknown",
    "cmu-round-statistics-tracked",
    "cmu-round-statistics-unknown",
    "cmu-round-statistics-unknown-suffix",
    "cmu-round-statistics-versus-summary",
    "cmu-round-statistics-waiting",
    "cmu-round-statistics-window-title",
    "cmu-round-statistics-winner",
    "cmu-round-statistics-wins",
})
CMU_INSURGENCY_TOOLS_TARGET_ONLY_MESSAGES = frozenset("""
cmu-insfor-tools-editor-window-title
cmu-insfor-tools-editor-custom-window-title
cmu-insfor-tools-editor-help
cmu-insfor-tools-editor-factions
cmu-insfor-tools-editor-new-faction
cmu-insfor-tools-editor-export-blank-sheet
cmu-insfor-tools-editor-import-filled-sheet
cmu-insfor-tools-editor-untitled
cmu-insfor-tools-editor-untitled-id
cmu-insfor-tools-editor-editing
cmu-insfor-tools-editor-field-title
cmu-insfor-tools-editor-field-recruited-message
cmu-insfor-tools-editor-field-description
cmu-insfor-tools-editor-field-roleplay-style
cmu-insfor-tools-editor-field-flag-entity
cmu-insfor-tools-editor-field-status-icon
cmu-insfor-tools-editor-field-recruited-icon
cmu-insfor-tools-editor-field-dollar-rate
cmu-insfor-tools-editor-default-faction
cmu-insfor-tools-editor-opposed-govfor
cmu-insfor-tools-editor-other-placeables
cmu-insfor-tools-editor-accept-dollars
cmu-insfor-tools-editor-tab-faction-info
cmu-insfor-tools-editor-tab-economy
cmu-insfor-tools-editor-tab-cell-kit
cmu-insfor-tools-editor-tab-vendors
cmu-insfor-tools-editor-tab-loadouts
cmu-insfor-tools-editor-save-server-custom
cmu-insfor-tools-editor-save-server-default
cmu-insfor-tools-editor-save-local-custom
cmu-insfor-tools-editor-export-sheet
cmu-insfor-tools-editor-apply-round
cmu-insfor-tools-editor-delete
cmu-insfor-tools-editor-clear
cmu-insfor-tools-editor-add
cmu-insfor-tools-editor-analyzer-submittables
cmu-insfor-tools-editor-items-per-point
cmu-insfor-tools-editor-points-per-item
cmu-insfor-tools-editor-placeholder-ratio
cmu-insfor-tools-editor-add-submittable
cmu-insfor-tools-editor-cell-kit-vendors
cmu-insfor-tools-editor-vendor-name
cmu-insfor-tools-editor-base-model
cmu-insfor-tools-editor-vendor-wrenchable
cmu-insfor-tools-editor-vendor-invulnerable
cmu-insfor-tools-editor-vendor-intel-points
cmu-insfor-tools-editor-vendor-use-base-arsenal
cmu-insfor-tools-editor-remove-vendor
cmu-insfor-tools-editor-add-vendor
cmu-insfor-tools-editor-sections
cmu-insfor-tools-editor-section-name
cmu-insfor-tools-editor-placeholder-per-player
cmu-insfor-tools-editor-placeholder-global
cmu-insfor-tools-editor-category-limit
cmu-insfor-tools-editor-remove-section
cmu-insfor-tools-editor-add-section
cmu-insfor-tools-editor-items-heading
cmu-insfor-tools-editor-placeholder-points
cmu-insfor-tools-editor-placeholder-amount
cmu-insfor-tools-editor-placeholder-max
cmu-insfor-tools-editor-add-item
cmu-insfor-tools-editor-role-loadouts
cmu-insfor-tools-editor-role-job
cmu-insfor-tools-editor-contents
cmu-insfor-tools-editor-remove-loadout
cmu-insfor-tools-editor-add-loadout
cmu-insfor-tools-editor-per-job-icons
cmu-insfor-tools-editor-add-per-job-icon
cmu-insfor-tools-editor-machine-analyzer
cmu-insfor-tools-editor-machine-intel-computer
cmu-insfor-tools-editor-machine-objectives-console
cmu-insfor-tools-editor-machine-tech-tree-console
cmu-insfor-tools-editor-machine-fax
cmu-insfor-tools-editor-default-machines
cmu-insfor-tools-editor-choose
cmu-insfor-tools-help-window-title
cmu-insfor-tools-help-introduction
cmu-insfor-tools-help-faction-list-title
cmu-insfor-tools-help-faction-list-body
cmu-insfor-tools-help-identity-title
cmu-insfor-tools-help-identity-body
cmu-insfor-tools-help-default-faction-title
cmu-insfor-tools-help-default-faction-body
cmu-insfor-tools-help-opposed-govfor-title
cmu-insfor-tools-help-opposed-govfor-body
cmu-insfor-tools-help-economy-title
cmu-insfor-tools-help-economy-body
cmu-insfor-tools-help-analyzer-title
cmu-insfor-tools-help-analyzer-body
cmu-insfor-tools-help-default-machines-title
cmu-insfor-tools-help-default-machines-body
cmu-insfor-tools-help-other-placeables-title
cmu-insfor-tools-help-other-placeables-body
cmu-insfor-tools-help-vendors-title
cmu-insfor-tools-help-vendors-body
cmu-insfor-tools-help-vendor-sections-title
cmu-insfor-tools-help-vendor-sections-body
cmu-insfor-tools-help-loadouts-title
cmu-insfor-tools-help-loadouts-body
cmu-insfor-tools-help-saving-title
cmu-insfor-tools-help-saving-body
cmu-insfor-tools-sapper-window-title
cmu-insfor-tools-sapper-tab-gunsmithing
cmu-insfor-tools-sapper-tab-fabrication
cmu-insfor-tools-sapper-no-weapon
cmu-insfor-tools-sapper-take-weapon
cmu-insfor-tools-sapper-attachment-slots
cmu-insfor-tools-sapper-load-weapon-for-slots
cmu-insfor-tools-sapper-modifiers
cmu-insfor-tools-sapper-no-modifiers
cmu-insfor-tools-sapper-empty
cmu-insfor-tools-sapper-slot-summary
cmu-insfor-tools-sapper-add
cmu-insfor-tools-sapper-remove
cmu-insfor-tools-sapper-materials
cmu-insfor-tools-sapper-no-materials-loaded
cmu-insfor-tools-sapper-material-count
cmu-insfor-tools-sapper-eject
cmu-insfor-tools-sapper-loose-ingredients
cmu-insfor-tools-sapper-loose-ingredients-help
cmu-insfor-tools-sapper-ingredient-count
cmu-insfor-tools-sapper-craft
cmu-insfor-tools-sapper-no-materials
cmu-insfor-tools-sapper-material-cost
cmu-insfor-tools-sapper-slot-rail
cmu-insfor-tools-sapper-slot-barrel
cmu-insfor-tools-sapper-slot-underbarrel
cmu-insfor-tools-sapper-slot-stock
cmu-insfor-tools-sapper-material-metal
cmu-insfor-tools-sapper-material-plasteel
cmu-insfor-tools-sapper-material-wood
cmu-insfor-tools-sapper-material-plastic
cmu-insfor-tools-sapper-ingredient-cable
cmu-insfor-tools-sapper-ingredient-electronics
cmu-insfor-tools-sapper-ingredient-power-cell
cmu-insfor-tools-sapper-ingredient-buckshot
cmu-insfor-tools-sapper-ingredient-ied
cmu-insfor-tools-sapper-ingredient-handcuffs
cmu-insfor-tools-sapper-stat-accuracy
cmu-insfor-tools-sapper-stat-damage-falloff
cmu-insfor-tools-sapper-stat-burst-scatter
cmu-insfor-tools-sapper-stat-shots-per-burst
cmu-insfor-tools-sapper-stat-damage
cmu-insfor-tools-sapper-stat-recoil
cmu-insfor-tools-sapper-stat-scatter
cmu-insfor-tools-sapper-stat-fire-delay
cmu-insfor-tools-sapper-stat-projectile-speed
cmu-insfor-tools-sapper-stat-range
cmu-insfor-tools-sapper-stat-walk-speed
cmu-insfor-tools-sapper-stat-sprint-speed
cmu-insfor-tools-sapper-stat-item-size
cmu-insfor-tools-sapper-stat-wield-delay
""".split())
CMU_BLACKFOOT_TARGET_ONLY_MESSAGES = frozenset("""\
cmu-blackfoot-door-gun-open-rear-door
cmu-blackfoot-door-gun-select-m866
cmu-blackfoot-door-gun-z-below
cmu-blackfoot-door-gun-z-current
cmu-blackfoot-flight-airborne-vtol
cmu-blackfoot-flight-airspace-blocked-offset
cmu-blackfoot-flight-already-taking-off
cmu-blackfoot-flight-altitude-airborne-only
cmu-blackfoot-flight-altitude-change-failed
cmu-blackfoot-flight-climbing-one-z
cmu-blackfoot-flight-deploy-before-takeoff
cmu-blackfoot-flight-deployed
cmu-blackfoot-flight-descending-one-z
cmu-blackfoot-flight-disconnect-tow-before-engines
cmu-blackfoot-flight-disconnect-tow-before-takeoff
cmu-blackfoot-flight-engines-idling
cmu-blackfoot-flight-engines-invalid-state
cmu-blackfoot-flight-engines-offline
cmu-blackfoot-flight-footprint-blocked-offset
cmu-blackfoot-flight-footprint-center-outside-map
cmu-blackfoot-flight-footprint-no-area
cmu-blackfoot-flight-footprint-outside-cas-airspace
cmu-blackfoot-flight-footprint-outside-lasing-airspace
cmu-blackfoot-flight-footprint-outside-map-offset
cmu-blackfoot-flight-footprint-outside-medevac-airspace
cmu-blackfoot-flight-footprint-outside-mortar-fire-airspace
cmu-blackfoot-flight-footprint-outside-mortar-placement-airspace
cmu-blackfoot-flight-footprint-outside-orbital-airspace
cmu-blackfoot-flight-footprint-outside-paradrop-airspace
cmu-blackfoot-flight-footprint-outside-supply-drop-airspace
cmu-blackfoot-flight-footprint-roofed
cmu-blackfoot-flight-idling-before-takeoff
cmu-blackfoot-flight-insufficient-fuel-takeoff
cmu-blackfoot-flight-invalid-z-map
cmu-blackfoot-flight-landed
cmu-blackfoot-flight-landing-failed-lower-z-move
cmu-blackfoot-flight-landing-failed-no-lower-z
cmu-blackfoot-flight-landing-failed-reason
cmu-blackfoot-flight-landing-sequence-started
cmu-blackfoot-flight-mode-airborne-only
cmu-blackfoot-flight-mode-engaged
cmu-blackfoot-flight-no-higher-z-climb
cmu-blackfoot-flight-no-lower-z-descend
cmu-blackfoot-flight-no-lower-z-grid-landing
cmu-blackfoot-flight-no-lower-z-landing
cmu-blackfoot-flight-no-upper-z-grid-takeoff
cmu-blackfoot-flight-no-upper-z-takeoff
cmu-blackfoot-flight-pilot-only-control
cmu-blackfoot-flight-rear-door-closed
cmu-blackfoot-flight-rear-door-controls-missing
cmu-blackfoot-flight-rear-door-opened
cmu-blackfoot-flight-start-engines-before-takeoff
cmu-blackfoot-flight-stow-grounded-only
cmu-blackfoot-flight-stowed
cmu-blackfoot-flight-switch-vtol-before-landing
cmu-blackfoot-flight-systems-restored-grounded
cmu-blackfoot-flight-takeoff-failed-no-upper-z
cmu-blackfoot-flight-takeoff-failed-reason
cmu-blackfoot-flight-takeoff-failed-thrusters
cmu-blackfoot-flight-takeoff-failed-upper-z-move
cmu-blackfoot-flight-takeoff-sequence-started
cmu-blackfoot-flight-thrusters-required-takeoff
cmu-blackfoot-flight-too-damaged-takeoff
cmu-blackfoot-flight-use-landing-sequence-ground
cmu-blackfoot-flight-vtol-airborne-before-landing
cmu-blackfoot-flight-vtol-mode-engaged
cmu-blackfoot-landing-pad-aircraft-not-parked
cmu-blackfoot-landing-pad-clear-area
cmu-blackfoot-landing-pad-cycle-started
cmu-blackfoot-landing-pad-cycle-stopped
cmu-blackfoot-landing-pad-not-linked
cmu-blackfoot-landing-pad-pack-tools
cmu-blackfoot-landing-pad-recharge-started-no-pump
cmu-blackfoot-landing-pad-valid-ground
cmu-blackfoot-look-outside
cmu-blackfoot-rear-door-closed
cmu-blackfoot-rear-door-control-not-linked
cmu-blackfoot-rear-door-open-before-boarding
cmu-blackfoot-rear-door-open-before-exiting
cmu-blackfoot-rear-door-opened
cmu-blackfoot-rear-door-too-fast
cmu-blackfoot-support-blocked-offset
cmu-blackfoot-support-deploy-on-pad
cmu-blackfoot-support-deploy-on-pad-then-wrench
cmu-blackfoot-support-floor-offset
cmu-blackfoot-support-move-aircraft-before-pack-pad
cmu-blackfoot-support-pack-final-wrench
cmu-blackfoot-support-pack-fuel-pump-before-pad
cmu-blackfoot-support-pack-screwdriver
cmu-blackfoot-support-pack-tools
cmu-blackfoot-support-pack-wrench
cmu-blackfoot-support-pad-flight-computer-mounted
cmu-blackfoot-support-pad-fuel-pump-mounted
cmu-blackfoot-support-stop-refueling-before-pack-pump
cmu-blackfoot-support-stop-service-before-pack-computer
cmu-blackfoot-support-stop-service-before-pack-pad
cmu-blackfoot-support-unknown-blocker
cmu-blackfoot-support-valid-ground
cmu-blackfoot-tow-airborne
cmu-blackfoot-tow-aircraft-invalid-map
cmu-blackfoot-tow-already-attached
cmu-blackfoot-tow-attached
cmu-blackfoot-tow-cannot-move-target
cmu-blackfoot-tow-crashed
cmu-blackfoot-tow-detached
cmu-blackfoot-tow-engines-running
cmu-blackfoot-tow-invalid-state
cmu-blackfoot-tow-no-towable-nearby
cmu-blackfoot-tow-no-tug-under-cockpit
cmu-blackfoot-tow-stowed
cmu-blackfoot-tow-tug-invalid-map
cmu-blackfoot-tow-use-detach-verb
cmu-blackfoot-tow-verb-attach
cmu-blackfoot-tow-verb-detach
""".split())
CMU_AMBASSADOR_TARGET_ONLY_MESSAGES = frozenset("""\
cmu-ambassador-announcement-sender-console
cmu-ambassador-announcement-sender-embassy
cmu-ambassador-comms-jam-activated
cmu-ambassador-comms-jam-disabled
cmu-ambassador-comms-jam-ended-insufficient-funds
cmu-ambassador-embargo-activated
cmu-ambassador-embargo-ended-insufficient-funds
cmu-ambassador-embargo-lifted
cmu-ambassador-support-dispatch-unavailable
cmu-ambassador-third-party-available
cmu-ambassador-third-party-cost
cmu-ambassador-third-party-cost-na
cmu-ambassador-third-party-cost-placeholder
cmu-ambassador-third-party-cost-zero
cmu-ambassador-third-party-list-entry
cmu-ambassador-third-party-list-entry-called
cmu-ambassador-third-party-no-available
cmu-ambassador-third-party-request-support
cmu-ambassador-third-party-requesting
cmu-ambassador-third-party-window-title
cmu-ambassador-trade-pact-activated
cmu-ambassador-trade-pact-ended
cmu-ambassador-trade-pact-ended-insufficient-funds
cmu-ambassador-ui-active-embargoes
cmu-ambassador-ui-active-trade-pacts
cmu-ambassador-ui-broadcast
cmu-ambassador-ui-broadcast-cost
cmu-ambassador-ui-broadcast-placeholder
cmu-ambassador-ui-budget
cmu-ambassador-ui-budget-placeholder
cmu-ambassador-ui-colony-economy-overview
cmu-ambassador-ui-comms-jam-active
cmu-ambassador-ui-comms-normal
cmu-ambassador-ui-communications
cmu-ambassador-ui-economy
cmu-ambassador-ui-embargo-active
cmu-ambassador-ui-embargo-inactive
cmu-ambassador-ui-faction
cmu-ambassador-ui-income-tax
cmu-ambassador-ui-incoming-shuttle-radar
cmu-ambassador-ui-no-embargoes
cmu-ambassador-ui-no-scan-data
cmu-ambassador-ui-no-trade-pacts
cmu-ambassador-ui-open-third-party-menu
cmu-ambassador-ui-sales-tax
cmu-ambassador-ui-scan-radar
cmu-ambassador-ui-scan-radar-cost
cmu-ambassador-ui-send
cmu-ambassador-ui-signal-boost
cmu-ambassador-ui-signal-boost-active
cmu-ambassador-ui-signal-control
cmu-ambassador-ui-signal-jam
cmu-ambassador-ui-signal-jam-active
cmu-ambassador-ui-signal-normal
cmu-ambassador-ui-signal-normal-costs
cmu-ambassador-ui-third-party-support
cmu-ambassador-ui-toggle-comms-jam
cmu-ambassador-ui-toggle-embargo
cmu-ambassador-ui-toggle-trade-pact
cmu-ambassador-ui-trade-pact-active
cmu-ambassador-ui-trade-pact-inactive
cmu-ambassador-ui-transit-tariff
cmu-ambassador-ui-window-title
cmu-ambassador-ui-withdraw
""".split())
CMU_COLONY_ECONOMY_TARGET_ONLY_MESSAGES = frozenset("""\
cmu-colony-economy-access-denied
cmu-colony-economy-account
cmu-colony-economy-account-unknown-placeholder
cmu-colony-economy-admin-support-title
cmu-colony-economy-admin-title
cmu-colony-economy-administration-sender
cmu-colony-economy-amount-placeholder
cmu-colony-economy-announcement-placeholder
cmu-colony-economy-apply
cmu-colony-economy-atm-income-tax
cmu-colony-economy-atm-title
cmu-colony-economy-balance
cmu-colony-economy-balance-placeholder
cmu-colony-economy-budget-console-title
cmu-colony-economy-buy
cmu-colony-economy-categories-label
cmu-colony-economy-category
cmu-colony-economy-clear-department
cmu-colony-economy-colony-budget
cmu-colony-economy-colony-budget-placeholder
cmu-colony-economy-corporate-affairs-sender
cmu-colony-economy-corporate-budget
cmu-colony-economy-corporate-budget-placeholder
cmu-colony-economy-corporate-support-title
cmu-colony-economy-corporate-title
cmu-colony-economy-credit-label
cmu-colony-economy-current-budget
cmu-colony-economy-current-budget-placeholder
cmu-colony-economy-current-income-tax
cmu-colony-economy-current-income-tax-placeholder
cmu-colony-economy-current-sales-tax
cmu-colony-economy-current-sales-tax-placeholder
cmu-colony-economy-current-transit-tariff
cmu-colony-economy-current-transit-tariff-placeholder
cmu-colony-economy-custom-salary
cmu-colony-economy-default-price-description
cmu-colony-economy-default-price-label
cmu-colony-economy-default-salary-label
cmu-colony-economy-deliver-to-label
cmu-colony-economy-delivery-location-placeholder
cmu-colony-economy-department-announcement-label
cmu-colony-economy-department-budget
cmu-colony-economy-department-budget-entry
cmu-colony-economy-department-budget-placeholder
cmu-colony-economy-department-budget-short-label
cmu-colony-economy-department-console-title
cmu-colony-economy-department-sender
cmu-colony-economy-department-tab
cmu-colony-economy-dispense-all-salaries
cmu-colony-economy-edit-name-price
cmu-colony-economy-employees-label
cmu-colony-economy-example-10
cmu-colony-economy-example-15
cmu-colony-economy-fire
cmu-colony-economy-hire-instruction
cmu-colony-economy-hired
cmu-colony-economy-income-tax-announcement
cmu-colony-economy-income-tax-description
cmu-colony-economy-income-tax-heading
cmu-colony-economy-insert-cash-select-item
cmu-colony-economy-inserted-cash
cmu-colony-economy-inserted-cash-placeholder
cmu-colony-economy-insufficient-department-budget
cmu-colony-economy-item-count
cmu-colony-economy-item-name-placeholder
cmu-colony-economy-items-for-sale-heading
cmu-colony-economy-manage-stock-heading
cmu-colony-economy-manage-stock-instruction
cmu-colony-economy-management-tab
cmu-colony-economy-new-tariff-label
cmu-colony-economy-new-tax-label
cmu-colony-economy-no-catalog
cmu-colony-economy-no-department-for-id
cmu-colony-economy-no-departments
cmu-colony-economy-no-employees
cmu-colony-economy-no-id-card
cmu-colony-economy-no-income-tax
cmu-colony-economy-no-items-available
cmu-colony-economy-no-items-category
cmu-colony-economy-no-items-for-sale
cmu-colony-economy-no-location-specified
cmu-colony-economy-no-reason-given
cmu-colony-economy-no-sales-tax
cmu-colony-economy-no-stock
cmu-colony-economy-order
cmu-colony-economy-order-reason-placeholder
cmu-colony-economy-orders-tab
cmu-colony-economy-price-placeholder
cmu-colony-economy-prices-include-tax
cmu-colony-economy-reason-label
cmu-colony-economy-remove
cmu-colony-economy-reset
cmu-colony-economy-return-change
cmu-colony-economy-salary-dispensed
cmu-colony-economy-salary-dispensed-with-tax
cmu-colony-economy-salary-placeholder
cmu-colony-economy-sales-tax-announcement
cmu-colony-economy-sales-tax-description
cmu-colony-economy-sales-tax-heading
cmu-colony-economy-sales-tax-included
cmu-colony-economy-save
cmu-colony-economy-scan-id
cmu-colony-economy-search-placeholder
cmu-colony-economy-select-category
cmu-colony-economy-sells-for-after-tax
cmu-colony-economy-send
cmu-colony-economy-set
cmu-colony-economy-set-default-salary
cmu-colony-economy-shop-instruction
cmu-colony-economy-shop-title
cmu-colony-economy-stock-count
cmu-colony-economy-support-unavailable
cmu-colony-economy-transfer
cmu-colony-economy-transfer-to-department
cmu-colony-economy-transit-tariff-announcement
cmu-colony-economy-transit-tariff-description
cmu-colony-economy-transit-tariff-heading
cmu-colony-economy-unknown
cmu-colony-economy-unknown-faction
cmu-colony-economy-withdraw-cash
cmu-colony-economy-withdraw-cash-label
cmu-colony-economy-withdraw-dollar-label
cmu-colony-economy-withdraw-heading
cmu-colony-economy-withdraw-income-tax-note
cmu-colony-economy-withdraw-no-income-tax
""".split())
CMU_RMC_VEHICLE_TARGET_ONLY_MESSAGES = frozenset("""\
cmu-rmc-vehicle-ammo-loader-title
cmu-rmc-vehicle-diagnostic-effect
cmu-rmc-vehicle-diagnostic-failure-on
cmu-rmc-vehicle-diagnostic-hardpoint-header
cmu-rmc-vehicle-diagnostic-repair
cmu-rmc-vehicle-diagnostic-vehicle-header
cmu-rmc-vehicle-failure-alert-armor
cmu-rmc-vehicle-failure-alert-electrical
cmu-rmc-vehicle-failure-alert-feed
cmu-rmc-vehicle-failure-alert-frame
cmu-rmc-vehicle-failure-alert-fuel
cmu-rmc-vehicle-failure-alert-generic
cmu-rmc-vehicle-failure-alert-misfire
cmu-rmc-vehicle-failure-alert-mount
cmu-rmc-vehicle-failure-alert-overheat
cmu-rmc-vehicle-failure-alert-tire
cmu-rmc-vehicle-failure-alert-transmission
cmu-rmc-vehicle-failure-alert-traverse
cmu-rmc-vehicle-failure-alert-tread
cmu-rmc-vehicle-failure-alert-trigger
cmu-rmc-vehicle-failure-detected
cmu-rmc-vehicle-failure-detected-on
cmu-rmc-vehicle-failure-diagnostic-status
cmu-rmc-vehicle-failure-effect-armor
cmu-rmc-vehicle-failure-effect-electrical
cmu-rmc-vehicle-failure-effect-feed
cmu-rmc-vehicle-failure-effect-frame
cmu-rmc-vehicle-failure-effect-fuel
cmu-rmc-vehicle-failure-effect-generic
cmu-rmc-vehicle-failure-effect-misfire
cmu-rmc-vehicle-failure-effect-mount
cmu-rmc-vehicle-failure-effect-overheat
cmu-rmc-vehicle-failure-effect-tire
cmu-rmc-vehicle-failure-effect-transmission
cmu-rmc-vehicle-failure-effect-traverse
cmu-rmc-vehicle-failure-effect-tread
cmu-rmc-vehicle-failure-effect-trigger
cmu-rmc-vehicle-failure-name-armor
cmu-rmc-vehicle-failure-name-electrical
cmu-rmc-vehicle-failure-name-feed
cmu-rmc-vehicle-failure-name-frame
cmu-rmc-vehicle-failure-name-fuel
cmu-rmc-vehicle-failure-name-generic
cmu-rmc-vehicle-failure-name-misfire
cmu-rmc-vehicle-failure-name-mount
cmu-rmc-vehicle-failure-name-overheat
cmu-rmc-vehicle-failure-name-tire
cmu-rmc-vehicle-failure-name-transmission
cmu-rmc-vehicle-failure-name-traverse
cmu-rmc-vehicle-failure-name-tread
cmu-rmc-vehicle-failure-name-trigger
cmu-rmc-vehicle-failure-repair-step-complete
cmu-rmc-vehicle-failure-repaired
cmu-rmc-vehicle-failure-status
cmu-rmc-vehicle-failure-summary-hull
cmu-rmc-vehicle-frame-repair-finish-wrench
cmu-rmc-vehicle-frame-repair-hardpoints-first
cmu-rmc-vehicle-frame-repair-weld-first
cmu-rmc-vehicle-hardpoint-already-removing
cmu-rmc-vehicle-hardpoint-finish-install-first
cmu-rmc-vehicle-hardpoint-frame-integrity
cmu-rmc-vehicle-hardpoint-free-loader-arm
cmu-rmc-vehicle-hardpoint-header
cmu-rmc-vehicle-hardpoint-invalid-slot
cmu-rmc-vehicle-hardpoint-menu-heading
cmu-rmc-vehicle-hardpoint-menu-title
cmu-rmc-vehicle-hardpoint-move-loader-failed
cmu-rmc-vehicle-hardpoint-need-power-loader
cmu-rmc-vehicle-hardpoint-need-prying-tool
cmu-rmc-vehicle-hardpoint-none-installed
cmu-rmc-vehicle-hardpoint-removal-cancelled
cmu-rmc-vehicle-hardpoint-removal-start-failed
cmu-rmc-vehicle-hardpoint-remove-free-hand
cmu-rmc-vehicle-hardpoint-remove-turret-attachments-first
cmu-rmc-vehicle-hardpoint-slot-line
cmu-rmc-vehicle-hardpoint-slot-missing
cmu-rmc-vehicle-hardpoint-slots-inaccessible
cmu-rmc-vehicle-hardpoint-turret-line
cmu-rmc-vehicle-hardpoint-vendor-hardpoints
cmu-rmc-vehicle-hardpoint-vendor-print
cmu-rmc-vehicle-hardpoint-vendor-vehicles
cmu-rmc-vehicle-lift-lowered
cmu-rmc-vehicle-lift-lowering
cmu-rmc-vehicle-lift-none
cmu-rmc-vehicle-lift-preparing
cmu-rmc-vehicle-lift-raised
cmu-rmc-vehicle-lift-raising
cmu-rmc-vehicle-loadout-armor
cmu-rmc-vehicle-loadout-general
cmu-rmc-vehicle-loadout-none
cmu-rmc-vehicle-loadout-primary
cmu-rmc-vehicle-loadout-secondary
cmu-rmc-vehicle-loadout-support
cmu-rmc-vehicle-overlay-admin-required
cmu-rmc-vehicle-overlay-collision-state
cmu-rmc-vehicle-overlay-debug-state
cmu-rmc-vehicle-overlay-disabled
cmu-rmc-vehicle-overlay-enabled
cmu-rmc-vehicle-overlay-hardpoint-state
cmu-rmc-vehicle-overlay-movement-state
cmu-rmc-vehicle-repair-armor-tighten
cmu-rmc-vehicle-repair-armor-weld
cmu-rmc-vehicle-repair-electrical-close
cmu-rmc-vehicle-repair-electrical-cut
cmu-rmc-vehicle-repair-electrical-reset
cmu-rmc-vehicle-repair-feed-cycle
cmu-rmc-vehicle-repair-feed-open
cmu-rmc-vehicle-repair-frame-jack
cmu-rmc-vehicle-repair-frame-retorque
cmu-rmc-vehicle-repair-frame-straighten
cmu-rmc-vehicle-repair-fuel-open
cmu-rmc-vehicle-repair-fuel-patch
cmu-rmc-vehicle-repair-fuel-tighten
cmu-rmc-vehicle-repair-misfire-open
cmu-rmc-vehicle-repair-misfire-pulse
cmu-rmc-vehicle-repair-misfire-tighten
cmu-rmc-vehicle-repair-mount-jack
cmu-rmc-vehicle-repair-mount-reseat
cmu-rmc-vehicle-repair-overheat-open
cmu-rmc-vehicle-repair-overheat-pry
cmu-rmc-vehicle-repair-overheat-pulse
cmu-rmc-vehicle-repair-tire-pry
cmu-rmc-vehicle-repair-tire-replace
cmu-rmc-vehicle-repair-tire-torque
cmu-rmc-vehicle-repair-transmission-reseat
cmu-rmc-vehicle-repair-transmission-tighten
cmu-rmc-vehicle-repair-traverse-reseat
cmu-rmc-vehicle-repair-traverse-tighten
cmu-rmc-vehicle-repair-tread-jack
cmu-rmc-vehicle-repair-tread-lock
cmu-rmc-vehicle-repair-tread-reseat
cmu-rmc-vehicle-repair-trigger-open
cmu-rmc-vehicle-repair-trigger-reseat
cmu-rmc-vehicle-repair-trigger-reset
cmu-rmc-vehicle-slot-armor
cmu-rmc-vehicle-slot-door-gun
cmu-rmc-vehicle-slot-front
cmu-rmc-vehicle-slot-launchers
cmu-rmc-vehicle-slot-primary
cmu-rmc-vehicle-slot-recon
cmu-rmc-vehicle-slot-roof
cmu-rmc-vehicle-slot-secondary
cmu-rmc-vehicle-slot-sensors
cmu-rmc-vehicle-slot-support
cmu-rmc-vehicle-slot-thrusters
cmu-rmc-vehicle-slot-turret
cmu-rmc-vehicle-slot-turret-cannon
cmu-rmc-vehicle-slot-turret-launcher
cmu-rmc-vehicle-slot-wheel-one
cmu-rmc-vehicle-status-busy
cmu-rmc-vehicle-status-idle
cmu-rmc-vehicle-supply-copies-collapsed
cmu-rmc-vehicle-supply-copies-expanded
cmu-rmc-vehicle-supply-loadout
cmu-rmc-vehicle-supply-lower
cmu-rmc-vehicle-supply-preview
cmu-rmc-vehicle-supply-preview-default
cmu-rmc-vehicle-supply-raise
cmu-rmc-vehicle-supply-status
cmu-rmc-vehicle-supply-stored-vehicles
cmu-rmc-vehicle-type-armor
cmu-rmc-vehicle-type-cannon
cmu-rmc-vehicle-type-door-gun
cmu-rmc-vehicle-type-front-attachment
cmu-rmc-vehicle-type-launcher
cmu-rmc-vehicle-type-roof-attachment
cmu-rmc-vehicle-type-secondary
cmu-rmc-vehicle-type-sensor-array
cmu-rmc-vehicle-type-support
cmu-rmc-vehicle-type-support-attachment
cmu-rmc-vehicle-type-thruster
cmu-rmc-vehicle-type-turret
cmu-rmc-vehicle-type-wheel
cmu-rmc-vehicle-value-none
cmu-rmc-vehicle-weapon-feed-misfire
cmu-rmc-vehicle-weapon-runaway-fire
cmu-rmc-vehicle-weapon-too-damaged
cmu-rmc-vehicle-weapons-ammo-placeholder
cmu-rmc-vehicle-weapons-auto-turret
cmu-rmc-vehicle-weapons-stabilization
""".split())
TARGET_ONLY_MESSAGE_OVERRIDES = {
    **{message_id: "_AU14" for message_id in ANPRC_UI_TARGET_ONLY_MESSAGES},
    **{message_id: "_RMC14" for message_id in RMC_ROADMAP_TARGET_ONLY_MESSAGES},
    **{message_id: "_CMU14" for message_id in CMU_INTEL_TARGET_ONLY_MESSAGES},
    **{message_id: "_RMC14" for message_id in RMC_AEGIS_TARGET_ONLY_MESSAGES},
    **{message_id: "_CMU14" for message_id in CMU_ROUND_STATISTICS_TARGET_ONLY_MESSAGES},
    **{message_id: "_AU14" for message_id in CMU_INSURGENCY_TOOLS_TARGET_ONLY_MESSAGES},
    **{message_id: "_CMU14" for message_id in CMU_BLACKFOOT_TARGET_ONLY_MESSAGES},
    **{message_id: "_AU14" for message_id in CMU_AMBASSADOR_TARGET_ONLY_MESSAGES},
    **{message_id: "_AU14" for message_id in CMU_COLONY_ECONOMY_TARGET_ONLY_MESSAGES},
    **{message_id: "_RMC14" for message_id in CMU_RMC_VEHICLE_TARGET_ONLY_MESSAGES},
    "cmu-blackfoot-flight-computer-aircraft-linked": "_CMU14",
    "cmu-blackfoot-flight-computer-aircraft-none": "_CMU14",
    "cmu-blackfoot-flight-computer-battery": "_CMU14",
    "cmu-blackfoot-flight-computer-fuel": "_CMU14",
    "cmu-blackfoot-flight-computer-meter-unavailable": "_CMU14",
    "cmu-blackfoot-flight-computer-meter-value": "_CMU14",
    "cmu-blackfoot-flight-computer-pad-aircraft-parked": "_CMU14",
    "cmu-blackfoot-flight-computer-pad-deployed": "_CMU14",
    "cmu-blackfoot-flight-computer-pad-no-link": "_CMU14",
    "cmu-blackfoot-flight-computer-pad-not-deployed": "_CMU14",
    "cmu-blackfoot-flight-computer-pump-linked": "_CMU14",
    "cmu-blackfoot-flight-computer-pump-missing": "_CMU14",
    "cmu-blackfoot-flight-computer-pump-no-link": "_CMU14",
    "cmu-blackfoot-flight-computer-pump-no-pad": "_CMU14",
    "cmu-blackfoot-flight-computer-start-recharge": "_CMU14",
    "cmu-blackfoot-flight-computer-start-refuel": "_CMU14",
    "cmu-blackfoot-flight-computer-stop-recharge": "_CMU14",
    "cmu-blackfoot-flight-computer-stop-refuel": "_CMU14",
    "cmu-blackfoot-flight-computer-title": "_CMU14",
    "cmu-body-part-picker-title": "_CMU14",
    "cmu-body-part-picker-window-title": "_CMU14",
    "cmu-body-part-picker-entry": "_CMU14",
    "cmu-close-button": "_CMU14",
    "cmu-faction-language-picker-description": "_CMU14",
    "cmu-faction-language-picker-faction-title": "_CMU14",
    "cmu-faction-language-picker-title": "_CMU14",
    "cmu-objective-detail-can-complete-times": "_CMU14",
    "cmu-objective-detail-completed-times": "_CMU14",
    "cmu-objective-detail-repeating": "_CMU14",
    "cmu-objective-detail-times-completed": "_CMU14",
    "cmu-objective-detail-worth-points": "_CMU14",
    "cmu-objective-intel-all-tiers-unlocked": "_CMU14",
    "cmu-objective-intel-all-tiers-unlocked-message": "_CMU14",
    "cmu-objective-intel-button": "_CMU14",
    "cmu-objective-intel-next-tier": "_CMU14",
    "cmu-objective-intel-points-label": "_CMU14",
    "cmu-objective-intel-unlock-cost": "_CMU14",
    "cmu-objective-intel-unlocked-label": "_CMU14",
    "cmu-objective-intel-window-title": "_CMU14",
    "cmu-objective-status-captured": "_CMU14",
    "cmu-objective-status-completed": "_CMU14",
    "cmu-objective-status-failed": "_CMU14",
    "cmu-objective-status-uncaptured": "_CMU14",
    "cmu-objective-status-uncompleted": "_CMU14",
    "cmu-objective-type-final": "_CMU14",
    "cmu-objective-type-major": "_CMU14",
    "cmu-objective-type-minor": "_CMU14",
    "cmu-objectives-console-title": "_CMU14",
    "cmu-objectives-current-win-points": "_CMU14",
    "cmu-objectives-current-win-points-initial": "_CMU14",
    "cmu-objectives-final-points": "_CMU14",
    "cmu-objectives-final-points-initial": "_CMU14",
    "cmu-requisitions-all-categories": "_RMC14",
    "cmu-requisitions-asrs-busy": "_RMC14",
    "cmu-requisitions-categories": "_RMC14",
    "cmu-requisitions-cost": "_RMC14",
    "cmu-requisitions-lower": "_RMC14",
    "cmu-requisitions-lowering": "_RMC14",
    "cmu-requisitions-manifest": "_RMC14",
    "cmu-requisitions-no-manifest-description": "_RMC14",
    "cmu-requisitions-no-matching-orders": "_RMC14",
    "cmu-requisitions-no-order-selected": "_RMC14",
    "cmu-requisitions-no-platform": "_RMC14",
    "cmu-requisitions-now": "_RMC14",
    "cmu-requisitions-order-preview": "_RMC14",
    "cmu-requisitions-platform-lowered": "_RMC14",
    "cmu-requisitions-platform-raised": "_RMC14",
    "cmu-requisitions-please-wait": "_RMC14",
    "cmu-requisitions-raise": "_RMC14",
    "cmu-requisitions-raising": "_RMC14",
    "cmu-requisitions-sealed-crate": "_RMC14",
    "cmu-requisitions-search-results": "_RMC14",
    "cmu-requisitions-stock": "_RMC14",
    "cmu-requisitions-stock-unlimited": "_RMC14",
    "cmu-requisitions-supply-budget": "_RMC14",
    "cmu-anprc-paper-comsec-notice": "_AU14",
    "cmu-anprc-paper-entries": "_AU14",
    "cmu-anprc-paper-frequency-assignments-title": "_AU14",
    "cmu-anprc-paper-frequency-instructions": "_AU14",
    "cmu-anprc-paper-intercept-log-title": "_AU14",
    "cmu-anprc-paper-intercept-marker": "_AU14",
    "cmu-anprc-paper-log-footer": "_AU14",
    "cmu-anprc-paper-net-log-title": "_AU14",
    "cmu-anprc-paper-soi-title": "_AU14",
    "cmu-anprc-paper-station": "_AU14",
    "cmu-anprc-paper-unknown-station": "_AU14",
    "cmu-clf-sleeper-fax-clf-body": "_AU14",
    "cmu-clf-sleeper-fax-govfor-body": "_AU14",
    "cmu-clf-sleeper-fax-operational-briefing-title": "_AU14",
    "cmu-clf-sleeper-fax-security-advisory-title": "_AU14",
    "cmu-clf-veteran-fax-body": "_AU14",
    "cmu-clf-veteran-fax-title": "_AU14",
    "cmu-clf-veteran-unknown-name": "_AU14",
    "cmu-universal-paper-tool-search-placeholder": "_CMU14",
    "cmu-voice-category-all": "_CMU14",
    "cmu-voice-no-results": "_CMU14",
    "cmu-voice-search-placeholder": "_CMU14",
    "cmu-wendigo-voice-window-title": "_CMU14",
    "cmu-working-joe-add-favorite": "_CMU14",
    "cmu-working-joe-favorites": "_CMU14",
    "cmu-working-joe-questions": "_CMU14",
    "cmu-working-joe-recent": "_CMU14",
    "cmu-working-joe-remove-favorite": "_CMU14",
    "cmu-working-joe-voice-window-title": "_CMU14",
    "cmu-yautja-direction-north": "_CMU14",
    "cmu-yautja-direction-northeast": "_CMU14",
    "cmu-yautja-direction-northwest": "_CMU14",
    "cmu-yautja-direction-south": "_CMU14",
    "cmu-yautja-direction-southeast": "_CMU14",
    "cmu-yautja-direction-southwest": "_CMU14",
    "cmu-yautja-weapon-choice-confirmation": "_CMU14",
    "cmu-yautja-weapon-choice-window-title": "_CMU14",
    "rmc-item-slot-knife": "_RMC14",
    "rmc-item-slot-l49-assault-shotgun": "_RMC14",
    "rmc-item-slot-m63-holster": "_RMC14",
    "rmc-item-slot-mre": "_RMC14",
    "rmc-item-slot-orp": "_RMC14",
    "rmc-construction-ui-stack-amount": "_CMU14",
    "rmc-construction-ui-window-title": "_CMU14",
}

# Spanish patterns may pass a second positional mode to culture-specific
# overrides registered by RMCLocalizationManager. No other modes are valid.
SPANISH_GRAMMAR_MODES = {
    "POSS-ADJ": {'"plural"'},
    "CONJUGATE-BE": {'"ser"'},
}

# The engine grammar library is intentionally allowed to add selectors and
# function calls required by Spanish articles and agreement.
INTENTIONAL_DIVERGENCES = {
    Path("_engine_lib.ftl"): {
        "variables",
        "functions",
        "variants",
        "open_braces",
        "close_braces",
        "message_syntax",
    },
    # The caller supplies English "is"/"are" as an internal value. Spanish
    # consumes it as a selector so that the raw English token is never shown.
    Path("botany/components/plant-holder-component.ftl"): {
        "variants",
        "open_braces",
        "close_braces",
        "message_syntax",
    },
}

INTENTIONAL_MESSAGE_DIVERGENCES = {
    Path("construction/ui/construction-menu-presenter.ftl"): {
        # The Spanish presenter receives this requirement name after the
        # target-only prototype helper has already resolved it. Calling LOC
        # again would interpret the translated text as a message ID.
        "construction-presenter-arbitrary-step": {"functions"},
    },
}

MESSAGE_RE = re.compile(r"^(-?[A-Za-z][A-Za-z0-9_-]*)\s*=", re.MULTILINE)
ATTRIBUTE_RE = re.compile(r"^\s+\.([A-Za-z][A-Za-z0-9_-]*)\s*=", re.MULTILINE)
VARIABLE_RE = re.compile(r"\$[A-Za-z][A-Za-z0-9_-]*")
FUNCTION_RE = re.compile(r"\{\s*([A-Z][A-Z0-9-]{1,})\s*(?=\()")
VARIANT_RE = re.compile(r"^\s*(\*)?\[([^\]/=]+)\]", re.MULTILINE)
MARKUP_RE = re.compile(r"\[(/?)([A-Za-z][A-Za-z0-9_-]*)(?:=([^\]]+))?\]")
URL_RE = re.compile(r"https?://[^\s\]]+")
SPANISH_GRAMMAR_CALL_RE = re.compile(
    r"\b(POSS-ADJ|CONJUGATE-BE)\s*\(([^)]*?,[^)]*?)\)"
)
PROTOTYPE_BLOCK_RE = re.compile(r"(?m)^- type:\s*([^\s#]+).*$")
PROTOTYPE_ID_RE = re.compile(r"(?m)^  id:\s*([^\s#]+)\s*(?:#.*)?$")
SURGERY_STEP_ID_RE = re.compile(r"(?m)^  - stepId:\s*([^\s#]+)\s*(?:#.*)?$")
SURGERY_DISPLAY_LOC_ID_RE = re.compile(
    r"(?m)^  displayNameLocId:\s*([^\s#]+)\s*(?:#.*)?$"
)
SURGERY_LABEL_LOC_ID_RE = re.compile(
    r"(?m)^    labelLocId:\s*([^\s#]+)\s*(?:#.*)?$"
)
ACCENT_FIELD_RE = re.compile(r"^  ([A-Za-z][A-Za-z0-9]*):")
ACCENT_MAPPING_RE = re.compile(r"^    ([^\s:#]+):\s*([^\s#]+)")
ACCENT_LIST_ITEM_RE = re.compile(r"^\s+-\s*([^\s#]+)")


@dataclass(frozen=True)
class MessageSyntax:
    attributes: tuple[str, ...]
    variables: Counter[str]
    functions: Counter[str]
    variants: Counter[tuple[str, str]]
    markup: Counter[tuple[str, str, str]]
    urls: Counter[str]
    open_braces: int
    close_braces: int


@dataclass(frozen=True)
class Structure:
    messages: tuple[str, ...]
    attributes: tuple[str, ...]
    variables: Counter[str]
    functions: Counter[str]
    variants: Counter[tuple[str, str]]
    markup: Counter[tuple[str, str, str]]
    urls: Counter[str]
    open_braces: int
    close_braces: int
    message_syntax: tuple[tuple[str, MessageSyntax], ...]


def syntax_variables(text: str) -> Counter[str]:
    variables: Counter[str] = Counter()
    depth = 0
    index = 0
    while index < len(text):
        char = text[index]
        if char == "{":
            depth += 1
        elif char == "}":
            depth = max(0, depth - 1)
        elif char == "$" and depth:
            match = VARIABLE_RE.match(text, index)
            if match:
                variables[match.group()] += 1
                index = match.end() - 1
        index += 1
    return variables


def rich_markup(text: str) -> Counter[tuple[str, str, str]]:
    tags = MARKUP_RE.findall(text)
    paired_names = {name for closing, name, _ in tags if closing}
    return Counter(
        (closing, name, parameter)
        for closing, name, parameter in tags
        if name in paired_names or parameter
    )


def per_message_syntax(text: str) -> tuple[tuple[str, MessageSyntax], ...]:
    matches = list(MESSAGE_RE.finditer(text))
    result: list[tuple[str, MessageSyntax]] = []
    for index, match in enumerate(matches):
        end = matches[index + 1].start() if index + 1 < len(matches) else len(text)
        block = text[match.start():end]
        result.append((
            match.group(1),
            MessageSyntax(
                attributes=tuple(ATTRIBUTE_RE.findall(block)),
                variables=syntax_variables(block),
                functions=Counter(FUNCTION_RE.findall(block)),
                variants=Counter(
                    (default, key.strip())
                    for default, key in VARIANT_RE.findall(block)
                ),
                markup=rich_markup(block),
                urls=Counter(URL_RE.findall(block)),
                open_braces=block.count("{"),
                close_braces=block.count("}"),
            ),
        ))
    return tuple(result)


def structure(text: str) -> Structure:
    return Structure(
        messages=tuple(MESSAGE_RE.findall(text)),
        attributes=tuple(ATTRIBUTE_RE.findall(text)),
        variables=syntax_variables(text),
        functions=Counter(FUNCTION_RE.findall(text)),
        variants=Counter((default, key.strip()) for default, key in VARIANT_RE.findall(text)),
        markup=rich_markup(text),
        urls=Counter(URL_RE.findall(text)),
        open_braces=text.count("{"),
        close_braces=text.count("}"),
        message_syntax=per_message_syntax(text),
    )


def invalid_top_level_lines(text: str) -> list[int]:
    """Find naked text that Fluent would parse as junk instead of a message."""
    invalid: list[int] = []
    for number, line in enumerate(text.splitlines(), 1):
        if (
            not line
            or line[0].isspace()
            or line.startswith(("#", "{", "}", "[", "*["))
        ):
            continue
        if MESSAGE_RE.match(line):
            continue
        invalid.append(number)
    return invalid


def invalid_string_escapes(text: str) -> list[tuple[int, int, str]]:
    """Find escapes that Linguini rejects inside Fluent string literals."""
    invalid: list[tuple[int, int, str]] = []
    for line_number, line in enumerate(text.splitlines(), 1):
        if line.lstrip().startswith("#"):
            continue

        in_string = False
        index = 0
        while index < len(line):
            char = line[index]
            if char == '"':
                in_string = not in_string
            elif char == "\\" and in_string:
                next_char = line[index + 1] if index + 1 < len(line) else ""
                if next_char in {'"', "\\"}:
                    index += 1
                elif next_char in {"u", "U"}:
                    digit_count = 4 if next_char == "u" else 8
                    digits = line[index + 2:index + 2 + digit_count]
                    if len(digits) == digit_count and all(
                        digit in "0123456789abcdefABCDEF" for digit in digits
                    ):
                        index += digit_count + 1
                    else:
                        escaped = line[index:index + 2 + digit_count]
                        invalid.append((line_number, index + 1, escaped))
                else:
                    escaped = line[index:index + 2]
                    invalid.append((line_number, index + 1, escaped))
            index += 1

    return invalid


def source_files() -> dict[Path, Path]:
    result: dict[Path, Path] = {}
    for root in (CONTENT_EN, ENGINE_EN):
        for path in root.rglob("*.ftl"):
            relative = path.relative_to(root)
            if relative in result:
                raise RuntimeError(f"Source locale path collision: {relative}")
            result[relative] = path
    return result


def compare(relative: Path, source: Path, translated: Path) -> list[str]:
    source_text = source.read_text(encoding="utf-8-sig")
    translated_text = translated.read_text(encoding="utf-8-sig")
    expected = structure(source_text)
    actual = structure(translated_text)
    errors: list[str] = []

    expected_ids = set(expected.messages)
    owner = relative.parts[0] if relative.parts else ""
    accepted_target_only: set[str] = set()
    actual_counts = Counter(actual.messages)
    for message_id, syntax in actual.message_syntax:
        if message_id in expected_ids or message_id in accepted_target_only:
            continue
        expected_owner = TARGET_ONLY_MESSAGE_OVERRIDES.get(message_id)
        if expected_owner is None:
            continue
        if owner != expected_owner:
            errors.append(
                f"{relative}: {message_id} belongs to {expected_owner}, not {owner}"
            )
            continue
        if actual_counts[message_id] != 1:
            errors.append(f"{relative}: duplicate target-only message ID {message_id}")
            continue
        if syntax.attributes:
            errors.append(
                f"{relative}: {message_id} has unsupported attribute(s): "
                f"{', '.join(sorted(set(syntax.attributes)))}"
            )
            continue
        accepted_target_only.add(message_id)

    if accepted_target_only:
        retained = tuple(
            (message_id, syntax)
            for message_id, syntax in actual.message_syntax
            if message_id not in accepted_target_only
        )

        def combined_counter(field: str) -> Counter:
            value: Counter = Counter()
            for _, syntax in retained:
                value.update(getattr(syntax, field))
            return value

        actual = Structure(
            messages=tuple(message_id for message_id, _ in retained),
            attributes=tuple(
                attribute
                for _, syntax in retained
                for attribute in syntax.attributes
            ),
            variables=combined_counter("variables"),
            functions=combined_counter("functions"),
            variants=combined_counter("variants"),
            markup=combined_counter("markup"),
            urls=combined_counter("urls"),
            open_braces=sum(syntax.open_braces for _, syntax in retained),
            close_braces=sum(syntax.close_braces for _, syntax in retained),
            message_syntax=retained,
        )

    invalid_lines = invalid_top_level_lines(translated_text)
    if invalid_lines:
        rendered = ", ".join(str(line) for line in invalid_lines[:20])
        suffix = " ..." if len(invalid_lines) > 20 else ""
        errors.append(
            f"{relative}: invalid top-level Fluent text at line(s) {rendered}{suffix}"
        )

    invalid_escapes = invalid_string_escapes(translated_text)
    for line, column, escaped in invalid_escapes:
        errors.append(
            f"{relative}: invalid Fluent string escape {escaped!r} "
            f"at line {line}, column {column}"
        )

    for match in SPANISH_GRAMMAR_CALL_RE.finditer(translated_text):
        function = match.group(1)
        mode = match.group(2).split(",", 1)[1].strip()
        if mode in SPANISH_GRAMMAR_MODES[function]:
            continue
        line = translated_text.count("\n", 0, match.start()) + 1
        errors.append(
            f"{relative}: unsupported Spanish grammar mode {mode!r} "
            f"for {function} at line {line}"
        )

    ignored_fields = INTENTIONAL_DIVERGENCES.get(relative, set())
    message_divergences = INTENTIONAL_MESSAGE_DIVERGENCES.get(relative, {})
    for field in Structure.__dataclass_fields__:
        if field in ignored_fields or field == "message_syntax":
            continue
        expected_value = getattr(expected, field)
        actual_value = getattr(actual, field)
        if any(field in fields for fields in message_divergences.values()):
            if isinstance(expected_value, Counter) and isinstance(actual_value, Counter):
                expected_value = expected_value.copy()
                actual_value = actual_value.copy()
                for message_id, syntax in expected.message_syntax:
                    if field in message_divergences.get(message_id, set()):
                        expected_value.subtract(getattr(syntax, field))
                for message_id, syntax in actual.message_syntax:
                    if field in message_divergences.get(message_id, set()):
                        actual_value.subtract(getattr(syntax, field))
                expected_value = +expected_value
                actual_value = +actual_value
        if expected_value != actual_value:
            errors.append(
                f"{relative}: {field} differ: expected {expected_value!r}, "
                f"got {actual_value!r}"
            )

    if "message_syntax" not in ignored_fields and expected.messages == actual.messages:
        for (message_id, expected_syntax), (_, actual_syntax) in zip(
            expected.message_syntax,
            actual.message_syntax,
            strict=True,
        ):
            allowed = message_divergences.get(message_id, set())
            differs = any(
                getattr(expected_syntax, field) != getattr(actual_syntax, field)
                for field in MessageSyntax.__dataclass_fields__
                if field not in allowed
            )
            if differs:
                errors.append(
                    f"{relative}: message_syntax differ for {message_id}: "
                    f"expected {expected_syntax!r}, got {actual_syntax!r}"
                )

    return errors


def validate_prototype_override(
    relative: Path,
    translated: Path,
    entities: Mapping[str, EntityPrototypeRecord],
    prototype_owners: Mapping[tuple[str, str], str] | None = None,
) -> list[str]:
    """Validate a strictly scoped es-ES-only prototype localization catalog."""

    errors: list[str] = []
    text = translated.read_text(encoding="utf-8-sig")
    parsed = structure(text)
    parts = relative.parts
    owner = parts[1] if len(parts) > 1 else ""
    display = relative.as_posix()
    prototype_owners = prototype_owners or {}

    for line in invalid_top_level_lines(text):
        errors.append(f"{display}: invalid top-level Fluent text at line {line}")
    for line, column, escaped in invalid_string_escapes(text):
        errors.append(
            f"{display}: invalid Fluent string escape {escaped!r} "
            f"at line {line}, column {column}"
        )

    duplicates = sorted(
        message_id
        for message_id, count in Counter(parsed.messages).items()
        if count > 1
    )
    for message_id in duplicates:
        errors.append(f"{display}: duplicate message ID {message_id}")

    for message_id, syntax in parsed.message_syntax:
        if message_id in TARGET_ONLY_MESSAGE_OVERRIDES:
            expected_owner = TARGET_ONLY_MESSAGE_OVERRIDES[message_id]
            if owner != expected_owner:
                errors.append(
                    f"{display}: {message_id} belongs to {expected_owner}, not {owner}"
                )
            if syntax.attributes:
                errors.append(
                    f"{display}: {message_id} has unsupported attribute(s): "
                    f"{', '.join(sorted(set(syntax.attributes)))}"
                )
            continue

        if message_id.startswith("ent-"):
            prototype_id = message_id.removeprefix("ent-")
            entity = entities.get(prototype_id)
            if entity is None:
                entity = next(
                    (
                        candidate
                        for _, candidate in sorted(entities.items())
                        if candidate.localization_id == message_id
                    ),
                    None,
                )
            if entity is None:
                errors.append(
                    f"{display}: {message_id} does not map to a live entity prototype"
                )
                continue
            entity_parts = Path(entity.path).parts
            entity_owner = (
                entity_parts[0]
                if entity_parts and entity_parts[0] in PROTOTYPE_OWNER_LAYERS
                else "_Vanilla"
            )
            if owner != entity_owner:
                errors.append(
                    f"{display}: {message_id} belongs to {entity_owner}, not {owner}"
                )
            unsupported = sorted(set(syntax.attributes) - PROTOTYPE_OVERRIDE_ATTRIBUTES)
            if unsupported:
                errors.append(
                    f"{display}: {message_id} has unsupported attribute(s): "
                    f"{', '.join(unsupported)}"
                )
            continue

        special_match = re.fullmatch(
            r"(stack|tile|flavor|job|alert)-(.+)-(name|description)",
            message_id,
        )
        if special_match is not None:
            prototype_type = special_match.group(1)
            prototype_id = special_match.group(2)
            field = special_match.group(3)
            allowed_fields = {
                "stack": {"name"},
                "tile": {"name"},
                "flavor": {"description"},
                "job": {"name", "description"},
                "alert": {"name", "description"},
            }
            if field not in allowed_fields[prototype_type]:
                errors.append(
                    f"{display}: {message_id} has unsupported {prototype_type} field '{field}'"
                )
                continue
            prototype_owner = prototype_owners.get((prototype_type, prototype_id))
            if prototype_owner is None:
                errors.append(
                    f"{display}: {message_id} does not map to a live "
                    f"{prototype_type} prototype"
                )
                continue
            if owner != prototype_owner:
                errors.append(
                    f"{display}: {message_id} belongs to {prototype_owner}, not {owner}"
                )
            if syntax.attributes:
                errors.append(
                    f"{display}: {message_id} has unsupported attribute(s): "
                    f"{', '.join(sorted(set(syntax.attributes)))}"
                )
            continue

        visible_metadata_patterns = (
            ("npcFaction", r"npc-faction-(.+)-(name)"),
            ("thirdParty", r"third-party-(.+)-(display-name)"),
            ("platoon", r"platoon-(.+)-(name)"),
            ("announcementPreset", r"announcement-preset-(.+)-(name|title)"),
            ("gamePreset", r"game-preset-(.+)-(name|description)"),
            ("customHoliday", r"custom-holiday-(.+)-(name|description)"),
            ("objectiveIntelTier", r"objective-intel-tier-(.+)-(title|description)"),
            ("material", r"material-(.+)-(name)"),
        )
        visible_metadata_match = None
        visible_metadata_type = ""
        for candidate_type, pattern in visible_metadata_patterns:
            if match := re.fullmatch(pattern, message_id):
                visible_metadata_match = match
                visible_metadata_type = candidate_type
                break

        if visible_metadata_match is not None:
            prototype_id = visible_metadata_match.group(1)
            prototype_owner = prototype_owners.get(
                (visible_metadata_type, prototype_id)
            )
            if prototype_owner is None:
                errors.append(
                    f"{display}: {message_id} does not map to a live "
                    f"{visible_metadata_type} prototype"
                )
                continue
            if owner != prototype_owner:
                errors.append(
                    f"{display}: {message_id} belongs to {prototype_owner}, not {owner}"
                )
            if syntax.attributes:
                errors.append(
                    f"{display}: {message_id} has unsupported attribute(s): "
                    f"{', '.join(sorted(set(syntax.attributes)))}"
                )
            continue

        access_match = re.fullmatch(r"access-(level|group)-(.+)-name", message_id)
        if access_match is not None:
            prototype_type = "accessLevel" if access_match.group(1) == "level" else "accessGroup"
            prototype_id = access_match.group(2)
            prototype_owner = prototype_owners.get((prototype_type, prototype_id))
            if prototype_owner is None:
                errors.append(
                    f"{display}: {message_id} does not map to a live {prototype_type} prototype"
                )
                continue
            if owner != prototype_owner:
                errors.append(
                    f"{display}: {message_id} belongs to {prototype_owner}, not {owner}"
                )
            if syntax.attributes:
                errors.append(
                    f"{display}: {message_id} has unsupported attribute(s): "
                    f"{', '.join(sorted(set(syntax.attributes)))}"
                )
            continue

        construction_step_match = re.fullmatch(
            r"construction-step-(.+)-name",
            message_id,
        )
        if construction_step_match is not None:
            step_id = construction_step_match.group(1)
            prototype_owner = prototype_owners.get(("constructionStep", step_id))
            if prototype_owner is None:
                errors.append(
                    f"{display}: {message_id} does not map to a live construction step"
                )
                continue
            if owner != prototype_owner:
                errors.append(
                    f"{display}: {message_id} belongs to {prototype_owner}, not {owner}"
                )
            if syntax.attributes:
                errors.append(
                    f"{display}: {message_id} has unsupported attribute(s): "
                    f"{', '.join(sorted(set(syntax.attributes)))}"
                )
            continue

        if message_id.startswith((
            "cmu-medical-surgery-procedure-",
            "cmu-medical-surgery-step-",
        )):
            prototype_owner = prototype_owners.get(
                ("surgeryLocalization", message_id),
            )
            if prototype_owner is None:
                errors.append(
                    f"{display}: {message_id} does not map to a live "
                    "surgery localization sidecar"
                )
                continue
            if owner != prototype_owner:
                errors.append(
                    f"{display}: {message_id} belongs to {prototype_owner}, not {owner}"
                )
            if syntax.attributes:
                errors.append(
                    f"{display}: {message_id} has unsupported attribute(s): "
                    f"{', '.join(sorted(set(syntax.attributes)))}"
                )
            continue

        guide_match = re.fullmatch(r"guide-entry-(.+)-name", message_id)
        if guide_match is not None:
            prototype_id = guide_match.group(1)
            prototype_owner = prototype_owners.get(("guideEntry", prototype_id))
            if prototype_owner is None:
                errors.append(
                    f"{display}: {message_id} does not map to a live guideEntry prototype"
                )
                continue
            if owner != prototype_owner:
                errors.append(
                    f"{display}: {message_id} belongs to {prototype_owner}, not {owner}"
                )
            if syntax.attributes:
                errors.append(
                    f"{display}: {message_id} has unsupported attribute(s): "
                    f"{', '.join(sorted(set(syntax.attributes)))}"
                )
            continue

        rank_match = re.fullmatch(r"rank-(.+)", message_id)
        if rank_match is not None:
            prototype_id = rank_match.group(1)
            prototype_owner = prototype_owners.get(("rank", prototype_id))
            if prototype_owner is None:
                errors.append(
                    f"{display}: {message_id} references unknown rank prototype "
                    f"'{prototype_id}'"
                )
                continue
            if owner != prototype_owner:
                errors.append(
                    f"{display}: {message_id} belongs to {prototype_owner}, not {owner}"
                )
            unsupported = sorted(
                set(syntax.attributes)
                - {"prefix", "prefix-male", "prefix-female"}
            )
            if unsupported:
                errors.append(
                    f"{display}: {message_id} has unsupported attributes: "
                    f"{', '.join(unsupported)}"
                )
            continue

        rmc_match = re.fullmatch(r"rmc-construction-(.+)-(name)", message_id)
        construction_match = re.fullmatch(
            r"construction-(.+)-(name|description)",
            message_id,
        )
        match = rmc_match or construction_match
        if match is None:
            errors.append(f"{display}: {message_id} is not a supported prototype override")
            continue

        prototype_type = "rmcConstruction" if rmc_match else "construction"
        prototype_id = match.group(1)
        prototype_owner = prototype_owners.get((prototype_type, prototype_id))
        if prototype_owner is None:
            errors.append(
                f"{display}: {message_id} does not map to a live "
                f"{prototype_type} prototype"
            )
            continue
        if owner != prototype_owner:
            errors.append(
                f"{display}: {message_id} belongs to {prototype_owner}, not {owner}"
            )
        if syntax.attributes:
            errors.append(
                f"{display}: {message_id} has unsupported attribute(s): "
                f"{', '.join(sorted(set(syntax.attributes)))}"
            )

    return errors


def validate_scoped_literal_override(
    relative: Path,
    translated: Path,
    live_message_ids: frozenset[str],
) -> list[str]:
    """Validate target-only scoped literal messages against live YAML data."""

    errors: list[str] = []
    text = translated.read_text(encoding="utf-8-sig")
    parsed = structure(text)
    display = relative.as_posix()
    for line in invalid_top_level_lines(text):
        errors.append(f"{display}: invalid top-level Fluent text at line {line}")
    for line, column, escaped in invalid_string_escapes(text):
        errors.append(
            f"{display}: invalid Fluent string escape {escaped!r} "
            f"at line {line}, column {column}"
        )
    for message_id, count in sorted(Counter(parsed.messages).items()):
        if count > 1:
            errors.append(f"{display}: duplicate message ID {message_id}")
    for message_id, syntax in parsed.message_syntax:
        if message_id not in live_message_ids:
            errors.append(
                f"{display}: {message_id} does not map to a live scoped YAML literal"
            )
        if syntax.attributes:
            errors.append(
                f"{display}: {message_id} has unsupported attribute(s): "
                f"{', '.join(sorted(set(syntax.attributes)))}"
            )
    return errors


def is_target_only_catalog(translated: Path) -> bool:
    """Return True when every message in the file is a declared target-only ID."""

    messages = structure(translated.read_text(encoding="utf-8-sig")).messages
    return bool(messages) and all(
        message_id in TARGET_ONLY_MESSAGE_OVERRIDES for message_id in messages
    )


def validate_target_only_catalog(relative: Path, translated: Path) -> list[str]:
    """Validate an es-ES-only UI catalog of declared target-only messages.

    These files localize C#/XAML literals that never received an en-US Fluent
    entry, so they have no source route to compare against. The owner layer is
    the first path segment and must match the layer declared for each ID in
    ``TARGET_ONLY_MESSAGE_OVERRIDES``.
    """

    errors: list[str] = []
    text = translated.read_text(encoding="utf-8-sig")
    parsed = structure(text)
    parts = relative.parts
    owner = parts[0] if parts else ""
    display = relative.as_posix()

    for line in invalid_top_level_lines(text):
        errors.append(f"{display}: invalid top-level Fluent text at line {line}")
    for line, column, escaped in invalid_string_escapes(text):
        errors.append(
            f"{display}: invalid Fluent string escape {escaped!r} "
            f"at line {line}, column {column}"
        )
    for message_id, count in sorted(Counter(parsed.messages).items()):
        if count > 1:
            errors.append(f"{display}: duplicate message ID {message_id}")
    for message_id, syntax in parsed.message_syntax:
        expected_owner = TARGET_ONLY_MESSAGE_OVERRIDES.get(message_id)
        if expected_owner is None:
            errors.append(
                f"{display}: {message_id} is not a declared target-only message"
            )
        elif owner != expected_owner:
            errors.append(
                f"{display}: {message_id} belongs to {expected_owner}, not {owner}"
            )
        if syntax.attributes:
            errors.append(
                f"{display}: {message_id} has unsupported attribute(s): "
                f"{', '.join(sorted(set(syntax.attributes)))}"
            )
    return errors


def load_prototype_owners(
    prototype_types: set[str] | None = None,
) -> dict[tuple[str, str], str]:
    """Load owner layers for target-only localizable prototype types."""

    prototype_types = prototype_types or {
        "accessGroup",
        "accessLevel",
        "alert",
        "announcementPreset",
        "construction",
        "constructionStep",
        "cmuSurgeryStepMetadata",
        "customHoliday",
        "flavor",
        "gamePreset",
        "guideEntry",
        "job",
        "material",
        "npcFaction",
        "objectiveIntelTier",
        "platoon",
        "rank",
        "rmcConstruction",
        "stack",
        "surgeryLocalization",
        "surgeryStep",
        "thirdParty",
        "tile",
    }
    result: dict[tuple[str, str], str] = {}
    paths = sorted(
        path
        for path in PROTOTYPES.rglob("*")
        if path.suffix.casefold() in {".yml", ".yaml"}
        and not any(
            part.casefold() == "generated"
            for part in path.relative_to(PROTOTYPES).parts
        )
    )
    for path in paths:
        relative = path.relative_to(PROTOTYPES)
        owner = (
            relative.parts[0]
            if relative.parts and relative.parts[0] in PROTOTYPE_OWNER_LAYERS
            else "_Vanilla"
        )
        text = path.read_text(encoding="utf-8-sig").replace("\t", "  ")
        starts = list(PROTOTYPE_BLOCK_RE.finditer(text))
        for index, start in enumerate(starts):
            prototype_type = start.group(1)
            end = starts[index + 1].start() if index + 1 < len(starts) else len(text)
            if prototype_type in prototype_types:
                prototype_id = PROTOTYPE_ID_RE.search(text, start.end(), end)
                if prototype_id is not None:
                    result[(prototype_type, prototype_id.group(1))] = owner
            if prototype_type != "cmuSurgeryStepMetadata":
                continue
            if (
                "surgeryStep" not in prototype_types
                and "surgeryLocalization" not in prototype_types
            ):
                continue
            block = text[start.start():end]
            if "surgeryStep" in prototype_types:
                for step_id in SURGERY_STEP_ID_RE.findall(block):
                    result[("surgeryStep", step_id)] = owner
            if "surgeryLocalization" in prototype_types:
                for loc_id in (
                    *SURGERY_DISPLAY_LOC_ID_RE.findall(block),
                    *SURGERY_LABEL_LOC_ID_RE.findall(block),
                ):
                    result[("surgeryLocalization", loc_id)] = owner
        if "constructionStep" in prototype_types:
            for finding in extract_visible_yaml(relative, text):
                if (
                    finding.prototype_type == "constructionGraph"
                    and finding.key == "name"
                    and not finding.top_level
                ):
                    step_id = normalize_override_segment(finding.value)
                    result[("constructionStep", step_id)] = owner
    return result


def validate_accent_localization_references() -> list[str]:
    """Require every active accent localization reference to resolve in es-ES or its fallback."""

    available: set[str] = set()
    for root in (CONTENT_EN, ENGINE_EN, SPANISH):
        if not root.exists():
            continue
        for path in root.rglob("*.ftl"):
            available.update(MESSAGE_RE.findall(path.read_text(encoding="utf-8-sig")))

    errors: list[str] = []
    if not PROTOTYPES.exists():
        return errors

    paths = sorted(
        path
        for path in PROTOTYPES.rglob("*")
        if path.suffix.casefold() in {".yml", ".yaml"}
        and not any(
            part.casefold() == "generated"
            for part in path.relative_to(PROTOTYPES).parts
        )
    )
    for path in paths:
        text = path.read_text(encoding="utf-8-sig").replace("\t", "  ")
        starts = list(PROTOTYPE_BLOCK_RE.finditer(text))
        for index, start in enumerate(starts):
            if start.group(1) != "accent":
                continue
            end = starts[index + 1].start() if index + 1 < len(starts) else len(text)
            block = text[start.start():end]
            prototype_id = PROTOTYPE_ID_RE.search(block)
            display_id = prototype_id.group(1) if prototype_id is not None else "<unknown>"
            section = ""
            references: set[str] = set()
            for line in block.splitlines():
                field = ACCENT_FIELD_RE.match(line)
                if field is not None:
                    section = field.group(1)
                    continue
                if section == "wordReplacements":
                    mapping = ACCENT_MAPPING_RE.match(line)
                    if mapping is not None:
                        references.update(mapping.groups())
                elif section in {"fullReplacements", "caseSensitiveReplacements"}:
                    item = ACCENT_LIST_ITEM_RE.match(line)
                    if item is not None:
                        references.add(item.group(1))

            relative = path.relative_to(PROTOTYPES).as_posix()
            for message_id in sorted(references - available):
                errors.append(
                    f"{relative}: accent {display_id} references unresolved "
                    f"localization ID {message_id}"
                )

    return errors


def load_intentional_fallbacks(
    sources: Mapping[Path, Path],
    translated: Mapping[Path, Path],
) -> tuple[set[Path], list[str]]:
    """Load and validate source routes intentionally served by en-US fallback."""

    if not FALLBACK_MANIFEST.exists():
        return set(), []

    errors: list[str] = []
    raw = FALLBACK_MANIFEST.read_bytes()
    if raw.startswith(b"\xef\xbb\xbf"):
        errors.append("intentional-fallbacks.txt: UTF-8 BOM is not allowed")
    if b"\r\n" in raw:
        errors.append("intentional-fallbacks.txt: CRLF line endings are not allowed")
    if raw and not raw.endswith(b"\n"):
        errors.append("intentional-fallbacks.txt: missing final newline")

    fallbacks: set[Path] = set()
    for line_number, raw_line in enumerate(raw.decode("utf-8-sig").splitlines(), 1):
        line = raw_line.strip()
        if not line or line.startswith("#"):
            continue
        pure = PurePosixPath(line)
        if pure.is_absolute() or ".." in pure.parts or "\\" in line:
            errors.append(
                f"intentional-fallbacks.txt:{line_number}: invalid relative source path {line!r}"
            )
            continue
        relative = Path(*pure.parts)
        if relative in fallbacks:
            errors.append(
                f"intentional-fallbacks.txt:{line_number}: duplicate path {line}"
            )
            continue
        fallbacks.add(relative)
        if relative not in sources:
            errors.append(
                f"intentional-fallbacks.txt:{line_number}: no matching en-US source {line}"
            )
        if relative in translated:
            errors.append(
                f"intentional-fallbacks.txt:{line_number}: Spanish target already exists for {line}"
            )

    return fallbacks, errors


def validate(require_complete: bool = False) -> list[str]:
    errors: list[str] = []
    sources = source_files()
    entities: dict[str, EntityPrototypeRecord] | None = None
    prototype_owners: dict[tuple[str, str], str] | None = None
    scoped_literal_ids: frozenset[str] | None = None
    translated = {
        path.relative_to(SPANISH): path
        for path in SPANISH.rglob("*.ftl")
    } if SPANISH.exists() else {}
    fallbacks, fallback_errors = load_intentional_fallbacks(sources, translated)
    errors.extend(fallback_errors)

    for relative, path in sorted(translated.items()):
        raw = path.read_bytes()
        if raw.startswith(b"\xef\xbb\xbf"):
            errors.append(f"{relative}: UTF-8 BOM is not allowed")
        if b"\r\n" in raw:
            errors.append(f"{relative}: CRLF line endings are not allowed")
        try:
            raw.decode("utf-8")
        except UnicodeDecodeError as exc:
            errors.append(f"{relative}: invalid UTF-8: {exc}")
            continue

        source = sources.get(relative)
        if source is None:
            if relative == SCOPED_LITERAL_OVERRIDE_PATH:
                scoped_literal_ids = scoped_literal_ids or collect_scoped_literal_override_ids(
                    PROTOTYPES
                )
                errors.extend(
                    validate_scoped_literal_override(relative, path, scoped_literal_ids)
                )
                continue
            if relative.parts and relative.parts[0] == PROTOTYPE_OVERRIDE_ROOT:
                entities = entities or load_entity_prototypes(PROTOTYPES)
                prototype_owners = prototype_owners or load_prototype_owners()
                errors.extend(
                    validate_prototype_override(
                        relative,
                        path,
                        entities,
                        prototype_owners,
                    )
                )
                continue
            if is_target_only_catalog(path):
                errors.extend(validate_target_only_catalog(relative, path))
                continue
            errors.append(f"{relative}: no matching en-US source file")
            continue
        errors.extend(compare(relative, source, path))

    message_owners: dict[str, set[str]] = defaultdict(set)
    for relative, path in translated.items():
        parsed = structure(path.read_text(encoding="utf-8-sig"))
        for message_id in parsed.messages:
            message_owners[message_id].add(relative.as_posix())
    for message_id, owners in sorted(message_owners.items()):
        if len(owners) > 1:
            errors.append(
                f"locale-wide duplicate message ID {message_id}: "
                f"{', '.join(sorted(owners))}"
            )

    errors.extend(validate_accent_localization_references())

    if require_complete:
        missing = sorted(set(sources) - set(translated) - fallbacks)
        errors.extend(f"{relative}: missing Spanish file" for relative in missing)

    return errors


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--require-complete",
        action="store_true",
        help=(
            "fail when an en-US Fluent file lacks both an es-ES counterpart "
            "and an intentional fallback declaration"
        ),
    )
    args = parser.parse_args()

    errors = validate(require_complete=args.require_complete)
    if errors:
        print("Spanish locale validation failed:", file=sys.stderr)
        for error in errors:
            print(f"- {error}", file=sys.stderr)
        return 1

    sources = source_files()
    translated = {
        path.relative_to(SPANISH): path
        for path in SPANISH.rglob("*.ftl")
    } if SPANISH.exists() else {}
    fallbacks, _ = load_intentional_fallbacks(sources, translated)
    translated_count = len(set(sources).intersection(translated))
    print(
        "Spanish locale structure is valid "
        f"({translated_count} translated files, {len(fallbacks)} intentional "
        f"fallbacks, {len(sources)} covered source files)."
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
