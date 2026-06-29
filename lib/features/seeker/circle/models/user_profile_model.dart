import 'circle_post_model.dart';

class UserProfileModel {
  final String id;
  final String name;
  final String avatar;
  final String bio;
  final int postsCount;
  final int friendsCount;
  final int followersCount;
  final int followingCount;
  final String
  relationshipStatus; // 'none', 'friend', 'request_sent', 'request_received'
  final List<String> media;
  final List<CirclePostModel> posts;

  UserProfileModel({
    required this.id,
    required this.name,
    required this.avatar,
    required this.bio,
    required this.postsCount,
    required this.friendsCount,
    required this.followersCount,
    required this.followingCount,
    required this.relationshipStatus,
    required this.media,
    required this.posts,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] ?? json;
    final stats = user['stats'] ?? {};
    return UserProfileModel(
      id: user['id'] ?? '',
      name: user['name'] ?? '',
      avatar: user['avatar'] ?? '',
      bio: user['bio'] ?? '',
      postsCount: stats['posts'] ?? 0,
      friendsCount: stats['friends'] ?? 0,
      followersCount: stats['followers'] ?? 0,
      followingCount: stats['following'] ?? 0,
      relationshipStatus: user['relationshipStatus'] ?? 'none',
      media: json['media'] != null
          ? List<String>.from(json['media'])
          : (user['media'] != null ? List<String>.from(user['media']) : []),
      posts: json['posts'] != null
          ? (json['posts'] as List)
                .map((i) => CirclePostModel.fromJson(i))
                .toList()
          : (user['posts'] != null
                ? (user['posts'] as List)
                      .map((i) => CirclePostModel.fromJson(i))
                      .toList()
                : []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'bio': bio,
      'stats': {
        'posts': postsCount,
        'friends': friendsCount,
        'followers': followersCount,
        'following': followingCount,
      },
      'relationshipStatus': relationshipStatus,
      'media': media,
      'posts': posts.map((p) => p.toJson()).toList(),
    };
  }

  UserProfileModel copyWith({
    String? id,
    String? name,
    String? avatar,
    String? bio,
    int? postsCount,
    int? friendsCount,
    int? followersCount,
    int? followingCount,
    String? relationshipStatus,
    List<String>? media,
    List<CirclePostModel>? posts,
  }) {
    return UserProfileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      bio: bio ?? this.bio,
      postsCount: postsCount ?? this.postsCount,
      friendsCount: friendsCount ?? this.friendsCount,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      relationshipStatus: relationshipStatus ?? this.relationshipStatus,
      media: media ?? this.media,
      posts: posts ?? this.posts,
    );
  }
}
