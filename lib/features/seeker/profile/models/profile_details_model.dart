class ProfileDetailsModel {
  final ProfileUser user;

  ProfileDetailsModel({required this.user});

  factory ProfileDetailsModel.fromJson(Map<String, dynamic> json) {
    return ProfileDetailsModel(user: ProfileUser.fromJson(json['user'] ?? {}));
  }

  Map<String, dynamic> toJson() {
    return {'user': user.toJson()};
  }
}

class ProfileUser {
  final String id;
  final String name;
  final String avatar;
  final String bio;
  final ProfileStats stats;
  final List<ProfileJournal> journals;
  final List<String> media;

  ProfileUser({
    required this.id,
    required this.name,
    required this.avatar,
    required this.bio,
    required this.stats,
    required this.journals,
    required this.media,
  });

  factory ProfileUser.fromJson(Map<String, dynamic> json) {
    return ProfileUser(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      avatar: json['avatar'] ?? 'https://i.pravatar.cc/150?u=me',
      bio: json['bio'] ?? '',
      stats: ProfileStats.fromJson(json['stats'] ?? {}),
      journals: json['journals'] != null
          ? (json['journals'] as List)
                .map((i) => ProfileJournal.fromJson(i))
                .toList()
          : [],
      media: json['media'] != null ? List<String>.from(json['media']) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'bio': bio,
      'stats': stats.toJson(),
      'journals': journals.map((j) => j.toJson()).toList(),
      'media': media,
    };
  }
}

class ProfileStats {
  final int posts;
  final int friends;
  final int followers;
  final int following;

  ProfileStats({
    required this.posts,
    required this.friends,
    required this.followers,
    required this.following,
  });

  factory ProfileStats.fromJson(Map<String, dynamic> json) {
    return ProfileStats(
      posts: json['posts'] ?? 0,
      friends: json['friends'] ?? 0,
      followers: json['followers'] ?? 0,
      following: json['following'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'posts': posts,
      'friends': friends,
      'followers': followers,
      'following': following,
    };
  }
}

class ProfileJournal {
  final String id;
  final String title;
  final String content;
  final String date;
  final bool isPrivate;

  ProfileJournal({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.isPrivate,
  });

  factory ProfileJournal.fromJson(Map<String, dynamic> json) {
    return ProfileJournal(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      date: json['date'] ?? '',
      isPrivate: json['isPrivate'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'date': date,
      'isPrivate': isPrivate,
    };
  }
}
