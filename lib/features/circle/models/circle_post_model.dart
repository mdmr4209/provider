class CirclePostModel {
  final String id;
  final String userName;
  final String userAvatar;
  final String timeAgo;
  final String content;
  final List<String>? images;
  final int likes;
  final int claps;
  final bool isLiked;
  final bool isClapped;
  final bool isOwnPost;
  final List<CircleComment>? comments;

  CirclePostModel({
    required this.id,
    required this.userName,
    required this.userAvatar,
    required this.timeAgo,
    required this.content,
    this.images,
    this.likes = 0,
    this.claps = 0,
    this.isLiked = false,
    this.isClapped = false,
    this.isOwnPost = false,
    this.comments,
  });

  factory CirclePostModel.fromJson(Map<String, dynamic> json) {
    return CirclePostModel(
      id: json['id'],
      userName: json['userName'],
      userAvatar: json['userAvatar'],
      timeAgo: json['timeAgo'],
      content: json['content'],
      images: json['images'] != null ? List<String>.from(json['images']) : null,
      likes: json['likes'] ?? 0,
      claps: json['claps'] ?? 0,
      isLiked: json['isLiked'] ?? false,
      isClapped: json['isClapped'] ?? false,
      isOwnPost: json['isOwnPost'] ?? false,
      comments: json['comments'] != null
          ? (json['comments'] as List).map((i) => CircleComment.fromJson(i)).toList()
          : null,
    );
  }

  static List<CirclePostModel> dummyPosts = [
    CirclePostModel(
      id: "post_000",
      userName: "Sarah M. (You)",
      userAvatar: "https://xsgames.co/randomusers/assets/avatars/female/1.jpg",
      timeAgo: "Just now",
      content: "Feeling great today! Just reached my 30-day milestone. Persistence is key! 🌟",
      isOwnPost: true,
      likes: 5,
      claps: 2,
    ),
    CirclePostModel(
      id: "post_001",
      userName: "Sarah M.",
      userAvatar: "https://xsgames.co/randomusers/assets/avatars/female/1.jpg",
      timeAgo: "2 min ago",
      content: "Day 14. Didn't reach out even though I wanted to. Proud of myself 💪",
      likes: 47,
      claps: 12,
      images: [
        "https://images.unsplash.com/photo-1506744038136-46273834b3fb?w=800&auto=format&fit=crop&q=60",
        "https://images.unsplash.com/photo-1511447333015-45b65e60f6d5?w=800&auto=format&fit=crop&q=60",
      ],
      isLiked: false,
      isClapped: true,
      comments: [
        CircleComment(
          id: "comment_001",
          userName: "Mike Tyson",
          userAvatar: "https://xsgames.co/randomusers/assets/avatars/male/2.jpg",
          content: "Keep going! You got this.",
        ),
      ],
    ),
    CirclePostModel(
      id: "post_002",
      userName: "Alex R.",
      userAvatar: "https://xsgames.co/randomusers/assets/avatars/male/3.jpg",
      timeAgo: "15 min ago",
      content: "Just finished a great workout. Feeling refreshed! 🧘‍♂️",
      images: [
        "https://picsum.photos/id/10/600/400",
      ],
      likes: 23,
      claps: 5,
      isLiked: true,
      isClapped: false,
    ),
    CirclePostModel(
      id: "post_003",
      userName: "Maya J.",
      userAvatar: "https://xsgames.co/randomusers/assets/avatars/female/4.jpg",
      timeAgo: "1 hour ago",
      content: "Nature is so healing. 🌿✨",
      images: [
        "https://picsum.photos/id/11/600/400",
      ],
      likes: 15,
      claps: 2,
      isLiked: false,
      isClapped: false,
    ),
  ];
}

class CircleComment {
  final String id;
  final String userName;
  final String userAvatar;
  final String content;

  CircleComment({
    required this.id,
    required this.userName,
    required this.userAvatar,
    required this.content,
  });

  factory CircleComment.fromJson(Map<String, dynamic> json) {
    return CircleComment(
      id: json['id'],
      userName: json['userName'],
      userAvatar: json['userAvatar'],
      content: json['content'],
    );
  }
}

class SuggestionModel {
  final String id;
  final String name;
  final String avatar;
  final int mutualFriends;

  SuggestionModel({
    required this.id,
    required this.name,
    required this.avatar,
    required this.mutualFriends,
  });

  factory SuggestionModel.fromJson(Map<String, dynamic> json) {
    return SuggestionModel(
      id: json['id'],
      name: json['name'],
      avatar: json['avatar'],
      mutualFriends: json['mutualFriends'] ?? 0,
    );
  }

  static List<SuggestionModel> dummySuggestions = [
    SuggestionModel(id: "sug_0", name: "You", avatar: "https://xsgames.co/randomusers/assets/avatars/male/5.jpg", mutualFriends: 0),
    SuggestionModel(id: "sug_1", name: "Sarah", avatar: "https://xsgames.co/randomusers/assets/avatars/female/6.jpg", mutualFriends: 2),
    SuggestionModel(id: "sug_2", name: "Alex", avatar: "https://xsgames.co/randomusers/assets/avatars/male/7.jpg", mutualFriends: 1),
    SuggestionModel(id: "sug_3", name: "Jordan", avatar: "https://xsgames.co/randomusers/assets/avatars/male/8.jpg", mutualFriends: 3),
    SuggestionModel(id: "sug_4", name: "Maya", avatar: "https://xsgames.co/randomusers/assets/avatars/female/9.jpg", mutualFriends: 2),
  ];
}
