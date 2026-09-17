# Copilot Instructions

## Shared Instructions

Shared Copilot instruction files are maintained centrally in the [.github](https://github.com/f2calv/.github) repository under `instructions/`, and are applied to every workspace from the VS Code user profile via `~/.copilot/instructions`. They are deliberately not copied into this repository, so a change there takes effect everywhere without a pull request here.

Everything below is specific to this repository.

## Workflow Diagram Conventions

Beyond the shared Mermaid guidance in `markdown.instructions.md`:

- Use `flowchart` for a workflow chain or the steps of a composite action, and `graph` for action dependencies and workflow call chains.
- Use the stadium shape `([ ])` for a reusable workflow, and the rectangle `[ ]` for an action or a job.
- Reserve `## Deployment Flow` for action call chains.

## README Contents

- The root `README.md` must document every reusable workflow, its key inputs and its action dependency chain.
