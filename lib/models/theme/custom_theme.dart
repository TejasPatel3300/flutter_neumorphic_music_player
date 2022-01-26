import 'package:flutter/material.dart';

class CustomTheme {
  CustomTheme({
    required this.bgColorTop,
    required this.bgColorBottom,
    required this.bgGradient,
    required this.themeColor,
    required this.textColor,
    required this.themeModeIcon,
    required this.shadowColorTop,
    required this.shadowColorDown,
  });
  final Color bgColorTop;
  final Color bgColorBottom;
  final Color themeColor;
  final Color textColor;
  final Color shadowColorTop;
  final Color shadowColorDown;
  final Gradient bgGradient;
  final Icon themeModeIcon;

  CustomTheme copyWith(
          {Color? bgColorTop,
          Color? bgColorBottom,
          Color? themeColor,
          Gradient? bgGradient,
          Color? textColor,
          Color? shadowColorTop,
          Color? shadowColorDown,
          Icon? themeModeIcon}) =>
      CustomTheme(
        bgColorTop: bgColorTop ?? this.bgColorTop,
        bgColorBottom: bgColorBottom ?? this.bgColorBottom,
        bgGradient: bgGradient ?? this.bgGradient,
        themeColor: themeColor ?? this.themeColor,
        textColor: textColor ?? this.textColor,
        themeModeIcon: themeModeIcon ?? this.themeModeIcon,
        shadowColorTop: shadowColorTop ?? this.shadowColorTop,
        shadowColorDown: shadowColorDown ?? this.shadowColorDown,
      );
}
