#!/usr/bin/env bash
# Check flake input ages and warn if any are older than threshold
set -euo pipefail

MAX_DAYS="${1:-30}"
WARN_ONLY="${2:-false}"

echo "Checking flake input ages (threshold: ${MAX_DAYS} days)..."

now=$(date +%s)
exit_code=0

while IFS= read -r line; do
  input=$(echo "${line}" | jaq -r '.key')

  # Skip root node and nodes without locked info
  [[ "${input}" == "root" ]] && continue
  last_modified=$(echo "${line}" | jaq -r '.value.locked.lastModified // empty' 2>/dev/null) || continue
  [[ -z "${last_modified}" ]] && continue

  age_days=$(((now - last_modified) / 86400))

  if [[ ${age_days} -gt ${MAX_DAYS} ]]; then
    echo "::warning::Input '${input}' is ${age_days} days old (threshold: ${MAX_DAYS})"
    [[ "${WARN_ONLY}" != "true" ]] && exit_code=1
  else
    echo "Input '${input}': ${age_days} days old"
  fi
done < <(jaq -c '.nodes | to_entries | .[]' flake.lock 2>/dev/null || true)

[[ ${exit_code} -eq 0 ]] && echo "All inputs within freshness threshold."
exit "${exit_code}"
