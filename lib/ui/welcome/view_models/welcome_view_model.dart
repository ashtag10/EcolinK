import 'package:flutter/foundation.dart';
import '../../../data/repositories/welcome_repository.dart';
import '../../../domain/models/welcome_data.dart';
import '../../../utils/result.dart';

class WelcomeViewModel extends ChangeNotifier {
  final WelcomeRepository _repository;

  WelcomeViewModel(this._repository);

  // États
  List<GoodDeal> _goodDeals = [];
  List<Article> _articles = [];
  bool _isLoadingGoodDeals = false;
  bool _isLoadingArticles = false;
  String? _errorMessage;

  // Getters
  List<GoodDeal> get goodDeals => _goodDeals;
  List<Article> get articles => _articles;
  bool get isLoadingGoodDeals => _isLoadingGoodDeals;
  bool get isLoadingArticles => _isLoadingArticles;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;

  // Actions
  Future<void> loadGoodDeals() async {
    _setLoadingGoodDeals(true);
    _clearError();

    try {
      final result = await _repository.getGoodDeals();

      switch (result) {
        case Ok():
          _goodDeals = result.value;
          _setLoadingGoodDeals(false);
        case Error():
          _setError(
              'Erreur lors du chargement des bons plans: ${result.error.toString()}');
          _setLoadingGoodDeals(false);
      }
    } catch (e) {
      _setError('Erreur inattendue: ${e.toString()}');
      _setLoadingGoodDeals(false);
    }
  }

  Future<void> loadArticles() async {
    _setLoadingArticles(true);
    _clearError();

    try {
      final result = await _repository.getArticles();

      switch (result) {
        case Ok():
          _articles = result.value;
          _setLoadingArticles(false);
        case Error():
          _setError(
              'Erreur lors du chargement des articles: ${result.error.toString()}');
          _setLoadingArticles(false);
      }
    } catch (e) {
      _setError('Erreur inattendue: ${e.toString()}');
      _setLoadingArticles(false);
    }
  }

  Future<void> loadAllData() async {
    await Future.wait([
      loadGoodDeals(),
      loadArticles(),
    ]);
  }

  void onGoodDealTap(GoodDeal deal) {
    // TODO: Navigation vers la page de formation
    debugPrint('Navigation vers: ${deal.actionUrl}');
  }

  void onArticleTap(Article article) {
    // TODO: Navigation vers la page d'article
    debugPrint('Navigation vers l\'article: ${article.id}');
  }

  void onCreateAccountTap() {
    // TODO: Navigation vers la page de création de compte
    debugPrint('Navigation vers création de compte');
  }

  void onShareWithFriendTap() {
    // TODO: Implémenter le partage
    debugPrint('Partage avec un ami');
  }

  void onSeeMoreArticlesTap() {
    // TODO: Navigation vers la liste complète des articles
    debugPrint('Navigation vers tous les articles');
  }

  // Méthodes privées pour la gestion des états
  void _setLoadingGoodDeals(bool loading) {
    _isLoadingGoodDeals = loading;
    notifyListeners();
  }

  void _setLoadingArticles(bool loading) {
    _isLoadingArticles = loading;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
