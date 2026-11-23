# Workflow Self-Tests

The [repository CI](../.github/workflows/ci.yml) calls its own reusable workflows at the commit
under review against small [fixtures](../tests/fixtures) before a release moves the floating alias.

[Workflow catalogue](../README.md)

## Fixture Coverage

| Workflow | Fixture | Exercises |
| --- | --- | --- |
| `app-build-dotnet.yml` | .NET library and xUnit v3 tests | Restore, build, MTP tests and coverage upload. |
| `sonarqube-dotnet.yml` | Repository root, .NET and MAUI fixtures | OIDC-authenticated multi-language analysis, compiled C# test/mobile code and MTP coverage; requires Cloud setup and the v3 action release. |
| `app-build-npm.yml` | Dependency-free npm fixture | Script contract, version/base propagation and exact artifact contents. |
| `pages-publish.yml` | The npm artifact, package-only | Static-site preparation and Pages packaging; deployment disabled. |
| `mkdocs-build.yml` | Ordinary `docs/` project | Strict script-free build, seven artifact checks and default-branch Pages deployment with live page/asset/search/exact-commit verification. |
| `container-image-build.yml` | Single-platform image | Vanilla amd64 build, arguments, cache and smoke; never published. |
| `container-image-build.yml` | Multi-architecture image | Legacy amd64/arm64/arm/v7, emulation and smoke; never published. |
| `container-image-build.yml` | Native AOT executable | Native amd64/arm64, architecture/dynamic-code checks, archive transfer and verified index in a disposable registry; never published to GHCR. |
| `container-image-build.yml` | Runner mapping contract | Nine default, native, self-hosted, malformed, duplicate and incomplete mapping cases. |
| `helm-chart-package.yml` | Chart owning an image value | Image rewriting, packaging and `ct lint`; never pushed. |
| `app-build-rust.yml` | Cargo binary with a unit test | Working directory, toolchain, fmt, Clippy, build and tests. |
| `app-build-python.yml` | Locked uv package | Lockfile, Ruff, mypy, pytest and `uv build`. |
| `app-build-go.yml` | Go module outside the root | Working directory, vet, staticcheck, build and race tests. |
| `terraform.yml` | Root module with output/test | Backend-free validate, fmt and Terraform tests. |
| `helm-lint.yml` | Chart and fixture values | Devcontainer Helm version, dependencies and fixture lint. |
| `dotnet-nuget-library.yml` | .NET fixture with `release: false` | Nested lint, versioning and companion Action build/tests. |
| `readme-ref-check.yml` | Root README | Floating major reference for the workflows. |
| `devcontainer-tool-versions` | Repository devcontainer | Helm and yq version reads without changing the file. |
| `ef-migrations-drift.yml` | Model-less context/design-time factory | Tool restore and pending-model-changes check. |
| `deploy-maui-android.yml` | Code-only MAUI app | Workload restore, pinned JDK and unsigned bundle; a debug-key APK with a clock version code and one-day artifact. Never deployed. |
| `build-maui-windows.yml` | Same MAUI fixture | Self-contained unpackaged publish and one-day artifact upload. |
| `clone-extra-repos` | Two public repositories | Explicit-ref/default-branch clones without persisted credentials. |

The root [global.json](../global.json), [tool manifest](../.config/dotnet-tools.json) and
[devcontainer](../.devcontainer/devcontainer.json) provide the fixtures' SDK, test-runner and
Helm requirements. These callers do not establish production registry authentication,
nuget.org OIDC publication or live deployment readiness.

## SonarQube Analysis

The independent `sonarqube` CI job analyzes the repository root rather than excluding
`tests/fixtures`. It builds the .NET solution and MAUI project on Windows so both mobile platform
source sets participate in C# analysis. Supported non-.NET source and configuration files are
picked up by the .NET scanner's multi-language mode; existing lint and language-specific tests
remain authoritative for unsupported checks such as Bash semantics and Rust Clippy.

The job waits for the Quality Gate and is included in the release fan-in. See the
[SonarQube guide](sonarqube-dotnet.md) for secretless setup and action-first release ordering.
Hosted analysis and MAUI scanner integration remain unverified until that setup and rollout.
