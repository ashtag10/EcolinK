import 'package:flutter/foundation.dart';
import '../../../data/repositories/welcome_repository.dart';
import '../../../domain/models/welcome_data.dart';
import '../../../utils/result.dart';

enum WelcomeUiState { loading, ready, error }

class WelcomeViewModel extends ChangeNotifier {
  final WelcomeRepository _repository;

  WelcomeViewModel(this._repository);

  List<GoodDeal> _goodDeals = [];
  List<GoodDeal> get goodDeals => _goodDeals;

  List<Article> _articles = [];
  List<Article> get articles => _articles;

  WelcomeUiState _state = WelcomeUiState.loading;
  WelcomeUiState get state => _state;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> loadAll() async {
    _state = WelcomeUiState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _repository.getGoodDeals(), // Result<List<GoodDeal>>
        _repository.getArticles(),  // Result<List<Article>>
      ]);

      // Déstructure et vérifie chaque Result avec pattern matching
      switch (results[0]) {
        case Ok<List<GoodDeal>>(value: final deals):
          _goodDeals = deals;
        case Error<List<GoodDeal>>(error: final err):
          _errorMessage = 'Erreur Bons plans: $err';
        case Ok<List<Object>>():
          // TODO: Handle this case.
          throw UnimplementedError();
        case Error<List<Object>>():
          // TODO: Handle this case.
          throw UnimplementedError();
      }

      switch (results[1]) {
        case Ok<List<Article>>(value: final arts):
          _articles = arts;
        case Error<List<Article>>(error: final err):
          _errorMessage = [
            if (_errorMessage != null) _errorMessage,
            'Erreur Articles: $err'
          ].whereType<String>().join(' | ');
        case Ok<List<Object>>():
          // TODO: Handle this case.
          throw UnimplementedError();
        case Error<List<Object>>():
          // TODO: Handle this case.
          throw UnimplementedError();
      }

      _state = (_errorMessage == null)
          ? WelcomeUiState.ready
          : WelcomeUiState.error;
    } catch (e) {
      _errorMessage = e.toString();
      _state = WelcomeUiState.error;
    }

    notifyListeners();
  }

  Future<void> retry() => loadAll();
}
