class Comment {
  final String podcastId;
  final String userId;
  final double rate;
  final int createdAt;
  final String content;
  Comment({
    required this.podcastId,
    required this.userId,
    required this.rate,
    required this.content,
    required this.createdAt,
  });

  factory Comment.fromJson(Map<dynamic, dynamic> json) {
    return Comment(
      podcastId: json['podcastId'] ?? '',
      userId: json['userId'] ?? '',
      rate: double.parse(json['rate'].toString()),
      createdAt: json['createdAt'],
      content: json['content'],);
  }
  Map<String, dynamic> toMap() {
    return {
      'podcastId': podcastId,
      'userId': userId,
      'rate': rate,
      'content': content,
      'createdAt': createdAt,
    };
  }
}
