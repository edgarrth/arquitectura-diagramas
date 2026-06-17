# ADR-001: Event Driven Payment Processing

Fecha: 2026-06-16

## 1. Contexto

La plataforma necesita desacoplar autorización, captura, settlement, notificaciones y backoffice sin bloquear el flujo transaccional principal.

## 2. Alternativas a evaluar

- REST síncrono entre todos los servicios
- Event Driven Architecture con Kafka/Pub/Sub
- Batch processing nocturno

## 3. Criterios de evaluación

| Criterio | Peso | Descripción |
|---|---:|---|
| Seguridad | 25% | Reduce riesgo operativo y exposición de datos |
| Escalabilidad | 20% | Soporta alto volumen transaccional |
| Resiliencia | 20% | Tolera fallas parciales |
| Observabilidad | 15% | Facilita monitoreo y troubleshooting |
| Time to Market | 10% | Permite implementación incremental |
| Costo | 10% | Impacto de operación y mantenimiento |

## 4. Análisis cualitativo

EDA permite desacoplar procesos posteriores, escalar consumidores independientemente y mejorar resiliencia.

## 5. Tabla ponderada

| Alternativa | Puntaje |
|---|---:|
| REST síncrono | 3.4 |
| Event Driven Architecture | 4.7 |
| Batch processing | 2.8 |

## 6. Decisión final

Se adopta arquitectura orientada a eventos para eventos de dominio de pagos.

## 7. Costos

Costo de infraestructura de mensajería, observabilidad y gobierno de esquemas.
