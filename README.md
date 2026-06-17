# Payment Processing Architecture

Repositorio profesional de arquitectura para un caso de uso de **Payment Processing**, documentado con:

- C4 Model usando Structurizr DSL
- UML Sequence usando PlantUML
- Event Driven Architecture
- PCI DSS Data Flow
- Deployment View
- Architecture Decision Records
- GitHub Actions
- GitHub Pages con MkDocs Material

## Navegación rápida

| Sección | Descripción |
|---|---|
| [Architecture Overview](docs/index.md) | Portal principal de documentación |
| [Structurizr Workspace](architecture/workspace.dsl) | Modelo fuente C4 |
| [System Context](docs/architecture/c4/system-context.md) | Vista de contexto |
| [Container View](docs/architecture/c4/container-view.md) | Vista de contenedores |
| [Component View](docs/architecture/c4/component-payment-service.md) | Vista de componentes |
| [Dynamic View](docs/architecture/c4/dynamic-payment-authorization.md) | Flujo dinámico de autorización |
| [Deployment View](docs/architecture/c4/deployment-view.md) | Vista de despliegue |
| [Payment Authorization Sequence](docs/architecture/uml/payment-authorization-sequence.md) | Secuencia UML |
| [Event Flow](docs/architecture/events/payment-event-flow.md) | Flujo de eventos |
| [PCI DSS Data Flow](docs/architecture/security/pci-data-flow.md) | Alcance PCI |
| [Infrastructure Topology](docs/architecture/infrastructure/gcp-topology.md) | Topología Cloud |
| [ADRs](docs/adr/index.md) | Decisiones de arquitectura |

## Cómo funciona

El archivo `architecture/workspace.dsl` es la fuente principal de verdad.  
GitHub Actions exporta automáticamente los diagramas desde Structurizr y publica la documentación en GitHub Pages.

## Ejecución local

```bash
./scripts/export-structurizr.sh
./scripts/serve-docs.sh
```

## Publicación automática

Al hacer push a `main`, GitHub Actions:

1. Exporta diagramas desde Structurizr.
2. Genera archivos Mermaid.
3. Construye el sitio MkDocs.
4. Publica en GitHub Pages.
