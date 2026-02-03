// lib/ui/dev/notch_playground.dart
import 'package:flutter/material.dart';
import '../core/themes/colors.dart';

class NotchPlaygroundPage extends StatefulWidget {
  const NotchPlaygroundPage({super.key});

  @override
  State<NotchPlaygroundPage> createState() => _NotchPlaygroundPageState();
}

class _NotchPlaygroundPageState extends State<NotchPlaygroundPage> {
  // Paramètres de l’encoche
  double w = 120;     // largeur
  double h = 58;      // profondeur
  double c1x = 0.30;  // ratio 1er point de contrôle (X)
  double c2x = 0.28;  // ratio 2e point de contrôle (X)
  double cy  = 0.55;  // ratio hauteur des points de contrôle (Y)
  bool  symmetric = true;

  // UI
  double barHeight = 70;
  double previewHeight = 200;
  double centerButton = 64;
  double buttonBottomOffset = 18;

  @override
  Widget build(BuildContext context) {
    final bg = Theme.of(context).scaffoldBackgroundColor;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notch Playground (Bézier)'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ==== PREVIEW ====
          SizedBox(
            height: previewHeight,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                SizedBox(
                  height: barHeight,
                  width: double.infinity,
                  child: CustomPaint(
                    painter: _BarPainter(
                      color: AppColors.vertEcolink,
                      background: bg,
                      w: w,
                      h: h,
                      c1x: c1x,
                      c2x: c2x,
                      cy: cy,
                      drawHelpers: true, // dessine les points/handles
                      symmetric: symmetric,
                    ),
                  ),
                ),
                // Bouton central (pour visualiser le rendu final)
                Positioned(
                  bottom: buttonBottomOffset,
                  child: Container(
                    height: centerButton,
                    width: centerButton,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 14,
                          offset: Offset(0, 6),
                          color: Color(0x33000000),
                        )
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Icon(Icons.home_rounded,
                        color: AppColors.vertEcolink, size: 28),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ==== SLIDERS ====
          _SliderTile(
            label: 'Largeur w (px)',
            value: w, min: 80, max: 220, divisions: 140,
            onChanged: (v) => setState(() => w = v),
          ),
          _SliderTile(
            label: 'Profondeur h (px)',
            value: h, min: 30, max: 100, divisions: 70,
            onChanged: (v) => setState(() => h = v),
          ),
          const Divider(height: 24),
          SwitchListTile(
            value: symmetric,
            onChanged: (v) => setState(() => symmetric = v),
            title: const Text('Contrôles symétriques (gauche/droite)'),
          ),
          _SliderTile(
            label: 'Contrôle X gauche – c1x (0.20 → 0.50)',
            value: c1x, min: 0.20, max: 0.50, divisions: 30,
            onChanged: (v) => setState(() => c1x = v),
          ),
          _SliderTile(
            label: 'Contrôle X gauche – c2x (0.20 → 0.50)',
            value: c2x, min: 0.20, max: 0.50, divisions: 30,
            onChanged: (v) => setState(() => c2x = v),
          ),
          _SliderTile(
            label: 'Contrôle Y (hauteur) – cy (0.30 → 0.80)',
            value: cy, min: 0.30, max: 0.80, divisions: 50,
            onChanged: (v) => setState(() => cy = v),
          ),
          const Divider(height: 24),

          // ==== OPTIONS VISUELLES ====
          _SliderTile(
            label: 'Hauteur de barre (préview)',
            value: barHeight, min: 56, max: 100, divisions: 44,
            onChanged: (v) => setState(() => barHeight = v),
          ),
          _SliderTile(
            label: 'Diamètre bouton central',
            value: centerButton, min: 48, max: 80, divisions: 32,
            onChanged: (v) => setState(() => centerButton = v),
          ),
          _SliderTile(
            label: 'Décalage bas du bouton',
            value: buttonBottomOffset, min: 8, max: 28, divisions: 20,
            onChanged: (v) => setState(() => buttonBottomOffset = v),
          ),

          const SizedBox(height: 16),
          _CodePreview(
            w: w, h: h, c1x: c1x, c2x: c2x, cy: cy, symmetric: symmetric,
          ),
        ],
      ),
    );
  }
}

class _SliderTile extends StatelessWidget {
  const _SliderTile({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    this.divisions,
  });

