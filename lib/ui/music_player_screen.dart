import 'package:flutter/material.dart';
import 'package:neumorphic_music_player/constants/colors.dart';

class MusicPlayerScreen extends StatefulWidget {
  const MusicPlayerScreen({Key? key}) : super(key: key);

  @override
  _MusicPlayerScreenState createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  bool _isLightMode = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: _isLightMode
              ? AppColors.gradientLightMode
              : AppColors.gradientDarkMode,
        ),
        child: SafeArea(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: _changeThemeMode,
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: _isLightMode
                                  ? const Icon(
                                      Icons.mode_night_outlined,
                                      color: AppColors.bgColorDarkTop,
                                    )
                                  : const Icon(
                                      Icons.light_mode_outlined,
                                      color: AppColors.bgColorLightTop,
                                    ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// method to change theme mode
  void _changeThemeMode() {
    _isLightMode = !_isLightMode;
    setState(() {});
  }
}
