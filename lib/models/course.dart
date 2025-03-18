class Course {
  final String id;
  final String title;
  final String description;
  final String instructor;
  final String platformId;
  final String platformName;
  final double price;
  final double rating;
  final int totalRatings;
  final int durationInWeeks;
  final String level;
  final String learningStyle;
  final bool hasCertificate;
  final List<String> skills;
  final String imageUrl;
  final String courseUrl;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.instructor,
    required this.platformId,
    required this.platformName,
    required this.price,
    required this.rating,
    required this.totalRatings,
    required this.durationInWeeks,
    required this.level,
    required this.learningStyle,
    required this.hasCertificate,
    required this.skills,
    required this.imageUrl,
    required this.courseUrl,
  });

  // Factory constructor from JSON
  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      instructor: json['instructor'],
      platformId: json['platformId'],
      platformName: json['platformName'],
      price: json['price'].toDouble(),
      rating: json['rating'].toDouble(),
      totalRatings: json['totalRatings'],
      durationInWeeks: json['durationInWeeks'],
      level: json['level'],
      learningStyle: json['learningStyle'],
      hasCertificate: json['hasCertificate'],
      skills: List<String>.from(json['skills']),
      imageUrl: json['imageUrl'],
      courseUrl: json['courseUrl'],
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'instructor': instructor,
      'platformId': platformId,
      'platformName': platformName,
      'price': price,
      'rating': rating,
      'totalRatings': totalRatings,
      'durationInWeeks': durationInWeeks,
      'level': level,
      'learningStyle': learningStyle,
      'hasCertificate': hasCertificate,
      'skills': skills,
      'imageUrl': imageUrl,
      'courseUrl': courseUrl,
    };
  }

  // Helper methods
  String getPriceText() {
    if (price == 0) {
      return 'Free';
    } else {
      return '\$${price.toStringAsFixed(2)}';
    }
  }

  String getDurationText() {
    if (durationInWeeks < 1) {
      return 'Self-paced';
    } else if (durationInWeeks == 1) {
      return '1 week';
    } else if (durationInWeeks <= 4) {
      return '$durationInWeeks weeks';
    } else {
      final months = (durationInWeeks / 4).round();
      return months == 1 ? '1 month' : '$months months';
    }
  }

  // Create a copy of this course with optional new values
  Course copyWith({
    String? id,
    String? title,
    String? description,
    String? instructor,
    String? platformId,
    String? platformName,
    double? price,
    double? rating,
    int? totalRatings,
    int? durationInWeeks,
    String? level,
    String? learningStyle,
    bool? hasCertificate,
    List<String>? skills,
    String? imageUrl,
    String? courseUrl,
  }) {
    return Course(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      instructor: instructor ?? this.instructor,
      platformId: platformId ?? this.platformId,
      platformName: platformName ?? this.platformName,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      totalRatings: totalRatings ?? this.totalRatings,
      durationInWeeks: durationInWeeks ?? this.durationInWeeks,
      level: level ?? this.level,
      learningStyle: learningStyle ?? this.learningStyle,
      hasCertificate: hasCertificate ?? this.hasCertificate,
      skills: skills ?? this.skills,
      imageUrl: imageUrl ?? this.imageUrl,
      courseUrl: courseUrl ?? this.courseUrl,
    );
  }
}