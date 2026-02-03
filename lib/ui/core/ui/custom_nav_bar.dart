import 'package:flutter/material.dart';
import 'package:ecolink/ui/core/themes/colors.dart';

const kBarGreen = AppColors.vertEcolink;

class CurvyNavbar extends StatefulWidget {
  const CurvyNavbar({
    super.key,
    required this.index,
    required this.onChanged,
    this.items = const [
      Icons.notifications_rounded,
      Icons.shopping_cart_rounded,
      Icons.home_rounded, // centre
      Icons.delete_sweep_rounded,
      Icons.person_rounded,
    ],
    this.activeColor = AppColors.vertEcolink,
    this.inactiveColor = Colors.white,
  });

  final int index;
  final ValueChanged<int> onChanged;
  final List<IconData> items;
  final Color activeColor;
  final Color inactiveColor;

  @override
  State<CurvyNavbar> createState() => _CurvyNavbarState();
}

class _CurvyNavbarState extends State<CurvyNavbar>
    with SingleTickerProviderStateMixin {
  // fractions horizontales (0..1) = centres des 5 icônes
  static const List<double> _fractions = [0.10, 0.30, 0.50, 0.70, 0.90];

  late double _currentFrac = _fractions[widget.index.clamp(0, 4)];
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 320),
  );
  Animation<double>? _anim;

  @override
  void didUpdateWidget(covariant CurvyNavbar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.index != widget.index) {
      final to = _fractions[widget.index.clamp(0, 4)];
      _anim = Tween(begin: _currentFrac, end: to)
          .chain(CurveTween(curve: Curves.easeOutCubic))
          .animate(_c)
        ..addListener(() => setState(() => _currentFrac = _anim!.value));
      _c.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    const double navHeight = 80;
    const double barHeight = 70;
    const double iconSize = 26;
    final double bottomOffset =
        (barHeight - iconSize) / 2; // ⇦ centre vertical parfait

    final bg = Theme.of(context).scaffoldBackgroundColor;

    return SafeArea(
      top: false,
      child: SizedBox(
        height: navHeight,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;

            return Stack(
              alignment: Alignment.bottomCenter,
              children: [
                // Barre + encoche (alignée par fraction)
                SizedBox(
                  height: barHeight,
                  width: double.infinity,
                  child: CustomPaint(
                    painter: _BarPainter(
                      color: kBarGreen,
                      background: bg,
                      centerXFraction: _currentFrac,
                    ),
                  ),
                ),

                // Icônes : positionnées par 'left' à partir des mêmes fractions
                // => centrage horizontal 1:1 avec l’encoche
                ...List.generate(widget.items.length, (i) {
                  final selected = i == widget.index;
                  final cx = _fractions[i] * w; // centre de l'icône
                  final left = cx - iconSize / 2; // coin gauche pour centrer
                  return Positioned(
                    left: left,
                    bottom: bottomOffset,
                    width: iconSize,
                    height: iconSize,
                    child: _NavIcon(
                      icon: widget.items[i],
                      selected: selected,
                      activeColor: widget.activeColor,
                      inactiveColor: widget.inactiveColor,
                      onTap: () => widget.onChanged(i),
                    ),
                  );
                }),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Painter: barre verte + encoche concave (Bézier) centrée à centerXFraction
class _BarPainter extends CustomPainter {
  _BarPainter({
    required this.color,
    required this.background,
    required this.centerXFraction,
  });

  final Color color;
  final Color background;
  final double centerXFraction;

  @override
  void paint(Canvas canvas, Size size) {
    // fond
    final barPaint = Paint()..color = color;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), barPaint);

    // encoche (TES paramètres)
    const double w = 128.0;
    const double h = 70.0;
    const double c1x = 0.20;
    const double c2x = 0.46;
    const double cy = 0.80;

    final cx = size.width * centerXFraction;

    final notch = Path()
      ..moveTo(cx - w / 2, 0)
      ..cubicTo(cx - w * c1x, 0, cx - w * c2x, h * cy, cx, h)
      ..cubicTo(cx + w * c2x, h * cy, cx + w * c1x, 0, cx + w / 2, 0)
      ..close();

    final notchPaint = Paint()..color = background;
    canvas.drawPath(notch, notchPaint);
  }

  @override
  bool shouldRepaint(covariant _BarPainter old) =>
      old.centerXFraction != centerXFraction || old.color != color;
}

/// Icône de nav: couleur + scale animés
class _NavIcon extends StatefulWidget {
  const _NavIcon({
    required this.icon,
    required this.selected,
    required this.activeColor,
    required this.inactiveColor,
    required this.onTap,
  });

  final IconData icon;
  final bool selected;
  final Color activeColor;
  final Color inactiveColor;
  final VoidCallback onTap;

  @override
  State<_NavIcon> createState() => _NavIconState();
}

class _NavIconState extends State<_NavIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 220),
    value: widget.selected ? 1 : 0,
  );

  @override
  void didUpdateWidget(covariant _NavIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selected != oldWidget.selected) {
      if (widget.selected) {
        _c.forward();
      } else {
        _c.reverse();
      }
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorTween = ColorTween(
      begin: widget.inactiveColor,
      end: widget.activeColor,
    ).animate(CurvedAnimation(parent: _c, curve: Curves.easeOut));

    final scaleTween = Tween<double>(begin: 1.0, end: 1.18)
        .animate(CurvedAnimation(parent: _c, curve: Curves.easeOut));

    return InkResponse(
      onTap: widget.onTap,
      radius: 28,
      child: AnimatedBuilder(
        animation: _c,
        builder: (_, __) {
          return Transform.scale(
            scale: scaleTween.value,
            child: Icon(
              widget.icon,
              size: 26,
              color: colorTween.value,
            ),
          );
        },
      ),
    );
  }
}
