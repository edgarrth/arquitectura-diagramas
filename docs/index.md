# Payment Processing Architecture

Este portal documenta una arquitectura de referencia para una plataforma de procesamiento de pagos.

## Objetivo

Definir una arquitectura base para procesar pagos con tarjeta, cubriendo:

- Autorización
- Captura
- Reversos y refunds
- Evaluación antifraude
- Tokenización
- Settlement
- Observabilidad
- Alcance PCI DSS
- Integración con adquirente, red de tarjetas y banco emisor

## Fuente de verdad

El modelo C4 principal vive en:

```text
architecture/workspace.dsl
```

Los diagramas se generan automáticamente con GitHub Actions.

## Vistas principales

| Vista | Propósito |
|---|---|
| C4 Context | Explica el ecosistema externo |
| C4 Container | Explica servicios, bases de datos y mensajería |
| C4 Component | Explica internals del Payment Service |
| Dynamic View | Explica el flujo de autorización |
| Deployment View | Explica despliegue productivo |
| UML Sequence | Detalla interacción transaccional |
| PCI Data Flow | Explica alcance PCI |
| ADRs | Documenta decisiones relevantes |
