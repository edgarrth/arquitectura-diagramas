# Payment Processing Architecture

Repositorio de arquitectura documentando con **Structurizr DSL**, **C4-PlantUML**, **Mermaid**, **MkDocs Material** y **GitHub Pages**.


## 1. Arquitectura de generación

La fuente principal del modelo es:

```text
architecture/workspace.dsl
```

Desde ese archivo se generan automáticamente:

```text
architecture/generated/c4-plantuml/*.puml
docs/assets/diagrams/svg/*.svg
```

El flujo completo es:

```text
Structurizr DSL
      ↓
Structurizr CLI
      ↓
C4-PlantUML
      ↓
PlantUML
      ↓
SVG
      ↓
MkDocs Material
      ↓
GitHub Pages
```

Los diagramas C4 finales se generan con **C4-PlantUML**, usando estereotipos como:

```text
Person
System
System_Ext
Container
ContainerDb
ContainerQueue
Component
Deployment_Node
Rel
```

Los diagramas auxiliares que no requieren C4, como secuencias, eventos o flujos PCI, están en **Mermaid**.

---

## 2. Estructura del repositorio

```text
.
├── .github/
│   └── workflows/
│       └── main.yml
│
├── architecture/
│   ├── workspace.dsl
│   └── generated/
│       └── c4-plantuml/
│
├── docs/
│   ├── index.md
│   ├── adr/
│   ├── architecture/
│   │   ├── c4/
│   │   ├── events/
│   │   ├── infrastructure/
│   │   ├── security/
│   │   └── uml/
│   └── assets/
│       └── diagrams/
│           └── svg/
│
├── scripts/
│   ├── generate-c4-plantuml.sh
│   ├── render-c4-svg.sh
│   └── serve-docs.sh
│
├── mkdocs.yml
└── README.md
```

---

## 3. Carpetas del proyecto

| Carpeta / archivo | Descripción |
|---|---|
| `.github/workflows/main.yml` | Workflow principal de GitHub Actions. Valida el DSL, genera C4-PlantUML, renderiza SVG, commitea diagramas generados y publica GitHub Pages. |
| `architecture/workspace.dsl` | Fuente de verdad del modelo C4 en Structurizr DSL. Aquí se definen personas, sistemas, contenedores, componentes, relaciones, vistas dinámicas y deployment. |
| `architecture/generated/c4-plantuml/` | Carpeta generada automáticamente. Contiene los `.puml` exportados desde Structurizr en formato C4-PlantUML. |
| `docs/index.md` | Página inicial del portal MkDocs. |
| `docs/architecture/c4/` | Páginas Markdown que muestran los diagramas C4 renderizados como SVG. |
| `docs/architecture/uml/` | Diagramas UML auxiliares en Mermaid, por ejemplo secuencias. |
| `docs/architecture/events/` | Diagramas de eventos del dominio de pagos. |
| `docs/architecture/security/` | Diagramas de seguridad, incluyendo PCI DSS Data Flow. |
| `docs/architecture/infrastructure/` | Diagramas de infraestructura y topología cloud. |
| `docs/assets/diagrams/svg/` | Carpeta generada automáticamente con los SVG finales. Estos son los diagramas que visualiza MkDocs/GitHub Pages. |
| `docs/adr/` | Architecture Decision Records. Documenta decisiones técnicas y arquitectónicas. |
| `scripts/` | Scripts para ejecutar la generación y publicación localmente. |
| `mkdocs.yml` | Configuración del sitio MkDocs Material: navegación, tema, extensiones y estructura del portal. |
| `README.md` | Guía principal del repositorio. |

---

## 4. Diagramas disponibles

| Vista | Documento |
|---|---|
| System Context | [docs/architecture/c4/system-context.md](docs/architecture/c4/system-context.md) |
| Container View | [docs/architecture/c4/container-view.md](docs/architecture/c4/container-view.md) |
| Component View | [docs/architecture/c4/component-payment-service.md](docs/architecture/c4/component-payment-service.md) |
| Dynamic View | [docs/architecture/c4/dynamic-payment-authorization.md](docs/architecture/c4/dynamic-payment-authorization.md) |
| Deployment View | [docs/architecture/c4/deployment-view.md](docs/architecture/c4/deployment-view.md) |
| Payment Authorization Sequence | [docs/architecture/uml/payment-authorization-sequence.md](docs/architecture/uml/payment-authorization-sequence.md) |
| Payment Event Flow | [docs/architecture/events/payment-event-flow.md](docs/architecture/events/payment-event-flow.md) |
| PCI DSS Data Flow | [docs/architecture/security/pci-data-flow.md](docs/architecture/security/pci-data-flow.md) |
| GCP Infrastructure Topology | [docs/architecture/infrastructure/gcp-topology.md](docs/architecture/infrastructure/gcp-topology.md) |
| ADRs | [docs/adr/index.md](docs/adr/index.md) |

