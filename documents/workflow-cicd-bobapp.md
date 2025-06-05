# Workflow CI/CD - BobApp

## Vue d'ensemble du processus DevOps

Ce document détaille la stratégie CI/CD mise en place pour le projet BobApp, utilisant GitHub Actions comme orchestrateur principal et SonarQube pour l'analyse de qualité.

### Objectifs du workflow
- **Intégration continue** : Tests automatisés à chaque commit
- **Déploiement continu** : Livraison automatisée selon les environnements
- **Quality Gates** : Contrôles qualité obligatoires
- **Feedback rapide** : Retours développeurs en moins de 10 minutes

## Architecture du pipeline CI/CD

```mermaid
graph TB
    subgraph "Source Control"
        GH[GitHub Repository]
        PR[Pull Request]
        MAIN[Main Branch]
        DEV[Develop Branch]
    end
    
    subgraph "CI/CD Pipeline - GitHub Actions"
        subgraph "Quality Checks"
            LINT[Linting & Formatting]
            TEST[Unit Tests]
            COV[Coverage Analysis]
            SONAR[SonarQube Scan]
        end
        
        subgraph "Build & Package"
            BUILD[Build Applications]
            DOCKER[Docker Images]
            PUSH[Push to Registry]
        end
        
        subgraph "Deployment"
            DEV_DEPLOY[Deploy to Dev]
            STAGING[Deploy to Staging]
            PROD[Deploy to Production]
        end
    end
    
    subgraph "Quality Gates"
        QG[SonarQube Quality Gate]
        SEC[Security Scan]
        PERF[Performance Tests]
    end
    
    subgraph "Environments"
        ENV_DEV[Development<br/>Port 3001/8081]
        ENV_STAGE[Staging<br/>Port 3002/8082]
        ENV_PROD[Production<br/>Port 3000/8080]
    end
    
    GH --> PR
    PR --> LINT
    PR --> TEST
    LINT --> COV
    TEST --> COV
    COV --> SONAR
    SONAR --> QG
    
    QG --> BUILD
    BUILD --> DOCKER
    DOCKER --> PUSH
    
    PUSH --> DEV_DEPLOY
    DEV_DEPLOY --> ENV_DEV
    
    ENV_DEV --> SEC
    SEC --> STAGING
    STAGING --> ENV_STAGE
    
    ENV_STAGE --> PERF
    PERF --> PROD
    PROD --> ENV_PROD
    
    MAIN --> BUILD
    DEV --> DEV_DEPLOY
```

## Stratégie de branchement - GitFlow adapté

```mermaid
gitGraph
    commit id: "Initial"
    branch develop
    checkout develop
    commit id: "Setup project"
    
    branch feature/frontend-tests
    checkout feature/frontend-tests
    commit id: "Add unit tests"
    commit id: "Configure Biome"
    checkout develop
    merge feature/frontend-tests
    
    branch feature/backend-tests
    checkout feature/backend-tests
    commit id: "Add service tests"
    commit id: "Integration tests"
    checkout develop
    merge feature/backend-tests
    
    checkout main
    merge develop id: "Release v1.0"
    tag: "v1.0.0"
    
    checkout develop
    branch hotfix/security-fix
    checkout hotfix/security-fix
    commit id: "Security patch"
    checkout main
    merge hotfix/security-fix
    checkout develop
    merge hotfix/security-fix
```

## Workflow détaillé par trigger

### 1. Pull Request Workflow

```mermaid
sequenceDiagram
    participant Dev as Développeur
    participant GH as GitHub
    participant GHA as GitHub Actions
    participant SQ as SonarQube
    participant Docker as Docker Registry
    
    Dev->>GH: Push feature branch
    Dev->>GH: Create Pull Request
    
    GH->>GHA: Trigger PR workflow
    
    par Frontend Pipeline
        GHA->>GHA: npm install
        GHA->>GHA: Biome check
        GHA->>GHA: ng test --watch=false
        GHA->>GHA: ng build --prod
    and Backend Pipeline
        GHA->>GHA: mvn clean compile
        GHA->>GHA: mvn test
        GHA->>GHA: mvn package
    end
    
    GHA->>SQ: Send coverage reports
    SQ->>SQ: Analyse quality
    SQ-->>GHA: Quality Gate result
    
    alt Quality Gate PASSED
        GHA-->>GH: ✅ All checks passed
        GH-->>Dev: PR ready for review
    else Quality Gate FAILED
        GHA-->>GH: ❌ Quality issues
        GH-->>Dev: Fix issues before merge
    end
```

