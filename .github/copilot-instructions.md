# Copilot Instructions

## Shared Instructions

Shared Copilot instruction files are maintained centrally in the [.github](https://github.com/f2calv/.github) repository under `instructions/`, and are applied to every workspace from the VS Code user profile via `~/.copilot/instructions`. They are deliberately not copied into this repository, so a change there takes effect everywhere without a pull request here.

Everything below is specific to this repository.

## Workflow Diagram Conventions

Beyond the shared Mermaid guidance in `documentation.instructions.md`:

- Use `flowchart` for workflow chains and composite action steps.
- Use `graph` for action dependencies and workflow call chains.
- Group related jobs or steps in subgraphs.
- Define `classDef` styling to distinguish actions owned by this organisation from third-party ones.
- Use the stadium shape `([ ])` for reusable workflows and the rectangle `[ ]` for actions and jobs.
- Reserve `## Deployment Flow` for CI/CD pipelines and action call chains, and `## Dependency Graph` for action and workflow relationships.
- Keep diagrams in sync with the actions and workflows they describe. When renaming an input or output, or adding or removing an action dependency, update the diagram nodes in the same change.

## README Scope

Where the shared documentation instructions refer to a project or a `.csproj`, read that as a **workflow or action** here — this repository has no .NET projects. The root `README.md` documents every reusable workflow, its key inputs and its action dependency chain.
