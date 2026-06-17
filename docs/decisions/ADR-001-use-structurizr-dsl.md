# ADR-001: Use Structurizr DSL for C4 architecture documentation

Fecha: 2026-06-16

# 1. Contexto

La arquitectura de payment processing requiere diagramas consistentes para contexto, contenedores, componentes, flujos dinámicos y despliegue.

GitHub no renderiza Structurizr DSL directamente, pero sí renderiza Mermaid en Markdown. Por eso se necesita una fuente única del modelo y una exportación automática a un formato visible en GitHub.

# 2. Alternativas a evaluar

- Mermaid manual
- PlantUML + C4-PlantUML
- Structurizr DSL + export automático a Mermaid

# 3. Criterios de evaluación

| Criterio | Descripción | Peso |
|---|---|---:|
| Fidelidad C4 | Capacidad de representar contexto, contenedores, componentes y deployment | 25% |
| Mantenibilidad | Facilidad para mantener una fuente única | 20% |
| Compatibilidad GitHub | Visualización directa en GitHub | 20% |
| Automatización | Capacidad de regenerar diagramas en CI/CD | 15% |
| Escalabilidad documental | Capacidad para crecer con más vistas | 10% |
| Curva de aprendizaje | Facilidad de adopción por el equipo | 10% |

# 4. Análisis cualitativo

Mermaid manual es simple, pero no garantiza consistencia entre vistas C4. PlantUML + C4-PlantUML tiene alta fidelidad C4, pero GitHub no lo renderiza nativamente. Structurizr DSL permite modelar C4 correctamente, mantener una fuente única y exportar a Mermaid para visualización en GitHub.

# 5. Tabla ponderada

| Alternativa | Puntaje |
|---|---:|
| Mermaid manual | 3.2 |
| PlantUML + C4-PlantUML | 4.0 |
| Structurizr DSL + export Mermaid | 4.7 |

# 6. Decisión final

Se selecciona **Structurizr DSL + export automático a Mermaid**.

# 7. Costos

No hay costos de licenciamiento para el repositorio. El costo principal es la adopción inicial del DSL y el mantenimiento del workflow de GitHub Actions.
