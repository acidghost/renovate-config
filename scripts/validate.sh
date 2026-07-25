#!/usr/bin/env bash
set -euo pipefail

for f in *.json; do
    if [[ "$f" =~ ^(package\.json|package-lock\.json|biome\.json)$ ]]; then
        continue
    fi
    echo "Validating $f"
    npx --no -- renovate-config-validator --no-global "$f"
done
