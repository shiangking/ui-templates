# ui-templates — approved UI template library

Single source of truth for frontend visual foundations. **Everything lives here, on GitHub** —
fetchable from any machine, no local copies required.

## Policy (the way we work now)

1. **Template-first, always.** Frontend work starts from an approved template's actual source files — never generated from scratch, never from LLM screenshot interpretation.
2. **Adapt, don't reinvent.** Preserve design tokens, components, navigation, responsive + accessibility behavior. Keep modifications targeted and explainable.
3. **No vision dependency.** Visual review is *optional*; when skipped it is recorded `optional-not-performed` — never marked passed. Acceptance rests on deterministic conformance checks.
4. **Templates are data.** Import is static (files only). Template code runs only in an isolated environment.
5. **If no template fits, ask.** Request a new template from the user; do not invent a new visual direction.

## Templates

| id | use for | entry |
|---|---|---|
| `clean-landing-v1` | landing pages, marketing sites, waitlists | [templates/clean-landing-v1/index.html](templates/clean-landing-v1/index.html) |
| `clean-dashboard-v1` | dashboards, trackers, admin tools | [templates/clean-dashboard-v1/index.html](templates/clean-dashboard-v1/index.html) |

All MIT-licensed, original work. Tokens in each manifest match the CSS custom properties in `assets/styles.css` verbatim.

## Usage (any machine)

```bash
# list what's approved
curl -fsSL https://raw.githubusercontent.com/shiangking/ui-templates/main/tools/import_template.sh | bash -s -- --list

# import a template (downloads manifest + files, executes nothing)
bash -c "$(curl -fsSL https://raw.githubusercontent.com/shiangking/ui-templates/main/tools/import_template.sh)" -- clean-landing-v1 ./my-product-ui
```

Or fetch a single file:

```
https://raw.githubusercontent.com/shiangking/ui-templates/main/templates/clean-landing-v1/manifest.json
```

## Conformance (checked, not judged)

Adapted products are verified with deterministic checks — component presence, token preservation,
no dependency removals, working navigation, no horizontal overflow at 375/768/1280px, responsive
breakpoints, a11y basics, no console errors, no external network requests, no broken assets/fonts.
Screenshots are kept as evidence but are **not** AI-interpreted. These checks prove template
conformance and functional usability — they do **not** claim subjective visual quality; that stays
explicitly unassessed unless a human reviews it.

See [manifest-schema.md](manifest-schema.md) to add a template (directory + manifest + registry entry).
