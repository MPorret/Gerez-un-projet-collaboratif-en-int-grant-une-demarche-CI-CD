# Analyse Backend - CI/CD avec Github Actions et SonarQube

## Vue d'ensemble du projet

**Nom du projet :** bobapp  
**Framework :** Spring Boot 2.6.1  
**Langage :** Java 11  
**Gestionnaire de dépendances :** Maven 3.6.3  
**Architecture :** REST API avec Spring WebFlux  

## Architecture actuelle

### Technologies utilisées
- **Spring Boot 2.6.1** avec WebFlux (reactive)
- **Java 11** 
- **Maven** pour la gestion des dépendances
- **JUnit 5** pour les tests
- **JaCoCo 0.8.5** pour la couverture de code (déjà configuré)
- **Docker** pour la conteneurisation

### Structure du projet
```
back/
├── src/
│   ├── main/
│   │   ├── java/com/openclassrooms/bobapp/
│   │   │   ├── controller/      # Contrôleurs REST
│   │   │   ├── service/         # Services métier
│   │   │   ├── model/           # Modèles de données
│   │   │   ├── data/            # Accès aux données
│   │   │   └── BobappApplication.java
│   │   └── resources/
│   │       ├── application.properties
│   │       └── json/            # Données JSON statiques
│   └── test/
│       └── java/               # Tests unitaires
├── pom.xml                     # Configuration Maven
├── Dockerfile                  # Image de production
└── mvnw, mvnw.cmd             # Maven Wrapper
```

### Analyse des composants

#### API REST
- **JokeController** : Endpoint unique `/api/joke` (GET)
- **JokeService** : Logique métier pour récupération des blagues
- **JsonReader** : Utilitaire pour lecture des données JSON
- **Joke** : Modèle de données

## État actuel de la qualité du code

### Points positifs
- **Architecture Spring Boot** bien structurée (Controller/Service/Model)
- **JaCoCo déjà configuré** pour la couverture de code
- **Spring WebFlux** pour la programmation réactive
- **Maven Wrapper** inclus pour la portabilité
- **Dockerisation** fonctionnelle avec multi-stage build
- **Séparation des responsabilités** respectée

### Points à améliorer pour CI/CD
- **Tests insuffisants** : seulement un test de contexte
- **Configuration application.properties** vide
- **Profils Spring** non configurés (dev, test, prod)
- **Plugins Maven** manquants pour l'analyse statique
- **Configuration SonarQube** absente
- **Tests d'intégration** manquants
- **Gestion des logs** non configurée

## Recommandations pour CI/CD

### 1. Configuration Maven améliorée

#### Plugins à ajouter dans pom.xml
```xml
<properties>
    <java.version>11</java.version>
    <maven.compiler.source>11</maven.compiler.source>
    <maven.compiler.target>11</maven.compiler.target>
    <sonar.maven.plugin>3.9.1.2184</sonar.maven.plugin>
    <jacoco.version>0.8.8</jacoco.version>
    <surefire.version>3.0.0-M9</surefire.version>
    <failsafe.version>3.0.0-M9</failsafe.version>
</properties>

<build>
    <plugins>
        <!-- Plugin Surefire pour tests unitaires -->
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-surefire-plugin</artifactId>
            <version>${surefire.version}</version>
            <configuration>
                <includes>
                    <include>**/*Test.java</include>
                    <include>**/*Tests.java</include>
                </includes>
            </configuration>
        </plugin>
        
        <!-- Plugin Failsafe pour tests d'intégration -->
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-failsafe-plugin</artifactId>
            <version>${failsafe.version}</version>
            <executions>
                <execution>
                    <goals>
                        <goal>integration-test</goal>
                        <goal>verify</goal>
                    </goals>
                </execution>
            </executions>
        </plugin>
        
        <!-- JaCoCo mise à jour -->
        <plugin>
            <groupId>org.jacoco</groupId>
            <artifactId>jacoco-maven-plugin</artifactId>
            <version>${jacoco.version}</version>
            <executions>
                <execution>
                    <goals>
                        <goal>prepare-agent</goal>
                    </goals>
                </execution>
                <execution>
                    <id>report</id>
                    <phase>test</phase>
                    <goals>
                        <goal>report</goal>
                    </goals>
                </execution>
                <execution>
                    <id>check</id>
                    <goals>
                        <goal>check</goal>
                    </goals>
                    <configuration>
                        <rules>
                            <rule>
                                <element>BUNDLE</element>
                                <limits>
                                    <limit>
                                        <counter>INSTRUCTION</counter>
                                        <value>COVEREDRATIO</value>
                                        <minimum>0.80</minimum>
                                    </limit>
                                </limits>
                            </rule>
                        </rules>
                    </configuration>
                </execution>
            </executions>
        </plugin>
        
        <!-- Plugin SonarQube -->
        <plugin>
            <groupId>org.sonarsource.scanner.maven</groupId>
            <artifactId>sonar-maven-plugin</artifactId>
            <version>${sonar.maven.plugin}</version>
        </plugin>
    </plugins>
</build>
```

