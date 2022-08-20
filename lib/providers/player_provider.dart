import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../models/track/track.dart';

class PlayerProvider with ChangeNotifier{
  final AudioPlayer _player = AudioPlayer();
  AudioPlayer get player => _player;

  Future<void> loadMusic(Track? track) async{
    await _player.setUrl(track?.uri??'');
  }

  Future<void> play()async{
    await _player.play();
  }

  Future<void> pause()async{
    await _player.pause();
  }

  bool isPlaying(){
    return _player.playing;
  }

  void seek(int durationMillis){
    _player.seek(
        Duration(milliseconds: durationMillis));
  }
}