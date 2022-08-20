import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/colors.dart';
import '../../constants/enums.dart';
import '../../models/theme/custom_theme.dart';
import '../../models/track/track.dart';
import '../../providers/player_provider.dart';
import '../../providers/theme_provider.dart';
import '../../utils/size_config.dart';
import 'widgets/audio_art_place_holder.dart';
import 'widgets/music_player_controls.dart';

class MusicPlayerScreen extends StatefulWidget {
  const MusicPlayerScreen({Key? key, this.track}) : super(key: key);
  final Track? track;

  @override
  _MusicPlayerScreenState createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  bool _isPlaying = false;
  double _sliderMaxValue = 0;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
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
                   widget.track?.name??'',
                  style: TextStyle(
                    color: _currentTheme.textColor,
                    fontSize: 22,
                    letterSpacing: 0.1,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  widget.track?.artist??'',
                  style: TextStyle(
                    color: _currentTheme.textColor,
                    fontSize: 16,
                    letterSpacing: 0.1,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
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
                Flexible(
                  child: StreamBuilder<Duration>(
                      stream: context.read<PlayerProvider>().player.positionStream,
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
                                  value: _sliderMaxValue >
                                          (snapshot.data?.inMilliseconds
                                                  .toDouble() ??
                                              0.0)
                                      ? snapshot.data?.inMilliseconds
                                              .toDouble() ??
                                          0.0
                                      : _sliderMaxValue,
                                  onChanged: (value) {
                                    if (kDebugMode) {
                                      print(value);
                                    }
                                    _seek(value.toInt());
                                  },
                                  max: _sliderMaxValue > 0.0
                                      ? _sliderMaxValue
                                      : 0.0,
                                  min: 0.0,
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                                _getDurationText(
                                    context.read<PlayerProvider>().player.duration?.inSeconds ?? 0),
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
    bool _playing = context.read<PlayerProvider>().player.playing;
    if(_playing){
      await context.read<PlayerProvider>().player.stop();
    }
    await context.read<PlayerProvider>().loadMusic(widget.track);
    _sliderMaxValue = _getSliderMaxValue( context.read<PlayerProvider>().player.duration?.inMilliseconds);
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
    if (kDebugMode) {
      print('duration from track data ==> ${widget.track?.duration}');
    }
    if (durationInMillis == null) {
      return 0.0;
    }
    if (kDebugMode) {
      print('duration from player ==> $durationInMillis');
    }
    return (durationInMillis).toDouble();
  }

  /// to handle play/pause functionality
  void _playAndPause() {
    if (_isPlaying) {
      context.read<PlayerProvider>().pause();
    } else {
      context.read<PlayerProvider>().play();
    }
    _isPlaying = !_isPlaying;
    setState(() {});
  }

  void _seek(int durationMillis) {
    context.read<PlayerProvider>().seek(durationMillis);
  }
}