#### Dépendances de test à ajouter
```xml
<dependencies>
    <!-- Dépendances existantes... -->
    
    <!-- Test dependencies -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-test</artifactId>
        <scope>test</scope>
    </dependency>
    <dependency>
        <groupId>io.projectreactor</groupId>
        <artifactId>reactor-test</artifactId>
        <scope>test</scope>
    </dependency>
    <dependency>
        <groupId>org.testcontainers</groupId>
        <artifactId>junit-jupiter</artifactId>
        <scope>test</scope>
    </dependency>
</dependencies>
```

### 2. Configuration des profils Spring

#### application.properties
```properties
# Configuration par défaut
spring.application.name=bobapp
server.port=8080
logging.level.com.openclassrooms.bobapp=INFO

# Profile actif par défaut
spring.profiles.active=@spring.profiles.active@
```

#### application-dev.properties
```properties
# Profil développement
logging.level.com.openclassrooms.bobapp=DEBUG
logging.level.org.springframework.web=DEBUG
server.port=8080
```

#### application-test.properties
```properties
# Profil test
logging.level.com.openclassrooms.bobapp=WARN
server.port=0
```

#### application-prod.properties
```properties
# Profil production
logging.level.com.openclassrooms.bobapp=WARN
server.port=8080
management.endpoints.web.exposure.include=health,info
```

### 3. Configuration SonarQube

#### Fichier sonar-project.properties
```properties
sonar.projectKey=bobapp-backend
sonar.projectName=BobApp Backend
sonar.projectVersion=1.0

# Source configuration
sonar.sources=src/main/java
sonar.tests=src/test/java
sonar.java.binaries=target/classes
sonar.java.test.binaries=target/test-classes

# Coverage
sonar.coverage.jacoco.xmlReportPaths=target/site/jacoco/jacoco.xml
sonar.junit.reportPaths=target/surefire-reports

# Exclusions
sonar.exclusions=**/BobappApplication.java
sonar.test.exclusions=**/*Test.java,**/*Tests.java

# Quality profiles
sonar.java.source=11
```

### 4. Pipeline Github Actions

#### Structure recommandée (.github/workflows/backend-ci.yml)

```yaml
name: Backend CI/CD

on:
  push:
    branches: [ main, develop ]
    paths: ['back/**']
  pull_request:
    branches: [ main ]
    paths: ['back/**']

jobs:
  test:
    runs-on: ubuntu-latest
    defaults:
      run:
        working-directory: ./back
    
    steps:
    - uses: actions/checkout@v3
      with:
        fetch-depth: 0  # Nécessaire pour SonarQube
    
    - name: Set up JDK 11
      uses: actions/setup-java@v3
      with:
        java-version: '11'
        distribution: 'temurin'
        cache: maven
    
    - name: Cache Maven packages
      uses: actions/cache@v3
      with:
        path: ~/.m2
        key: ${{ runner.os }}-m2-${{ hashFiles('**/pom.xml') }}
        restore-keys: ${{ runner.os }}-m2
    
    - name: Run tests
      run: ./mvnw clean test
    
    - name: Generate test coverage report
      run: ./mvnw jacoco:report
    
    - name: Upload coverage to Codecov
      uses: codecov/codecov-action@v3
      with:
        file: ./back/target/site/jacoco/jacoco.xml
    
    - name: SonarQube Scan
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
      run: |
        ./mvnw sonar:sonar \
          -Dsonar.projectKey=bobapp-backend \
          -Dsonar.host.url=${{ secrets.SONAR_HOST_URL }} \
          -Dsonar.login=${{ secrets.SONAR_TOKEN }}

  build-and-deploy:
    needs: test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    defaults:
      run:
        working-directory: ./back
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Set up JDK 11
      uses: actions/setup-java@v3
      with:
        java-version: '11'
        distribution: 'temurin'
        cache: maven
    
    - name: Build application
      run: ./mvnw clean package -DskipTests
    
    - name: Build Docker image
      run: |
        docker build -t bobapp-backend:${{ github.sha }} .
        docker tag bobapp-backend:${{ github.sha }} bobapp-backend:latest
    
    - name: Deploy to staging/production
      # Configuration spécifique selon votre infrastructure
      run: echo "Deploy step to be configured"
```

