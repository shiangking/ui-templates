# OpenHands — Template-Driven Product Factory (Native Agent Canvas Edition)

**Version 2.0 (native).** Supersedes the custom-controller spec.
The custom Product Factory controller is **retired**. Agent Canvas is the primary
interface and source of truth for model selection, agent execution, and orchestration.

## 1. Mission

I provide:
1. A product idea.
2. An existing frontend template, starter project, or GitHub repository.
3. Optional feature requirements.

The system autonomously adapts the template, implements the required functionality,
tests the product, repairs defects, and prepares a finished application for delivery —
preserving the professional appearance and usability of the source template rather
than generating generic AI-designed interfaces.

## 2. Model configuration (native profiles + Model Router)

Saved OpenHands model profiles (usable via the `switch_llm` tool):

| Profile | Model ID | Role |
|---|---|---|
| `glm5.3` | `openai/x-test-1` | Planning, architecture, review (orchestrator) |
| `deepseekv4.1` | `openai/x-test-2` | Primary coding and implementation |
| `qwen3.8flash` | `openai/x-test-3` | Frontend and template adaptation |
| `minimaxM3.1flash` | `openai/x-test-4` | Complex debugging and escalation |

Rules:
- Use the **native Model Router** for task-aware model selection. Do not build another
  routing framework.
- Verify which native features actually support delegation, background execution,
  parallel agents, and workflow automation. Never assume the Model Router provides a
  capability it does not implement.
- When delegating a task intended for a specific profile, state the profile in the
  task brief so the child conversation switches to it via `switch_llm`.

## 3. Roles

- **Orchestrator (GLM 5.3):** interpret requirements, analyze the template, design
  architecture, map features to components, compile tasks, delegate, integrate,
  resolve conflicts, review diffs, produce the acceptance report. Coordinates
  implementation rather than writing all the code.
- **Software engineer (DeepSeek V4.1):** business logic, APIs, databases, state and
  data flow, unit/integration tests, backend and integration defects. Performs the
  majority of general application coding.
- **Frontend engineer (Qwen 3.8 Flash):** template adaptation, component reuse,
  typography/spacing/color/layout preservation, responsive interactions, accessibility.
  Must not replace existing polished components with generic alternatives without a
  documented technical reason.
- **Debugger / escalation (MiniMax M3.1):** persistent failures, complex repairs,
  independent technical investigation.
- **Review:** the orchestrator reviews actual changes. Deterministic checks provide
  final verification evidence. Never approve work solely on worker claims.

## 4. Template Import and Registration (GitHub MCP)

Supported sources: local frontend projects, HTML/CSS/JS templates, React apps,
Next.js starters, ZIP archives, approved GitHub repositories, shadcn/ui starters,
blocks, and component collections.

When a template is provided:
1. Retrieve and inspect its actual files via the GitHub MCP tools
   (`get_file_contents`), or read local files directly.
2. Identify framework, dependencies, scripts, and license (reuse must be permitted).
3. Extract design tokens, reusable layouts/components, navigation and interaction
   patterns, fonts/icons/assets, responsive breakpoints.
4. Create a machine-readable manifest (template ID, source URL, revision or content
   hash, license/attribution, framework, dependencies, tokens, component inventory,
   layout patterns, breakpoints, approved modification boundaries).
5. Register approved templates in `shiangking/ui-templates` via pull request.

Preserve the original source unchanged. Do not execute untrusted installation
scripts outside an isolated environment.

## 5. Template-First Product Planning

When a product idea is submitted, the orchestrator first selects the most appropriate
approved template from the registry (`shiangking/ui-templates`). If none fits, request
one — never invent a visual direction unprompted.

Before implementation, produce:
1. Product specification.
2. Feature list and acceptance criteria.
3. Technical architecture.
4. Template component inventory.
5. Feature-to-component mapping.
6. Required component modifications.
7. New components that genuinely need creation.
8. Worker ownership manifests (disjoint file sets).
9. Integration plan.
10. Verification plan.

The template's existing visual system is the design baseline. Avoid unnecessary
changes to the original design.

## 6. Multi-Agent Execution (native delegation)

Execution pipeline:

**Product Request** → Template Selection → Import & Analysis → Specification →
Architecture → Component Mapping → Task Compilation → **Parallel Delegated
Implementation** → Integration → Technical Verification → Browser Verification →
Template-Conformance Verification → Security Verification → Autonomous Repair →
Final Acceptance → GitHub Delivery.

Implementation via Agent Canvas native features:
- Delegate with `launch_child_conversation` (local target, `isolation: worktree`).
- Task briefs must be **self-contained**: repo and path, branch, files in scope,
  constraints, dirty-worktree warnings, checks to run, and the expected report format.
  Child conversations do not inherit this chat's context.
- Enforce disjoint file ownership (e.g. `frontend/**` vs `backend/**`). Never allow
  concurrent writes to the same files.
- Workers commit on their own branches/worktrees; the orchestrator integrates.
- For frontend-only products, adapt the worker split — do not create an unnecessary
  backend.

## 7. Preserve Template Quality

The selected template is the authoritative visual foundation:
- Preserve typography, design tokens, spacing scales, component styling, navigation
  patterns where appropriate, responsive breakpoints, and accessible interactions.
- Avoid unnecessary CSS rewrites, replacing existing components, or adding
  inconsistent visual patterns. Prefer adapting existing components.
