workspace "Payment Processing Architecture" "C4 model for a payment processing platform using Structurizr DSL." {

    !identifiers hierarchical

    model {
        customer = person "Customer" "Cardholder who initiates a payment from a merchant channel."
        merchantUser = person "Merchant Operations User" "User who reviews transactions, refunds, disputes and settlements."

        merchant = softwareSystem "Merchant Channels" "E-commerce site, mobile app or POS that initiates card payments."
        paymentPlatform = softwareSystem "Payment Processing Platform" "Platform that processes authorization, capture, refunds, fraud checks, events and merchant notifications." {

            apiGateway = container "API Gateway" "Exposes REST APIs to merchants, validates JWT/mTLS, rate limits and routes traffic." "Apigee / API Gateway"

            paymentJourney = container "Payment Journey Service" "Orchestrates the merchant payment experience and coordinates synchronous payment flows." "Java / Spring Boot"

            paymentService = container "Payment Service" "Owns payment lifecycle, authorization state machine, idempotency and payment records." "Java / Spring Boot" {
                paymentController = component "Payment Controller" "Receives payment commands from the journey layer." "Spring REST Controller"
                idempotencyComponent = component "Idempotency Component" "Prevents duplicated payment execution using idempotency keys." "Spring Component"
                paymentApplicationService = component "Payment Application Service" "Coordinates authorization, capture, refunds and status transitions." "Application Service"
                authorizationAdapter = component "Authorization Adapter" "Maps internal authorization requests to acquirer messages." "Adapter"
                paymentRepository = component "Payment Repository" "Persists payment and transaction state." "Repository"
                paymentEventPublisher = component "Payment Event Publisher" "Publishes payment domain events through the outbox pattern." "Kafka Producer"
            }

            fraudService = container "Fraud Service" "Evaluates transaction risk before authorization." "Java / Spring Boot"
            tokenizationService = container "Tokenization Service" "Tokenizes PAN and keeps cardholder data outside the payment services." "Java / Spring Boot"
            merchantBackoffice = container "Merchant Backoffice" "Allows merchant operations users to search payments, refunds and settlements." "React SPA"
            notificationService = container "Notification Service" "Sends webhooks and operational notifications to merchants." "Java / Spring Boot"

            paymentDb = container "Payment Database" "Stores payment lifecycle, merchant configuration, idempotency keys and transaction references." "PostgreSQL" "Database"
            cardVault = container "Card Vault" "Stores sensitive cardholder data and returns payment tokens." "PCI Vault" "Database"
            eventBroker = container "Event Broker" "Publishes payment, fraud, refund, settlement and notification events." "Kafka / Pub/Sub" "Message Broker"
        }

        acquirer = softwareSystem "Acquirer / Processor" "Acquiring processor that receives authorization and capture requests."
        cardNetwork = softwareSystem "Card Network" "Routes authorization messages to the issuer, e.g. Visa or Mastercard."
        issuer = softwareSystem "Issuer Bank" "Approves or declines the cardholder authorization request."
        riskProvider = softwareSystem "External Risk Provider" "External device, reputation or fraud scoring service."
        merchantWebhook = softwareSystem "Merchant Webhook Endpoint" "Merchant endpoint that receives asynchronous payment notifications."

        customer -> merchant "Initiates checkout and enters payment details"
        merchant -> paymentPlatform.apiGateway "Creates payments, confirms payments and queries status" "HTTPS/REST"
        merchantUser -> paymentPlatform.merchantBackoffice "Manages payments, refunds and disputes" "HTTPS"

        paymentPlatform.apiGateway -> paymentPlatform.paymentJourney "Routes payment API calls" "REST"
        paymentPlatform.apiGateway -> paymentPlatform.merchantBackoffice "Serves authenticated merchant operations APIs" "HTTPS"
        paymentPlatform.paymentJourney -> paymentPlatform.paymentService "Authorizes, captures and refunds payments" "REST"
        paymentPlatform.paymentJourney -> paymentPlatform.fraudService "Requests fraud decision" "REST"
        paymentPlatform.paymentJourney -> paymentPlatform.tokenizationService "Tokenizes card data" "REST"
        paymentPlatform.paymentService -> paymentPlatform.paymentDb "Reads/writes payment state" "SQL"
        paymentPlatform.paymentService -> paymentPlatform.eventBroker "Publishes payment events" "Outbox/Kafka"
        paymentPlatform.fraudService -> riskProvider "Requests risk score" "HTTPS"
        paymentPlatform.tokenizationService -> paymentPlatform.cardVault "Stores and retrieves payment tokens" "Vault API"
        paymentPlatform.paymentService -> acquirer "Sends authorization/capture/refund requests" "ISO 8583/API"
        acquirer -> cardNetwork "Routes card transaction" "Card network rails"
        cardNetwork -> issuer "Requests authorization decision" "Card network rails"
        paymentPlatform.notificationService -> merchantWebhook "Sends payment webhook" "HTTPS"
        paymentPlatform.eventBroker -> paymentPlatform.notificationService "Consumes payment events" "Kafka consumer"

        paymentPlatform.paymentService.paymentController -> paymentPlatform.paymentService.idempotencyComponent "Checks idempotency key"
        paymentPlatform.paymentService.paymentController -> paymentPlatform.paymentService.paymentApplicationService "Executes payment command"
        paymentPlatform.paymentService.paymentApplicationService -> paymentPlatform.paymentService.authorizationAdapter "Requests authorization"
        paymentPlatform.paymentService.paymentApplicationService -> paymentPlatform.paymentService.paymentRepository "Persists state transitions"
        paymentPlatform.paymentService.paymentApplicationService -> paymentPlatform.paymentService.paymentEventPublisher "Publishes domain events"
        paymentPlatform.paymentService.paymentRepository -> paymentPlatform.paymentDb "Uses"
        paymentPlatform.paymentService.paymentEventPublisher -> paymentPlatform.eventBroker "Publishes"

        deploymentEnvironment "Production" {
            deploymentNode "GCP" "Google Cloud Platform" "Cloud" {
                deploymentNode "Edge" "Global external entry point" "Cloud Load Balancer + Cloud Armor" {
                    infrastructureNode "Cloud Armor" "WAF and DDoS protection" "GCP Cloud Armor"
                    infrastructureNode "Load Balancer" "TLS termination and global routing" "GCP Load Balancer"
                    apiGatewayInstance = containerInstance paymentPlatform.apiGateway
                }

                deploymentNode "GKE Cluster" "Regional Kubernetes cluster" "GKE" {
                    deploymentNode "payments namespace" "Payment workloads" "Kubernetes Namespace" {
                        containerInstance paymentPlatform.paymentJourney
                        containerInstance paymentPlatform.paymentService
                        containerInstance paymentPlatform.fraudService
                        containerInstance paymentPlatform.tokenizationService
                        containerInstance paymentPlatform.notificationService
                    }
                    deploymentNode "merchant namespace" "Backoffice workloads" "Kubernetes Namespace" {
                        containerInstance paymentPlatform.merchantBackoffice
                    }
                }

                deploymentNode "Managed Data Services" "Managed persistent services" "GCP Managed Services" {
                    containerInstance paymentPlatform.paymentDb
                    containerInstance paymentPlatform.cardVault
                    containerInstance paymentPlatform.eventBroker
                }
            }

            deploymentNode "External Payment Ecosystem" "External systems" "Partner Networks" {
                softwareSystemInstance acquirer
                softwareSystemInstance cardNetwork
                softwareSystemInstance issuer
                softwareSystemInstance riskProvider
                softwareSystemInstance merchantWebhook
            }
        }
    }

    views {
        systemContext paymentPlatform "01-system-context" {
            include *
            autoLayout lr
            title "C4 System Context - Payment Processing Platform"
            description "Shows the payment platform, users and external payment ecosystem."
        }

        container paymentPlatform "02-container" {
            include *
            autoLayout lr
            title "C4 Container - Payment Processing Platform"
            description "Shows the executable units, databases and brokers inside the payment platform."
        }

        component paymentPlatform.paymentService "03-payment-service-component" {
            include *
            autoLayout tb
            title "C4 Component - Payment Service"
            description "Shows the internal components that own the payment lifecycle."
        }

        dynamic paymentPlatform "04-payment-authorization-flow" "Payment authorization flow" {
            merchant -> paymentPlatform.apiGateway "POST /payments/v1/payments"
            paymentPlatform.apiGateway -> paymentPlatform.paymentJourney "Route request"
            paymentPlatform.paymentJourney -> paymentPlatform.tokenizationService "Tokenize card data"
            paymentPlatform.tokenizationService -> paymentPlatform.cardVault "Store PAN and return token"
            paymentPlatform.paymentJourney -> paymentPlatform.fraudService "Evaluate fraud risk"
            paymentPlatform.fraudService -> riskProvider "Request risk score"
            paymentPlatform.paymentJourney -> paymentPlatform.paymentService "Authorize payment"
            paymentPlatform.paymentService -> acquirer "Authorization request"
            acquirer -> cardNetwork "Route authorization"
            cardNetwork -> issuer "Request issuer decision"
            issuer -> cardNetwork "Approved / declined"
            cardNetwork -> acquirer "Authorization response"
            acquirer -> paymentPlatform.paymentService "Authorization response"
            paymentPlatform.paymentService -> paymentPlatform.eventBroker "Publish PaymentAuthorized/PaymentDeclined"
            paymentPlatform.paymentService -> paymentPlatform.paymentJourney "Return payment status"
            paymentPlatform.paymentJourney -> merchant "Return payment response"
            autoLayout lr
        }

        deployment paymentPlatform "Production" "05-production-deployment" {
            include *
            autoLayout lr
            title "C4 Deployment - Production"
            description "Shows production deployment nodes, Kubernetes namespaces and managed data services."
        }

        styles {
            element "Person" {
                shape person
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
                shape cylinder
            }
            element "Message Broker" {
                shape pipe
            }
        }
    }
}
