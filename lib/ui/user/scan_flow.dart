import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ecolink/ui/core/themes/colors.dart';
import 'package:ecolink/routing/routes.dart';

/// Public helper to start the simple scan flow:
/// 1) open camera and take picture
/// 2) show "Scan en cours" loader for 5s
/// 3) show detection result screen with action buttons
Future<void> startScanFlow(BuildContext context) async {
  // Capture the messenger and navigator before any async gaps
  final messenger = ScaffoldMessenger.of(context);
  final navigator = Navigator.of(context);

  // Ensure camera permission
  final permissionStatus = await Permission.camera.status;
  if (!permissionStatus.isGranted) {
    final result = await Permission.camera.request();
    if (!result.isGranted) {
      messenger.showSnackBar(const SnackBar(
          content:
              Text('La permission caméra est requise pour prendre une photo')));
      return;
    }
  }

  final picker = ImagePicker();
  try {
    final XFile? file = await picker.pickImage(source: ImageSource.camera);
    if (file == null) return; // user cancelled

    // Show the loader page while "scanning"
    navigator.push(MaterialPageRoute(
      builder: (_) => ScanLoadingPage(imageFile: File(file.path)),
    ));
  } catch (e) {
    // Generic error handling - show dialog to user and log
    if (navigator.mounted) {
      showDialog(
          context: navigator.context,
          builder: (_) => AlertDialog(
                title: const Text('Erreur'),
                content: Text('Impossible d\'ouvrir la caméra: $e'),
                actions: [
                  TextButton(
                      onPressed: () => navigator.pop(), child: const Text('OK'))
                ],
              ));
    }
  }
}

class ScanLoadingPage extends StatefulWidget {
  const ScanLoadingPage({super.key, required this.imageFile});
  final File imageFile;

  @override
  State<ScanLoadingPage> createState() => _ScanLoadingPageState();
}

class _ScanLoadingPageState extends State<ScanLoadingPage>
    with SingleTickerProviderStateMixin {
  Timer? _timer;
  AnimationController? _animController;
  bool _showCompletion = false;

  @override
  void initState() {
    super.initState();
    // Simulate 5s scan then play a short completion animation
    _timer = Timer(const Duration(seconds: 5), _startCompletionAnimation);
  }

  void _startCompletionAnimation() {
    if (!mounted) return;
    setState(() => _showCompletion = true);
    _animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    _animController!.addStatusListener((s) {
      if (s == AnimationStatus.completed && mounted) {
        // Slide up transition to the result page
        Navigator.of(context).pushReplacement(PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (_, __, ___) => DetectionResultPage(
            imageFile: widget.imageFile,
          ),
          transitionsBuilder: (_, animation, __, child) {
            final offset = Tween<Offset>(
                    begin: const Offset(0, 1), end: Offset.zero)
                .animate(
                    CurvedAnimation(parent: animation, curve: Curves.easeOut));
            return SlideTransition(position: offset, child: child);
          },
        ));
      }
    });
    _animController!.forward();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Show the captured image dimmed in background
          Image.file(widget.imageFile, fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.45)),
          Center(
            child: _showCompletion
                ? ScaleTransition(
                    scale: Tween(begin: 0.6, end: 1.0).animate(CurvedAnimation(
                        parent: _animController!, curve: Curves.elasticOut)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.check_circle_outline,
                            color: Colors.white, size: 88),
                        SizedBox(height: 16),
                        Text('Détection terminée',
                            style:
                                TextStyle(color: Colors.white, fontSize: 18)),
                      ],
                    ),
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      SizedBox(height: 16),
                      CircularProgressIndicator(color: Colors.white),
                      SizedBox(height: 16),
                      Text('Scan en cours',
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                    ],
                  ),
          )
        ],
      ),
    );
  }
}

class DetectionResultPage extends StatelessWidget {
  const DetectionResultPage({super.key, required this.imageFile});
  final File imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // background image
          Positioned.fill(child: Image.file(imageFile, fit: BoxFit.cover)),
          // dark overlay
          Container(color: Colors.black.withOpacity(0.25)),

          // Bottom sheet-like card
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 26),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text('Type de déchet détecté',
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 16)),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context)
                            .pushNamedAndRemoveUntil(
                                AppRoutes.welcome, (_) => false),
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text('Bouteille Plastique',
                      style: TextStyle(
                          color: AppColors.vertEcolink,
                          fontWeight: FontWeight.w800,
                          fontSize: 18)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // For now, redirect to Home
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                AppRoutes.home, (_) => false);
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.vertEcolink,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8))),
                          child: const Text('Point de dépôt',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            // For now, redirect to Home as well
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                AppRoutes.home, (_) => false);
                          },
                          style: OutlinedButton.styleFrom(
                            side:
                                const BorderSide(color: AppColors.vertEcolink),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text('Astuce',
                              style: TextStyle(color: AppColors.vertEcolink)),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
