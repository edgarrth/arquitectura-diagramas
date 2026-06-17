workspace "Payment Processing Platform" "C4 architecture model for a fintech payment processing platform" {

    !identifiers hierarchical

    model {
        customer = person "Customer" "Cardholder who makes a payment using a debit or credit card."
        merchantUser = person "Merchant Operator" "Merchant backoffice user who monitors payments, refunds and settlements."

        merchant = softwareSystem "Merchant Platform" "E-commerce, mobile app or POS system used by the merchant."
        paymentPlatform = softwareSystem "Payment Processing Platform" "Platform responsible for payment authorization, fraud evaluation, capture, settlement and notifications."
        acquirer = softwareSystem "Acquiring Processor" "Acquirer or payment processor connected to card networks."
        cardNetwork = softwareSystem "Card Network" "Visa, Mastercard or another payment network."
        issuer = softwareSystem "Issuing Bank" "Bank that issued the customer's card."
        fraudProvider = softwareSystem "External Fraud Provider" "Optional external risk scoring provider."
        notificationProvider = softwareSystem "Notification Provider" "Email, SMS or push provider."

        customer -> merchant "Initiates payment"
        merchantUser -> paymentPlatform "Monitors payments and settlements"
        merchant -> paymentPlatform "Creates and confirms payments" "HTTPS/REST"
        paymentPlatform -> acquirer "Sends authorization, capture and refund requests" "ISO 8583 / REST / gRPC"
        acquirer -> cardNetwork "Routes transaction"
        cardNetwork -> issuer "Requests authorization"
        paymentPlatform -> fraudProvider "Requests external risk score" "HTTPS"
        paymentPlatform -> notificationProvider "Sends payment notifications" "HTTPS"

        apiGateway = container paymentPlatform "API Gateway" "Apigee / API Gateway" "Exposes secure payment APIs to merchants. Handles authentication, rate limits, routing and observability."
        paymentJourney = container paymentPlatform "Payment Journey Service" "Java / Spring Boot" "Orchestrates merchant-facing payment journeys and shields clients from internal service complexity."
        paymentService = container paymentPlatform "Payment Service" "Java / Spring Boot" "Owns payment lifecycle: created, authorized, captured, refunded, voided and settled."
        fraudService = container paymentPlatform "Fraud Service" "Java / Python" "Evaluates fraud rules and risk scores before authorization."
        tokenizationService = container paymentPlatform "Tokenization Service" "Java / Spring Boot" "Tokenizes card data and isolates PCI-sensitive operations."
        settlementService = container paymentPlatform "Settlement Service" "Java / Spring Boot" "Processes clearing, settlement files and merchant reconciliation."
        notificationService = container paymentPlatform "Notification Service" "Java / Spring Boot" "Sends merchant and customer notifications."
        backoffice = container paymentPlatform "Merchant Backoffice" "React / Web" "Allows merchants to search payments, refunds and settlements."
        eventBus = container paymentPlatform "Event Bus" "Kafka / Pub/Sub" "Publishes payment domain events."
        paymentDb = containerDb paymentPlatform "Payment Database" "PostgreSQL / AlloyDB" "Stores payment, transaction and settlement records."
        tokenVault = containerDb paymentPlatform "Token Vault" "HSM-backed secure vault" "Stores card tokens and encrypted references."
        observability = container paymentPlatform "Observability Platform" "OpenTelemetry / Grafana / Dynatrace" "Collects metrics, traces and logs."

        merchant -> apiGateway "Calls payment APIs" "HTTPS/REST"
        merchantUser -> backoffice "Uses" "HTTPS"
        backoffice -> apiGateway "Consumes internal APIs" "HTTPS"
        apiGateway -> paymentJourney "Routes payment requests" "REST"
        paymentJourney -> paymentService "Creates and authorizes payments" "REST"
        paymentJourney -> fraudService "Requests fraud evaluation" "REST"
        paymentJourney -> tokenizationService "Tokenizes card data" "REST"
        paymentService -> paymentDb "Reads and writes payment state" "SQL"
        paymentService -> eventBus "Publishes payment events" "Async"
        paymentService -> acquirer "Sends authorization/capture/refund" "REST/ISO 8583"
        fraudService -> fraudProvider "Requests risk score" "HTTPS"
        tokenizationService -> tokenVault "Stores tokens" "Encrypted protocol"
        settlementService -> eventBus "Consumes payment events" "Async"
        settlementService -> paymentDb "Reads settlement data" "SQL"
        notificationService -> eventBus "Consumes payment events" "Async"
        notificationService -> notificationProvider "Sends notifications" "HTTPS"
        apiGateway -> observability "Sends API telemetry"
        paymentJourney -> observability "Sends traces and metrics"
        paymentService -> observability "Sends traces and metrics"
        fraudService -> observability "Sends traces and metrics"

        paymentController = component paymentService "Payment Controller" "Spring REST Controller" "Exposes internal payment lifecycle endpoints."
        paymentApplication = component paymentService "Payment Application Service" "Application Service" "Coordinates payment commands and transaction boundaries."
        authorizationProcessor = component paymentService "Authorization Processor" "Domain Service" "Builds authorization requests and interprets acquirer responses."
        captureProcessor = component paymentService "Capture Processor" "Domain Service" "Executes payment capture."
        refundProcessor = component paymentService "Refund Processor" "Domain Service" "Executes refunds and reversals."
        paymentRepository = component paymentService "Payment Repository" "Repository" "Persists and queries payment aggregates."
        outboxPublisher = component paymentService "Outbox Publisher" "Worker" "Publishes reliable domain events from the transactional outbox."
        acquirerClient = component paymentService "Acquirer Client" "HTTP / ISO8583 Client" "Connects to acquiring processor."

        paymentJourney -> paymentController "Uses" "REST"
        paymentController -> paymentApplication "Delegates commands"
        paymentApplication -> authorizationProcessor "Authorizes payments"
        paymentApplication -> captureProcessor "Captures payments"
        paymentApplication -> refundProcessor "Refunds payments"
        paymentApplication -> paymentRepository "Persists state"
        paymentApplication -> outboxPublisher "Stores events"
        authorizationProcessor -> acquirerClient "Sends authorization"
        acquirerClient -> acquirer "Sends transaction requests"
        paymentRepository -> paymentDb "SQL"
        outboxPublisher -> eventBus "Publishes events"

        gcp = deploymentEnvironment "Production" {
            deploymentNode "Google Cloud Platform" "GCP" {
                deploymentNode "Edge" "Cloud Armor + Global Load Balancer + Apigee" {
                    apiGatewayInstance = containerInstance apiGateway
                }

                deploymentNode "GKE Cluster" "Google Kubernetes Engine" {
                    deploymentNode "payment-namespace" "Kubernetes Namespace" {
                        journeyInstance = containerInstance paymentJourney
                        paymentInstance = containerInstance paymentService
                        fraudInstance = containerInstance fraudService
                        tokenizationInstance = containerInstance tokenizationService
                        settlementInstance = containerInstance settlementService
                        notificationInstance = containerInstance notificationService
                    }
                }

                deploymentNode "Data Services" "Managed Services" {
                    paymentDbInstance = containerInstance paymentDb
                    tokenVaultInstance = containerInstance tokenVault
                    eventBusInstance = containerInstance eventBus
                }

                deploymentNode "Observability" "Telemetry Stack" {
                    observabilityInstance = containerInstance observability
                }
            }
        }
    }

    views {
        systemContext paymentPlatform "01-system-context" {
            include *
            autoLayout lr
            description "Shows Payment Processing Platform in the ecosystem of merchants, acquirers, card networks and issuing banks."
        }

        container paymentPlatform "02-container-view" {
            include *
            autoLayout lr
            description "Shows the main applications, services, databases and asynchronous infrastructure inside the Payment Processing Platform."
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
            acquirer -> cardNetwork "Route to network"
            cardNetwork -> issuer "Request issuer approval"
            issuer -> cardNetwork "Approve or decline"
            cardNetwork -> acquirer "Return response"
            acquirer -> paymentService "Return authorization result"
            paymentService -> eventBus "Publish PaymentAuthorized or PaymentDeclined"
            paymentJourney -> merchant "Return authorization result"
            autoLayout lr
            description "Dynamic view for the payment authorization flow."
        }

        deployment paymentPlatform "Production" "05-deployment-view" {
            include *
            autoLayout lr
            description "Shows the production deployment of the platform on GCP."
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
