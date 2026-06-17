# ADR-002: Tokenization and PCI Scope Reduction

Fecha: 2026-06-16

## 1. Contexto

El sistema procesa pagos con tarjeta y debe minimizar exposición de PAN, CVV y datos sensibles.

## 2. Alternativas a evaluar

- Guardar datos de tarjeta en Payment Service
- Tokenización interna con vault seguro
- Delegar tokenización completamente al adquirente

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

La tokenización separa datos sensibles del dominio de pagos y reduce el alcance PCI de servicios de negocio.

## 5. Tabla ponderada

| Alternativa | Puntaje |
|---|---:|
| Guardar tarjeta en Payment Service | 1.8 |
| Tokenización interna | 4.6 |
| Tokenización del adquirente | 4.1 |

## 6. Decisión final

Se adopta Tokenization Service con Token Vault/HSM.

## 7. Costos

Costo de vault, cifrado, gestión de llaves, auditoría y hardening.
