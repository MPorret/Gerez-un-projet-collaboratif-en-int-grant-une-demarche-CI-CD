# Documentation CI/CD – BobApp

## Objectifs du Workflow

Ce workflow CI/CD permet d'automatiser les tâches suivantes :

1. **Tests unitaires**  
   Garantir que les nouvelles fonctionnalités ne provoquent pas de régressions.

2. **Analyse de la qualité du code (SonarCloud)**  
   Maintenir un haut standard de qualité du code et identifier les vulnérabilités, les bugs ou les dettes techniques.

3. **Déploiement Docker**  
   Automatiser le build et la publication d’images Docker du frontend (Angular) et du backend (Spring Boot) sur Docker Hub.

---

## Étapes détaillées du Workflow

### Étape 1 : Tests et Coverage

- Exécute les tests unitaires frontend (Angular) et backend (Java) avec Jacoco.
- Génère les rapports de couverture des tests pour évaluer la couverture du code.
- **Objectif** : Valider la stabilité du code et s'assurer que les modifications n'entraînent pas de régressions.

### Étape 2 : Analyse SonarCloud

- Réalise une analyse de la qualité du code frontend et backend.
- **Objectif** : Identifier les vulnérabilités, bugs et dettes techniques.

### Étape 3 : Build et Push Docker (uniquement après merge sur `main`)

- Construit les images Docker pour le frontend et backend.
- Publie ces images sur Docker Hub avec des tags uniques pour une meilleure gestion des versions.
- **Objectif** : Simplifier le déploiement en production et le versionnement des releases.

---

## KPIs Proposés

Deux indicateurs de performance pour mesurer la qualité et la fiabilité du code :

- **Couverture minimale de code** : 80% minimum exigé pour toute nouvelle implémentation.
- **Nombre maximal d’issues bloquantes** : Aucune nouvelle issue bloquante autorisée.

Ces KPIs garantissent une **qualité durable** et **robuste** du projet BobApp.

---

## Métriques Actuelles

### Backend

- **Couverture actuelle :** 38.8%
- **Issues détectées :**
  - 1 issue de fiabilité
  - 8 problèmes de maintenabilité
  - 2 hotspots de sécurité

### Frontend

- **Couverture actuelle :** 47.6%
- **Issues détectées :**
  - 5 problèmes de maintenabilité

> Ces valeurs indiquent une nécessité d'améliorer la couverture des tests et de résoudre les dettes techniques existantes.

---

## Analyse des retours utilisateurs

Quatre retours utilisateurs ont été examinés :

1. **Plantage du navigateur lors de l'envoi de blague**  
   → Problème critique de stabilité. (prioritaire)

2. **Bug lors de la publication de vidéo**  
   → Manque d’efficacité dans le suivi et la résolution des bugs. (secondaire, à moitié résolu)

3. **Problème de réception des blagues**  
   → Dysfonctionnement du backend, probablement lié à une mauvaise gestion des erreurs ou une fonctionnalité non testée. (prioritaire)

4. **Suppression des favoris par frustration**  
   → Résultat des autres problèmes évoqués.

---

## Justification des choix de CI/CD face aux problèmes

- **Automatisation des tests + coverage élevé**  
  → Réduction des régressions, amélioration de la fiabilité.

- **Utilisation de SonarCloud**  
  → Détection proactive des dettes techniques, bugs et vulnérabilités.

- **Publication sur Docker Hub**  
  → Facilite les déploiements rapides et fiables, avec possibilité de rollback.

---

Ces mesures vont permettre une **amélioration significative de la stabilité**, **de la fiabilité** et **de la satisfaction utilisateur** pour l’application **BobApp**.
