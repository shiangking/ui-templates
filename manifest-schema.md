# Template manifest schema v1

Every template directory contains `manifest.json`:

```jsonc
{
  "id": "string, kebab-case, unique in registry.json",
  "version": "semver string",
  "title": "human-readable name",
  "license": "SPDX identifier + short note",
  "source": "where the template came from (original work / upstream URL + commit)",
  "framework": "vanilla-html-css-js | react | nextjs | ...",
  "dependencies": ["npm/pypi deps; empty for vanilla"],
  "entry": "path to the page/app entry file",
  "use_when": "one line: which products this template fits",
  "tokens": { "design tokens exactly as consumed by the source files (CSS custom properties)" },
  "layout": { "structure": "...", "breakpoints": { "mobile": "...", "tablet": "..." } },
  "components": { "component_name": "description incl. geometry/colors" },
  "usability_rules": ["checked conformance rules (contrast, hit areas, overflow)"],
  "files": ["all files an importer must fetch"],
  "conformance_checks": {
    "required_components": ["selectors/ids that must remain present in adapted products"],
    "token_keys": ["token keys whose values must not drift without explicit approval"],
    "viewports": [375, 768, 1280]
  }
}
```

Rules:
- `tokens` values MUST match the CSS custom properties in `assets/styles.css` verbatim.
- `files` MUST be complete: an importer fetches exactly these paths.
- External network requests at runtime are forbidden (fonts are system stacks; no CDNs).
- Adding a template = new directory + `manifest.json` + one entry in `registry.json`.
