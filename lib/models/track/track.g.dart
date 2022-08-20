// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Track _$TrackFromJson(Map<String, dynamic> json) => Track(
      name: json['name'] as String,
      artist: json['artist'] as String,
      uri: json['uri'] as String,
      duration: json['duration'] as int,
      size: json['size'] as int,
    );

Map<String, dynamic> _$TrackToJson(Track instance) => <String, dynamic>{
      'name': instance.name,
      'artist': instance.artist,
      'uri': instance.uri,
      'duration': instance.duration,
      'size': instance.size,
    };
