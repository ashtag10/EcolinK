import 'package:ecolink/ui/core/ui/custom_nav_bar.dart';
import 'package:ecolink/ui/dev/notch_playground.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../routing/routes.dart';
import '../../core/ui/shared_widgets.dart';
import '../../core/localization/applocalization.dart';

import '../view_models/welcome_view_model.dart';
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
    // Variante safe : aucun usage de context après await
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = Provider.of<WelcomeViewModel>(context, listen: false);
      vm.loadAll();
    });
  }

  int _navIndex = 2;

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<WelcomeViewModel>();
    final dimens = Dimens.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // ======= HEADER vert avec CTA =======
          SliverToBoxAdapter(
              child: HeaderHero(
            title: AppLocalization.of(context).welcome,
            subtitle: AppLocalization.of(context).joinAction,
            onCta: () => context.go(AppRoutes.register),
          )),

          // ======= Bons plans autour de moi =======
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              dimens.paddingScreenHorizontal,
              20,
              dimens.paddingScreenHorizontal,
              12,
            ),
            sliver: const SliverToBoxAdapter(
              child: SectionTitle('Bons plans autour de moi'),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: dimens.paddingScreenHorizontal,
              ),
              child: GoodDealHighlight(
                deal: (vm.state == WelcomeUiState.ready &&
                        vm.goodDeals.isNotEmpty)
                    ? vm.goodDeals.first
                    : null,
                onTrain: () {
                  // TODO: action "ME FORMER"

                  // depuis n’importe où juste pour tester la barre
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => const NotchPlaygroundPage()),
                  ); // juste pour tester la barre
                },
              ),
            ),
          ),

          // ======= Mes premiers pas sur EcoLink =======
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              dimens.paddingScreenHorizontal,
              24,
              dimens.paddingScreenHorizontal,
              8,
            ),
            sliver: const SliverToBoxAdapter(
              child: SectionTitle.rich(
                leading: 'Mes premiers pas sur ',
                accent: 'EcoLink',
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Dimens.of(context).paddingScreenHorizontal,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: QuickActionCard(
                      title: 'Créez un compte',
                      icon: Icons.person_add_alt_1_rounded,
                      onTap: () {
                        context.go(AppRoutes.register);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: QuickActionCard(
                      title: 'Partagez à un ami',
                      icon: Icons.group_add_rounded,
                      onTap: () {
                        // TODO
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ======= Articles =======
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              dimens.paddingScreenHorizontal,
              24,
              dimens.paddingScreenHorizontal,
              8,
            ),
            sliver: SliverToBoxAdapter(
              child: Row(
                children: [
                  const SectionTitle('Articles'),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () {
                      // TODO: ouvrir liste complète
                    },
                    icon: const Text(
                      'VOIR PLUS',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        letterSpacing: .2,
                        color: AppColors.vertEcolink,
                      ),
                    ),
                    label: const Icon(
                      Icons.arrow_forward_rounded,
                      size: 18,
                      color: AppColors.vertEcolink,
                    ),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 250,
              child: ListView.separated(
                padding: EdgeInsets.only(
                  left: dimens.paddingScreenHorizontal,
                  right: 8,
                ),
                scrollDirection: Axis.horizontal,
                itemCount: (vm.state == WelcomeUiState.ready)
                    ? vm.articles.length
                    : 2, // placeholders
                separatorBuilder: (_, __) => const SizedBox(width: 16),
                itemBuilder: (context, i) {
                  final art = (vm.state == WelcomeUiState.ready)
                      ? vm.articles[i]
                      : null;
                  return ArticleCardLarge(
                    article: art,
                    onTap: () {
                      // TODO: ouvrir article
                    },
                  );
                },
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),

      // ======= Bottom Navigation style custom =======
      bottomNavigationBar: CurvyNavbar(
        index: _navIndex,
        onChanged: (i) {
          setState(() => _navIndex = i);
          // TODO: ici, change d’onglet / route selon i
          // ex: if (i == 2) context.go('/home');
        },
      ),
    );
  }
}

/* ===========================
 *  WIDGETS
 * ===========================
 */

// Widgets moved to `shared_widgets.dart` to allow reuse by HomeScreen and others.
