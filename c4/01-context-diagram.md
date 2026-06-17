# C4 - Context Diagram

@startuml

!include C4_Context.puml

Person(customer, "Customer")

System(merchant, "Merchant")

System(payment, "Payment Platform")

System(acquirer, "Acquirer")

Rel(customer, merchant, "Makes payment")

Rel(merchant, payment, "Processes payment")

Rel(payment, acquirer, "Authorizes transaction")

@enduml
