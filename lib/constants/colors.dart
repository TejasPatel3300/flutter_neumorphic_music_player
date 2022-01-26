import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color bgColorLightTop = Color(0xFFD7D5E4);
  static const Color bgColorLightBottom = Color(0xFF7A7886);
  static const Color bgColorDarkTop = Color(0xFF62696E);
  static const Color bgColorDarkBottom = Color(0xFF2A1D29);

  static const Color textColorLight = Color(0xFFD7D5E4);
  static const Color textColorDark = Color(0xFF2A1D29);

  static const Color themeColorLight = Color(0xFF00B0AA);
  static const Color themeColorDark = Color(0xFF005855);

  static const Gradient gradientModeLight = LinearGradient(
    colors: [bgColorLightTop, bgColorLightBottom],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient gradientModeDark = LinearGradient(
    colors: [bgColorDarkTop, bgColorDarkBottom],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
