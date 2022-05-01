import 'package:flutter/material.dart';
import 'package:neumorphic_music_player/constants/enums.dart';

import '../constants/colors.dart';
import '../models/theme/custom_theme.dart';

class ThemeProvider with ChangeNotifier {
  CustomThemeMode currentThemeMode = CustomThemeMode.light;
  CustomTheme currentTheme = CustomTheme(
    bgColorTop: AppColors.bgColorLightTop,
    bgColorBottom: AppColors.bgColorLightBottom,
    bgGradient: AppColors.gradientModeLight,
    themeColor: AppColors.themeColorLight,
    textColor: AppColors.textColorDark,
    themeModeIcon: const Icon(Icons.mode_night_outlined),
    shadowColorTop: AppColors.themeShadowTopLight,
    shadowColorDown: AppColors.themeShadowDownLight,
  );

  void changeTheme(CustomThemeMode themeMode) {
    switch (themeMode) {
      case CustomThemeMode.light:
        currentThemeMode = CustomThemeMode.light;
        currentTheme = CustomTheme(
          bgColorTop: AppColors.bgColorLightTop,
          bgColorBottom: AppColors.bgColorLightBottom,
          bgGradient: AppColors.gradientModeLight,
          themeColor: AppColors.themeColorLight,
          textColor: AppColors.textColorDark,
          themeModeIcon: const Icon(Icons.mode_night_outlined),
          shadowColorTop: AppColors.themeShadowTopLight,
          shadowColorDown: AppColors.themeShadowDownLight,
        );
        notifyListeners();
        break;
      case CustomThemeMode.dark:
        currentThemeMode = CustomThemeMode.dark;
        currentTheme = CustomTheme(
          bgColorTop: AppColors.bgColorDarkTop,
          bgColorBottom: AppColors.bgColorDarkBottom,
          bgGradient: AppColors.gradientModeDark,
          themeColor: AppColors.themeColorLight,
          textColor: AppColors.textColorLight,
          themeModeIcon: const Icon(
            Icons.light_mode_outlined,
            color: Colors.white,
          ),
          shadowColorTop: AppColors.themeShadowTopDark,
          shadowColorDown: AppColors.themeShadowDownDark,
        );
        notifyListeners();
        break;
    }
  }
}
