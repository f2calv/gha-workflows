# App Build Go

Check formatting and modules, run vet and staticcheck, build and run race-enabled Go tests.

[Workflow catalogue](../README.md) | [Workflow source](../.github/workflows/app-build-go.yml)

## Key Inputs

| Input | Contract |
| --- | --- |
| `version` | Required; injected into `main.version`. |
| `runs-on` | Default `ubuntu-26.04`. |
| `go-version-file` | Default `go.mod`; selects the toolchain. |
| `working-directory` | Default `.`; Go commands run here. |
| `package` | Default `./...`. |
| `ldflags` | Additional linker flags; default empty. |

## Permissions And Results

Grant `contents: read`. The caller needs a Go module and code that supports race-enabled tests.
The workflow returns success/failure, not named outputs or a published package.
Use the [shared caller pattern](calling-workflows.md) to pass a calculated version.

## Deployment Flow

The build job depends on these checkout, toolchain and static-analysis actions.

```mermaid
graph LR
    workflow(["_app-build-go"]) --> build["app-build-go"]
    build --> checkout["actions/checkout@v7"]
    build --> sdk["actions/setup-go@v7"]
    build --> analysis["dominikh/staticcheck-action@v1"]
    click checkout href "https://github.com/actions/checkout" "Open checkout" _blank
    click sdk href "https://github.com/actions/setup-go" "Open setup-go" _blank
    click analysis href "https://github.com/dominikh/staticcheck-action" "Open staticcheck-action" _blank
```

Repositories: [checkout](https://github.com/actions/checkout),
[setup-go](https://github.com/actions/setup-go),
[staticcheck-action](https://github.com/dominikh/staticcheck-action).
