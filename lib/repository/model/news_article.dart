class NewsArticle {
  final String title;
  final String description;
  final String imageUrl;
  final DateTime publishedAt;
  final String source;

  NewsArticle({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.publishedAt,
    required this.source,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['urlToImage'] ?? json['imageUrl'] ?? '',
      publishedAt: json['publishedAt'] is String
          ? DateTime.parse(json['publishedAt'])
          : json['publishedAt'],
      source: json['source'] is Map
          ? json['source']['name'] ?? ''
          : json['source'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'imageUrl': imageUrl,
        'publishedAt': publishedAt.toIso8601String(),
        'source': source,
      };
}
