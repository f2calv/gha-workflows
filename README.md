# GitHub Actions Reusable Workflows Repository

A collection of reusable GitHub Actions workflows covering common CI/CD scenarios across public and private repositories. For background on reusable workflows see the [official docs](https://docs.github.com/en/actions/using-workflows/reusing-workflows).

All reusable workflows are called via `workflow_call` and follow a consistent naming convention — the `name:` field is prefixed with `_` (e.g. `_app-build-dotnet`) to distinguish them from standalone workflows.

## Usage

Reference a workflow from any repository:

```yaml
jobs:
  build:
    uses: f2calv/gha-workflows/.github/workflows/app-build-dotnet.yml@v1
    with:
      version: ${{ needs.versioning.outputs.version }}
      solution-name: MySolution.slnx
```

## Workflows

### Application Build

| Workflow | Description | Key Inputs |
| --- | --- | --- |
| [App Build .NET](.github/workflows/app-build-dotnet.yml) | Restore, workload restore, build a .NET solution/project. Installs .NET 8/9/10 SDKs. Optionally clones extra repositories into the build context. | `version` (required), `solution-name`, `configuration`, `dotnet-restore-args`, `dotnet-build-args`, `extra-repos` |
| [App Build Go](.github/workflows/app-build-go.yml) | `gofmt` check, `go mod verify`, `go vet`, staticcheck, build and test a Go module. Toolchain version is sourced from `go.mod`. | `version` (required), `go-version-file`, `package`, `ldflags` |
| [App Build Rust](.github/workflows/app-build-rust.yml) | Format check, clippy lint, fetch and build a Rust project. | `version` (required) |

### Database

| Workflow | Description | Key Inputs |
| --- | --- | --- |
| [EF Migrations Drift](.github/workflows/ef-migrations-drift.yml) | Fail when the EF Core model has schema changes not captured by a migration (runs `dotnet ef migrations has-pending-model-changes`; no live database required). Installs .NET 8/9/10 SDKs and restores tools. The caller repo must pin `dotnet-ef` in `.config/dotnet-tools.json` and provide an `IDesignTimeDbContextFactory` configured with the migrations provider. | `project` (required), `startup-project`, `context`, `configuration`, `extra-repos` |

### Containers & Helm

| Workflow | Description | Key Inputs |
| --- | --- | --- |
| [Container Image Build](.github/workflows/container-image-build.yml) | Multi-architecture buildx build and push to a container registry (ghcr.io, ACR, Docker Hub). Tags with the exact semver plus latest (or latest-dev off the default branch); published versions are immutable and are never overwritten. Optionally clones extra repositories into the Docker build context. | `registry` (required), `tag` (required), `platform`, `dockerfile`, `push-image`, `extra-repos` |
| [Helm Chart Package](.github/workflows/helm-chart-package.yml) | Lint, package and push a Helm chart to an OCI registry. Helm version is sourced from `.devcontainer/devcontainer.json`. | `tag` (required), `image-registry` (required), `chart-registry` (required), `chart-repository` (required), `chart-path`, `has-image` |
| [GitOps Helm Update](.github/workflows/gitops-helm-update.yml) | Update and render an ArgoCD Helm manifest, then optionally commit it to its GitOps repository. | `manifest-paths`, `tag`, `namespace`, `gitops-repo`, chart and image coordinates |
| [GitOps Manifest Update](.github/workflows/gha-gitops-manifest-update.yml) | Update image tags in a GitOps repository via [f2calv/gha-gitops-manifest-update](https://github.com/f2calv/gha-gitops-manifest-update). | `tag` (required), `image-registry` (required), `image-repository` (required), `manifest-paths` (required), `namespace` (required) |
| [Package Cleanup](.github/workflows/package-cleanup.yml) | Prune old container/Helm chart versions from ghcr.io via [dataaxiom/ghcr-cleanup-action](https://github.com/dataaxiom/ghcr-cleanup-action). Keeps the N most-recent tagged versions, deletes untagged orphans, and protects excluded tags. Defaults to dry-run. | `packages` (required), `keep-n-tagged`, `exclude-tags`, `older-than`, `delete-untagged`, `dry-run` |

### Release & Versioning

| Workflow | Description | Key Inputs |
| --- | --- | --- |
| [Release Versioning](.github/workflows/gha-release-versioning.yml) | Determine a semantic version (via [GitVersion](https://gitversion.net/)), tag the repo and create a GitHub release. | `semVer`, `tag-prefix`, `move-major-tag`, `tag-and-release` |

### Code Quality

| Workflow | Description | Key Inputs |
| --- | --- | --- |
| [Lint](.github/workflows/lint.yml) | Run [pre-commit](https://pre-commit.com/) hooks against all files in the repository. | `pre-commit-version` |

## Deployment Flow

Mermaid diagrams showing the action dependency chain for each workflow. Actions and workflows owned by [f2calv](https://github.com/f2calv) are highlighted in blue.

### _app-build-dotnet

```mermaid
flowchart LR
    classDef f2calv fill:#dbeafe,stroke:#2563eb,color:#1e3a5f
    W(["_app-build-dotnet"]) --> J["app-build-dotnet"]
    J --> A1["actions/checkout@v6"]
    J --> A2["actions/setup-dotnet@v5"]
```

### _app-build-go

```mermaid
flowchart LR
    classDef f2calv fill:#dbeafe,stroke:#2563eb,color:#1e3a5f
    W(["_app-build-go"]) --> J["app-build-go"]
    J --> A1["actions/checkout@v7"]
    J --> A2["actions/setup-go@v6"]
    J --> A3["dominikh/staticcheck-action@v1"]
```

### _app-build-rust

```mermaid
flowchart LR
    classDef f2calv fill:#dbeafe,stroke:#2563eb,color:#1e3a5f
    W(["_app-build-rust"]) --> J["app-build-rust"]
    J --> A1["actions/checkout@v6"]
```

### _ef-migrations-drift

```mermaid
flowchart LR
    classDef f2calv fill:#dbeafe,stroke:#2563eb,color:#1e3a5f
    W(["_ef-migrations-drift"]) --> J["ef-migrations-drift"]
    J --> A1["actions/checkout@v7"]
    J --> A2["actions/setup-dotnet@v5"]
```

### _container-image-build

```mermaid
flowchart LR
    classDef f2calv fill:#dbeafe,stroke:#2563eb,color:#1e3a5f
    W(["_container-image-build"]) --> J["container-image-build"]
    J --> A1["actions/checkout@v6"]
```

### _helm-chart-package

```mermaid
flowchart LR
    classDef f2calv fill:#dbeafe,stroke:#2563eb,color:#1e3a5f
    W(["_helm-chart-package"]) --> J["helm-chart-package"]
    J --> A1["actions/checkout@v6"]
    J --> A2["azure/setup-helm@v5"]
    J --> A3["helm/kind-action@v1"]
```

### _gha-gitops-manifest-update

```mermaid
flowchart LR
    classDef f2calv fill:#dbeafe,stroke:#2563eb,color:#1e3a5f
    W(["_gha-gitops-manifest-update"]) --> J["gha-gitops-manifest-update"]
    J --> A1["actions/checkout@v6"]
    J --> A2["f2calv/gha-gitops-manifest-update@v2"]
    class A2 f2calv
```

### _package-cleanup

```mermaid
flowchart LR
    classDef f2calv fill:#dbeafe,stroke:#2563eb,color:#1e3a5f
    W(["_package-cleanup"]) --> J["package-cleanup"]
    J --> A1["dataaxiom/ghcr-cleanup-action@v1"]
```

### _gha-release-versioning

```mermaid
flowchart LR
    classDef f2calv fill:#dbeafe,stroke:#2563eb,color:#1e3a5f
    W(["_gha-release-versioning"]) --> J["gha-release-versioning"]
    J --> A1["actions/checkout@v6"]
    J --> A2["f2calv/gha-release-versioning@v1"]
    class A2 f2calv
```

### _lint

```mermaid
flowchart LR
    classDef f2calv fill:#dbeafe,stroke:#2563eb,color:#1e3a5f
    W(["_lint"]) --> J["lint"]
    J --> A1["actions/checkout@v6"]
```

## Companion Actions

These workflows depend on companion composite actions:

- [f2calv/gha-release-versioning](https://github.com/f2calv/gha-release-versioning) — Semantic versioning with GitVersion
- [f2calv/gha-dotnet-nuget](https://github.com/f2calv/gha-dotnet-nuget) — .NET build, test, pack and NuGet push
- [f2calv/gha-gitops-manifest-update](https://github.com/f2calv/gha-gitops-manifest-update) — GitOps manifest image tag updates

## Other Resources

- [GitHub Actions Docs](https://docs.github.com/en/actions)
- [Reusing Workflows](https://docs.github.com/en/actions/using-workflows/reusing-workflows)
- My older [Azure DevOps Shared YAML Templates](https://github.com/f2calv/CasCap.YAMLTemplates)