### 2. Main Branch Deployment

```mermaid
sequenceDiagram
    participant GH as GitHub
    participant GHA as GitHub Actions
    participant Docker as Docker Registry
    participant PROD as Production
    
    GH->>GHA: Merge to main
    GHA->>GHA: Run full test suite
    
    par Build Frontend
        GHA->>GHA: ng build --configuration=production
        GHA->>GHA: docker build frontend
    and Build Backend
        GHA->>GHA: mvn clean package
        GHA->>GHA: docker build backend
    end
    
    GHA->>Docker: Push images with tags
    Docker-->>GHA: Push successful
    
    GHA->>PROD: Deploy containers
    PROD-->>GHA: Deployment successful
    
    GHA->>GHA: Run smoke tests
    GHA-->>GH: Deployment complete
```

## Configuration des environnements

### Variables d'environnement par stage

```mermaid
graph LR
    subgraph "Development"
        DEV_DB[H2 Database]
        DEV_PORT[Ports: 4200/8080]
        DEV_LOG[DEBUG Logging]
    end
    
    subgraph "Staging"
        STAGE_DB[PostgreSQL Test]
        STAGE_PORT[Ports: 3002/8082]
        STAGE_LOG[INFO Logging]
    end
    
    subgraph "Production"
        PROD_DB[PostgreSQL Prod]
        PROD_PORT[Ports: 3000/8080]
        PROD_LOG[WARN Logging]
        PROD_SEC[HTTPS + Security]
    end
```

## GitHub Actions - Structure des workflows

### Structure des fichiers

```
.github/
├── workflows/
│   ├── frontend-ci.yml          # CI Frontend (PR + merge)
│   ├── backend-ci.yml           # CI Backend (PR + merge)
│   ├── deploy-staging.yml       # Déploiement staging
│   ├── deploy-production.yml    # Déploiement production
│   └── security-scan.yml        # Scans sécurité hebdomadaires
├── dependabot.yml              # Updates automatiques dépendances
└── CODEOWNERS                  # Code review obligatoire
```

### Workflow Frontend CI

```mermaid
graph TD
    START[PR/Push on main] --> CHECKOUT[Checkout Code]
    CHECKOUT --> CACHE[Cache Node Modules]
    CACHE --> INSTALL[npm ci]
    INSTALL --> LINT[Run Biome Checks]
    LINT --> TEST[Run Unit Tests]
    TEST --> BUILD[Build Production]
    BUILD --> COVERAGE[Generate Coverage]
    COVERAGE --> SONAR[SonarQube Analysis]
    
    SONAR --> QG{Quality Gate}
    QG -->|Pass| SUCCESS[✅ Success]
    QG -->|Fail| FAILURE[❌ Failure]
    
    SUCCESS --> DOCKER[Build Docker Image]
    DOCKER --> PUSH[Push to Registry]
    PUSH --> END[End]
    
    FAILURE --> END
```

### Workflow Backend CI

```mermaid
graph TD
    START[PR/Push on main] --> CHECKOUT[Checkout Code]
    CHECKOUT --> JAVA[Setup Java 11]
    JAVA --> CACHE[Cache Maven Dependencies]
    CACHE --> COMPILE[mvn compile]
    COMPILE --> TEST[mvn test]
    TEST --> PACKAGE[mvn package]
    PACKAGE --> JACOCO[JaCoCo Report]
    JACOCO --> SONAR[SonarQube Analysis]
    
    SONAR --> QG{Quality Gate}
    QG -->|Pass| SUCCESS[✅ Success]
    QG -->|Fail| FAILURE[❌ Failure]
    
    SUCCESS --> DOCKER[Build Docker Image]
    DOCKER --> PUSH[Push to Registry]
    PUSH --> END[End]
    
    FAILURE --> END
```

## Quality Gates et métriques

### Critères SonarQube

```mermaid
graph LR
    subgraph "Coverage Requirements"
        COV_UNIT[Unit Tests: >80%]
        COV_BRANCH[Branch Coverage: >70%]
        COV_LINE[Line Coverage: >85%]
    end
    
    subgraph "Quality Metrics"
        DUP[Duplications: <3%]
        MAIN[Maintainability: A]
        REL[Reliability: A]
        SEC[Security: A]
    end
    
    subgraph "Code Smells"
        DEBT[Technical Debt: <30min]
        SMELL[Code Smells: <50]
        COMPLEX[Complexity: <15/method]
    end
```

