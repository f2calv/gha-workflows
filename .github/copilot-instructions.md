# Copilot Instructions

## Shared Instructions

Shared Copilot instructions, skills and prompts are maintained centrally in the [.github](https://github.com/f2calv/.github) repository, under `.github/instructions/`, `.github/skills/` and `.github/prompts/`. They are deliberately not copied into this repository, so a change there takes effect everywhere without a pull request here.

To load them, clone that repository and either add it to this VS Code workspace, or link its folders into `~/.copilot/`. Its README explains both.

If those shared files are not visible, stop and tell the user rather than guessing the conventions — this repository depends on them.

Everything below is specific to this repository.

## Workflow Diagram Conventions

Beyond the shared Mermaid guidance in `markdown.instructions.md`:

- Use `flowchart` for a workflow chain or the steps of a composite action, and `graph` for action dependencies and workflow call chains.
- Use the stadium shape `([ ])` for a reusable workflow, and the rectangle `[ ]` for an action or a job.
- Reserve `## Deployment Flow` for action call chains.

## README Contents

- Keep the root `README.md` concise: identity, workflow catalogue, quick start, version selection and documentation links.
- Link every reusable workflow to `docs/<workflow-file-stem>.md`, which owns its key inputs, permissions, prerequisites, results and action dependency diagram. Cross-workflow architecture views remain in the topic guides; never duplicate diagrams in the root README.
