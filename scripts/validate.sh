#!/usr/bin/env bash
set -euo pipefail

tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

for f in *.json; do
    if [[ "$f" =~ ^(package\.json|package-lock\.json|biome\.json)$ ]]; then
        continue
    fi
    if [[ "$f" == approve.json ]]; then
        # The standalone validator does not expand preset arguments.
        for update_type in minor patch; do
            rendered="$tmpdir/approve.$update_type.json"
            sed "s/{{arg0}}/$update_type/g; s/{{args}}/$update_type/g" "$f" > "$rendered"
            echo "Validating approve($update_type)"
            npx --no -- renovate-config-validator --no-global "$rendered"
        done
        continue
    fi
    echo "Validating $f"
    npx --no -- renovate-config-validator --no-global "$f"
done
