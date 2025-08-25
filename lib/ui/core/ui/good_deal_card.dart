import 'package:flutter/material.dart';
import '../../../domain/models/welcome_data.dart';
import '../themes/colors.dart';

class GoodDealCard extends StatelessWidget {
  final GoodDeal deal;
  final VoidCallback onTap;
  final double width;
  final double height;

  const GoodDealCard({
    super.key,
    required this.deal,
    required this.onTap,
    this.width = 280,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
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
          // Image du bon plan
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: deal.imageUrl.isNotEmpty
                ? ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.asset(
                      deal.imageUrl,
                      width: double.infinity,
                      height: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Center(
                        child: Icon(Icons.image, size: 48, color: Colors.grey),
                      ),
                    ),
                  )
                : const Center(
                    child: Icon(Icons.image, size: 48, color: Colors.grey),
                  ),
          ),

          // Contenu de la card
          Expanded(
            child: Padding(
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
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    deal.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.grisClair,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.vertEcolink,
                        foregroundColor: AppColors.blanc,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(deal.actionText),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
