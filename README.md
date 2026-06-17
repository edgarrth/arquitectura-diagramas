# Payment Processing Architecture

Repositorio profesional de arquitectura para **Payment Processing**.

## Principio principal

La fuente de verdad es:

```text
architecture/workspace.dsl
```

Desde ese modelo, GitHub Actions genera automáticamente:

```text
architecture/generated/c4-plantuml/*.puml
docs/assets/diagrams/svg/*.svg
```

Los diagramas C4 finales se generan usando **C4-PlantUML**, es decir, con estereotipos/macros C4 como:

- `Person`
- `System`
- `System_Ext`
- `Container`
- `ContainerDb`
- `ContainerQueue`
- `Component`
- `Deployment_Node`
- `Rel`

## Flujo de generación

```text
Structurizr DSL
      ↓
structurizr/cli export -format plantuml/c4plantuml
      ↓
C4-PlantUML .puml
      ↓
PlantUML render
      ↓
SVG
      ↓
MkDocs / GitHub Pages
```

## Documentación

| Vista | Documento |
|---|---|
| System Context | [docs/architecture/c4/system-context.md](docs/architecture/c4/system-context.md) |
| Container View | [docs/architecture/c4/container-view.md](docs/architecture/c4/container-view.md) |
| Component View | [docs/architecture/c4/component-payment-service.md](docs/architecture/c4/component-payment-service.md) |
| Dynamic View | [docs/architecture/c4/dynamic-payment-authorization.md](docs/architecture/c4/dynamic-payment-authorization.md) |
| Deployment View | [docs/architecture/c4/deployment-view.md](docs/architecture/c4/deployment-view.md) |
| UML Sequence | [docs/architecture/uml/payment-authorization-sequence.md](docs/architecture/uml/payment-authorization-sequence.md) |
| Event Flow | [docs/architecture/events/payment-event-flow.md](docs/architecture/events/payment-event-flow.md) |
| PCI Data Flow | [docs/architecture/security/pci-data-flow.md](docs/architecture/security/pci-data-flow.md) |

## Ejecución local

```bash
./scripts/generate-c4-plantuml.sh
./scripts/render-c4-svg.sh
./scripts/serve-docs.sh
```
