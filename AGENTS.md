# OpenHands Product Factory — Template-Driven Multi-Agent Orchestration

## Mission

I want to provide:
1. A product idea.
2. An existing frontend template, starter project, or GitHub repository.
3. Optional feature requirements.

The system should then autonomously adapt the template, implement the required functionality, test the product, repair defects, and prepare a finished application for delivery.

The objective is to produce applications that preserve the professional appearance and usability of their source templates rather than generating generic AI-designed interfaces.

---

## 2. Model and Agent Responsibilities

Use the existing saved OpenHands model profiles.

### GLM 5.3 — Lead Orchestrator

Profile: `glm5.3`

Responsibilities:
- Interpret product requirements.
- Analyze the selected frontend template.
- Design the application architecture.
- Identify reusable components.
- Define feature-to-component mappings.
- Break development into independent tasks.
- Assign tasks to workers.
- Manage dependencies.
- Coordinate integration.
- Resolve architectural conflicts.
- Conduct independent code reviews.
- Produce the final acceptance report.

GLM should coordinate implementation rather than writing all the code itself.

### DeepSeek V4.1 Flash 1017 — Primary Software Engineer

Profile: `deepseekv4.1`

Responsibilities:
- Implement business logic.
- Build APIs and backend services where required.
- Design and integrate databases.
- Implement authentication where required.
- Implement application state and data flows.
- Connect frontend components to working functionality.
- Write unit and integration tests.
- Fix backend and integration defects.

DeepSeek should perform the majority of general application coding.

### Qwen 3.8 Flash Next — Frontend Engineer

Profile: `qwen3.8flash`

Responsibilities:
- Adapt the approved template.
- Reuse existing UI components.
- Preserve typography, spacing, colors, and layouts.
- Implement responsive interactions.
- Connect frontend components to application state.
- Maintain design-system consistency.
- Fix frontend defects.
- Preserve accessibility behavior.

Qwen must not replace existing polished components with generic alternatives without a documented technical reason.

### Independent Review

Use GLM for architecture and code review, with deterministic checks providing final verification evidence.

The reviewer must inspect actual changes and must not approve work solely based on worker claims.

---

## 3. Template Import and Registration

Support these template sources:

- Local frontend project directories.
- HTML/CSS/JavaScript templates.
- React applications.
- Next.js starter projects.
- ZIP archives.
- Approved GitHub repositories.
- shadcn/ui-generated starter projects.
- shadcn/ui blocks and component collections.

When a template is provided:

1. Verify the source exists and is accessible.
2. Inspect its actual files.
3. Identify its framework.
4. Inspect package dependencies and scripts.
5. Verify the license permits the intended reuse.
6. Identify reusable layouts and components.
7. Extract design tokens.
8. Identify navigation and interaction patterns.
9. Record fonts, icons, assets, and responsive breakpoints.
10. Create a machine-readable template manifest.

The manifest must include:

- Template ID.
- Source path or repository URL.
- Source revision or content hash.
- License and attribution requirements.
- Framework.
- Dependency information.
- Design tokens.
- Component inventory.
- Layout patterns.
- Responsive breakpoints.
- Approved modification boundaries.

Register approved templates in the existing Product Factory template library.

Preserve the original source unchanged.

Do not execute untrusted installation scripts outside an isolated environment.

---

## 4. Template-First Product Planning

When I submit a new product idea, the orchestrator must first identify the most appropriate approved template.

If I specify a template, use that template unless it is technically incompatible or its license prevents reuse.

If no template is specified, select from the existing approved template library.

If no suitable approved template exists, request one rather than inventing a visual direction.

Before implementation, GLM must produce:

1. Product specification.
2. Feature list and acceptance criteria.
3. Technical architecture.
4. Template component inventory.
5. Feature-to-component mapping.
6. Required component modifications.
7. New components that genuinely need to be created.
8. Worker ownership manifests.
9. Integration plan.
10. Verification plan.

Use the template's existing visual system as the design baseline.

Avoid unnecessary changes to the original design.

---

## 5. Multi-Agent Execution Workflow

Use the existing persistent orchestration controller.

The execution pipeline must be:

**Product Request**
→ Template Selection
→ Template Import and Analysis
→ Product Specification
→ Architecture
→ Component Mapping
→ Task Dependency Compilation
→ Parallel Agent Implementation
→ Integration
→ Technical Verification
→ Browser Verification
→ Template-Conformance Verification
→ Security Verification
→ Autonomous Repair
→ Final Acceptance
→ GitHub Delivery Preparation

### Parallel Development

Use separate Git worktrees and explicit file ownership.

Initial workers:

**Worker A — Qwen Frontend**
- Template component adaptation.
- UI interactions.
- Responsive behavior.
- Frontend state.
- Frontend tests.

**Worker B — DeepSeek Backend**
- Business logic.
- APIs.
- Database.
- Data validation.
- Backend tests.

Where tasks are independent, run them concurrently.

For frontend-only projects, adapt the worker split to avoid creating an unnecessary backend.

Do not allow concurrent writes to the same files.

Use the existing dependency-aware scheduler and recovery mechanisms.

---

## 6. Preserve Template Quality

The selected template is the authoritative visual foundation.

Enforce the following rules:

- Preserve existing typography.
- Preserve design tokens.
- Preserve spacing scales.
- Preserve component styling.
- Preserve navigation patterns where appropriate.
- Preserve responsive breakpoints.
- Preserve accessible interactions.
- Avoid unnecessary CSS rewrites.
- Avoid replacing existing components.
- Avoid adding inconsistent visual patterns.
- Prefer adapting existing components over creating new ones.

Every significant visual change must have a documented reason.

