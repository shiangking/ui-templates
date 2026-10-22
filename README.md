# ui-templates — approved UI template library

Single source of truth for frontend visual foundations. **Everything lives here, on GitHub** —
fetchable from any machine, no local copies required.

## Policy (the way we work now)

1. **Template-first, always.** Frontend work starts from an approved template's actual source files — never generated from scratch, never from LLM screenshot interpretation.
2. **Adapt, don't reinvent.** Preserve design tokens, components, navigation, responsive + accessibility behavior. Keep modifications targeted and explainable.
3. **No vision dependency.** Visual review is *optional*; when skipped it is recorded `optional-not-performed` — never marked passed. Acceptance rests on deterministic conformance checks.
4. **Templates are data.** Import is static (files or pinned git clone). Template code runs only in an isolated environment.
5. **If no template fits, ask.** Request a new template from the user; do not invent a new visual direction.
6. **Quality bar is human.** Templates enter this library only with user approval; agent-authored work must pass explicit user review (two early agent-generated page templates were removed on 2026-10-22 for this reason). `design-system-v1` was approved by the user on 2026-10-22; reference renders are guides, not page templates.

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

## Templates

### Code templates (pinned upstream, imported by commit SHA)

| id | use for | framework | upstream |
|---|---|---|---|
| `fimbo-portfolio-1` | one-page gradient portfolio | vanilla | [imfunniee/fimbo](https://github.com/imfunniee/fimbo) `1` @ `2297bec` |
| `fimbo-portfolio-2` | header + social one-pager | vanilla | [imfunniee/fimbo](https://github.com/imfunniee/fimbo) `2` @ `2297bec` |
| `fimbo-portfolio-3` | multi-section + particles | vanilla | [imfunniee/fimbo](https://github.com/imfunniee/fimbo) `3` @ `2297bec` |
| `odyssey-theme` | startup marketing/blog theme | astro | [treefarmstudio/odyssey-theme](https://github.com/treefarmstudio/odyssey-theme) @ `d191e57` |

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

# import a vendored design-spec
bash -c "$(curl -fsSL https://raw.githubusercontent.com/shiangking/ui-templates/main/tools/import_template.sh)" -- figma-startup-kit ./my-spec
```

## Conformance (checked, not judged)

Adapted products are verified with deterministic checks — component presence, token preservation,
no dependency removals, working navigation, no horizontal overflow at 375/768/1280px, responsive
breakpoints, a11y basics, no console errors, no external network requests, no broken assets/fonts.
Screenshots are kept as evidence but are **not** AI-interpreted. These checks prove template
conformance and functional usability — they do **not** claim subjective visual quality; that stays
explicitly unassessed unless a human reviews it.

See [manifest-schema.md](manifest-schema.md) to add a template (directory + manifest + registry entry).
