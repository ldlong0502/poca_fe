import 'package:poca/models/episode.dart';
import 'package:poca/models/topic.dart';
import 'package:poca/models/user_model.dart';

class ChannelModel {
  final String id;
  final String name;
  final String imageUrl;
  final String idUser;
  final String about;
  final Map<String, dynamic> info;
  final List<String> subscribed;
  final List<String> topics;
  final bool isUser;

  ChannelModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.idUser,
    required this.about,
    required this.topics,
    required this.subscribed,
    required this.isUser,
    required this.info,
  });

  ChannelModel copyWith({
    String? id,
    String? name,
    String? imageUrl,
    String? idUser,
    String? about,
    List<String>? subscribed,
    List<String>? topics,
    bool? isUser,
    Map<String, dynamic>? info,
  }) {
    return ChannelModel(
      id: id ?? this.id,
      name: name ?? this.name,
      about: about ?? this.about,
      topics: topics ?? this.topics,
      idUser: idUser ?? this.idUser,
      imageUrl: imageUrl ?? this.imageUrl,
      subscribed: subscribed ?? this.subscribed,
      isUser: isUser ?? this.isUser,
      info: info ?? this.info,
    );
  }

  factory ChannelModel.fromJson(Map<String, dynamic> json) {
    var subscribes = <String>[];
    if (json['subscribed'] != null) {
      json['subscribed'].forEach((v) {
        subscribes.add(v as String);
      });
    }
    var topics = <String>[];
    if (json['topics'] != null) {
      json['topics'].forEach((v) {
        topics.add(v as String);
      });
    }
    return ChannelModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      about: json['about'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      subscribed: subscribes,
      idUser: json['idUser'] ??'',
      topics: topics,
      isUser: json['isUser'] ?? false,
      info: Map<String, dynamic>.from(json['info'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'about': about,
      'subscribed': subscribed,
      'topics': topics,
      'idUser': idUser,
      'isUser': isUser,
      'info': info,
    };
  }
}
