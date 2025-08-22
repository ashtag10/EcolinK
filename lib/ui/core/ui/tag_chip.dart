// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui';
import 'package:flutter/material.dart';

import '../themes/colors.dart';

class TagChip extends StatelessWidget {
  const TagChip({
    super.key,
    required this.tag,
    this.fontSize = 10,
    this.height = 20,
    this.chipColor,
    this.onChipColor,
  });

  final String tag;
  final double fontSize;
  final double height;
  final Color? chipColor;
  final Color? onChipColor;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(height / 2),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: chipColor ??
                Theme.of(context).extension<TagChipTheme>()?.chipColor ??
                AppColors.blancTransparent,
          ),
          child: SizedBox(
            height: height,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _iconFrom(tag),
                    color: onChipColor ??
                        Theme.of(context)
                            .extension<TagChipTheme>()
                            ?.onChipColor ??
                        Colors.white,
                    size: fontSize,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    tag,
                    textAlign: TextAlign.center,
                    style: _textStyle(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconData? _iconFrom(String tag) {
    // À personnaliser selon tes tags Ecolink
    return switch (tag) {
      'Plastique' => Icons.recycling,
      'Verre' => Icons.wine_bar_outlined,
      'Papier' => Icons.description_outlined,
      'Métal' => Icons.hardware_outlined,
      'Compost' => Icons.eco_outlined,
      _ => Icons.label_outlined,
    };
  }

  TextStyle _textStyle(BuildContext context) => TextStyle(
        fontFamily: 'Segoe UI',
        fontWeight: FontWeight.w500,
        fontSize: fontSize,
        color: onChipColor ??
            Theme.of(context).extension<TagChipTheme>()?.onChipColor ??
            Colors.white,
        textBaseline: TextBaseline.alphabetic,
      );
}

class TagChipTheme extends ThemeExtension<TagChipTheme> {
  final Color chipColor;
  final Color onChipColor;

  TagChipTheme({required this.chipColor, required this.onChipColor});

  @override
  ThemeExtension<TagChipTheme> copyWith({
    Color? chipColor,
    Color? onChipColor,
  }) {
    return TagChipTheme(
      chipColor: chipColor ?? this.chipColor,
      onChipColor: onChipColor ?? this.onChipColor,
    );
  }

  @override
  ThemeExtension<TagChipTheme> lerp(
    covariant ThemeExtension<TagChipTheme> other,
    double t,
  ) {
    if (other is! TagChipTheme) {
      return this;
    }
    return TagChipTheme(
      chipColor: Color.lerp(chipColor, other.chipColor, t) ?? chipColor,
      onChipColor: Color.lerp(onChipColor, other.onChipColor, t) ?? onChipColor,
    );
  }
}