  final String label;
  final double value, min, max;
  final int? divisions;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600))),
            Text(value.toStringAsFixed(2)),
          ],
        ),
        Slider(
          value: value, min: min, max: max, divisions: divisions,
          onChanged: onChanged,
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _CodePreview extends StatelessWidget {
  const _CodePreview({
    required this.w,
    required this.h,
    required this.c1x,
    required this.c2x,
    required this.cy,
    required this.symmetric,
  });

  final double w, h, c1x, c2x, cy;
  final bool symmetric;

  @override
  Widget build(BuildContext context) {
    final code = '''
// Paramètres (à mettre dans ton painter)
const w = ${w.toStringAsFixed(1)};
const h = ${h.toStringAsFixed(1)};
const c1x = ${c1x.toStringAsFixed(2)};
const c2x = ${c2x.toStringAsFixed(2)};
const cy  = ${cy.toStringAsFixed(2)};
final cx = size.width / 2;

final notch = Path()
  ..moveTo(cx - w/2, 0)
  ..cubicTo(cx - w*c1x, 0, cx - w*c2x, h*cy, cx, h)
  ..cubicTo(cx + w*${symmetric ? 'c2x' : c2x.toStringAsFixed(2)}, h*cy,
            cx + w*${symmetric ? 'c1x' : c1x.toStringAsFixed(2)}, 0,
            cx + w/2, 0)
  ..close();
''';

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF6F8FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      padding: const EdgeInsets.all(12),
      child: SelectableText(code, style: const TextStyle(fontFamily: 'monospace', fontSize: 12)),
    );
  }
}

/// Painter de la barre + encoche, avec helpers pour visualiser les points.
class _BarPainter extends CustomPainter {
  _BarPainter({
    required this.color,
    required this.background,
    required this.w,
    required this.h,
    required this.c1x,
    required this.c2x,
    required this.cy,
    required this.symmetric,
    this.drawHelpers = false,
  });

  final Color color;
  final Color background;
  final double w, h, c1x, c2x, cy;
  final bool symmetric;
  final bool drawHelpers;

  @override
  void paint(Canvas canvas, Size size) {
    // 1) Fond de barre
    final barPaint = Paint()..color = color;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), barPaint);

    // 2) Encoche (goutte inversée)
    final cx = size.width / 2;
    final notch = Path()
      ..moveTo(cx - w/2, 0)
      ..cubicTo(cx - w*c1x, 0, cx - w*c2x, h*cy, cx, h)
      ..cubicTo(
        cx + w*(symmetric ? c2x : c2x),
        h*cy,
        cx + w*(symmetric ? c1x : c1x),
        0,
        cx + w/2,
        0,
      )
      ..close();

    final notchPaint = Paint()..color = background;
    canvas.drawPath(notch, notchPaint);

    // 3) Aides visuelles : points & segments des contrôles
    if (drawHelpers) {
      final help = Paint()
        ..color = Colors.black26
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;

      final leftStart = Offset(cx - w/2, 0);
      final leftC1   = Offset(cx - w*c1x, 0);
      final leftC2   = Offset(cx - w*c2x, h*cy);
      final mid      = Offset(cx, h);
      final rightC2  = Offset(cx + w*(symmetric ? c2x : c2x), h*cy);
      final rightC1  = Offset(cx + w*(symmetric ? c1x : c1x), 0);
      final rightEnd = Offset(cx + w/2, 0);

      // segments
      canvas.drawLine(leftStart, leftC1, help);
      canvas.drawLine(leftC2, mid, help);
      canvas.drawLine(mid, rightC2, help);
      canvas.drawLine(rightC1, rightEnd, help);

      // points
      void dot(Offset o, {Color c = Colors.red}) {
        final p = Paint()..color = c;
        canvas.drawCircle(o, 3, p);
      }

      dot(leftStart, c: Colors.blue);
      dot(leftC1);
      dot(leftC2);
      dot(mid, c: Colors.green);
      dot(rightC2);
      dot(rightC1);
      dot(rightEnd, c: Colors.blue);
    }
  }

  @override
  bool shouldRepaint(covariant _BarPainter old) {
    return color != old.color ||
        w != old.w || h != old.h ||
        c1x != old.c1x || c2x != old.c2x || cy != old.cy ||
        drawHelpers != old.drawHelpers ||
        symmetric != old.symmetric;
  }
}
