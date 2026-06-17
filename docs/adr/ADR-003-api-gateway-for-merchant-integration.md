# ADR-003: API Gateway for Merchant Integration

Fecha: 2026-06-16

## 1. Contexto

Merchants externos requieren integración segura, versionada, observable y gobernada.

## 2. Alternativas a evaluar

- Exponer servicios directamente
- Usar API Gateway administrado
- Usar ingress Kubernetes como gateway principal

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

El API Gateway centraliza autenticación, rate limiting, cuotas, transformación, versionado y analítica de consumo.

## 5. Tabla ponderada

| Alternativa | Puntaje |
|---|---:|
| Exposición directa | 2.0 |
| API Gateway administrado | 4.8 |
| Ingress Kubernetes | 3.3 |

## 6. Decisión final

Se adopta API Gateway como punto único de entrada para merchants.

## 7. Costos

Costo de licenciamiento/consumo del gateway, operación y definición de políticas.
