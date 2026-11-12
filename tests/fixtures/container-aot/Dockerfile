# syntax=docker/dockerfile:1
# Profile: sample
# Shape: tool
# Native AOT fixture: the build must execute on the requested native architecture.

# ------------------------------------------------------------------------------
# Stage 1 of 2: build
# ------------------------------------------------------------------------------
FROM mcr.microsoft.com/dotnet/sdk:11.0-resolute-aot AS build
WORKDIR /src
COPY tests/fixtures/dotnet/Directory.Build.props tests/fixtures/dotnet/Directory.Packages.props ./
COPY tests/fixtures/dotnet/src/Fixture.Aot/Fixture.Aot.csproj src/Fixture.Aot/
ARG BUILDPLATFORM
ARG TARGETPLATFORM
RUN --mount=type=secret,id=nuget_source <<EOF
set -eu
test "$BUILDPLATFORM" = "$TARGETPLATFORM"
case "$TARGETPLATFORM" in
    linux/amd64) RID=linux-x64 ;;
    linux/arm64) RID=linux-arm64 ;;
    *) exit 1 ;;
esac
set --
if [ -f /run/secrets/nuget_source ]; then
    set -- --source "$(cat /run/secrets/nuget_source)"
fi
dotnet restore src/Fixture.Aot/Fixture.Aot.csproj --runtime "$RID" \
    "$@" \
    -p:PublishAot=true -p:InvariantGlobalization=true -p:Configuration=Release
printf '%s' "$RID" > /src/target-rid
EOF
COPY tests/fixtures/dotnet/src/Fixture.Aot/Program.cs src/Fixture.Aot/
ARG VERSION=0.0.0
ARG GIT_COMMIT=n/a
RUN --network=none <<EOF
set -eux
dotnet publish src/Fixture.Aot/Fixture.Aot.csproj --configuration Release \
    --runtime "$(cat /src/target-rid)" --no-restore --self-contained true \
    -p:PublishAot=true -p:InvariantGlobalization=true \
    -p:Version="$VERSION" -p:SourceRevisionId="$GIT_COMMIT" --output /out
EOF

# ------------------------------------------------------------------------------
# Stage 2 of 2: final
# ------------------------------------------------------------------------------
FROM mcr.microsoft.com/dotnet/runtime-deps:11.0-resolute-chiseled AS final
WORKDIR /app
COPY --link --from=build /out .
ARG GIT_TAG=0.0.0
ENV GIT_TAG=$GIT_TAG
USER $APP_UID
ENTRYPOINT ["/app/Fixture.Aot"]
