#!/usr/bin/env bash
#Reads tool versions from a JSONC devcontainer.json into step outputs. The file is converted into a
#temporary copy, so the checkout is never modified. A missing feature yields an empty output.
set -euo pipefail

if [[ ! -f "$DEVCONTAINER_PATH" ]]; then
  echo "::error file=$DEVCONTAINER_PATH::Tool versions are managed by '$DEVCONTAINER_PATH', which is missing."
  exit 1
fi

JSON="$RUNNER_TEMP/devcontainer-tool-versions.json"
npx --yes json5@2 "$DEVCONTAINER_PATH" > "$JSON"

HELM=$(jq -r '[.features[] | objects | .helm // empty] | first // ""' "$JSON")
YQ=$(jq -r '[.features[] | objects | .yqVersion // empty] | first // ""' "$JSON")

for pair in "helm=$HELM" "yq=$YQ"; do
  value="${pair#*=}"
  if [[ -n "$value" && ! "$value" =~ ^(latest|v?[0-9]+(\.[0-9]+){0,2})$ ]]; then
    echo "::error file=$DEVCONTAINER_PATH::${pair%%=*} version '$value' must be latest or a version."
    exit 1
  fi
  echo "$pair" | tee -a "$GITHUB_OUTPUT"
done
