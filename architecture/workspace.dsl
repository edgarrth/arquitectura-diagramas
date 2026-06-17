workspace "Payment Processing Platform" "C4 model for a payment processing platform" {

    !identifiers hierarchical

    model {
        customer = person "Customer" "Cardholder who pays with debit or credit card."
        merchantOperator = person "Merchant Operator" "Merchant user who monitors payments, refunds and settlements."

        merchant = softwareSystem "Merchant Platform" "E-commerce, mobile app, checkout or POS system."
        paymentPlatform = softwareSystem "Payment Processing Platform" "Processes authorization, capture, fraud evaluation, settlement and notifications."
        acquirer = softwareSystem "Acquiring Processor" "Acquirer or processor connected to card networks."
        cardNetwork = softwareSystem "Card Network" "Visa, Mastercard or another payment network."
        issuer = softwareSystem "Issuing Bank" "Bank that issued the customer card."
        fraudProvider = softwareSystem "External Fraud Provider" "External risk scoring provider."
        notificationProvider = softwareSystem "Notification Provider" "Email, SMS or push provider."

        customer -> merchant "Initiates payment" "HTTPS / POS"
        merchantOperator -> paymentPlatform "Monitors payments and settlements" "HTTPS"
        merchant -> paymentPlatform "Creates and confirms payments" "HTTPS / REST"
        paymentPlatform -> acquirer "Sends authorization, capture and refund requests" "REST / ISO 8583"
        acquirer -> cardNetwork "Routes transaction"
        cardNetwork -> issuer "Requests authorization"
        paymentPlatform -> fraudProvider "Requests risk score" "HTTPS"
        paymentPlatform -> notificationProvider "Sends notifications" "HTTPS"

        apiGateway = container paymentPlatform "API Gateway" "Apigee / API Gateway" "Exposes secure payment APIs, rate limits, authentication, quotas and observability."
        paymentJourney = container paymentPlatform "Payment Journey Service" "Java / Spring Boot" "Orchestrates merchant-facing payment journeys."
        paymentService = container paymentPlatform "Payment Service" "Java / Spring Boot" "Owns payment lifecycle and transaction state."
        fraudService = container paymentPlatform "Fraud Service" "Java / Python" "Evaluates risk and fraud rules."
        tokenizationService = container paymentPlatform "Tokenization Service" "Java / Spring Boot" "Tokenizes card data and isolates PCI-sensitive operations."
        settlementService = container paymentPlatform "Settlement Service" "Java / Spring Boot" "Processes clearing, settlement and reconciliation."
        notificationService = container paymentPlatform "Notification Service" "Java / Spring Boot" "Sends payment notifications."
        backoffice = container paymentPlatform "Merchant Backoffice" "React" "Allows merchants to search payments, refunds and settlements."
        eventBus = container paymentPlatform "Event Bus" "Kafka / Pub/Sub" "Publishes payment domain events." "Queue"
        paymentDb = container paymentPlatform "Payment Database" "PostgreSQL / AlloyDB" "Stores payments, transactions and settlements." "Database"
        tokenVault = container paymentPlatform "Token Vault" "HSM-backed vault" "Stores tokens and encrypted references." "Database"
        observability = container paymentPlatform "Observability Platform" "OpenTelemetry / Grafana / Dynatrace" "Collects logs, metrics and traces."

        merchant -> apiGateway "Consumes payment APIs" "HTTPS / REST"
        merchantOperator -> backoffice "Uses" "HTTPS"
        backoffice -> apiGateway "Consumes internal APIs" "HTTPS"
        apiGateway -> paymentJourney "Routes payment requests" "REST"
        paymentJourney -> paymentService "Creates and authorizes payments" "REST"
        paymentJourney -> fraudService "Requests fraud evaluation" "REST"
        paymentJourney -> tokenizationService "Tokenizes card data" "REST"
        paymentService -> paymentDb "Reads/writes payment state" "SQL"
        paymentService -> eventBus "Publishes payment events" "Async"
        paymentService -> acquirer "Sends payment instructions" "REST / ISO 8583"
        fraudService -> fraudProvider "Requests external score" "HTTPS"
        tokenizationService -> tokenVault "Stores tokenized data" "Encrypted protocol"
        settlementService -> eventBus "Consumes payment events" "Async"
        settlementService -> paymentDb "Reads settlement data" "SQL"
        notificationService -> eventBus "Consumes payment events" "Async"
        notificationService -> notificationProvider "Sends notifications" "HTTPS"
        apiGateway -> observability "Sends telemetry"
        paymentService -> observability "Sends telemetry"
        fraudService -> observability "Sends telemetry"

        paymentController = component paymentService "Payment Controller" "Spring REST Controller" "Exposes internal payment lifecycle endpoints."
        paymentApplication = component paymentService "Payment Application Service" "Application Service" "Coordinates payment commands and transaction boundaries."
        authorizationProcessor = component paymentService "Authorization Processor" "Domain Service" "Builds authorization requests and interprets acquirer responses."
        captureProcessor = component paymentService "Capture Processor" "Domain Service" "Executes payment capture."
        refundProcessor = component paymentService "Refund Processor" "Domain Service" "Executes refunds and reversals."
        paymentRepository = component paymentService "Payment Repository" "Repository" "Persists and queries payment aggregates."
        outboxPublisher = component paymentService "Outbox Publisher" "Worker" "Publishes reliable domain events from the transactional outbox."
        acquirerClient = component paymentService "Acquirer Client" "HTTP / ISO8583 Client" "Connects to acquiring processor."

        paymentJourney -> paymentController "Calls" "REST"
        paymentController -> paymentApplication "Delegates commands"
        paymentApplication -> authorizationProcessor "Authorizes payments"
        paymentApplication -> captureProcessor "Captures payments"
        paymentApplication -> refundProcessor "Refunds payments"
        paymentApplication -> paymentRepository "Persists payment state"
        paymentApplication -> outboxPublisher "Stores outbox events"
        authorizationProcessor -> acquirerClient "Sends authorization"
        acquirerClient -> acquirer "Sends transaction requests" "REST / ISO8583"
        paymentRepository -> paymentDb "Reads/writes" "SQL"
        outboxPublisher -> eventBus "Publishes payment events" "Async"

        production = deploymentEnvironment "Production" {
            gcp = deploymentNode "Google Cloud Platform" "GCP" {
                edge = deploymentNode "Edge Layer" "Cloud Armor + Global Load Balancer + Apigee" {
                    apiGatewayInstance = containerInstance apiGateway
                }

                gke = deploymentNode "GKE Cluster" "Google Kubernetes Engine" {
                    paymentNamespace = deploymentNode "payment namespace" "Kubernetes Namespace" {
                        paymentJourneyInstance = containerInstance paymentJourney
                        paymentServiceInstance = containerInstance paymentService
                        fraudServiceInstance = containerInstance fraudService
                        tokenizationServiceInstance = containerInstance tokenizationService
                        settlementServiceInstance = containerInstance settlementService
                        notificationServiceInstance = containerInstance notificationService
                    }
                }

                dataServices = deploymentNode "Data Services" "Managed Services" {
                    paymentDbInstance = containerInstance paymentDb
                    tokenVaultInstance = containerInstance tokenVault
                    eventBusInstance = containerInstance eventBus
                }

                telemetry = deploymentNode "Observability" "Telemetry Stack" {
                    observabilityInstance = containerInstance observability
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

        component paymentService "03-component-payment-service" {
            include *
            autoLayout lr
            description "Shows the internal components of the Payment Service."
        }

        dynamic paymentPlatform "04-dynamic-payment-authorization" {
            customer -> merchant "Pays with card"
            merchant -> apiGateway "POST /payments/v1/authorizations"
            apiGateway -> paymentJourney "Route and authenticate request"
            paymentJourney -> tokenizationService "Tokenize card data"
            paymentJourney -> fraudService "Evaluate fraud risk"
            paymentJourney -> paymentService "Authorize payment"
            paymentService -> acquirer "Send authorization request"
            acquirer -> cardNetwork "Route transaction"
            cardNetwork -> issuer "Request issuer approval"
            issuer -> cardNetwork "Approve or decline"
            cardNetwork -> acquirer "Return network response"
            acquirer -> paymentService "Return authorization result"
            paymentService -> eventBus "Publish PaymentAuthorized or PaymentDeclined"
            paymentService -> paymentJourney "Return authorization result"
            paymentJourney -> apiGateway "Return payment result"
            apiGateway -> merchant "201 Created / 402 Declined"
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
