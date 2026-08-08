# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Read `AGENTS.md` first

`AGENTS.md` (Spanish) is the repository's canonical agent contract, and `docs/agent-development.md` is its extended guide. Both are authoritative; this file is a Claude-Code-oriented summary and does not override them.

> **CI conflict:** `Tools/validate_agent_context.py` lists `CLAUDE.md` in `DUPLICATE_CONTEXTS`, so the presence of this file at the repo root fails the `source-guards` job in `.github/workflows/ci.yml` with `CLAUDE.md duplica o compite con el contrato canónico AGENTS.md.` Either keep this file untracked, move it to `.claude/CLAUDE.md` (the validator only scans root entries plus `.cursor/rules/*.mdc`), or update the validator and `Tools/tests/test_validate_agent_context.py` together.

## What this repo is

CMU-14 — a multiplayer Alien-universe game forked from RMC14 (itself from CM13), built on the RobustToolbox engine (a pinned submodule). This particular fork (`TheLacrox/ColonialMarinesUniverse-ESP-Capibara`) exists primarily for Spanish translation and local adaptations.

## Setup

.NET SDK `10.0.100` (`global.json`, `rollForward: latestFeature`), Python 3 for repo guards, Rust/Cargo only for the map checker.

```bash
git submodule update --init --recursive   # RobustToolbox has its own submodules
dotnet restore SpaceStation14.slnx
```

Always work from the repo root. Record `git status --short --branch` before editing and never clean or restore changes you did not create.

## Commands

Build the narrowest owning project in `DebugOpt` (what CI uses):

```bash
dotnet build Content.Shared/Content.Shared.csproj -c DebugOpt --no-restore
dotnet build Content.Server/Content.Server.csproj -c DebugOpt --no-restore
dotnet build Content.Client/Content.Client.csproj -c DebugOpt --no-restore
```

Unit tests, then a single filtered test:

```bash
dotnet test Content.Tests/Content.Tests.csproj -c DebugOpt --no-restore -- NUnit.ConsoleOut=0

dotnet test Content.IntegrationTests/Content.IntegrationTests.csproj -c DebugOpt --no-restore \
  --filter 'FullyQualifiedName~Content.IntegrationTests.Tests.PrototypeTests' -- \
  NUnit.ConsoleOut=0 NUnit.MapWarningTo=Failed
```

The integration suite is expensive and CI shards it; reproduce the affected shard's filter from `.github/workflows/ci.yml` instead of running the whole suite. `_CMU14` and `_RMC14` have their own shards (`FullyQualifiedName~Content.IntegrationTests._CMU14`).

YAML/prototype linter — loads both client and server, so a broken reference fails far from the edited file:

```bash
dotnet build Content.YAMLLinter/Content.YAMLLinter.csproj -c DebugOpt --no-restore
dotnet run --project Content.YAMLLinter/Content.YAMLLinter.csproj -c DebugOpt --no-build --no-restore
```

Repo guards — run at the end of any task:

```bash
python3 Tools/check_crlf.py
python3 Tools/validate_agent_context.py
python3 -m unittest Tools.tests.test_validate_agent_context -v
git diff --check
git status --short
```

Maps (`_CMU14`, `_RMC14`, `_AU14` — check all three for a global change):

```bash
cargo build --release --manifest-path .github/map_checker/Cargo.toml
.github/map_checker/target/release/map_checker -c .github/map_checker/matchers.yml -m Resources/Maps/_CMU14
python3 .github/scripts/validate_yamale.py --schema RobustToolbox/Schemas/mapfile.yml \
  --path-pattern '.*Resources/Maps/.*' --validators RobustToolbox/Schemas/mapfile_validators.py
```

RSI/textures: `python3 RobustToolbox/Schemas/validate_rsis.py Resources/` (needs `pillow jsonschema`).
`attributions.yml`: validate against `.github/Schemas/rga.yml` with the same `validate_yamale.py` runner.
DB migrations: `Content.Server.Database/add-migration.sh` (or `.ps1`) — generates **both** SQLite and PostgreSQL variants; never hand-edit snapshots or leave one provider behind.

## Commands with side effects — do not run "just to check"

| Command | Effect |
| --- | --- |
| `RUN_THIS.py`, `BuildChecker/git_helper.py` | Installs/replaces Git hooks, updates submodules |
| `dotnet build SpaceStation14.slnx -c Debug`/`DebugOpt` | Includes `BuildChecker`, so triggers the above |
| `Tools/sync_audio_placeholders.py` | Creates/replaces/deletes audio placeholders |
| `Content.Tools` (map merge driver), `Content.Scripts`, `Content.MapRenderer` | Rewrite maps/RSI/metadata |
| Map & Z-level save commands | Reserialize whole maps → massive diffs |
| `runclient*` / `runserver*` | Persistent processes; only for a requested run test, stop them after |

The non-mutating whole-solution build excludes `BuildChecker`:

```bash
dotnet build SpaceStation14.slnx -c Release --no-restore /m
```

## Architecture

Standard RobustToolbox ECS split. C# 14, nullable enabled; `.editorconfig` governs (UTF-8, LF except Windows scripts, 4 spaces C#, 2 spaces YAML/XML/JSON/projects).

