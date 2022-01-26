import 'package:flutter/material.dart';

class CustomTheme {
  CustomTheme({
    required this.bgColorTop,
    required this.bgColorBottom,
    required this.bgGradient,
    required this.themeColor,
    required this.themeModeIcon,
  });
  final Color bgColorTop;
  final Color bgColorBottom;

  final Color themeColor;

  final Gradient bgGradient;
  final Icon themeModeIcon;

  CustomTheme copyWith(
          {Color? bgColorTop,
          Color? bgColorBottom,
          Color? themeColor,
          Gradient? bgGradient,
          Icon? themeModeIcon}) =>
      CustomTheme(
          bgColorTop: bgColorTop ?? this.bgColorTop,
          bgColorBottom: bgColorBottom ?? this.bgColorBottom,
          bgGradient: bgGradient ?? this.bgGradient,
          themeColor: themeColor ?? this.themeColor,
          themeModeIcon: themeModeIcon ?? this.themeModeIcon);
}
