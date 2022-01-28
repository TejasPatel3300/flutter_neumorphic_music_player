import 'package:flutter/material.dart';
import 'package:neumorphic_music_player/constants/colors.dart';
import 'package:neumorphic_music_player/ui/player/widgets/music_player_controls.dart';
import '../../models/theme/custom_theme.dart';
import 'widgets/audio_art_place_holder.dart';
import '../../utils/size_config.dart';
import 'package:provider/provider.dart';

import '../../constants/enums.dart';
import '../../providers/theme_provider.dart';

class MusicPlayerScreen extends StatefulWidget {
  const MusicPlayerScreen({Key? key}) : super(key: key);

  @override
  _MusicPlayerScreenState createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    CustomTheme _currentTheme =
        Provider.of<ThemeProvider>(context).currentTheme;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: Provider.of<ThemeProvider>(context).currentTheme.bgGradient,
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.05),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: _changeThemeMode,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 30),
                        child: Provider.of<ThemeProvider>(context)
                            .currentTheme
                            .themeModeIcon,
                      ),
                    )
                  ],
                ),
                Text(
                  'High School',
                  style: TextStyle(
                    color: _currentTheme.textColor,
                    fontSize: 22,
                    letterSpacing: 0.1,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Nicky Minaj',
                  style: TextStyle(
                    color: _currentTheme.textColor,
                    fontSize: 16,
                    letterSpacing: 0.1,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                // SizedBox(height: SizeConfig.screenHeight * 0.05),
                const Spacer(),
                Container(
                  height: SizeConfig.screenHeight * 0.20,
                  width: SizeConfig.screenHeight * 0.20,
                  decoration: BoxDecoration(
                      color: Colors.black87,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: _currentTheme.shadowColorTop,
                          offset: const Offset(-10, -10),
                          blurRadius: 24,
                        ),
                        BoxShadow(
                          color: _currentTheme.shadowColorDown,
                          offset: const Offset(10, 10),
                          blurRadius: 24,
                        )
                      ]),
                  child: AudioArtPlaceHolder(currentTheme: _currentTheme),
                ),
                const Spacer(),
                /*
                * may need to create new custom slider with reference
                * of material slider
                *
                * look and feel must be same
                * */
                // Slider(value: value, onChanged: onChanged),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('3:14',
                        style: TextStyle(color: _currentTheme.textColor)),
                    Container(
                      height: 7,
                      width: SizeConfig.screenWidth * 0.45,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: Stack(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [Colors.black, Colors.black45],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter),
                            ),
                          ),
                          FractionallySizedBox(
                            heightFactor: 1,
                            widthFactor: 0.3,
                            child: Container(
                              decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                colors: [
                                  AppColors.themeColorDark,
                                  AppColors.themeColorLight
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              )),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text('8:37',
                        style: TextStyle(color: _currentTheme.textColor)),
                  ],
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.05),
                MusicPlayerControls(currentTheme: _currentTheme),
                SizedBox(height: SizeConfig.screenHeight * 0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// method to change theme mode
  void _changeThemeMode() {
    final _currentThemeMode = context.read<ThemeProvider>().currentThemeMode;
    Provider.of<ThemeProvider>(context, listen: false).changeTheme(
        _currentThemeMode == CustomThemeMode.light
            ? CustomThemeMode.dark
            : CustomThemeMode.light);
  }
}
