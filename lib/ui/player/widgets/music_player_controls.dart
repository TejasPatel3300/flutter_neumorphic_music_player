import 'package:flutter/material.dart';
import 'package:neumorphic_music_player/models/theme/custom_theme.dart';
import '../../../utils/size_config.dart';

class MusicPlayerControls extends StatelessWidget {
  const MusicPlayerControls({
    Key? key,
    required this.currentTheme,
  }) : super(key: key);

  final CustomTheme currentTheme;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          height: SizeConfig.screenHeight * 0.05,
          width: SizeConfig.screenHeight * 0.05,
          decoration: BoxDecoration(
              color: Colors.black87,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: currentTheme.shadowColorTop,
                  offset: const Offset(-5, -5),
                  blurRadius: 16,
                ),
                BoxShadow(
                  color: currentTheme.shadowColorDown,
                  offset: const Offset(5, 5),
                  blurRadius: 16,
                )
              ]),
          child: Icon(Icons.skip_previous, color: currentTheme.themeColor),
        ),
        Container(
          height: SizeConfig.screenHeight * 0.07,
          width: SizeConfig.screenHeight * 0.07,
          decoration: BoxDecoration(
              color: Colors.black87,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: currentTheme.shadowColorTop,
                  offset: const Offset(-5, -5),
                  blurRadius: 16,
                ),
                BoxShadow(
                  color: currentTheme.shadowColorDown,
                  offset: const Offset(5, 5),
                  blurRadius: 16,
                )
              ]),
          child: Icon(Icons.play_arrow, color: currentTheme.themeColor),
        ),
        Container(
          height: SizeConfig.screenHeight * 0.05,
          width: SizeConfig.screenHeight * 0.05,
          decoration: BoxDecoration(
              color: Colors.black87,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: currentTheme.shadowColorTop,
                  offset: const Offset(-5, -5),
                  blurRadius: 16,
                ),
                BoxShadow(
                  color: currentTheme.shadowColorDown,
                  offset: const Offset(5, 5),
                  blurRadius: 16,
                )
              ]),
          child: Icon(Icons.skip_next, color: currentTheme.themeColor),
        ),
      ],
    );
  }
}
