import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../constants/constants.dart';
import '../../constants/enums.dart';
import '../../models/track/track.dart';
import '../../providers/player_provider.dart';
import '../../providers/theme_provider.dart';
import '../../utils/size_config.dart';
import '../player/music_player_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<IndexedAudioSource> _playlistAudioSources = [];

  @override
  void initState() {
    super.initState();
    _getAudioFiles();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      bottomNavigationBar: _bottomNavMusicPlayerControls(context),
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
                SizedBox(height: SizeConfig.screenHeight * 0.03),
                Row(

                  children: [
                    const SizedBox(width: 16),
                    Text(
                      'My Player',
                      style: TextStyle(
                        color: Provider.of<ThemeProvider>(context)
                            .currentTheme
                            .themeColor,
                        fontSize: 40,
                      ),
                    ),
                    const Expanded(child: SizedBox()),
                    GestureDetector(
                      onTap: _changeThemeMode,
                      child: Container(
                        child: Provider.of<ThemeProvider>(context)
                            .currentTheme
                            .themeModeIcon,
                      ),
                    ),
                    const SizedBox(width: 16),
                  ],
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.02),
                Expanded(
                    child: ListView.builder(
                  itemCount: _playlistAudioSources.length,
                  itemBuilder: (context, index) => _trackTile(index, context),
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container _bottomNavMusicPlayerControls(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: Provider.of<ThemeProvider>(context).currentTheme.bgGradient,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              context.watch<PlayerProvider>().currentTrackTitle,
              style: TextStyle(
                  color: Provider.of<ThemeProvider>(context)
                      .currentTheme
                      .textColor),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 5),
          Container(
            height: SizeConfig.screenHeight * 0.05,
            width: SizeConfig.screenHeight * 0.05,
            decoration: BoxDecoration(
              color: Colors.black87,
              shape: BoxShape.circle,
              boxShadow: _getBoxShadows(),
            ),
            child: Icon(Icons.skip_previous,
                color: Provider.of<ThemeProvider>(context)
                    .currentTheme
                    .themeColor),
          ),
          const SizedBox(width: 5),
          Container(
            height: SizeConfig.screenHeight * 0.05,
            width: SizeConfig.screenHeight * 0.05,
            decoration: BoxDecoration(
              color: Colors.black87,
              shape: BoxShape.circle,
              boxShadow: _getBoxShadows(),
            ),
            child: Icon(Icons.pause,
                color: Provider.of<ThemeProvider>(context)
                    .currentTheme
                    .themeColor),
          ),
          const SizedBox(width: 5),
          Container(
            height: SizeConfig.screenHeight * 0.05,
            width: SizeConfig.screenHeight * 0.05,
            decoration: BoxDecoration(
              color: Colors.black87,
              shape: BoxShape.circle,
              boxShadow: _getBoxShadows(),
            ),
            child: Icon(Icons.skip_next,
                color: Provider.of<ThemeProvider>(context)
                    .currentTheme
                    .themeColor),
          )
        ],
      ),
    );
  }

  Widget _trackTile(int index, BuildContext context) {
    final _title = (_playlistAudioSources[index].tag
        as Map<String, dynamic>)[Constants.audioTagTitle] as String;
    final _artist = (_playlistAudioSources[index].tag
        as Map<String, dynamic>)[Constants.audioTagArtist] as String;
    final _bitrate = (_playlistAudioSources[index].tag
        as Map<String, dynamic>)[Constants.audioBitrate] as String?;

    return ListTile(
      title: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Provider.of<ThemeProvider>(context).currentTheme.textColor,
            ),
          ),
          Row(
            children: [
              Text(
                _getAudioQuality(_bitrate),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Provider.of<ThemeProvider>(context)
                      .currentTheme
                      .themeColor,
                  fontSize: 12,
                ),
              ),
              if (_getAudioQuality(_bitrate).isNotEmpty)
                const SizedBox(width: 5)
              else
                const SizedBox(),
              Text(
                _getArtistName(_artist),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Provider.of<ThemeProvider>(context)
                      .currentTheme
                      .textColor,
                ),
              ),
            ],
          ),
        ],
      ),
      trailing: GestureDetector(
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return Container(

                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: Provider.of<ThemeProvider>(context)
                      .currentTheme
                      .bgGradient,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Add to playlist'),
                    Text('Details'),
                  ],
                ),
              );
            },
          );
        },
        child: Icon(
          Icons.more_vert,
          color: Provider.of<ThemeProvider>(context).currentTheme.textColor,
        ),
      ),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MusicPlayerScreen(
            title: _title,
            artist: _artist,
            currentIndex: index,
          ),
        ));
      },
    );
  }

  String _getAudioQuality(String? bitrate) {
    String quality = '';
    if (bitrate != null && bitrate.isNotEmpty) {
      final intBitrate = int.parse(bitrate);
      if (intBitrate >= 320000) {
        quality = 'HQ';
      }
    }
    return quality;
  }

  String _getArtistName(String name) {
    String artistName = name;
    if (name == '<unknown>') {
      artistName = 'Unknown';
    }
    return artistName;
  }

  /// method to change theme mode
  void _changeThemeMode() {
    final _currentThemeMode = context.read<ThemeProvider>().currentThemeMode;
    Provider.of<ThemeProvider>(context, listen: false).changeTheme(
        _currentThemeMode == CustomThemeMode.light
            ? CustomThemeMode.dark
            : CustomThemeMode.light);
  }

  List<BoxShadow> _getBoxShadows() {
    return [
      BoxShadow(
        color: Provider.of<ThemeProvider>(context).currentTheme.shadowColorTop,
        offset: const Offset(-3, -3),
        blurRadius: 10,
      ),
      BoxShadow(
        color: Provider.of<ThemeProvider>(context).currentTheme.shadowColorDown,
        offset: const Offset(3, 3),
        blurRadius: 10,
      )
    ];
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
      await context.read<PlayerProvider>().setInitialPlaylist(_audioList);
      _playlistAudioSources =
          context.read<PlayerProvider>().playlistAudioSources;
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
