# ui-templates — approved UI template library

Single source of truth for frontend visual foundations. **Everything lives here, on GitHub** —
fetchable from any machine, no local copies required.

## Policy (the way we work now)

1. **Template-first, always.** Frontend work starts from an approved template's actual source files — never generated from scratch, never from LLM screenshot interpretation.
2. **Adapt, don't reinvent.** Preserve design tokens, components, navigation, responsive + accessibility behavior. Keep modifications targeted and explainable.
3. **No vision dependency.** Visual review is *optional*; when skipped it is recorded `optional-not-performed` — never marked passed. Acceptance rests on deterministic conformance checks.
4. **Templates are data.** Import is static (files or pinned git clone). Template code runs only in an isolated environment.
5. **If no template fits, ask.** Request a new template from the user; do not invent a new visual direction.

## Templates

### Code templates (vendored in this repo)

| id | use for | framework | entry |
|---|---|---|---|
| `clean-landing-v1` | landing pages, marketing sites, waitlists | vanilla html/css/js | [index.html](templates/clean-landing-v1/index.html) |
| `clean-dashboard-v1` | dashboards, trackers, admin tools | vanilla html/css/js | [index.html](templates/clean-dashboard-v1/index.html) |

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

These are **design specs, not code** (`design-spec.json`): translate them onto an approved code template's structure. Replace upstream artwork with licensed assets; self-host fonts.

## Usage (any machine)

```bash
# list what's approved
curl -fsSL https://raw.githubusercontent.com/shiangking/ui-templates/main/tools/import_template.sh | bash -s -- --list

# import a vendored template (downloads manifest + files, executes nothing)
bash -c "$(curl -fsSL https://raw.githubusercontent.com/shiangking/ui-templates/main/tools/import_template.sh)" -- clean-landing-v1 ./my-product-ui

# import a pinned upstream template (shallow clone at the pinned SHA)
bash -c "$(curl -fsSL https://raw.githubusercontent.com/shiangking/ui-templates/main/tools/import_template.sh)" -- odyssey-theme ./my-site
```

## Conformance (checked, not judged)

Adapted products are verified with deterministic checks — component presence, token preservation,
no dependency removals, working navigation, no horizontal overflow at 375/768/1280px, responsive
breakpoints, a11y basics, no console errors, no external network requests, no broken assets/fonts.
Screenshots are kept as evidence but are **not** AI-interpreted. These checks prove template
conformance and functional usability — they do **not** claim subjective visual quality; that stays
explicitly unassessed unless a human reviews it.

See [manifest-schema.md](manifest-schema.md) to add a template (directory + manifest + registry entry).
