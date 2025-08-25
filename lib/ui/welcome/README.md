# Page d'Accueil - Architecture MVVM + Repository

## Structure des fichiers

```
lib/ui/welcome/
├── README.md                           # Documentation
├── models/                             # Modèles de données (déplacés vers domain/models)
├── view_models/
│   └── welcome_view_model.dart        # ViewModel avec logique métier
├── widgets/
│   └── welcome_screen.dart            # Interface utilisateur
└── repositories/                       # Repository (déplacé vers data/repositories)
```

## Architecture

### 1. **Domain Models** (`lib/domain/models/welcome_data.dart`)
- `GoodDeal` : Modèle pour les bons plans de recyclage
- `Article` : Modèle pour les articles écologiques

### 2. **Repository** (`lib/data/repositories/welcome_repository.dart`)
- `WelcomeRepository` : Interface abstraite
- `WelcomeRepositoryImpl` : Implémentation avec données temporaires
- **Prêt pour l'API** : Remplacez les données temporaires par des appels API

### 3. **ViewModel** (`lib/ui/welcome/view_models/welcome_view_model.dart`)
- Gère l'état de l'interface (loading, erreurs, données)
- Expose les actions utilisateur
- Communique avec le Repository
- Notifie l'UI des changements via `ChangeNotifier`

### 4. **View** (`lib/ui/welcome/widgets/welcome_screen.dart`)
- Interface utilisateur complète
- Utilise `Consumer<WelcomeViewModel>` pour réagir aux changements
- Sections : Header, Bons plans, Premiers pas, Articles, Navigation

## Fonctionnalités

### ✅ **Implémentées**
- Header vert avec message de bienvenue
- Section "Bons plans autour de moi" avec carousel horizontal
- Section "Mes premiers pas sur EcoLink" avec boutons d'action
- Section "Articles" avec carousel horizontal
- Navigation inférieure avec 5 onglets
- Gestion des états (loading, erreurs)
- Pattern MVVM complet

### 🔄 **Prêt pour l'API**
- Repository avec interface abstraite
- Gestion des erreurs avec `Result<T>`
- Modèles JSON-ready
- ViewModel avec méthodes asynchrones

### 🎨 **Design**
- Couleurs Ecolink (#31A05E)
- Interface responsive
- Animations et transitions
- Navigation intuitive

## Utilisation

### Navigation
```dart
// Depuis le SplashScreen
context.go(AppRoutes.welcome);

// Depuis n'importe où
GoRouter.of(context).go(AppRoutes.welcome);
```

### Ajout de nouvelles fonctionnalités
1. **Modèle** : Ajoutez dans `domain/models/`
2. **Repository** : Implémentez dans `data/repositories/`
3. **ViewModel** : Ajoutez la logique métier
4. **UI** : Créez les widgets dans `widgets/`

## Prochaines étapes

1. **Intégration API** : Remplacez les données temporaires
2. **Navigation** : Implémentez les routes pour les actions
3. **Images** : Ajoutez les assets réels
4. **Tests** : Créez les tests unitaires et d'intégration