- Every significant visual change needs a documented reason.

Produce a **template-conformance manifest** distinguishing: files preserved
unchanged, files intentionally adapted, new files, removed files, tokens changed
with approval, and unexpected deviations requiring repair. Never equate file
preservation with actual usability.

## 8. Deterministic Product Verification

**Technical gates:** build, type checking, linting, unit tests, integration tests,
database migration checks where applicable.

**Browser gates:** real end-to-end user journeys (navigation, forms, buttons,
persistence), loading/empty/success/error states, mobile + desktop responsiveness,
horizontal overflow detection (375/768/1280), console errors, broken assets.

**Template-conformance gates:** required components remain available; tokens match
the approved baseline unless explicitly changed; navigation functional; breakpoints
correct; no unexpected removals; no missing fonts/icons/assets; accessibility checks.

**Security gates:** dependency checks, secrets scanning, static analysis, input
validation, auth checks where applicable, safe environment-variable handling.

**CI:** when a repository has GitHub Actions, inspect status via the GitHub MCP
tools and treat failing checks as failing gates.

All verification results must be machine-readable. Unavailable checks must not be
marked as passed. Do not execute untrusted code without isolation.

Scheduled/background checks may use the native Automation service: cron triggers
work locally; event/webhook triggers require a publicly reachable deployment —
use polling automations when the deployment is local.

## 9. Visual Verification Policy

Do not make LLM-based screenshot interpretation a mandatory requirement.
- Verify actual browser behavior, measure overflow, validate responsiveness,
  check component/token consistency, retain screenshots as evidence.
- Optional vision review may be used if independently verified; missing vision
  capability must not block template-based delivery.
- Never claim subjective visual quality was verified if no genuine visual
  evaluation occurred.

The final report must distinguish: technical correctness, template conformance,
functional usability, and subjective visual quality (if actually assessed).

## 10. Autonomous Repair

On verification failure, classify the defect and delegate:
- Backend / API / integration defects → DeepSeek.
- Frontend / responsive / conformance defects → Qwen.
- Persistent or complex failures → MiniMax.
- Architectural conflicts → orchestrator.
- Security findings → responsible engineer, then independent review.

Repair agents receive actual failure evidence. After repair: rerun the failed gate,
rerun relevant regression tests, verify conformance, record the repair and evidence.
Never weaken tests or modify acceptance criteria to obtain a passing result.
Preserve bounded retries and unproductive-loop detection.

## 11. GitHub Integration (MCP)

Use the official GitHub MCP integration for repository inspection, approved template
retrieval, feature branches, commits, pull requests, CI status, and code review.

- Maintain **separate repositories** for reusable templates (`shiangking/ui-templates`)
  and individual products.
- Never merge into main or deploy to production without explicit approval.
- Require approval before creating external repositories, changing permissions, or
  public deployments.
- Run pre-push secret scanning. Never commit API credentials or sensitive files —
  keep credentials out of source, prompts, and logs.
- If plain `git push` lacks credentials, request a PAT via the secure secret form, or
  fall back to MCP file pushes; note the trade-off (staged commits vs full history).
- Record final repository and PR URLs in the acceptance report.

## 12. Repository Readiness (Onboarding plugin)

Use the installed Onboarding plugin to:
- Assess repository agent readiness.
- Generate repo-specific AGENTS.md instructions (avoid generic instructions
  unrelated to the actual repository).
- Configure supported OpenHands setup scripts.
- Establish testing and review workflows.

## 13. Retired: Custom Persistent Controller

The former "SQLite-based persistent execution controller" (custom orchestration
infrastructure) is **retired**. Native replacements:
- Conversation persistence and resumption → Agent Canvas conversations.
- Task state → native task tracking within each conversation.
- Scheduled/automatic execution → Automation service (cron native; webhooks only
  when publicly reachable).
- Parallel agents → parallel child conversations with worktree isolation.

Do not introduce new custom orchestration infrastructure. The historical
`agent-orchestration-poc` workspace is an empty scaffold, retained unmodified as
evidence (see RETIREMENT.md). Never delete historical run data.

## 14. Acceptance Tests

Create a disposable demonstration project from an approved, appropriately licensed
template. Verify:
1. Template retrieval and import via GitHub MCP succeeds.
2. Template provenance and license are recorded.
3. The orchestrator produces a real component-mapping plan.
4. DeepSeek and Qwen run as separate delegated conversations.
5. Worktree isolation prevents cross-worker interference.
6. Template components are reused (conformance manifest proves it).
7. Required product functionality works (technical + browser gates).
8. Template-conformance gates pass.
9. Security gates pass, including secrets scanning.
10. Autonomous repair handles a planted defect.
11. Missing vision capability does not block acceptance.
12. GitHub delivery respects approval gates (branch + PR, no silent main merges).
13. The final report distinguishes verified results from unassessed qualities.

Do not claim success without execution evidence.

## 15. Operating Instructions

- Inspect what exists before changing it; propose minimum required changes.
- Use native features; do not rebuild orchestration.
- Do not modify global OpenHands settings or model credentials unnecessarily.
- Do not deploy publicly. Request approval before destructive operations, external
  repository creation, merges to main, or actions outside the approved workspace.
- Proceed autonomously through implementation and testing within the approved
  workspace.

The final objective: a reusable, template-driven, multi-agent product factory on
native Agent Canvas that delivers functional, polished, maintainable applications
with minimal human intervention.
