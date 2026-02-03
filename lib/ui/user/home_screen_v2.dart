import 'package:flutter/material.dart';
import 'package:ecolink/ui/core/themes/colors.dart';
import 'package:ecolink/ui/core/ui/shared_widgets.dart';
import 'package:ecolink/ui/core/ui/custom_nav_bar.dart';
import 'package:ecolink/ui/user/scan_flow.dart';

import '../../domain/models/user.dart';

class HomeScreenV2 extends StatelessWidget {
  const HomeScreenV2({super.key, this.user});

  final User? user;

  @override
  Widget build(BuildContext context) {
    final displayName = user?.name ?? 'Bonjour';

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: HeaderHero(
              title: 'Hello, $displayName',
              subtitle: 'Continuez d\'agir pour la planète et gagner un badge',
              showCTA: false,
              leadingImage: CircleAvatar(
                radius: 24,
                backgroundColor: Colors.white,
                child: const Icon(Icons.person, color: AppColors.vertEcolink),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            sliver: const SliverToBoxAdapter(
                child: SectionTitle('Bons plans autour de moi')),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GoodDealHighlight(deal: null, onTrain: () {}),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
            sliver: const SliverToBoxAdapter(
                child: SectionTitle.rich(
                    leading: 'Je recycle avec ', accent: 'EcoLink')),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                      child: QuickActionCard(
                          title: 'Prenez une image',
                          icon: Icons.camera_alt_rounded,
                          onTap: () => startScanFlow(context))),
                  const SizedBox(width: 12),
                  Expanded(
                      child: QuickActionCard(
                          title: 'Mes activités',
                          icon: Icons.show_chart,
                          onTap: () {})),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
            sliver: SliverToBoxAdapter(
              child: Row(
                children: const [
                  SectionTitle('Articles'),
                  Spacer(),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 250,
              child: ListView.separated(
                padding: const EdgeInsets.only(left: 16, right: 8),
                scrollDirection: Axis.horizontal,
                itemCount: 2,
                separatorBuilder: (_, __) => const SizedBox(width: 16),
                itemBuilder: (context, i) =>
                    ArticleCardLarge(article: null, onTap: () {}),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
      bottomNavigationBar: CurvyNavbar(index: 2, onChanged: (i) {}),
    );
  }
}
