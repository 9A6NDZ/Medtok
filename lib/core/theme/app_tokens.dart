import 'package:flutter/material.dart';

/// Central design tokens. Keep the palette small and calm; medical apps
/// must stay legible for older users and those with low vision.
abstract final class AppTokens {
  // Spacing scale (4pt grid).
  static const double space1 = 4;
  static const double space2 = 8;
  static const double space3 = 12;
  static const double space4 = 16;
  static const double space5 = 24;
  static const double space6 = 32;

  // Radii.
  static const double radiusM = 12;
  static const double radiusL = 20;

  /// Minimum interactive target. Larger than the 48dp platform minimum,
  /// deliberately, for accessibility.
  static const double minTouchTarget = 56;

  // Brand seed – a calm teal, not alarming red-heavy.
  static const Color seed = Color(0xFF00796B);

  // Semantic status colors (used for dose states). These are tuned to be
  // distinguishable for common color-vision deficiencies and are always
  // paired with a text label + icon, never color alone.
  static const Color statusTaken = Color(0xFF2E7D32);
  static const Color statusPending = Color(0xFF616161);
  static const Color statusSnoozed = Color(0xFFF9A825);
  static const Color statusSkipped = Color(0xFFB00020);
  static const Color statusPaused = Color(0xFF5C6BC0);
  static const Color statusUnsure = Color(0xFF8E24AA);
}
