import 'package:poca/models/user_model.dart';

class Episode {
  final String id;
  final String title;
  final String description;
  final int duration;
  final String audioFile;
  final int publishDate;
  final int listens;
  final String imageUrl;
  final List<UserModel> favoritesList;

  Episode(
      { required this.id,
        required this.title,
        required this.description,
        required this.duration,
        required this.audioFile,
        required this.publishDate,
        required this.listens,
        required this.imageUrl,
        required this.favoritesList,
        });

  factory Episode.fromJson(Map<String, dynamic> json) {
    var favorites = <UserModel>[];
    if (json['favoritesList'] != null) {
      json['favoritesList'].forEach((v) {
        favorites!.add(UserModel.fromJson(v));
      });
    }

    return Episode(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description']?? '',
      duration: json['duration']?? 0,
      audioFile: json['audioFile']?? '',
      publishDate: json['publishDate']?? 0,
      listens: json['listens']?? 0,
      imageUrl: json['imageUrl']?? '',
      favoritesList: favorites,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'duration': duration,
      'audioFile': audioFile,
      'publishDate': publishDate,
      'listens': listens,
      'favoritesList': favoritesList.map((v) => v.toJson()).toList(),
      'imageUrl': imageUrl,
    };
  }
}