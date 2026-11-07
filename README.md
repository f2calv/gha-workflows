# gha-workflows

Reusable GitHub Actions workflows for repository maintainers: build and validate applications,
publish packages, containers and Helm charts, and run Terraform or GitOps updates.

[![CI](https://github.com/f2calv/gha-workflows/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/f2calv/gha-workflows/actions/workflows/ci.yml)

## Workflow Catalogue

Each guide contains key inputs, permissions, prerequisites, results and an action dependency
diagram. Its source link provides the complete `workflow_call` contract.

| Category | Workflow Guide | Purpose |
| --- | --- | --- |
| Application | [App Build .NET](docs/app-build-dotnet.md) | Restore, build, test and optionally collect coverage. |
| Application | [App Build Go](docs/app-build-go.md) | Format checks, vet, staticcheck, build and race tests. |
| Application | [App Build Python](docs/app-build-python.md) | Locked uv restore, Ruff, mypy, pytest and package build. |
| Application | [App Build Rust](docs/app-build-rust.md) | Toolchain setup, fmt, Clippy, build and tests. |
| Mobile | [Deploy MAUI Android](docs/deploy-maui-android.md) | Unsigned bundle or signed Google Play upload. |
| Mobile | [Build MAUI Windows](docs/build-maui-windows.md) | Unpackaged, self-contained Windows artifact. |
| Database | [EF Migrations Drift](docs/ef-migrations-drift.md) | Detect model changes missing from migrations. |
| Infrastructure | [Terraform](docs/terraform.md) | Backend-free validation/tests or Azure-backed operations. |
| Containers | [Container Image Build](docs/container-image-build.md) | Single-builder or split-native multi-platform images. |
| Helm | [Helm Chart Package](docs/helm-chart-package.md) | Lint, test, package and optionally push OCI charts. |
| GitOps | [GitOps Helm Update](docs/gitops-helm-update.md) | Edit, validate and optionally push manifest updates. |
| Maintenance | [Package Cleanup](docs/package-cleanup.md) | GHCR retention and deletion; dry-run by default. |
| Packages | [.NET NuGet Library](docs/dotnet-nuget-library.md) | Library CI with package publication and optional release. |
| Release | [Release Versioning](docs/gha-release-versioning.md) | Calculate versions and optionally publish tags/releases. |
| Validation | [Helm Lint](docs/helm-lint.md) | Chart dependency and fixture-values lint. |
| Validation | [README Reference Check](docs/readme-ref-check.md) | Require an exact floating-major usage reference. |
| Validation | [Lint](docs/lint.md) | Run the caller's pre-commit configuration. |

## Quick Start

Put this caller in your repository's `.github/workflows/build.yml`. It calculates a version
without publishing, then builds and tests a .NET solution:

```yaml
name: build
on: [push, pull_request]
permissions: {}
jobs:
  versioning:
    permissions:
      contents: read
    uses: f2calv/gha-workflows/.github/workflows/gha-release-versioning.yml@v1
    with:
      tag-and-release: false
      tag-prefix: ''
      move-major-tag: false

  build:
    needs: versioning
    permissions:
      contents: read
    uses: f2calv/gha-workflows/.github/workflows/app-build-dotnet.yml@v1
    with:
      version: ${{ needs.versioning.outputs.version }}
      solution-name: Example.slnx
```

Replace `Example.slnx` and supply `GitVersion.yml`. Tests require `global.json` selecting
Microsoft.Testing.Platform and compatible projects; use `execute-tests: false` for a build-only
caller. Reusable-workflow jobs declare neither `steps` nor `runs-on`; use the workflow inputs.

## Version Selection

Use `@v1` for the floating major release, or pin an immutable `@vX.Y.Z` from the
[releases](https://github.com/f2calv/gha-workflows/releases). Minor aliases also float.
Current-checkout features may require a newer reference than the published alias; check the
individual guide, especially for native container runner mappings.

Callers own `needs` relationships, token permissions and trusted-event restrictions.
Publication is not universally disabled on pull requests. Start with the
[shared invocation and security contract](docs/calling-workflows.md).

## Documentation

- [Calling workflows](docs/calling-workflows.md): version references, secrets, outputs and composite Actions
- [Container image architecture](docs/architecture-container-images.md): native runners, platform artifacts and OCI indexes
- [Helm and GitOps architecture](docs/architecture-helm-gitops.md): image/chart/manifest hand-offs and testing modes
- [NuGet library architecture](docs/architecture-nuget-library.md): release gates and Trusted Publishing
- [Workflow self-tests](docs/self-tests.md): fixture coverage and validation boundaries
- [GitHub reusable workflows](https://docs.github.com/en/actions/using-workflows/reusing-workflows): platform usage rules

## License

Released under the [MIT License](LICENSE).
