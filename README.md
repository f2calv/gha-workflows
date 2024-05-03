# GitHub Actions Reusable Workflows Repository

This is a reusable workflow repository, for more information see [Resources in YAML Pipelines](https://docs.github.com/en/actions/using-workflows/reusing-workflows).

These workflows cover a number of common scenarios that I face across my public/private repositories here on GitHub.

## General Build Workflows

- [App Build .NET](.github/workflows/app-build-dotnet.yml)
- [App Build Rust](.github/workflows/app-build-rust.yml)

## GitHub Packages: Containers

- [Container Image Build](.github/workflows/container-image-build.yml)
- [Helm Chart Package](.github/workflows/helm-chart-package.yml)
- [GitOps Manifest Update](.github/workflows/gha-gitops-manifest-update.yml)

## GitHub Packages: NuGet

- [.NET build/test/pack/nuget push](.github/workflows/dotnet-publish-nuget.yml)

## Release Versioning

- [GitHub Actions Release Versioning](.github/workflows/gha-release-versioning.yml)

## Other Resources

- [GitHub Actions Docs](https://docs.github.com/en/actions)
- My older [Azure DevOps Shared YAML Templates](https://github.com/f2calv/CasCap.YAMLTemplates)
