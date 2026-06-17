#!/usr/bin/env bash
set -euo pipefail

mkdir -p architecture/generated/c4-plantuml

docker run --rm \
  -v "$(pwd)":/usr/local/structurizr \
  structurizr/cli export \
  -workspace architecture/workspace.dsl \
  -format plantuml/c4plantuml \
  -output architecture/generated/c4-plantuml

echo "Generated C4-PlantUML files in architecture/generated/c4-plantuml"
