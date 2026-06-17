#!/usr/bin/env bash
set -euo pipefail

mkdir -p docs/assets/diagrams/svg

docker run --rm \
  -v "$(pwd)":/workspace \
  -w /workspace \
  plantuml/plantuml:latest \
  -tsvg \
  -o /workspace/docs/assets/diagrams/svg \
  /workspace/architecture/generated/c4-plantuml/*.puml

echo "Generated SVG diagrams in docs/assets/diagrams/svg"
