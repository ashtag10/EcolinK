import 'package:flutter/material.dart';
import 'dart:math';
import 'package:go_router/go_router.dart';
import '../../routing/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _trashController;
  late AnimationController _logoController;

  final List<Offset> sources = [
    const Offset(0.1, 0.1), // haut gauche
    const Offset(0.9, 0.2), // haut droite
    const Offset(0.2, 0.9), // bas gauche
    const Offset(0.8, 0.85), // bas droite
    const Offset(0.5, 1.0), // bas centre
  ];

  @override
  void initState() {
    super.initState();

    _trashController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..forward();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _trashController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _logoController.forward();
      }
    });

    // Navigation automatique après l'animation complète
    _logoController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Attendre un peu pour que l'utilisateur voie le logo final
        Future.delayed(const Duration(milliseconds: 1500), () {
          if (mounted) {
            context.go(AppRoutes.welcome);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _trashController.dispose();
    _logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final center = Offset(size.width / 2, size.height / 2);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // --- Background aligné en bas ---
          Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              "assets/images/background.png",
              fit: BoxFit.fill,
              width: size.width,
            ),
          ),

          // --- Lignes de connexion entre sources et centre ---
          CustomPaint(
            size: size,
            painter: ConnectionPainter(sources, center, _trashController),
          ),

          // --- Déchets animés (spirale + rotation recyclage) ---
          AnimatedBuilder(
            animation: _trashController,
            builder: (context, child) {
              final progress =
                  Curves.easeInOutCubic.transform(_trashController.value);
              final trashWidgets = <Widget>[];

              for (int i = 0; i < sources.length; i++) {
                final source = Offset(
                  sources[i].dx * size.width,
                  sources[i].dy * size.height,
                );

                // interpolation courbée (spirale)
                final t = progress;
                final dx = source.dx + (center.dx - source.dx) * t;
                final dy = source.dy + (center.dy - source.dy) * t;

                // ajout d'une spirale (rotation autour du chemin)
                final spiralRadius = 40 * (1 - t);
                final spiralAngle = t * 6 * pi + (i * pi / 3);
                final offset = Offset(
                  dx + cos(spiralAngle) * spiralRadius,
                  dy + sin(spiralAngle) * spiralRadius,
                );

                // rotation de l'icône
                final angle = t * 6 * pi;

                trashWidgets.add(Positioned(
                  left: offset.dx - 24,
                  top: offset.dy - 24,
                  child: Opacity(
                    opacity: 1 - t,
                    child: Transform.rotate(
                      angle: angle,
                      child: Image.asset(
                        "assets/images/bottle.png",
                        width: 48,
                        height: 48,
                      ),
                    ),
                  ),
                ));
              }

              return Stack(children: trashWidgets);
            },
          ),

          // --- Logo final ---
          Center(
            child: ScaleTransition(
              scale: CurvedAnimation(
                parent: _logoController,
                curve: Curves.elasticOut,
              ),
              child: FadeTransition(
                opacity: _logoController,
                child: Image.asset(
                  "assets/images/logo_name_ecolink.png",
                  width: 300,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Painter pour les lignes de connexion ---
class ConnectionPainter extends CustomPainter {
  final List<Offset> sources;
  final Offset center;
  final Animation<double> animation;

  ConnectionPainter(this.sources, this.center, this.animation)
      : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final progress = animation.value;

    for (var src in sources) {
      final source = Offset(src.dx * size.width, src.dy * size.height);

      final currentPoint = Offset(
        source.dx + (center.dx - source.dx) * progress,
        source.dy + (center.dy - source.dy) * progress,
      );

      final paint = Paint()
        ..color = Colors.green
            .withOpacity((1 - progress) * 0.4) // opacité décroissante
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;

      canvas.drawLine(source, currentPoint, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
