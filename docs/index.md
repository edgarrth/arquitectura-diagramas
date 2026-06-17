# Payment Processing Architecture

Este repositorio usa **Structurizr DSL como fuente de verdad** y genera diagramas C4 finales usando **C4-PlantUML**.

## Cadena de generación

```text
architecture/workspace.dsl
        ↓
structurizr/cli export -format plantuml/c4plantuml
        ↓
architecture/generated/c4-plantuml/*.puml
        ↓
plantuml render
        ↓
docs/assets/diagrams/svg/*.svg
```

## Por qué esta aproximación

- El modelo vive en un solo lugar.
- Las vistas C4 se generan desde el modelo.
- Los `.puml` generados usan macros/estereotipos C4.
- GitHub Pages muestra SVG, evitando problemas de renderizado nativo.