- `Content.Shared` — components, serialized events/messages, predicted logic, system contracts. No secrets, no server-only authoritative state.
- `Content.Server` — authority. Revalidates permission, range, state, cost even when the client already checked for UX. Owns persistence, admin, migrations. A BUI message is never proof of authorization.
- `Content.Client` — UI/XAML, rendering, overlays, input. Displays replicated state and sends *intent*, never game decisions.
- `Resources` — YAML prototypes, `.ftl` locale, RSI/textures/audio, maps. Resource paths are logical, leading `/` in C#, and **case-sensitive** even though Windows is not.

### Layer ownership (the part that trips people up)

| Prefix | Meaning | Rule |
| --- | --- | --- |
| `_CMU14` | CMU's own layer | Destination for new CMU-only functionality |
| `_RMC14` | Legacy RMC14, still maintained | Extend in place; do not migrate to `_CMU14` just because you touched it |
| `_AU14` / `AU14` | Legacy AU14 (custom construction, maps) | Read its own docs; preserve persistence contracts |
| no prefix | Vanilla SS14 / integration points | Minimal hook only, using local marker style (`// CMU14`, `// CMU14 start` / `// CMU14 end`) |

Inline `// RMC14` / `// AU14` / `// CMU14` markers are the strategy for surviving upstream syncs — a global reformat or refactor must not delete them. Never infer ownership from an ID prefix alone; trace code, prototype, locale, asset and tests before deciding where to change something.

### Vertical slice

A feature normally spans five surfaces — changing only the YAML or only the client leaves contracts inconsistent. The Yautja bracer panel is the reference slice:

- `Content.Shared/_CMU14/Yautja/YautjaActions.cs` — UI key, panel state, command message
- `Content.Server/_CMU14/Yautja/YautjaBracerMenuSystem.cs` — receives message, rechecks `CanUseMenu`, applies, publishes state
- `Content.Client/_CMU14/Yautja/YautjaBracerBui.cs` + `YautjaBracerWindow.xaml.cs` — presentation
- `Resources/Prototypes/_CMU14/Threats/Yautja/Equipment/devices.yml` — component + BUI on the entity
- `Resources/Locale/en-US/_CMU14/yautja/yautja.ftl` — visible strings

### Domains with mandatory reading

- Medical: `docs/medical-architecture.md` — body index and raw state stay server-side; structural vs. medical revisions are separate; network projections are bounded.
- AU14 custom construction: `Content.Server/_AU14/Construction/CustomConstruction/DATABASE_PERSISTENCE.md`.

## Generated and external boundaries

1. `Resources/Prototypes/_AU14/CustomConstruction/Generated/` — written by in-game editors *and* mirrored in the database. Not a destination for new content; an isolated YAML diff may not reflect operational state.
2. `Resources/Audio/_CMU14/Private/` — silent placeholders. Real audio lives in the private sibling repo `ColonialMarinesAudio` and is overlaid by the publish workflow. Never synthesize missing private content.
3. `Resources/MapImages/`, `bin/`, `obj/`, `artifacts/`, `release/`, DocFX output — generated; do not present as source changes.
4. `Resources/migration.yml` remaps **entity prototype IDs when loading maps** only. It is not a general prototype-reference rename table.
5. Map YAML is not ordinary YAML: `.gitattributes` assigns `merge=mapping-merge-driver` → `Tools/mapping-merge-driver.sh` → `Content.Tools`. Resolve conflicts through that flow or the map editor.
6. `RobustToolbox` and `RSI.NET` are pinned submodules. Do not edit them or advance their gitlinks; CI explicitly rejects RobustToolbox gitlink bumps in PRs. After any build or generator, inspect `git status --short` and classify every change.

## Localization

`Resources/Locale/en-US` is the source corpus and holds CMU keys under `_CMU14`. `es-ES` is this fork's active translation target and is already large; `nl-NL` and `ru-RU` are token. Do not mix Spanish text into `en-US`.

Two Spanish-specific validators exist (with unit tests, but **not** wired into CI):

```bash
python3 Tools/validate_spanish_locale.py                    # structural parity vs en-US; --require-complete to enforce coverage
python3 Tools/audit_spanish_visible_yaml.py                 # inventories player-visible literal text still hardcoded in prototype YAML
python3 -m unittest Tools.tests.test_validate_spanish_locale Tools.tests.test_audit_spanish_visible_yaml -v
```

`Resources/Locale/es-ES/intentional-fallbacks.txt` declares routes deliberately left untranslated. When adding keys, check the declaration, every `Loc.GetString`/prototype use, Fluent argument names matching the code, and the rendered UI — not just FTL syntax.

## Git flow — one-directional fork

Upstream `AU-14/ColonialMarinesUniverse` is a **source of incoming changes only**. The authorized flow is `upstream → fork`, never the reverse.

- Run `git remote -v` first; remote names are conventions, not guarantees.
- Sync via a temporary `sync/upstream-*` branch off clean fork `master`, `git merge --no-ff upstream/master`, resolve preserving both upstream features and local translations (never blanket `ours`/`theirs`), then push **only** to `origin`. Integrate sync PRs with a merge commit, not squash.
- Never open, prepare, or suggest a PR toward upstream. Never push to an upstream branch or remote. Never `reset --hard` to `upstream/master`.
- Do not stage, commit, push, merge or rebase unless explicitly asked.
