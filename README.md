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

# Ejecucion
##Opción 1: Localmente (recomendado)
1. Instalar Docker
2. Generar los archivos C4-PlantUML

Desde la raíz del repositorio:
```bash
./scripts/generate-c4-plantuml.sh
```
o:
```bash
bash scripts/generate-c4-plantuml.sh
```

Esto ejecuta:

```bash
docker run --rm \
  -v $(pwd):/usr/local/structurizr \
  structurizr/cli export \
  -workspace architecture/workspace.dsl \
  -format plantuml/c4plantuml \
  -output architecture/generated/c4-plantuml
```bash

Generará:

```text
architecture/generated/c4-plantuml/

├── 01-system-context.puml
├── 02-container-view.puml
├── 03-component-payment-service.puml
├── 04-dynamic-payment-authorization.puml
└── 05-deployment-view.puml
```

Aquí ya puedes abrir los .puml y ver que contienen:

```bash
Person(...)
System(...)
System_Ext(...)

Container(...)
ContainerDb(...)

Component(...)

Deployment_Node(...)

```bash

3. Generar SVG

Ejecuta:
```bash
./scripts/render-c4-svg.sh
```

Esto renderiza todos los .puml.

Resultado:

```text
docs/assets/diagrams/svg/
```
```text
├── 01-system-context.svg
├── 02-container-view.svg
├── 03-component-payment-service.svg
├── 04-dynamic-payment-authorization.svg
└── 05-deployment-view.svg
```

### Linux

start docs\assets\diagrams\svg\01-system-context.svg

### Windows

Ver la documentación completa

Instala MkDocs:

```bash
pip install mkdocs-material pymdown-extensions
```

Luego:

```bash
mkdocs serve
```

Abre:
```text
http://127.0.0.1:8000
```

y tendrás un portal navegable.

## Opción 2: GitHub Actions

Al hacer commit:

```text
Structurizr DSL
      ↓
Export C4-PlantUML
      ↓
Render SVG
      ↓
Commit SVG
      ↓
Deploy GitHub Pages
```

valida:
```text
architecture/generated/c4-plantuml/01-system-context.puml
```

Visualizar diagramas:
```text
architecture/generated/c4-plantuml/
docs/assets/diagrams/svg/
```
