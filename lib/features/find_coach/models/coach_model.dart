class CoachModel {
  final String id;
  final String name;
  final String title;
  final double rating;
  final int reviews;
  final String avatar;
  final String experience;
  final String bio;

  CoachModel({
    required this.id,
    required this.name,
    required this.title,
    required this.rating,
    required this.reviews,
    required this.avatar,
    this.experience = '5 Year Experience',
    this.bio = 'Amazon Alexa Shopping is seeking a talented, experienced, and self-directed UX Designer...',
  });

  factory CoachModel.fromJson(Map<String, dynamic> json) {
    return CoachModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      title: json['title'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      reviews: json['reviews'] ?? 0,
      avatar: json['avatar'] ?? 'https://i.pravatar.cc/150?u=coach',
      experience: json['experience'] ?? '5 Year Experience',
      bio: json['bio'] ?? 'Amazon Alexa Shopping is seeking a talented, experienced, and self-directed UX Designer...',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'title': title,
      'rating': rating,
      'reviews': reviews,
      'avatar': avatar,
      'experience': experience,
      'bio': bio,
    };
  }
}

class CoachSlotModel {
  final String duration;
  final double price;

  CoachSlotModel({
    required this.duration,
    required this.price,
  });

  factory CoachSlotModel.fromJson(Map<String, dynamic> json) {
    return CoachSlotModel(
      duration: json['duration'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'duration': duration,
      'price': price,
    };
  }
}

class CoachReviewModel {
  final String reviewerName;
  final String reviewerAvatar;
  final String date;
  final double rating;
  final String content;

  CoachReviewModel({
    required this.reviewerName,
    required this.reviewerAvatar,
    required this.date,
    required this.rating,
    required this.content,
  });

  factory CoachReviewModel.fromJson(Map<String, dynamic> json) {
    return CoachReviewModel(
      reviewerName: json['reviewerName'] ?? '',
      reviewerAvatar: json['reviewerAvatar'] ?? 'https://i.pravatar.cc/150?u=reviewer',
      date: json['date'] ?? '',
      rating: (json['rating'] ?? 5.0).toDouble(),
      content: json['content'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reviewerName': reviewerName,
      'reviewerAvatar': reviewerAvatar,
      'date': date,
      'rating': rating,
      'content': content,
    };
  }
}
