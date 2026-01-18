class User {
  final String email;
  final String nickname;
  final String? avatar;
  String? accessToken;

  User({
    required this.email,
    required this.nickname,
    this.avatar,
    this.accessToken,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'] ?? '',
      nickname: json['nickname'] ?? json['name'] ?? '',
      avatar: json['avatar'],
      accessToken: json['access_token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'nickname': nickname,
      'avatar': avatar,
      'access_token': accessToken,
    };
  }
}
