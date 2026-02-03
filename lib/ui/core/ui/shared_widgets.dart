import 'package:flutter/material.dart';
import '../themes/colors.dart';

// Public header widget used by Welcome and Home
class HeaderHero extends StatelessWidget {
  const HeaderHero({
    super.key,
    required this.title,
    required this.subtitle,
    this.showCTA = true,
    this.ctaLabel = 'Je m\'inscris',
    this.onCta,
    this.leadingImage,
  });

  final String title;
  final String subtitle;
  final bool showCTA;
  final String ctaLabel;
  final VoidCallback? onCta;
  final Widget? leadingImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: AppColors.vertEcolink),
      padding: const EdgeInsets.fromLTRB(16, 36, 16, 20),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          leadingImage ??
              Image.asset('assets/images/logo_ecolink_blank.png',
                  height: 34, width: 34, fit: BoxFit.contain),
          const SizedBox(height: 16),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, height: 1.3),
          ),
          const SizedBox(height: 14),
          if (showCTA)
            SizedBox(
              width: 170,
              child: ElevatedButton(
                onPressed: onCta,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.vertEcolink,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  ctaLabel,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key})
      : leading = null,
        accent = null;
  const SectionTitle.rich(
      {super.key, required this.leading, required this.accent})
      : text = null;

  final String? text;
  final String? leading;
  final String? accent;

  @override
  Widget build(BuildContext context) {
    final style = const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    );
    if (text != null) return Text(text!, style: style);
    return RichText(
      text: TextSpan(
        text: leading,
        style: style,
        children: [
          TextSpan(
            text: accent ?? 'EcoLink',
            style: const TextStyle(color: AppColors.vertEcolink),
          ),
        ],
      ),
    );
  }
}

class GoodDealHighlight extends StatelessWidget {
  const GoodDealHighlight(
      {super.key, required this.deal, required this.onTrain});
  final dynamic deal; // Keep dynamic to avoid coupling
  final VoidCallback onTrain;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: (deal?.imageUrl != null)
                ? Image.asset(deal!.imageUrl, fit: BoxFit.cover)
                : Container(color: const Color(0xFFEFEFEF)),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
            decoration: const BoxDecoration(color: Colors.white),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    deal?.title ??
                        'Comment recycler les bouteilles plastiques ?',
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, color: Colors.black87),
                  ),
                ),
                const SizedBox(width: 8),
                PillButton(label: 'ME FORMER', onTap: onTrain),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PillButton extends StatelessWidget {
  const PillButton({super.key, required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.vertEcolink,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Text(label,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                  letterSpacing: .2)),
        ),
      ),
    );
  }
}

class QuickActionCard extends StatelessWidget {
  const QuickActionCard(
      {super.key,
      required this.title,
      required this.icon,
      required this.onTap});
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.vertEcolink,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 96,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14)),
                const Spacer(),
                Align(
                    alignment: Alignment.bottomRight,
                    child: Icon(icon, color: Colors.white, size: 40)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ArticleCardLarge extends StatelessWidget {
  const ArticleCardLarge(
      {super.key, required this.article, required this.onTap});
  final dynamic article;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      child: Material(
        color: Colors.white,
        elevation: .5,
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  height: 120,
                  width: 260,
                  color: const Color(0xFFEFF4FF),
                  child: (article?.imageUrl != null)
                      ? Image.asset(article!.imageUrl, fit: BoxFit.cover)
                      : const SizedBox.shrink()),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(article?.title ?? 'Journée de l’Écologie',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 16)),
                      const SizedBox(height: 6),
                      Text(
                          article?.description ??
                              'La journée Mondiale de l’Écologie…',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 13,
                              height: 1.25)),
                    ]),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                child: Row(children: [
                  Text(article?.date ?? '08/2025 • 11h05',
                      style:
                          const TextStyle(fontSize: 11, color: Colors.black45)),
                  const Spacer(),
                  Align(
                      alignment: Alignment.bottomLeft, child: _TinyReadMore()),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TinyReadMore extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 22,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          color: const Color(0xFFE7EEF8),
          borderRadius: BorderRadius.circular(999)),
      alignment: Alignment.center,
      child: const Text('Lire…',
          style: TextStyle(fontSize: 12, color: Colors.black87)),
    );
  }
}
