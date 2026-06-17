workspace "Payment Processing Platform" "C4 model for a payment processing platform" {

    !identifiers hierarchical

    model {
        customer = person "Customer" "Cardholder who pays with debit or credit card."
        merchantOperator = person "Merchant Operator" "Merchant user who monitors payments, refunds and settlements."

        merchant = softwareSystem "Merchant Platform" "E-commerce, mobile app, checkout or POS system."
        acquirer = softwareSystem "Acquiring Processor" "Acquirer or processor connected to card networks."
        cardNetwork = softwareSystem "Card Network" "Visa, Mastercard or another payment network."
        issuer = softwareSystem "Issuing Bank" "Bank that issued the customer card."
        fraudProvider = softwareSystem "External Fraud Provider" "External risk scoring provider."
        notificationProvider = softwareSystem "Notification Provider" "Email, SMS or push provider."

        paymentPlatform = softwareSystem "Payment Processing Platform" "Processes authorization, capture, fraud evaluation, settlement and notifications." {
            apiGateway = container "API Gateway" "Exposes secure payment APIs, rate limits, authentication, quotas and observability." "Apigee / API Gateway"
            paymentJourney = container "Payment Journey Service" "Orchestrates merchant-facing payment journeys." "Java / Spring Boot"

            paymentService = container "Payment Service" "Owns payment lifecycle and transaction state." "Java / Spring Boot" {
                paymentController = component "Payment Controller" "Exposes internal payment lifecycle endpoints." "Spring REST Controller"
                paymentApplication = component "Payment Application Service" "Coordinates payment commands and transaction boundaries." "Application Service"
                authorizationProcessor = component "Authorization Processor" "Builds authorization requests and interprets acquirer responses." "Domain Service"
                captureProcessor = component "Capture Processor" "Executes payment capture." "Domain Service"
                refundProcessor = component "Refund Processor" "Executes refunds and reversals." "Domain Service"
                paymentRepository = component "Payment Repository" "Persists and queries payment aggregates." "Repository"
                outboxPublisher = component "Outbox Publisher" "Publishes reliable domain events from the transactional outbox." "Worker"
                acquirerClient = component "Acquirer Client" "Connects to acquiring processor." "HTTP / ISO8583 Client"
            }

            fraudService = container "Fraud Service" "Evaluates risk and fraud rules." "Java / Python"
            tokenizationService = container "Tokenization Service" "Tokenizes card data and isolates PCI-sensitive operations." "Java / Spring Boot"
            settlementService = container "Settlement Service" "Processes clearing, settlement and reconciliation." "Java / Spring Boot"
            notificationService = container "Notification Service" "Sends payment notifications." "Java / Spring Boot"
            backoffice = container "Merchant Backoffice" "Allows merchants to search payments, refunds and settlements." "React"
            eventBus = container "Event Bus" "Publishes payment domain events." "Kafka / Pub/Sub" "Queue"
            paymentDb = container "Payment Database" "Stores payments, transactions and settlements." "PostgreSQL / AlloyDB" "Database"
            tokenVault = container "Token Vault" "Stores tokens and encrypted references." "HSM-backed vault" "Database"
            observability = container "Observability Platform" "Collects logs, metrics and traces." "OpenTelemetry / Grafana / Dynatrace"
        }

        customer -> merchant "Initiates payment" "HTTPS / POS"
        merchantOperator -> paymentPlatform "Monitors payments and settlements" "HTTPS"
        merchant -> paymentPlatform.apiGateway "Consumes payment APIs" "HTTPS / REST"

        paymentPlatform.apiGateway -> paymentPlatform.paymentJourney "Routes payment requests" "REST"
        paymentPlatform.paymentJourney -> paymentPlatform.paymentService "Creates and authorizes payments" "REST"
        paymentPlatform.paymentJourney -> paymentPlatform.fraudService "Requests fraud evaluation" "REST"
        paymentPlatform.paymentJourney -> paymentPlatform.tokenizationService "Tokenizes card data" "REST"

        paymentPlatform.paymentService -> paymentPlatform.paymentDb "Reads/writes payment state" "SQL"
        paymentPlatform.paymentService -> paymentPlatform.eventBus "Publishes payment events" "Async"
        paymentPlatform.paymentService -> acquirer "Sends authorization, capture and refund requests" "REST / ISO 8583"

        acquirer -> cardNetwork "Routes transaction"
        cardNetwork -> issuer "Requests authorization"

        paymentPlatform.fraudService -> fraudProvider "Requests external score" "HTTPS"
        paymentPlatform.tokenizationService -> paymentPlatform.tokenVault "Stores tokenized data" "Encrypted protocol"

        paymentPlatform.settlementService -> paymentPlatform.eventBus "Consumes payment events" "Async"
        paymentPlatform.settlementService -> paymentPlatform.paymentDb "Reads settlement data" "SQL"

        paymentPlatform.notificationService -> paymentPlatform.eventBus "Consumes payment events" "Async"
        paymentPlatform.notificationService -> notificationProvider "Sends notifications" "HTTPS"

        paymentPlatform.backoffice -> paymentPlatform.apiGateway "Consumes internal APIs" "HTTPS"
        merchantOperator -> paymentPlatform.backoffice "Uses" "HTTPS"

        paymentPlatform.apiGateway -> paymentPlatform.observability "Sends telemetry"
        paymentPlatform.paymentService -> paymentPlatform.observability "Sends telemetry"
        paymentPlatform.fraudService -> paymentPlatform.observability "Sends telemetry"

        paymentPlatform.paymentJourney -> paymentPlatform.paymentService.paymentController "Calls" "REST"
        paymentPlatform.paymentService.paymentController -> paymentPlatform.paymentService.paymentApplication "Delegates commands"
        paymentPlatform.paymentService.paymentApplication -> paymentPlatform.paymentService.authorizationProcessor "Authorizes payments"
        paymentPlatform.paymentService.paymentApplication -> paymentPlatform.paymentService.captureProcessor "Captures payments"
        paymentPlatform.paymentService.paymentApplication -> paymentPlatform.paymentService.refundProcessor "Refunds payments"
        paymentPlatform.paymentService.paymentApplication -> paymentPlatform.paymentService.paymentRepository "Persists payment state"
        paymentPlatform.paymentService.paymentApplication -> paymentPlatform.paymentService.outboxPublisher "Stores outbox events"
        paymentPlatform.paymentService.authorizationProcessor -> paymentPlatform.paymentService.acquirerClient "Sends authorization"
        paymentPlatform.paymentService.acquirerClient -> acquirer "Sends transaction requests" "REST / ISO8583"
        paymentPlatform.paymentService.paymentRepository -> paymentPlatform.paymentDb "Reads/writes" "SQL"
        paymentPlatform.paymentService.outboxPublisher -> paymentPlatform.eventBus "Publishes payment events" "Async"

        production = deploymentEnvironment "Production" {
            deploymentNode "Google Cloud Platform" "GCP" {
                deploymentNode "Edge Layer" "Cloud Armor + Global Load Balancer + Apigee" {
                    containerInstance paymentPlatform.apiGateway
                }

                deploymentNode "GKE Cluster" "Google Kubernetes Engine" {
                    deploymentNode "payment namespace" "Kubernetes Namespace" {
                        containerInstance paymentPlatform.paymentJourney
                        containerInstance paymentPlatform.paymentService
                        containerInstance paymentPlatform.fraudService
                        containerInstance paymentPlatform.tokenizationService
                        containerInstance paymentPlatform.settlementService
                        containerInstance paymentPlatform.notificationService
                    }
                }

                deploymentNode "Data Services" "Managed Services" {
                    containerInstance paymentPlatform.paymentDb
                    containerInstance paymentPlatform.tokenVault
                    containerInstance paymentPlatform.eventBus
                }

                deploymentNode "Observability" "Telemetry Stack" {
                    containerInstance paymentPlatform.observability
                }
            }
        }
    }

    views {
        systemContext paymentPlatform "01-system-context" {
            include *
            autoLayout lr
            description "Shows Payment Processing Platform in the payment ecosystem."
        }

        container paymentPlatform "02-container-view" {
            include *
            autoLayout lr
            description "Shows the main services, databases and infrastructure inside the platform."
        }

        component paymentPlatform.paymentService "03-component-payment-service" {
            include *
            autoLayout lr
            description "Shows the internal components of the Payment Service."
        }

        dynamic paymentPlatform "04-dynamic-payment-authorization" {
            customer -> merchant "Pays with card"
            merchant -> paymentPlatform.apiGateway "POST /payments/v1/authorizations"
            paymentPlatform.apiGateway -> paymentPlatform.paymentJourney "Route and authenticate request"
            paymentPlatform.paymentJourney -> paymentPlatform.tokenizationService "Tokenize card data"
            paymentPlatform.paymentJourney -> paymentPlatform.fraudService "Evaluate fraud risk"
            paymentPlatform.paymentJourney -> paymentPlatform.paymentService "Authorize payment"
            paymentPlatform.paymentService -> acquirer "Send authorization request"
            acquirer -> cardNetwork "Route transaction"
            cardNetwork -> issuer "Request issuer approval"
            issuer -> cardNetwork "Approve or decline"
            cardNetwork -> acquirer "Return network response"
            acquirer -> paymentPlatform.paymentService "Return authorization result"
            paymentPlatform.paymentService -> paymentPlatform.eventBus "Publish PaymentAuthorized or PaymentDeclined"
            paymentPlatform.paymentService -> paymentPlatform.paymentJourney "Return authorization result"
            paymentPlatform.paymentJourney -> paymentPlatform.apiGateway "Return payment result"
            paymentPlatform.apiGateway -> merchant "201 Created / 402 Declined"
            autoLayout lr
            description "Shows the authorization flow as a C4 dynamic view."
        }

        deployment paymentPlatform "Production" "05-deployment-view" {
            include *
            autoLayout lr
            description "Shows the production deployment on GCP."
        }

        styles {
            element "Person" {
                shape Person
                background #08427b
                color #ffffff
            }

            element "Software System" {
                background #1168bd
                color #ffffff
            }

            element "Container" {
                background #438dd5
                color #ffffff
            }

            element "Component" {
                background #85bbf0
                color #000000
            }

            element "Database" {
                shape Cylinder
                background #f5da81
                color #000000
            }

            element "Queue" {
                shape Pipe
                background #f5da81
                color #000000
            }
        }

        theme default
    }
}