### 5. Optimisations Docker

#### Dockerfile amélioré
```dockerfile
# Multi-stage build optimisé
FROM maven:3.8.6-openjdk-11-slim AS build

WORKDIR /app
COPY pom.xml .
COPY mvnw .
COPY .mvn .mvn

# Cache dependencies
RUN mvn dependency:go-offline

COPY src ./src
RUN mvn clean package -DskipTests

FROM openjdk:11-jre-slim AS production

# Create non-root user for security
RUN groupadd -r spring && useradd -r -g spring spring

WORKDIR /app
COPY --from=build /app/target/*.jar app.jar

RUN chown spring:spring app.jar
USER spring

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8080/actuator/health || exit 1

ENTRYPOINT ["java", "-jar", "app.jar"]
```

### 6. Tests à implémenter

#### Tests unitaires manquants
```java
// JokeControllerTest.java
@WebMvcTest(JokeController.class)
class JokeControllerTest {
    
    @Autowired
    private WebTestClient webTestClient;
    
    @MockBean
    private JokeService jokeService;
    
    @Test
    void shouldReturnRandomJoke() {
        // Test implementation
    }
}

// JokeServiceTest.java
@ExtendWith(MockitoExtension.class)
class JokeServiceTest {
    
    @InjectMocks
    private JokeService jokeService;
    
    @Test
    void shouldReturnRandomJoke() {
        // Test implementation
    }
}
```

#### Tests d'intégration
```java
// JokeControllerIntegrationTest.java
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
class JokeControllerIntegrationTest {
    
    @Autowired
    private WebTestClient webTestClient;
    
    @Test
    void shouldReturnJokeFromEndpoint() {
        // Integration test implementation
    }
}
```

## Plan de mise en œuvre

### Phase 1 : Configuration et qualité (2-3 jours)
1. Mettre à jour le pom.xml avec les nouveaux plugins
2. Configurer les profils Spring
3. Créer le fichier sonar-project.properties
4. Ajouter les dépendances de test manquantes

### Phase 2 : Tests (3-4 jours)
1. Implémenter les tests unitaires manquants
2. Ajouter les tests d'intégration
3. Configurer les seuils de couverture JaCoCo
4. Valider la génération des rapports

### Phase 3 : CI/CD (2-3 jours)
1. Créer le workflow Github Actions
2. Configurer SonarQube
3. Tester les pipelines
4. Configurer les secrets et variables

### Phase 4 : Déploiement (1-2 jours)
1. Optimiser le Dockerfile
2. Configurer les health checks
3. Mettre en place le déploiement automatique

## Métriques de qualité recommandées

### SonarQube Quality Gates
- **Coverage** : minimum 80%
- **Duplicated Lines** : maximum 3%
- **Maintainability Rating** : A
- **Reliability Rating** : A
- **Security Rating** : A
- **Technical Debt** : maximum 5%

### JaCoCo Coverage
- **Instructions** : minimum 80%
- **Branches** : minimum 75%
- **Lines** : minimum 80%
- **Methods** : minimum 80%

## Risques identifiés

1. **Tests insuffisants** : Coverage actuel probablement très faible (< 10%)
2. **Spring Boot 2.6.1** : Version relativement ancienne, migration vers 2.7+ recommandée
3. **Configuration sécurité** : Aucune configuration de sécurité présente
4. **Gestion des erreurs** : Pas de gestion d'erreurs globale
5. **Monitoring** : Actuator non configuré pour les métriques

## Conclusion

Le projet Spring Boot présente une architecture solide mais nécessite des améliorations significatives pour une CI/CD robuste :

### **Points critiques à adresser :**
- **Implémentation massive de tests** (actuellement quasi inexistants)
- **Configuration des profils** Spring pour différents environnements
- **Ajout des plugins Maven** pour l'analyse statique
- **Configuration SonarQube** complète

### **Avantages existants :**
- Architecture bien structurée
- JaCoCo déjà présent
- Dockerisation fonctionnelle
- Spring WebFlux pour la performance

**Estimation :** L'implémentation complète nécessitera 8-10 jours, avec un focus prioritaire sur les tests qui représentent 40% de l'effort total. 