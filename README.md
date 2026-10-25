# ui-templates — approved UI template library

Single source of truth for frontend visual foundations. **Everything lives here, on GitHub** —
fetchable from any machine, no local copies required.

## Policy (the way we work now)

1. **Template-first, always.** Frontend work starts from an approved template's actual source files — never generated from scratch, never from LLM screenshot interpretation.
2. **Adapt, don't reinvent.** Preserve design tokens, components, navigation, responsive + accessibility behavior. Keep modifications targeted and explainable.
3. **No vision dependency.** Visual review is *optional*; when skipped it is recorded `optional-not-performed` — never marked passed. Acceptance rests on deterministic conformance checks.
4. **Templates are data.** Import is static (files or pinned git clone). Template code runs only in an isolated environment.
5. **If no template fits, ask.** Request a new template from the user; do not invent a new visual direction.
6. **Quality bar is human.** Templates enter this library only with user approval or are user-sourced; agent-authored work must pass explicit user review (two early agent-generated page templates were removed on 2026-10-22 for this reason). `design-system-v1` was approved by the user on 2026-10-22; `northstar-design-systems` was user-sourced on 2026-10-23; reference renders are guides, not page templates.

## Agent instructions (AGENTS.md)

[AGENTS.md](AGENTS.md) is the canonical orchestration spec for template-driven, multi-agent
product builds: agent roles (GLM orchestrator / DeepSeek engineer / Qwen frontend), template
import and conformance rules, verification gates, autonomous repair, and delivery safeguards.

Agents in any workspace should fetch this file at the start of a product/UI build:

```bash
curl -fsSL https://raw.githubusercontent.com/shiangking/ui-templates/main/AGENTS.md
```

## Layers

### `design-system-v1` — base layer (tokens + components + motion)

