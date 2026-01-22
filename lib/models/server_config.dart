class ServerConfig {
  final String baseUrl;
  final String name;
  final String? token;
  final DateTime? lastUpdated;
  final bool isActive;

  ServerConfig({
    required this.baseUrl,
    this.name = '',
    this.token,
    this.lastUpdated,
    this.isActive = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'baseUrl': baseUrl,
      'name': name,
      'token': token,
      'lastUpdated': lastUpdated?.toIso8601String(),
      'isActive': isActive,
    };
  }

  factory ServerConfig.fromJson(Map<String, dynamic> json) {
    return ServerConfig(
      baseUrl: json['baseUrl'] ?? '',
      name: json['name'] ?? '',
      token: json['token'],
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'])
          : null,
      isActive: json['isActive'] ?? false,
    );
  }

  ServerConfig copyWith({
    String? baseUrl,
    String? name,
    String? token,
    DateTime? lastUpdated,
    bool? isActive,
  }) {
    return ServerConfig(
      baseUrl: baseUrl ?? this.baseUrl,
      name: name ?? this.name,
      token: token ?? this.token,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      isActive: isActive ?? this.isActive,
    );
  }
}
