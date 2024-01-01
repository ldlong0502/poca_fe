import 'episode.dart';

class EpisodeDownLoad {
  final Episode item;
  final String path;
  final int dateDown;

  EpisodeDownLoad({
    required this.item,
    required this.path,
    required this.dateDown,
  });

  EpisodeDownLoad copyWith({
    Episode? item,
    String? path,
    int? dateDown,
  }) {
    return EpisodeDownLoad(
      item: item ?? this.item,
      path: path ?? this.path,
      dateDown: dateDown ?? this.dateDown,
    );
  }

  factory EpisodeDownLoad.fromJson(Map<dynamic, dynamic> json) {
    return EpisodeDownLoad(
      item: Episode.fromJson(json['item']),
      dateDown: json['dateDown'] as int ?? 0,
      path: json['path'] as String ?? '',
    );
  }

  Map<dynamic, dynamic> toJson() {
    return {
      'item': item.toJson(),
      'dateDown': dateDown,
      'path': path,
    };
  }
}
