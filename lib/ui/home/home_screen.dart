import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../constants/constants.dart';
import '../../constants/enums.dart';
import '../../models/track/track.dart';
import '../../providers/theme_provider.dart';
import '../../utils/size_config.dart';
import '../player/music_player_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Track> _audioFiles = [];

  @override
  void initState() {
    super.initState();
    _getAudioFiles();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
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
                Expanded(
                    child: ListView.builder(
                  itemCount: _audioFiles.length,
                  itemBuilder: (context, index) => _trackTile(index, context),
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _trackTile(int index, BuildContext context) {
    return ListTile(
      title: Text(
        _audioFiles[index].name,
        style: TextStyle(
          color: Provider.of<ThemeProvider>(context).currentTheme.textColor,
        ),
      ),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MusicPlayerScreen(
            track: _audioFiles[index],
          ),
        ));
      },
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

  Future<void> _getAudioFiles() async {
    const _methodChannel = MethodChannel(Constants.audioFilesChannel);
    final _permissionStatus = await Permission.storage.status;
    bool _isGranted = _permissionStatus.isGranted;
    if (_permissionStatus.isDenied) {
      _isGranted = await Permission.storage.request().isGranted;
    }
    if (!_isGranted) {
      _showMyDialog();
      return;
    }
    final List<dynamic>? _result =
        await _methodChannel.invokeMethod(Constants.methodQueryAudioFiles);
    final _refinedList = _result
        ?.cast<Map<dynamic, dynamic>>()
        .map((e) => e.cast<String, dynamic>())
        .toList();

    if (_refinedList != null) {
      final _audioList = _refinedList.map((e) => Track.fromJson(e)).toList();
      _audioFiles = _audioList;
      setState(() {});
    }
    return;
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('MP'),
          content: const Text('External storage permission needed'),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
