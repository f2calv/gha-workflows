# Fixture.Aot

A small executable used by the container workflow's Native AOT integration fixture. Its output is
`<GIT_TAG>|<process architecture>|<dynamic code supported>`; a native build reports `False` in the
last field.

The [fixture Dockerfile](../../../container-aot/Dockerfile) publishes for `linux-x64` or
`linux-arm64` and refuses a non-native build platform. The repository's CI builds and runs both
variants on separate native runners, then verifies their combined image index in a disposable
registry. It does not publish the fixture to GHCR.

The normal .NET fixture solution builds this project as managed code. Native AOT is selected only
by the container fixture's restore and publish commands.
