#!/usr/bin/env bash
#Shallow-clones each entry of EXTRA_REPOS. The token is sent as a per-command HTTP header, so it is
#never written to a remote URL or .git/config, which may later be copied into a container build context.
set -euo pipefail

fail() {
  echo "::error::$1"
  exit 1
}

if ! jq -e 'type == "array"' <<< "$EXTRA_REPOS" > /dev/null; then
  fail "repos must be a JSON array."
fi

AUTH_HEADER="AUTHORIZATION: basic $(printf 'x-access-token:%s' "$CLONE_TOKEN" | base64 --wrap=0)"
echo "::add-mask::$AUTH_HEADER"

while IFS= read -r item; do
  REPO=$(jq -r '.repo // ""' <<< "$item")
  REF=$(jq -r '.ref // ""' <<< "$item")
  DEST=$(jq -r '.path // "deps"' <<< "$item")

  [[ "$REPO" =~ ^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+$ ]] || fail "repo '$REPO' must be owner/name."
  [[ -z "$REF" || "$REF" =~ ^[A-Za-z0-9_./-]+$ ]] || fail "ref '$REF' for $REPO is invalid."
  [[ -n "$DEST" ]] || fail "path for $REPO is empty."

  ARGS=(--depth 1)
  #An omitted ref clones the default branch.
  [[ -z "$REF" ]] || ARGS+=(--branch "$REF")

  echo "Cloning $REPO@${REF:-<default>} into $DEST"
  git -c "http.https://github.com/.extraheader=$AUTH_HEADER" \
    clone "${ARGS[@]}" "https://github.com/$REPO.git" "$DEST"
done < <(jq -c '.[]' <<< "$EXTRA_REPOS")
