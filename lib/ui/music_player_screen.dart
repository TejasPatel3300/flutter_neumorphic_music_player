import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/enums.dart';
import '../providers/theme_provider.dart';

class MusicPlayerScreen extends StatefulWidget {
  const MusicPlayerScreen({Key? key}) : super(key: key);

  @override
  _MusicPlayerScreenState createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  @override
  Widget build(BuildContext context) {
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
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
                    const SizedBox(height: 20),
                  ],
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
    final _currentThemeMode = context.read<ThemeProvider>().currentThemeMode;
    Provider.of<ThemeProvider>(context, listen: false).changeTheme(
        _currentThemeMode == CustomThemeMode.light
            ? CustomThemeMode.dark
            : CustomThemeMode.light);
  }
}
