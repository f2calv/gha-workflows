# Minimal image used by this repository's CI to exercise container-image-build.yml across
# architectures; it is built and smoke-tested but never published.
# Profile: sample

FROM alpine:3.24 AS final

ARG VERSION=0.0.0

ENV VERSION=$VERSION

USER 65532:65532

ENTRYPOINT ["/bin/sh", "-c", "echo \"$VERSION\""]
