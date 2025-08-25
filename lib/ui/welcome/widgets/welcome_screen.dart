import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/welcome_view_model.dart';
import '../../../domain/models/welcome_data.dart';
import '../../core/themes/colors.dart';
import '../../core/themes/dimens.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    // Charger les données au démarrage
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WelcomeViewModel>().loadAllData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blanc,
      body: Consumer<WelcomeViewModel>(
        builder: (context, viewModel, child) {
          return CustomScrollView(
            slivers: [
              // Header vert avec message de bienvenue
              _buildWelcomeHeader(),

              // Contenu principal
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimens.of(context).paddingScreenHorizontal,
                    vertical: Dimens.of(context).paddingScreenVertical,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section Bons plans
                      _buildGoodDealsSection(viewModel),

                      const SizedBox(height: 32),

                      // Section Premiers pas
                      _buildFirstStepsSection(viewModel),

                      const SizedBox(height: 32),

                      // Section Articles
                      _buildArticlesSection(viewModel),

                      const SizedBox(height: 100), // Espace pour la navigation
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildWelcomeHeader() {
    return SliverToBoxAdapter(
      child: Container(
        color: AppColors.vertEcolink,
        padding: const EdgeInsets.fromLTRB(16, 60, 16, 32),
        child: Column(
          children: [
            // Icône de recyclage
            const Icon(
              Icons.recycling,
              color: AppColors.blanc,
              size: 48,
            ),
            const SizedBox(height: 16),

            // Titre de bienvenue
            const Text(
              'Bienvenue sur Ecolink !',
              style: TextStyle(
                color: AppColors.blanc,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Message d'action
            const Text(
              'Envie d\'agir pour la planète ?\nRejoins-nous pour passer à l\'action...',
              style: TextStyle(
                color: AppColors.blanc,
                fontSize: 16,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Bouton d'inscription
            ElevatedButton(
              onPressed: () {
                // TODO: Navigation vers l'inscription
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.blanc,
                foregroundColor: AppColors.vertEcolink,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text(
                'Je m\'inscris',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoodDealsSection(WelcomeViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Bons plans autour de moi',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.noir,
          ),
        ),
        const SizedBox(height: 16),
        if (viewModel.isLoadingGoodDeals)
          const Center(child: CircularProgressIndicator())
        else if (viewModel.hasError)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              viewModel.errorMessage ?? 'Une erreur est survenue.',
              style: const TextStyle(color: Colors.red),
            ),
          )
        else if (viewModel.goodDeals.isNotEmpty)
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: viewModel.goodDeals.length,
              itemBuilder: (context, index) {
                final deal = viewModel.goodDeals[index];
                return _buildGoodDealCard(deal, viewModel);
              },
            ),
          )
        else
          const Text(
            'Aucun bon plan pour le moment.',
            style: TextStyle(color: AppColors.grisClair),
          ),
      ],
    );
  }

  Widget _buildGoodDealCard(GoodDeal deal, WelcomeViewModel viewModel) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: AppColors.blanc,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder (à remplacer par l'image réelle)
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: const Center(
              child: Icon(Icons.image, size: 48, color: Colors.grey),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  deal.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.noir,
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => viewModel.onGoodDealTap(deal),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.vertEcolink,
                    foregroundColor: AppColors.blanc,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(deal.actionText),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFirstStepsSection(WelcomeViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: const TextSpan(
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.noir),
            children: [
              TextSpan(text: 'Mes premiers pas sur '),
              TextSpan(
                text: 'EcoLink',
                style: TextStyle(color: AppColors.vertEcolink),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                icon: Icons.person_add,
                title: 'Créez un compte',
                onTap: viewModel.onCreateAccountTap,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildActionCard(
                icon: Icons.group,
                title: 'Partagez à un ami',
                onTap: viewModel.onShareWithFriendTap,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: AppColors.vertEcolink,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.blanc, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: AppColors.blanc,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArticlesSection(WelcomeViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Articles',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.noir,
              ),
            ),
            GestureDetector(
              onTap: viewModel.onSeeMoreArticlesTap,
              child: const Text(
                'VOIR PLUS →',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.vertEcolink,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (viewModel.isLoadingArticles)
          const Center(child: CircularProgressIndicator())
        else if (viewModel.hasError)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              viewModel.errorMessage ?? 'Une erreur est survenue.',
              style: const TextStyle(color: Colors.red),
            ),
          )
        else if (viewModel.articles.isNotEmpty)
          SizedBox(
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: viewModel.articles.length,
              itemBuilder: (context, index) {
                final article = viewModel.articles[index];
                return _buildArticleCard(article, viewModel);
              },
            ),
          )
        else
          const Text(
            'Aucun article pour le moment.',
            style: TextStyle(color: AppColors.grisClair),
          ),
      ],
    );
  }

  Widget _buildArticleCard(Article article, WelcomeViewModel viewModel) {
    return Container(
      width: 250,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.blue[600],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              article.title,
              style: const TextStyle(
                color: AppColors.blanc,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              article.date,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Text(
                article.description,
                style: const TextStyle(
                  color: AppColors.blanc,
                  fontSize: 14,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '08/2025 à 18h05',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
                ElevatedButton(
                  onPressed: () => viewModel.onArticleTap(article),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.violet,
                    foregroundColor: AppColors.blanc,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(article.readMoreText),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      height: 80,
      decoration: const BoxDecoration(
        color: AppColors.vertEcolink,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(Icons.notifications, 'Notifications', false),
          _buildNavItem(Icons.shopping_cart, 'Panier', false),
          _buildNavItem(Icons.home, 'Accueil', true),
          _buildNavItem(Icons.recycling, 'Recyclage', false),
          _buildNavItem(Icons.person, 'Profil', false),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isSelected) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.blanc : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            icon,
            color: isSelected ? AppColors.vertEcolink : AppColors.blanc,
            size: 24,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.vertEcolink : AppColors.blanc,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
