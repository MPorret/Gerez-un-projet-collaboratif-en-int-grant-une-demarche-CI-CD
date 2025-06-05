# 🛡️ Configuration de Protection de Branche

## Configuration recommandée pour la branche `main`

### Étapes pour configurer la protection de branche :

1. **Aller dans Settings > Branches** de votre repository GitHub
2. **Cliquer sur "Add rule"** pour la branche `main`
3. **Activer les options suivantes :**

#### ✅ Checks de base
- ☑️ **Require a pull request before merging**
  - ☑️ Require approvals: `1`
  - ☑️ Dismiss stale PR approvals when new commits are pushed
  - ☑️ Require review from code owners (si vous avez un CODEOWNERS)

#### ✅ Checks obligatoires
- ☑️ **Require status checks to pass before merging**
  - ☑️ Require branches to be up to date before merging
  - **Status checks requis :**
    - `🧪 Quality Checks`
    - `🏗️ Build Check`
    - `✅ PR Status`

#### ✅ Protections additionnelles
- ☑️ **Require conversation resolution before merging**
- ☑️ **Restrict pushes that create files**
- ☑️ **Do not allow bypassing the above settings**

### 🚦 Workflow de validation

Avec cette configuration, une PR ne pourra être mergée que si :

1. **✅ Biome Check** - Code lint et formaté correctement
2. **✅ TypeScript Check** - Aucune erreur de type
3. **✅ Tests & Coverage** - Tous les tests passent avec coverage requis
4. **✅ Build Production** - Le build de production réussit
5. **✅ Review** - Au moins une approbation de review
6. **✅ Conflicts** - Branche à jour avec main

### 📊 Métriques de qualité

Le workflow vérifie automatiquement :
- **Lint/Format** avec Biome (ultra-rapide)
- **Type Safety** avec TypeScript
- **Code Coverage** avec rapport détaillé en commentaire
- **Build Success** pour production

### 🔧 Actions sur échec

Si un check échoue :
1. **La PR est bloquée** automatiquement
2. **Les détails de l'erreur** sont affichés dans les checks
3. **Le développeur doit corriger** avant de pouvoir merger

### 💡 Commandes locales recommandées

Avant de push, lancez toujours :
```bash
npm run check:fix    # Corrige automatiquement Biome
npm run test:ci      # Vérifie les tests et coverage
npm run build:prod   # Vérifie que le build fonctionne
```

## 🎯 Objectifs

Cette configuration garantit :
- **Qualité de code constante**
- **Aucune régression**
- **Processus de review standardisé**
- **Déploiements fiables** 