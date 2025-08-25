class GoodDeal {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String actionText;
  final String actionUrl;

  GoodDeal({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.actionText,
    required this.actionUrl,
  });

  factory GoodDeal.fromJson(Map<String, dynamic> json) {
    return GoodDeal(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      actionText: json['actionText'] ?? '',
      actionUrl: json['actionUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'actionText': actionText,
      'actionUrl': actionUrl,
    };
  }
}

class Article {
  final String id;
  final String title;
  final String date;
  final String description;
  final String imageUrl;
  final String readMoreText;

  Article({
    required this.id,
    required this.title,
    required this.date,
    required this.description,
    required this.imageUrl,
    required this.readMoreText,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      date: json['date'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      readMoreText: json['readMoreText'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date': date,
      'description': description,
      'imageUrl': imageUrl,
      'readMoreText': readMoreText,
    };
  }
}
