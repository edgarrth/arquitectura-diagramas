# ADR-002: Event Driven Payment Processing

Fecha: 2026-06-16

# 1. Contexto

La plataforma debe procesar pagos, autorizaciones, capturas, reembolsos, notificaciones y conciliaciones. Algunos pasos son síncronos, como la autorización, pero otros deben desacoplarse para mejorar resiliencia y escalabilidad.

# 2. Alternativas a evaluar

- Arquitectura síncrona REST end-to-end
- Arquitectura orientada a eventos
- Procesamiento batch tradicional

# 3. Criterios de evaluación

| Criterio | Descripción | Peso |
|---|---|---:|
| Resiliencia | Capacidad de tolerar fallos parciales | 20% |
| Escalabilidad | Capacidad de absorber picos transaccionales | 20% |
| Consistencia operacional | Trazabilidad de estados y eventos | 20% |
| Observabilidad | Facilidad de monitorear el ciclo de vida del pago | 15% |
| Time to market | Velocidad de implementación | 15% |
| Costos | Infraestructura y operación | 10% |

# 4. Análisis cualitativo

La autorización requiere una respuesta síncrona al merchant. Sin embargo, eventos como `PaymentAuthorized`, `PaymentDeclined`, `PaymentCaptured`, `RefundCreated` y `SettlementCompleted` permiten desacoplar notificaciones, conciliación y reporting.

# 5. Tabla ponderada

| Alternativa | Puntaje |
|---|---:|
| REST end-to-end | 3.4 |
| Event Driven Architecture | 4.8 |
| Batch tradicional | 2.7 |

# 6. Decisión final

Se adopta una arquitectura híbrida: síncrona para autorización y orientada a eventos para procesos posteriores.

# 7. Costos

Se requiere operar un broker de eventos y reforzar observabilidad, trazabilidad, idempotencia y manejo de reintentos.
