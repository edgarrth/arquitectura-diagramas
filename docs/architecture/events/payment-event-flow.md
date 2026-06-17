# Payment Event Flow

```mermaid
flowchart LR
    PaymentCreated["PaymentCreated"]
    PaymentTokenized["PaymentTokenized"]
    FraudChecked["FraudChecked"]
    PaymentAuthorized["PaymentAuthorized"]
    PaymentCaptured["PaymentCaptured"]
    SettlementRequested["SettlementRequested"]
    PaymentSettled["PaymentSettled"]
    PaymentFailed["PaymentFailed"]
    PaymentRefunded["PaymentRefunded"]

    PaymentCreated --> PaymentTokenized
    PaymentTokenized --> FraudChecked
    FraudChecked --> PaymentAuthorized
    FraudChecked --> PaymentFailed
    PaymentAuthorized --> PaymentCaptured
    PaymentCaptured --> SettlementRequested
    SettlementRequested --> PaymentSettled
    PaymentCaptured --> PaymentRefunded
```

## Eventos principales

| Evento | Productor | Consumidores |
|---|---|---|
| PaymentCreated | Payment Journey Service | Fraud Service, Payment Service |
| FraudChecked | Fraud Service | Payment Journey Service |
| PaymentAuthorized | Payment Service | Settlement Service, Notification Service |
| PaymentCaptured | Payment Service | Settlement Service |
| PaymentSettled | Settlement Service | Backoffice, Notification Service |
| PaymentRefunded | Payment Service | Notification Service, Backoffice |