Create a template-conformance manifest that distinguishes:
- Files preserved unchanged.
- Files intentionally adapted.
- New files.
- Removed files.
- Design tokens changed with approval.
- Unexpected deviations requiring repair.

Do not equate file preservation with actual usability.

---

## 7. Deterministic Product Verification

Use the existing Phase E verification system.

### Technical Gates
- Build.
- Type checking.
- Linting.
- Unit tests.
- Integration tests.
- Database migration checks where applicable.

### Browser Gates
- Playwright end-to-end user journeys.
- Navigation.
- Forms.
- Buttons.
- Data persistence where applicable.
- Loading, empty, success, and error states.
- Mobile and desktop responsiveness.
- Horizontal overflow detection.
- Console errors.
- Broken asset detection.

### Template-Conformance Gates
- Required template components remain available.
- Design tokens match the approved baseline unless explicitly changed.
- Navigation patterns remain functional.
- Responsive breakpoints behave correctly.
- No unexpected component or dependency removal.
- No missing fonts, icons, or assets.
- Accessibility checks pass.

### Security Gates
- Dependency vulnerability checks.
- Secrets scanning.
- Static security analysis.
- Input validation.
- Authentication and authorization checks where applicable.
- Safe handling of environment variables.

Do not execute untrusted code without appropriate isolation.

All verification results must be machine-readable.

Unavailable checks must not be marked as passed.

---

## 8. Visual Verification Policy

Do not make LLM-based screenshot interpretation a mandatory requirement.

We are deliberately moving away from unreliable vision-dependent workflows.

Instead:

- Preserve the approved template's design system.
- Verify actual browser behavior.
- Measure layout overflow.
- Validate responsive behavior.
- Verify accessibility.
- Check component and token consistency.
- Retain screenshots as evidence.

Optional vision-based review may be used if independently verified, but missing vision capability must not block template-based delivery.

Do not claim subjective visual quality was verified if no genuine visual evaluation occurred.

The final report must distinguish:
1. Technical correctness.
2. Template conformance.
3. Functional usability.
4. Subjective visual quality, if actually assessed.

---

## 9. Autonomous Repair

When verification fails, classify the defect and delegate it.

Routing:
- Backend defects → DeepSeek.
- API and integration defects → DeepSeek.
- Frontend defects → Qwen.
- Responsive and template-conformance defects → Qwen.
- Architectural conflicts → GLM.
- Security findings → Responsible engineer, followed by independent review.

Repair agents must receive actual failure evidence.

After repair:

1. Rerun the failed gate.
2. Rerun relevant regression tests.
3. Verify template conformance.
4. Record the repair and evidence.
5. Continue only if acceptance criteria are satisfied.

Never weaken tests or modify acceptance criteria simply to achieve a passing result.

Preserve bounded retries and unproductive-loop detection.

---

## 10. GitHub Integration

Use the existing GitHub delivery module.

For each approved project:

1. Initialize or use an approved repository.
2. Create feature branches.
3. Commit meaningful development milestones.
4. Run pre-push secret scanning.
5. Push to the approved private repository.
6. Open a pull request.
7. Attach technical verification results.
8. Include template provenance and attribution.
9. Include relevant screenshots and acceptance reports.
10. Record the final repository and PR URLs.

Require approval before creating new external repositories, changing permissions, merging into main, or deploying publicly.

Never commit API credentials or sensitive files.

If GitHub access is unavailable, prepare the local deliverables and report the blocker.

---

## 11. Persistent Unattended Execution

Use the existing SQLite-based execution controller.

The system must support:

- Persistent project state.
- Task dependencies.
- Model-specific execution.
- Parallel worktrees.
- Automatic retries.
- Bounded repair loops.
- Checkpointing.
- Safe interruption and resumption.
- Evidence reconstruction.
- Completion reporting.

Do not introduce new orchestration infrastructure unless necessary.

Do not add token-cost optimization or spending ceilings.

Retain timeouts, loop detection, cancellation, and execution safety controls.

---

## 13. Acceptance Tests

Create a disposable demonstration project using an approved, appropriately licensed frontend template.

Verify:

1. Template imports successfully.
2. Template provenance and license are recorded.
3. GLM produces a real component-mapping plan.
4. DeepSeek and Qwen run as separate agents.
5. Parallel worktrees remain isolated.
6. Template components are reused.
7. Required product functionality works.
8. Technical gates pass.
9. Playwright user journeys pass.
10. Template-conformance gates pass.
11. Security gates pass.
12. Autonomous repair handles planted defects.
13. SQLite recovery works after interruption.
14. Missing vision capability does not block template-based acceptance.
15. GitHub delivery respects approval gates.
16. Final report accurately distinguishes verified results from unavailable or unassessed qualities.

Do not claim success without execution evidence.

---

## 14. Implementation Instructions

First inspect the existing Phase E Product Factory.

Identify which modules already support template-driven development and which require changes.

Then:

1. Propose the minimum required changes.
2. Identify any new dependencies.
3. Preserve all existing orchestration functionality.
4. Implement template import and registration.
5. Implement template-aware planning.
6. Implement template-aware task compilation.
7. Integrate template conformance with verification.
8. Test the multi-agent workflow.
9. Verify recovery and GitHub safeguards.
10. Produce an evidence-based acceptance report.

Do not rebuild the entire system.

Do not modify global OpenHands settings or model credentials.

Do not delete historical run data.

Do not deploy publicly.

Request approval before destructive operations, external repository creation, or actions outside the approved workspace.

**Proceed autonomously through implementation and testing within the existing approved project workspace.**

The final objective is a reusable, template-driven, multi-agent product factory capable of delivering functional, polished, maintainable applications with minimal human intervention.
