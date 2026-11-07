# Helm Lint

Build chart dependencies and run `helm lint` against each chart and every `ci/*-values.yaml`
fixture. No cluster is needed.

[Workflow catalogue](../README.md) | [Workflow source](../.github/workflows/helm-lint.yml)

## Key Inputs

| Input | Contract |
| --- | --- |
| `charts` | Required JSON array of chart directories, such as `["charts/example"]`. |
| `runs-on` | Default `ubuntu-26.04`; one matrix job per chart. |
| `require-ci-values` | Default `true`; fail when no fixture values exist. |
| `helm-version` | Optional version override. |
| `devcontainer-path` | Default `.devcontainer/devcontainer.json`; supplies Helm's version when no override is set. |

## Permissions And Results

Grant `contents: read`. The workflow checks charts but neither packages nor publishes them,
and declares no named outputs. Use [Helm Chart Package](helm-chart-package.md) for packaging
and optional install tests.

## Deployment Flow

The version-reader action is optional when `helm-version` is supplied. Blue identifies the
repository-owned action.

```mermaid
graph LR
    classDef owned fill:#dbeafe,stroke:#2563eb,color:#1e3a5f
    workflow(["_helm-lint"]) --> lint["helm (chart matrix)"]
    lint --> checkout["actions/checkout@v7"]
    lint --> helm["azure/setup-helm@v5"]
    lint --> versions["devcontainer-tool-versions@v1"]
    class versions owned
    click checkout href "https://github.com/actions/checkout" "Open checkout" _blank
    click helm href "https://github.com/azure/setup-helm" "Open setup-helm" _blank
    click versions href "https://github.com/f2calv/gha-workflows/tree/main/.github/actions/devcontainer-tool-versions" "Open devcontainer-tool-versions" _blank
```

Repositories: [checkout](https://github.com/actions/checkout),
[setup-helm](https://github.com/azure/setup-helm),
[devcontainer-tool-versions](../.github/actions/devcontainer-tool-versions/action.yml).
