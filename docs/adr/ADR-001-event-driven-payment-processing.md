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
| Seguridad | 25% | Capacidad de reducir riesgo operativo y exposición de datos |
| Escalabilidad | 20% | Capacidad de soportar alto volumen transaccional |
| Resiliencia | 20% | Capacidad de tolerar fallas parciales |
| Observabilidad | 15% | Facilidad para monitorear y diagnosticar |
| Time to Market | 10% | Velocidad de implementación |
| Costo | 10% | Costo de operación y mantenimiento |

## 4. Análisis cualitativo

La arquitectura orientada a eventos permite desacoplar procesos posteriores a la autorización, mejorar resiliencia y escalar consumidores de forma independiente.

## 5. Tabla ponderada

| Alternativa | Puntaje |
|---|---:|
| REST síncrono | 3.4 |
| Event Driven Architecture | 4.7 |
| Batch processing | 2.8 |

## 6. Decisión final

Se adopta Event Driven Architecture para eventos de dominio de pagos.

## 7. Costos

Incremento en infraestructura de mensajería, observabilidad, gobierno de esquemas y operación.