### Workflow de validation qualité

```mermaid
flowchart TD
    CODE[Code Commit] --> STATIC[Static Analysis]
    STATIC --> TESTS[Run Tests]
    TESTS --> COVERAGE[Check Coverage]
    
    COVERAGE --> COV_OK{Coverage ≥ 80%}
    COV_OK -->|No| REJECT[❌ Reject PR]
    COV_OK -->|Yes| QUALITY[Quality Analysis]
    
    QUALITY --> QUAL_OK{Quality Gate}
    QUAL_OK -->|Fail| REJECT
    QUAL_OK -->|Pass| SECURITY[Security Scan]
    
    SECURITY --> SEC_OK{No Vulnerabilities}
    SEC_OK -->|Vulnerabilities| REJECT
    SEC_OK -->|Clean| APPROVE[✅ Approve PR]
    
    REJECT --> FIX[Fix Issues]
    FIX --> CODE
```

## Déploiement et rollback

### Stratégie de déploiement Blue/Green

```mermaid
graph LR
    subgraph "Load Balancer"
        LB[Nginx/HAProxy]
    end
    
    subgraph "Blue Environment (Current)"
        BLUE_F[Frontend v1.0]
        BLUE_B[Backend v1.0]
    end
    
    subgraph "Green Environment (New)"
        GREEN_F[Frontend v1.1]
        GREEN_B[Backend v1.1]
    end
    
    LB --> BLUE_F
    LB --> BLUE_B
    
    GREEN_F -.- GREEN_B
    
    style GREEN_F fill:#90EE90
    style GREEN_B fill:#90EE90
    style BLUE_F fill:#ADD8E6
    style BLUE_B fill:#ADD8E6
```

### Processus de rollback automatique

```mermaid
sequenceDiagram
    participant CD as CD Pipeline
    participant PROD as Production
    participant MON as Monitoring
    participant ALERT as Alerting
    
    CD->>PROD: Deploy new version
    PROD->>MON: Health check endpoints
    
    loop Every 30s for 5 minutes
        MON->>PROD: Check /health
        alt Health OK
            PROD-->>MON: 200 OK
        else Health KO
            PROD-->>MON: 500 Error
            MON->>ALERT: Trigger alert
            ALERT->>CD: Rollback signal
            CD->>PROD: Rollback to previous version
        end
    end
    
    Note over CD,ALERT: Auto-rollback if health checks fail
```

## Monitoring et observabilité

### Métriques surveillées

```mermaid
graph TB
    subgraph "Application Metrics"
        REQ[Request Rate]
        RESP[Response Time]
        ERR[Error Rate]
        AVAIL[Availability]
    end
    
    subgraph "Infrastructure Metrics"
        CPU[CPU Usage]
        MEM[Memory Usage]
        DISK[Disk I/O]
        NET[Network]
    end
    
    subgraph "Business Metrics"
        JOKES[Jokes Served/min]
        USERS[Active Users]
        PERF[Page Load Time]
    end
    
    subgraph "Alerting"
        SLACK[Slack Notifications]
        EMAIL[Email Alerts]
        PAGES[PagerDuty]
    end
    
    REQ --> SLACK
    ERR --> EMAIL
    AVAIL --> PAGES
```

## Sécurité dans le pipeline

### Scans de sécurité intégrés

```mermaid
graph TD
    CODE[Code Changes] --> STATIC_SEC[Static Security Analysis]
    STATIC_SEC --> DEP_CHECK[Dependency Vulnerability Scan]
    DEP_CHECK --> SECRET[Secret Detection]
    SECRET --> CONTAINER[Container Security Scan]
    CONTAINER --> DEPLOY{Deploy}
    
    DEPLOY -->|Pass| RUNTIME[Runtime Security Monitoring]
    DEPLOY -->|Fail| BLOCK[❌ Block Deployment]
    
    BLOCK --> FIX[Fix Security Issues]
    FIX --> CODE
```

---

*Workflow CI/CD établi selon les meilleures pratiques DevOps*
*Méthode TDD : Tests automatisés à chaque étape du pipeline* 