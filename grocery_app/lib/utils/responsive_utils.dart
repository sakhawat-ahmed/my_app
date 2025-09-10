import 'package:flutter/widgets.dart';

class ResponsiveUtils {
  static double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
  static double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;
  static Orientation orientation(BuildContext context) => MediaQuery.of(context).orientation;

  // Breakpoints
  static bool isMobile(BuildContext context) => screenWidth(context) < 600;
  static bool isTablet(BuildContext context) => screenWidth(context) >= 600 && screenWidth(context) < 1200;
  static bool isDesktop(BuildContext context) => screenWidth(context) >= 1200;

  // Responsive sizing
  static double responsiveSize(BuildContext context, {double mobile = 16, double tablet = 18, double desktop = 20}) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }

  // Responsive padding
  static EdgeInsets responsivePadding(BuildContext context) {
    if (isMobile(context)) return const EdgeInsets.all(16.0);
    if (isTablet(context)) return const EdgeInsets.all(24.0);
    return const EdgeInsets.all(32.0);
  }

  // Grid layout columns
  static int gridCrossAxisCount(BuildContext context) {
    if (isMobile(context)) return 2;
    if (isTablet(context)) return 3;
    return 4;
  }

  // Image sizes
  static double productImageSize(BuildContext context) {
    if (isMobile(context)) return 120;
    if (isTablet(context)) return 150;
    return 180;
  }

  // Font sizes
  static double titleFontSize(BuildContext context) {
    if (isMobile(context)) return 18;
    if (isTablet(context)) return 22;
    return 26;
  }

  static double priceFontSize(BuildContext context) {
    if (isMobile(context)) return 16;
    if (isTablet(context)) return 18;
    return 20;
  }
}