#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

mkdir -p docs/diagrams
rm -f docs/diagrams/*.mmd docs/diagrams/*.md

docker run --rm \
  -v "$PWD:/usr/local/structurizr" \
  structurizr/cli:latest \
  validate -workspace architecture/workspace.dsl

docker run --rm \
  -v "$PWD:/usr/local/structurizr" \
  structurizr/cli:latest \
  export -workspace architecture/workspace.dsl -format mermaid -output docs/diagrams

python3 scripts/wrap-mermaid.py