---

## 5. Cómo ejecutarlo en GitHub Actions

### 5.1. Habilitar GitHub Pages

En el repositorio de GitHub:

```text
Settings
  → Pages
      → Build and deployment
          → Source = GitHub Actions
```

Esto permite que el workflow publique el sitio generado por MkDocs.

---

### 5.2. Ejecutar automáticamente

El workflow se ejecuta automáticamente cuando haces push a `main`:

```bash
git add .
git commit -m "Update architecture"
git push origin main
```

El pipeline hará lo siguiente:

```text
1. Checkout del repositorio
2. Setup Java
3. Descarga/cache de Structurizr CLI
4. Validación de architecture/workspace.dsl
5. Exportación a C4-PlantUML
6. Renderizado de C4-PlantUML a SVG
7. Commit de los archivos generados
8. Build del sitio MkDocs
9. Deploy a GitHub Pages
```

---

### 5.3. Ejecutar manualmente

También puedes ejecutarlo manualmente:

```text
Actions
  → Generate C4-PlantUML and Publish Docs
      → Run workflow
```

Esto es útil cuando quieres regenerar documentación sin hacer cambios en el código.

---

## 6. Dónde ver los resultados en GitHub

### 6.1. Archivos C4-PlantUML generados

Después de correr el workflow, los `.puml` quedan en:

```text
architecture/generated/c4-plantuml/
```

Ejemplos:

```text
structurizr-01-system-context.puml
structurizr-02-container-view.puml
structurizr-03-component-payment-service.puml
structurizr-04-dynamic-payment-authorization.puml
structurizr-05-deployment-view.puml
```

Estos archivos permiten verificar que los diagramas C4 fueron generados como **C4-PlantUML**.

---

### 6.2. SVG generados

Los diagramas renderizados quedan en:

```text
docs/assets/diagrams/svg/
```

Ejemplos:

```text
structurizr-01-system-context.svg
structurizr-02-container-view.svg
structurizr-03-component-payment-service.svg
structurizr-04-dynamic-payment-authorization.svg
structurizr-05-deployment-view.svg
```

Estos SVG son los que se muestran dentro del portal MkDocs.

---

### 6.3. Portal GitHub Pages

Cuando GitHub Pages queda publicado, la URL tendrá este formato:

```text
https://<usuario-o-organizacion>.github.io/<nombre-del-repositorio>/
```

Ejemplo:

```text
https://edgarrth.github.io/arquitectura-diagramas/
```

Desde ahí puedes navegar:

```text
C4
 ├── System Context
 ├── Container View
 ├── Component View
 ├── Dynamic View
 └── Deployment View

UML
 └── Payment Authorization Sequence

Events
 └── Payment Event Flow

Security
 └── PCI DSS Data Flow

Infrastructure
 └── GCP Topology

ADR
 ├── ADR-001
 ├── ADR-002
 └── ADR-003
```

---

## 7. Cómo ejecutarlo localmente

### 7.1. Requisitos

Necesitas:

```text
Docker
Java 21
Python 3.10+
pip
```

Valida:

```bash
docker --version
java -version
python --version
pip --version
```

---

### 7.2. Generar C4-PlantUML desde Structurizr

```bash
./scripts/generate-c4-plantuml.sh
```

Resultado esperado:

```text
architecture/generated/c4-plantuml/
```

---

### 7.3. Renderizar SVG desde C4-PlantUML

```bash
./scripts/render-c4-svg.sh
```

Resultado esperado:

```text
docs/assets/diagrams/svg/
```

---

### 7.4. Levantar la documentación local

```bash
./scripts/serve-docs.sh
```

Luego abre:

```text
http://127.0.0.1:8000
```

---

## 8. Flujo normal de trabajo

### Modificar la arquitectura

Edita:

```text
architecture/workspace.dsl
```

Luego:

```bash
git add architecture/workspace.dsl
git commit -m "Update payment architecture model"
git push origin main
```

GitHub Actions generará nuevamente los `.puml`, los `.svg` y publicará la documentación.

---

### Modificar una página de documentación

Edita cualquier archivo dentro de:

```text
docs/
```

Luego:

```bash
git add docs/
git commit -m "Update architecture documentation"
git push origin main
```

MkDocs publicará la nueva versión del sitio.

---

## 9. Cómo validar que los diagramas C4 son reales

Abre cualquier archivo generado en:

```text
architecture/generated/c4-plantuml/
```

Deberías ver macros C4-PlantUML como:

```plantuml
Person(...)
System(...)
System_Ext(...)
Container(...)
Component(...)
Rel(...)
```
