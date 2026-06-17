# Payment Processing Architecture

Repositorio de documentación arquitectónica para un caso de uso de **payment processing**, usando **Structurizr DSL** como fuente única del modelo C4.

GitHub no renderiza Structurizr DSL directamente. Por eso este repositorio genera vistas Mermaid automáticamente desde `architecture/workspace.dsl`, y las publica como Markdown dentro de `docs/diagrams`.

## Diagramas C4

| Vista | Descripción |
|---|---|
| [01 - System Context](./docs/diagrams/01-system-context.md) | Relación entre la plataforma de pagos, merchants, cardholders, adquirente, red de tarjetas e issuer. |
| [02 - Container](./docs/diagrams/02-container.md) | Contenedores internos: API Gateway, Journey, Payment Service, Fraud, Tokenization, Vault, Kafka y DB. |
| [03 - Payment Service Component](./docs/diagrams/03-payment-service-component.md) | Componentes internos del Payment Service. |
| [04 - Payment Authorization Flow](./docs/diagrams/04-payment-authorization-flow.md) | Flujo dinámico de autorización de pago. |
| [05 - Production Deployment](./docs/diagrams/05-production-deployment.md) | Despliegue productivo en GCP/GKE y servicios externos. |

## Documentos adicionales

| Documento | Descripción |
|---|---|
| [Modelo fuente Structurizr](./architecture/workspace.dsl) | Fuente única del modelo arquitectónico. |
| [ADR-001](./docs/decisions/ADR-001-use-structurizr-dsl.md) | Decisión de usar Structurizr DSL para documentación C4. |
| [ADR-002](./docs/decisions/ADR-002-event-driven-payment-processing.md) | Decisión de usar arquitectura orientada a eventos para payment processing. |

## Cómo generar localmente

Requiere Docker.

```bash
./scripts/export-diagrams.sh
```

Esto ejecuta:

```bash
docker run --rm \
  -v "$PWD:/usr/local/structurizr" \
  structurizr/cli:latest \
  export -workspace architecture/workspace.dsl -format mermaid -output docs/diagrams
```

## Publicación automática en GitHub

Cada push a `main` ejecuta `.github/workflows/publish-architecture.yml`.

El workflow:

1. Valida el `workspace.dsl`.
2. Exporta las vistas a Mermaid.
3. Convierte los `.mmd` generados en páginas `.md` renderizables por GitHub.
4. Hace commit automático de los diagramas generados si cambiaron.

## Flujo recomendado

```text
Editar architecture/workspace.dsl
        ↓
Commit + push a main
        ↓
GitHub Actions exporta Mermaid
        ↓
docs/diagrams/*.md queda actualizado
        ↓
README enlaza a todos los diagramas
```

## Por qué Structurizr

Structurizr permite modelar C4 con una fuente única y generar múltiples vistas consistentes: contexto, contenedores, componentes, dinámicas y deployment.
