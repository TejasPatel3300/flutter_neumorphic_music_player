import 'package:json_annotation/json_annotation.dart';
part 'track.g.dart';

@JsonSerializable()
class Track {
  Track({
    required this.name,
    required this.artist,
    required this.uri,
    required this.duration,
    required this.size,
  });

  factory Track.fromJson(Map<String, dynamic> json) => _$TrackFromJson(json);

  Map<String, dynamic> toJson() => _$TrackToJson(this);

  final String name;
  final String artist;
  final String uri;
  final int duration;
  final int size;
}
