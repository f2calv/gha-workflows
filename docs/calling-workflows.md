# Calling Reusable Workflows

Call a reusable workflow as a job and supply its inputs, required token permissions and declared
secrets. The caller owns ordering, event restrictions and publication policy.

[Workflow catalogue and quick start](../README.md)

## Invocation And Version Selection

All workflows use `workflow_call`; shared workflow names generally begin with `_`. A calling
job declares `uses`, not its own `steps` or `runs-on`. Override the callee's `runs-on` input
where supported. Most Linux workflows default to `ubuntu-26.04`; Windows builds default to
`windows-2025`. Use explicit `needs` relationships between versioning, builds and publication.

This collection uses immutable `vX.Y.Z` release tags and floating `vMAJOR`/`vMAJOR.MINOR`
aliases. Select an exact tag from the [releases](https://github.com/f2calv/gha-workflows/releases)
to lock the implementation. New inputs in the current checkout may not exist in an older
release; the native container guide calls out its required contract.

The [root quick start](../README.md#quick-start) is a complete calculation-and-build caller.
Workflow-specific guides link directly to the YAML defining every input and output.
See [GitHub's reusable workflow guidance](https://docs.github.com/en/actions/using-workflows/reusing-workflows).

## Permissions And Secrets

Nested workflows cannot elevate the caller's token. Grant the permissions declared by the
callee even for jobs that may be skipped. `GITHUB_TOKEN` is automatically available and is not
a secret to redeclare in `workflow_call`. Map declared secrets explicitly, or use
`secrets: inherit` only for trusted calls needing repository secrets. Jobs selecting a GitHub
environment resolve its environment-scoped secrets and protection rules.

| Workflow | Caller token permissions | Additional credentials |
| --- | --- | --- |
| .NET, Go, Python and Rust builds; EF drift; lint; Helm lint; README check | `contents: read` | Extra clones require actual target-repository read access. |
| Container image build | `contents: read`, `packages: write` | Uses `GITHUB_TOKEN`; no separate registry-secret contract. |
| Helm chart package | `contents: read`, `packages: write` | Uses `GITHUB_TOKEN` as the chart password; supply the username. |
| GitOps Helm update | `contents: read`, `packages: read` | Declared `GH_PAT_GITOPS` with target-repository access. |
| Package cleanup | `packages: write` | Token must administer the target owner's packages. |
| Release calculation/publication | `contents: read` / `contents: write` | Automatic token. |
| Terraform | `contents: read`, `id-token: write`, including `validate` and `test` | Azure operations use `ARM_TENANT_ID`, `ARM_SUBSCRIPTION_ID`, `ARM_CLIENT_ID`; client-secret mode also uses `ARM_CLIENT_SECRET`. |
| .NET NuGet library | `contents: write`, `id-token: write`, `packages: write` | Follow the [Trusted Publishing boundary](architecture-nuget-library.md#trusted-publishing). |
| MAUI Windows | `contents: read` | No additional credentials. |
| MAUI Android | `contents: read` | Deployment requires the five [signing/upload secrets](deploy-maui-android.md#signing-and-publication). |

Publication and Terraform mutations are not universally event-gated. Native container builds
validate Dependabot changes without publishing; GitOps and Android jobs skip Dependabot;
Windows builds run for every actor. Use explicit trusted-event conditions and appropriate
environment approvals rather than assuming a publication-off default.

## Extra Repositories

Where supported, `extra-repos` accepts a JSON array of objects with `repo`, `ref` and `path`,
for example `[{"repo":"example/dependency","ref":"main","path":"deps/dependency"}]`.
The [clone-extra-repos Action](../.github/actions/clone-extra-repos/action.yml) shallow-clones
the requested ref, or the repository default branch when the ref is omitted.

The token is sent as a per-command header, never persisted in a remote URL or `.git/config`
that a container build context could copy. The default token does not automatically grant
access to another private repository.

## Outputs And Side Effects

Consume named outputs through `needs.<job>.outputs.<name>`. [Release Versioning](gha-release-versioning.md)
returns `version`, `major`, `minor`, `patch` and `release-exists`;
[MAUI Windows](build-maui-windows.md) returns `artifact-name`.

Other workflows expose job success/failure and documented side effects, not named outputs:
.NET coverage and Windows/plan artifacts may upload; container/Helm/NuGet jobs may publish;
GitOps may push commits; Android may publish a bundle or upload it to Play. A .NET application
build neither publishes packages nor exposes the NuGet companion Action's outputs.

## Composite And Companion Actions

[devcontainer-tool-versions](../.github/actions/devcontainer-tool-versions/action.yml) reads
Helm and yq versions from JSONC into outputs using a temporary copy, leaving the checkout intact.
The clone Action's contract is described above.

Versioning and GitOps use [gha-release-versioning](https://github.com/f2calv/gha-release-versioning)
and [gha-gitops-manifest-update](https://github.com/f2calv/gha-gitops-manifest-update).
For NuGet packaging/publication in a local job, use
[gha-dotnet-nuget](https://github.com/f2calv/gha-dotnet-nuget), which is not a dependency of
the application build workflow.
