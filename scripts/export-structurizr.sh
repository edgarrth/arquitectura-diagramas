#!/usr/bin/env bash
set -euo pipefail

mkdir -p docs/assets/diagrams

docker run --rm \
  -v "$(pwd)":/usr/local/structurizr \
  structurizr/cli export \
  -workspace architecture/workspace.dsl \
  -format mermaid \
  -output docs/assets/diagrams

echo "Diagrams exported to docs/assets/diagrams"
