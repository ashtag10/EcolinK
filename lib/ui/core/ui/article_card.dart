import 'package:flutter/material.dart';
import '../../../domain/models/welcome_data.dart';
import '../themes/colors.dart';

class ArticleCard extends StatelessWidget {
  final Article article;
  final VoidCallback onTap;
  final double width;
  final double height;

  const ArticleCard({
    super.key,
    required this.article,
    required this.onTap,
    this.width = 250,
    this.height = 180,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: AppColors.violet,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titre de l'article
            Text(
              article.title,
              style: const TextStyle(
                color: AppColors.blanc,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),

            // Date de l'article
            Text(
              article.date,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),

            // Description de l'article
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

            // Footer avec date et bouton
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
                  onPressed: onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.vertEcolink,
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
}
