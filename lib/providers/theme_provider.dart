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
    themeModeIcon: const Icon(Icons.mode_night_outlined),
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
          themeModeIcon: const Icon(Icons.mode_night_outlined),
        );
        notifyListeners();
        break;
      case CustomThemeMode.dark:
        currentThemeMode = CustomThemeMode.dark;
        currentTheme = CustomTheme(
          bgColorTop: AppColors.bgColorDarkTop,
          bgColorBottom: AppColors.bgColorDarkBottom,
          bgGradient: AppColors.gradientModeDark,
          themeColor: AppColors.themeColorDark,
          themeModeIcon: const Icon(
            Icons.light_mode_outlined,
            color: Colors.white,
          ),
        );
        notifyListeners();
        break;
    }
  }
}
