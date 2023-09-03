/*
 * Created by Tejas Patel on 10/17/22, 11:24 PM
 * Copyright (c) 2022 . All rights reserved.
 * Last modified 10/17/22, 11:17 PM
 */

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../constants/constants.dart';
import '../models/track/track.dart';

class PlayerProvider with ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();

  AudioPlayer get player => _player;

  late ConcatenatingAudioSource _playlist;

  List<Track> allTracks = [];
  List<IndexedAudioSource> playlistAudioSources = [];

  String currentTrackTitle = '';
  String currentTrackArtist = '';

  Future<void> setInitialPlaylist(List<Track> tracks) async {
    allTracks = tracks;
    final _audioSources = tracks
        .map((e) => AudioSource.uri(
              Uri.parse(e.uri),
              tag: {
                Constants.audioTagTitle: e.name,
                Constants.audioTagArtist: e.artist,
                Constants.audioBitrate: e.bitrate,
              },
            ))
        .toList();
    playlistAudioSources = _audioSources;
    _playlist = ConcatenatingAudioSource(children: _audioSources);
    await _player.setAudioSource(_playlist);
    _listenForChangesInSequenceState();
    // play();
  }

  Future<void> play() async {
    await _player.play();
  }

  Future<void> pause() async {
    await _player.pause();
  }

  bool isPlaying() {
    return _player.playing;
  }

  void seek(int durationMillis) {
    _player.seek(Duration(milliseconds: durationMillis));
  }

  Future<void> seekToIndex(int index) async {
    _setTitleAndArtist(index);
    await _player.seek(Duration.zero,
        index: index); // Skip to the start of the track of given index
    if (kDebugMode) {
      print('icymetadata: ${_player.icyMetadata?.info?.url}');
    }
  }

  Future<void> seekToNext() async {
    final _currentIndex = _player.currentIndex;
    if (_currentIndex != null &&
        _currentIndex == playlistAudioSources.length - 1) {
      await seekToIndex(0);
      return;
    }
    _setTitleAndArtist(_currentIndex! + 1);
    await _player.seekToNext(); // Skip to the next item
    if (kDebugMode) {
      print('icymetadata: ${_player.icyMetadata?.info?.url}');
    }
  }

  Future<void> seekToPrevious() async {
    final _currentIndex = _player.currentIndex;
    if (_currentIndex != null && _currentIndex == 0) {
      await seekToIndex(playlistAudioSources.length - 1);
      return;
    }
    _setTitleAndArtist(_currentIndex! - 1);
    await _player.seekToPrevious(); // Skip to the previous item
    if (kDebugMode) {
      print('icymetadata: ${_player.icyMetadata?.info?.url}');
    }
  }

  void _setTitleAndArtist(int index) {
    currentTrackTitle = (playlistAudioSources[index].tag
        as Map<String, dynamic>)[Constants.audioTagTitle] as String;
    final artist = (playlistAudioSources[index].tag
        as Map<String, dynamic>)[Constants.audioTagArtist] as String;
    currentTrackArtist = artist == '<unknown>' ? 'Unknown' : artist;
    notifyListeners();
  }

  void _listenForChangesInSequenceState() {
    _player.sequenceStateStream.listen((sequenceState) {
      if (sequenceState == null) return;
      final _currentIndex = sequenceState.currentIndex;
      _setTitleAndArtist(_currentIndex);
    });
  }
}
