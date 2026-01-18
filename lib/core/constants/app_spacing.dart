import 'package:flutter/material.dart';

class AppSpacing {
  AppSpacing._();

  // Base spacing unit: 4px
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;

  // Padding presets
  static const EdgeInsets paddingXs = EdgeInsets.all(xs);
  static const EdgeInsets paddingSm = EdgeInsets.all(sm);
  static const EdgeInsets paddingMd = EdgeInsets.all(md);
  static const EdgeInsets paddingLg = EdgeInsets.all(lg);
  static const EdgeInsets paddingXl = EdgeInsets.all(xl);

  // Horizontal padding
  static const EdgeInsets paddingHorizontalSm = EdgeInsets.symmetric(
    horizontal: sm,
  );
  static const EdgeInsets paddingHorizontalMd = EdgeInsets.symmetric(
    horizontal: md,
  );
  static const EdgeInsets paddingHorizontalLg = EdgeInsets.symmetric(
    horizontal: lg,
  );
  static const EdgeInsets paddingHorizontalXl = EdgeInsets.symmetric(
    horizontal: xl,
  );

  // Vertical padding
  static const EdgeInsets paddingVerticalSm = EdgeInsets.symmetric(
    vertical: sm,
  );
  static const EdgeInsets paddingVerticalMd = EdgeInsets.symmetric(
    vertical: md,
  );
  static const EdgeInsets paddingVerticalLg = EdgeInsets.symmetric(
    vertical: lg,
  );
  static const EdgeInsets paddingVerticalXl = EdgeInsets.symmetric(
    vertical: xl,
  );

  // Screen padding
  static const EdgeInsets screenPadding = EdgeInsets.symmetric(
    horizontal: lg,
    vertical: lg,
  );
  static const EdgeInsets screenPaddingHorizontal = EdgeInsets.symmetric(
    horizontal: lg,
  );

  // Border radius
  static const double radiusXs = 4;
  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 24;
  static const double radiusFull = 999;

  // Border radius presets
  static BorderRadius borderRadiusSm = BorderRadius.circular(radiusSm);
  static BorderRadius borderRadiusMd = BorderRadius.circular(radiusMd);
  static BorderRadius borderRadiusLg = BorderRadius.circular(radiusLg);
  static BorderRadius borderRadiusXl = BorderRadius.circular(radiusXl);
  static BorderRadius borderRadiusFull = BorderRadius.circular(radiusFull);

  // Icon sizes
  static const double iconXs = 16;
  static const double iconSm = 20;
  static const double iconMd = 24;
  static const double iconLg = 32;
  static const double iconXl = 48;

  // Button heights
  static const double buttonHeightSm = 40;
  static const double buttonHeightMd = 48;
  static const double buttonHeightLg = 56;

  // Input heights
  static const double inputHeight = 56;
  static const double inputHeightCompact = 48;

  // Card elevation
  static const double elevationSm = 2;
  static const double elevationMd = 4;
  static const double elevationLg = 8;

  // Splash screen
  static const double splashLogoSize = 120.0;
  static const double splashDotSize = 10.0;
  static const double splashDotSpacing = 8.0;

  // Chart constants
  static const double chartHeight = 200.0;
  static const double chartDotRadius = 4.0;
  static const double chartLineWidth = 3.0;
  static const double chartSecondaryLineWidth = 2.0;
}
