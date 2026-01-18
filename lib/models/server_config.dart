class ServerConfig {
  final String baseUrl;
  final String? token;
  final DateTime? lastUpdated;

  ServerConfig({
    required this.baseUrl,
    this.token,
    this.lastUpdated,
  });

  Map<String, dynamic> toJson() {
    return {
      'baseUrl': baseUrl,
      'token': token,
      'lastUpdated': lastUpdated?.toIso8601String(),
    };
  }

  factory ServerConfig.fromJson(Map<String, dynamic> json) {
    return ServerConfig(
      baseUrl: json['baseUrl'] ?? '',
      token: json['token'],
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'])
          : null,
    );
  }

  ServerConfig copyWith({
    String? baseUrl,
    String? token,
    DateTime? lastUpdated,
  }) {
    return ServerConfig(
      baseUrl: baseUrl ?? this.baseUrl,
      token: token ?? this.token,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
