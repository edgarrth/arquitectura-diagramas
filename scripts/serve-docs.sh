#!/usr/bin/env bash
set -euo pipefail

pip install mkdocs-material pymdown-extensions
mkdocs serve
