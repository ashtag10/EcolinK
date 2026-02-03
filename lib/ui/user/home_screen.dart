import 'package:flutter/material.dart';
import 'package:ecolink/ui/core/themes/colors.dart';

import '../../domain/models/user.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, this.user});

  final User? user;

  @override
  Widget build(BuildContext context) {
    final displayName = user?.name ?? 'Bonjour';
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Green header
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              decoration: const BoxDecoration(color: AppColors.vertEcolink),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.share, color: Colors.white),
                        onPressed: () {},
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.logout, color: Colors.white),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Hello, $displayName',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.white,
                        child: const Icon(Icons.person,
                            color: AppColors.vertEcolink),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Continuez d\'agir pour la planète et gagner un badge',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),

            // Content header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
              child: const Text('Bons plans autour de moi',
                  style: TextStyle(fontWeight: FontWeight.w700)),
            ),

            // Good deal card (simplified)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Material(
                elevation: 1,
                borderRadius: BorderRadius.circular(12),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Container(color: const Color(0xFFEFEFEF)),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      color: Colors.white,
                      child: Row(
                        children: [
                          const Expanded(
                              child: Text(
                                  'Comment recycler les bouteilles plastiques ?',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w600))),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.vertEcolink),
                            child: const Text('ME FORMER',
                                style: TextStyle(color: Colors.white)),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),

            // Placeholder for the rest
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 86,
                      decoration: BoxDecoration(
                          color: AppColors.vertEcolink,
                          borderRadius: BorderRadius.circular(12)),
                      child: Center(
                          child: Text('Prenez une image',
                              style: TextStyle(color: Colors.white))),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      height: 86,
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12)),
                      child: Center(
                          child: Text('Mes activités',
                              style: TextStyle(color: Colors.black87))),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),
            const Expanded(
                child: Center(
                    child: Text('Articles / Flux - (contenu simplifié)')))
          ],
        ),
      ),
    );
  }
}
