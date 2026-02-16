import 'package:flutter/material.dart';

class ResponsiveHelper {
  static bool isLandscape(BuildContext context) =>
      MediaQuery.orientationOf(context) == Orientation.landscape;

  static bool isTablet(BuildContext context) =>
      MediaQuery.sizeOf(context).shortestSide >= 600;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= 1000;

  static double horizontalPadding(BuildContext context) {
    if (isDesktop(context)) return 28;
    if (isTablet(context)) return 20;
    return 12;
  }

  static double maxContentWidth(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= 1400) return 1180;
    if (width >= 1000) return 920;
    if (width >= 700) return 680;
    return width;
  }

  static int productGridCount(double availableWidth) {
    if (availableWidth >= 1200) return 5;
    if (availableWidth >= 900) return 4;
    if (availableWidth >= 650) return 3;
    return 2;
  }
}
