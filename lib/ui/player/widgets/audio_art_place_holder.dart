import 'package:flutter/material.dart';
import 'package:neumorphic_music_player/models/theme/custom_theme.dart';
import 'package:neumorphic_music_player/utils/size_config.dart';

class AudioArtPlaceHolder extends StatelessWidget {
  const AudioArtPlaceHolder({
    Key? key,
    required CustomTheme currentTheme,
  })  : _currentTheme = currentTheme,
        super(key: key);

  final CustomTheme _currentTheme;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 4,
            height: SizeConfig.screenHeight * 0.03,
            margin: const EdgeInsets.only(right: 4),
            color: _currentTheme.themeColor,
          ),
          Container(
            width: 4,
            height: SizeConfig.screenHeight * 0.05,
            margin: const EdgeInsets.only(right: 4),
            color: _currentTheme.themeColor,
          ),
          Container(
            width: 4,
            height: SizeConfig.screenHeight * 0.08,
            margin: const EdgeInsets.only(right: 4),
            color: _currentTheme.themeColor,
          ),
          Container(
            width: 4,
            height: SizeConfig.screenHeight * 0.04,
            margin: const EdgeInsets.only(right: 4),
            color: _currentTheme.themeColor,
          ),
          Container(
            width: 4,
            height: SizeConfig.screenHeight * 0.06,
            color: _currentTheme.themeColor,
          ),
        ],
      ),
    );
  }
}