The vocabulary every page is composed from. Built 2026-10-22 from user feedback ("need more templates
for smaller UI designs — pills, side menu, top bar, font size") plus motion DNA extracted from
user-supplied Framer references.

| file | layer | contents |
|---|---|---|
| `templates/design-system-v1/tokens.css` | foundation | 12-step neutral ramp, semantic colors, type scale 12–60px with tracking rules, 4px spacing grid, radius + shadow scales |
| `templates/design-system-v1/components.css` | primitives | pills, buttons (32/40/48), topbar (64px), sidebar (260px, active accent), inputs/selects, data tables, cards, stat cards, tabs, avatars, toggles, menus, tooltips, alerts, progress, skeletons |
| `templates/design-system-v1/motion.css` + `motion.js` | **Motion Profile 1: Framer soft** | springs `100/30` + `100/10` extracted from the Nuria Framer bundle; `data-reveal`, `data-stagger`, `.m-lift/.m-pop/.m-press/.m-shine/.m-pulse`, marquee |
| `templates/design-system-v1/motion-cinematic.css` + `motion-cinematic.js` | **Motion Profile 2: cinematic** | Storm Lab vocabulary: scroll-pinned scenes, curtain/kinetic type, lightning, magnetic buttons, parallax, custom cursor, grain |

Usage rule: import `tokens.css` + `components.css`, add **exactly one** motion profile, compose
components only from tokens. Zero dependencies. Both profiles honor `prefers-reduced-motion`.

### `northstar-design-systems` — multi-theme design system (user-sourced 2026-10-23)

Three complete design directions on **one CSS-variable contract** (`--ds-*`), fully scoped to `.ds-kit`,
zero dependencies, ~50 components + page recipes (landing / app shell / component gallery), and
best-in-class a11y: skip links, `:focus-visible`, ARIA tabs/dialog/switch, `aria-live` toasts,
keyboard tab navigation, and both OS `prefers-reduced-motion` **and** an in-app motion-pause toggle.

| theme | personality | signature values |
|---|---|---|
| **Studio** | quiet product clarity (dashboards, everyday product UI) | `#5a46c5` indigo, Inter 600 @ −0.055em, radii 8/14/22px |
| **Fieldwork** | bold editorial (outdoor brands, portfolios) | `#b73e15` rust on parchment `#f2efe8`, Arial Narrow 800 uppercase, tight radii 4/6/8px |
| **Nocturne** | dark precision (developer tools, launch pages) | `#b3e9dd` mint on `#12151a`, Inter 500 @ −0.06em, periwinkle `#6f8ee0` graphics |

Files: `tokens.css` (all values), `themes.json` (machine-readable theme source of truth), `themes.js`,
`app.js` (interactive reference), `preview.html` (open for a working tour). Built-in motion: `ds-enter`
420ms `cubic-bezier(.22,1,.36,1)` with 50ms stagger — the same curve as our Framer-soft profile.

**Relationship to `design-system-v1`**: siblings, not duplicates. v1 = single-theme vocabulary + 2
motion profiles for marketing pages. Northstar = multi-theme theming + application shell + a11y
patterns for product UIs. Pick by project type; they share philosophy, not files.

## Templates

### Code templates (pinned upstream, imported by commit SHA)

| id | use for | framework | upstream |
|---|---|---|---|
| `fimbo-portfolio-1` | one-page gradient portfolio | vanilla | [imfunniee/fimbo](https://github.com/imfunniee/fimbo) `1` @ `2297bec` |
| `fimbo-portfolio-2` | header + social one-pager | vanilla | [imfunniee/fimbo](https://github.com/imfunniee/fimbo) `2` @ `2297bec` |
| `fimbo-portfolio-3` | multi-section + particles | vanilla | [imfunniee/fimbo](https://github.com/imfunniee/fimbo) `3` @ `2297bec` |
| `odyssey-theme` | startup marketing/blog theme | astro | [treefarmstudio/odyssey-theme](https://github.com/treefarmstudio/odyssey-theme) @ `d191e57` |
| `orbita-dark-landing` | dark cinematic space landing (starfield hero, bento, timeline, pricing, FAQ) | vanilla | original work, added at user request 2026-10-25 |

Both upstreams are MIT-licensed. Pinned SHAs guarantee byte-identical imports.

### Design-source templates (Figma → machine-readable spec)

| id | use for | contents |
|---|---|---|
| `figma-prompverse-ai` | dark AI landing pages | tokens (Manrope/Poppins, #1D73F3 accent), 8-section inventory, component specs |
| `figma-startup-kit` | SaaS section-library pages | #2F1893/#1E0E62/#25DAC5 system, ~150 sections across 16 canvases, component catalog |
| `figma-genesis-landing` | premium science/agritech pages | IBM Plex Sans −0.04em tracking, sky-glass hero, floating glass flag cards, green/amber/indigo score system, navy 32px science cards |

These are **design specs, not code** (`manifest.json` + extraction notes): translate them onto an
approved code template's structure. Replace upstream artwork with licensed assets; self-host fonts.

## Reference renders (`renders/`)

Working HTML translations that show how specs/templates map to real code — **guides, not page templates**:

| id | shows |
|---|---|
| `genesis-reference-render` | the Genesis Figma spec translated faithfully to HTML/CSS (photo artwork approximated with CSS gradients — noted honestly in its manifest) |
| `odyssey-motion-reference` | the annotation pattern: odyssey-theme @ `d191e57` + `motion.css` data-attributes, tokens untouched; functional 5-theme switcher; user-approved 2026-10-22 |

## Usage (any machine)

```bash
# list what's approved
curl -fsSL https://raw.githubusercontent.com/shiangking/ui-templates/main/tools/import_template.sh | bash -s -- --list

# import a pinned upstream template (shallow clone at the pinned SHA)
bash -c "$(curl -fsSL https://raw.githubusercontent.com/shiangking/ui-templates/main/tools/import_template.sh)" -- odyssey-theme ./my-site

# import a vendored design-spec or design system
bash -c "$(curl -fsSL https://raw.githubusercontent.com/shiangking/ui-templates/main/tools/import_template.sh)" -- northstar-design-systems ./my-kit
```

## Conformance (checked, not judged)

Adapted products are verified with deterministic checks — component presence, token preservation,
no dependency removals, working navigation, no horizontal overflow at 375/768/1280px, responsive
breakpoints, a11y basics, no console errors, no external network requests, no broken assets/fonts.
Screenshots are kept as evidence but are **not** AI-interpreted. These checks prove template
conformance and functional usability — they do **not** claim subjective visual quality; that stays
explicitly unassessed unless a human reviews it.

See [manifest-schema.md](manifest-schema.md) to add a template (directory + manifest + registry entry).

### Agent-added (vendored, user-requested additions)

| id | use for | framework | provenance |
|---|---|---|---|
| `orbita-dark-landing` | dark space-themed product landing page | vanilla | original work by agent, vendored at user request 2026-10-25 — user-approved addition, see [manifest](templates/orbita-dark-landing/manifest.json) |