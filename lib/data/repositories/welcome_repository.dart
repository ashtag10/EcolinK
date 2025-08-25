import '../../domain/models/welcome_data.dart';
import '../../utils/result.dart';

abstract class WelcomeRepository {
  Future<Result<List<GoodDeal>>> getGoodDeals();
  Future<Result<List<Article>>> getArticles();
}

class WelcomeRepositoryImpl implements WelcomeRepository {
  // TODO: Injecter le service API ici
  // final ApiService _apiService;

  // WelcomeRepositoryImpl(this._apiService);

  @override
  Future<Result<List<GoodDeal>>> getGoodDeals() async {
    try {
      // TODO: Remplacer par l'appel API réel
      // final response = await _apiService.getGoodDeals();
      // return Result.ok(response.map((e) => GoodDeal.fromJson(e)).toList());

      // Données temporaires pour le développement
      await Future.delayed(
          const Duration(milliseconds: 500)); // Simulation API delay

      final goodDeals = [
        GoodDeal(
          id: '1',
          title: 'Comment recycler les bouteilles plastiques ?',
          description:
              'Apprenez les bonnes pratiques pour recycler vos bouteilles plastiques',
          imageUrl: 'assets/images/plastic_bottles.jpg',
          actionText: 'ME FORMER',
          actionUrl: '/training/plastic-bottles',
        ),
        GoodDeal(
          id: '2',
          title: 'Recyclage du verre',
          description: 'Découvrez comment recycler le verre efficacement',
          imageUrl: 'assets/images/glass_recycling.jpg',
          actionText: 'ME FORMER',
          actionUrl: '/training/glass',
        ),
      ];

      return Result.ok(goodDeals);
    } catch (e) {
      return Result.error(
          Exception('Erreur lors du chargement des bons plans: $e'));
    }
  }

  @override
  Future<Result<List<Article>>> getArticles() async {
    try {
      // TODO: Remplacer par l'appel API réel
      // final response = await _apiService.getArticles();
      // return Result.ok(response.map((e) => Article.fromJson(e)).toList());

      // Données temporaires pour le développement
      await Future.delayed(
          const Duration(milliseconds: 300)); // Simulation API delay

      final articles = [
        Article(
          id: '1',
          title: 'Journée de l\'Écologie',
          date: 'Samedi 18 juin',
          description:
              'La journée Mondiale de l\'Ecologie. Les journaux en parlent...',
          imageUrl: 'assets/images/ecology_day.jpg',
          readMoreText: 'Lire...',
        ),
        Article(
          id: '2',
          title: 'Recyclage en entreprise',
          date: 'Lundi 20 juin',
          description: 'Comment implémenter le recyclage dans votre entreprise',
          imageUrl: 'assets/images/business_recycling.jpg',
          readMoreText: 'Lire...',
        ),
      ];

      return Result.ok(articles);
    } catch (e) {
      return Result.error(
          Exception('Erreur lors du chargement des articles: $e'));
    }
  }
}
