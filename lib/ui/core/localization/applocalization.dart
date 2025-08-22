import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppLocalization {
  static AppLocalization of(BuildContext context) {
    return Localizations.of<AppLocalization>(context, AppLocalization)!;
  }

  static const _strings = <String, String>{
    'welcome': 'Bienvenue sur Ecolink !',
    'joinAction':
        'Envie d\'agir pour la planète ? Rejoins-nous pour passer à l\'action...',
    'register': 'Je m\'inscris',
    'goodDeals': 'Bons plans autour de moi',
    'howToRecycleBottles': 'Comment recycler les bouteilles plastiques ?',
    'trainMe': 'ME FORMER',
    'firstSteps': 'Mes premiers pas sur EcoLink',
    'createAccount': 'Créez un compte',
    'shareFriend': 'Partagez à un ami',
    'recycleWithEcolink': 'Je recycle avec EcoLink',
    'takePicture': 'Prenez une image',
    'myActivities': 'Mes activités',
    'points': '{points} Points',
    'articles': 'Articles',
    'seeMore': 'VOIR PLUS',
    'login': 'Connexion',
    'logout': 'Déconnexion',
    'error': 'Erreur',
    'tryAgain': 'Réessayer',
    'search': 'Rechercher',
    'profile': 'Profil',
    'home': 'Accueil',
    'rewards': 'Récompenses',
    'myAccount': 'Mon compte',
    // Ajoute ici d'autres clés selon tes besoins
  };

  static String _get(String label) =>
      _strings[label] ?? '[${label.toUpperCase()}]';

  String get welcome => _get('welcome');
  String get joinAction => _get('joinAction');
  String get register => _get('register');
  String get goodDeals => _get('goodDeals');
  String get howToRecycleBottles => _get('howToRecycleBottles');
  String get trainMe => _get('trainMe');
  String get firstSteps => _get('firstSteps');
  String get createAccount => _get('createAccount');
  String get shareFriend => _get('shareFriend');
  String get recycleWithEcolink => _get('recycleWithEcolink');
  String get takePicture => _get('takePicture');
  String get myActivities => _get('myActivities');
  String points(int value) =>
      _get('points').replaceAll('{points}', value.toString());
  String get articles => _get('articles');
  String get seeMore => _get('seeMore');
  String get login => _get('login');
  String get logout => _get('logout');
  String get error => _get('error');
  String get tryAgain => _get('tryAgain');
  String get search => _get('search');
  String get profile => _get('profile');
  String get home => _get('home');
  String get rewards => _get('rewards');
  String get myAccount => _get('myAccount');

  // Ajoute ici d'autres getters si besoin
}

class AppLocalizationDelegate extends LocalizationsDelegate<AppLocalization> {
  @override
  bool isSupported(Locale locale) => locale.languageCode == 'fr';

  @override
  Future<AppLocalization> load(Locale locale) {
    return SynchronousFuture(AppLocalization());
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalization> old) =>
      false;
}
