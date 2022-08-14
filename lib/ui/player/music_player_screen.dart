import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../constants/colors.dart';
import '../../constants/constants.dart';
import 'widgets/music_player_controls.dart';
import '../../models/theme/custom_theme.dart';
import 'widgets/audio_art_place_holder.dart';
import '../../utils/size_config.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../constants/enums.dart';
import '../../providers/theme_provider.dart';

class MusicPlayerScreen extends StatefulWidget {
  const MusicPlayerScreen({Key? key}) : super(key: key);

  @override
  _MusicPlayerScreenState createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  AudioPlayer? _player;
  Stream<Duration>? _playerPositionStream;
  bool _isPlaying = false;
  double _sliderMaxValue = 0;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
    _getAudioFiles();
  }

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
                  '---- ----',
                  style: TextStyle(
                    color: _currentTheme.textColor,
                    fontSize: 22,
                    letterSpacing: 0.1,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '------- ----',
                  style: TextStyle(
                    color: _currentTheme.textColor,
                    fontSize: 16,
                    letterSpacing: 0.1,
                    fontWeight: FontWeight.w500,
                  ),
                ),
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
                Flexible(
                  child: StreamBuilder<Duration>(
                      stream: _playerPositionStream ??
                          const Stream<Duration>.empty(),
                      builder: (context, snapshot) {
                        if (kDebugMode) {
                          print(
                              'snapshot ==> ${snapshot.data?.inMilliseconds ?? 0}');
                        }
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(width: 16),
                            Text(
                                _getDurationText(snapshot.data?.inSeconds ?? 0),
                                style:
                                    TextStyle(color: _currentTheme.textColor)),
                            const SizedBox(width: 5),
                            Flexible(
                              child: SliderTheme(
                                data: SliderThemeData(
                                  thumbShape: SliderComponentShape.noThumb,
                                  activeTrackColor: AppColors.themeColorLight,
                                  inactiveTrackColor: Colors.black45,
                                ),
                                child: Slider(
                                  value: snapshot.data?.inMilliseconds
                                          .toDouble() ??
                                      0.0,
                                  onChanged: (value) {
                                    if (kDebugMode) {
                                      print(value);
                                    }
                                    _player?.seek(
                                        Duration(milliseconds: value.toInt()));
                                  },
                                  max: _sliderMaxValue,
                                  min: 0.0,
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                                _getDurationText(
                                    _player?.duration?.inSeconds ?? 0),
                                style:
                                    TextStyle(color: _currentTheme.textColor)),
                            const SizedBox(width: 16),
                          ],
                        );
                      }),
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.05),
                MusicPlayerControls(
                    currentTheme: _currentTheme,
                    actionPrevious: () {},
                    actionPlay: _playAndPause,
                    actionNext: () {},
                    isPlaying: _isPlaying),
                SizedBox(height: SizeConfig.screenHeight * 0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _player?.dispose();
    super.dispose();
  }

  /// method to change theme mode
  void _changeThemeMode() {
    final _currentThemeMode = context.read<ThemeProvider>().currentThemeMode;
    Provider.of<ThemeProvider>(context, listen: false).changeTheme(
        _currentThemeMode == CustomThemeMode.light
            ? CustomThemeMode.dark
            : CustomThemeMode.light);
  }

  /// method to initialize audioPlayer
  Future<void> _initializePlayer() async {
    _player = AudioPlayer();
    await _player?.setAsset('assets/files/sample.mp3');
    _playerPositionStream = _player?.positionStream;
    _sliderMaxValue = _getSliderMaxValue(_player?.duration?.inMilliseconds);
    if (mounted) {
      setState(() {});
    }
  }

  /// method to get duration-text for slider
  /// [duration] : duration in seconds
  String _getDurationText(int duration) {
    return '${duration ~/ 60}:${(duration % 60).toString().padLeft(2, '0')}';
  }

  /// to get max-value for slider
  /// [durationInMillis] : duration in milliseconds
  double _getSliderMaxValue(int? durationInMillis) {
    if (durationInMillis == null) {
      return 0.0;
    }
    print('duration from player ==> $durationInMillis');
    // added 10 milliseconds extra to avoid error of
    // assert(value >= min && value <= max)
    return (durationInMillis + 200).toDouble();
  }

  /// to handle play/pause functionality
  void _playAndPause() {
    if (_isPlaying) {
      _player?.pause();
    } else {
      _player?.play();
    }
    _isPlaying = !_isPlaying;
    setState(() {});
  }

  Future<void> _getAudioFiles()async {
    const _methodChannel = MethodChannel(Constants.audioFilesChannel);
     final _permissionStatus = await Permission.manageExternalStorage.status;
     bool _isGranted = _permissionStatus.isGranted;
     if(_permissionStatus.isDenied){
       // _showMyDialog();
       // return;
       _isGranted = await Permission.manageExternalStorage.request().isGranted;
     }
     if(!_isGranted){
       _showMyDialog();
       return;
     }
    final _result = await _methodChannel.invokeMethod(Constants.methodQueryAudioFiles);
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
