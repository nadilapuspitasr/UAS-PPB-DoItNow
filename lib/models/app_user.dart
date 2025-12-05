class AppUser {
  final String id;
  final String email;
  final String name;
  final String npm;
  final String major;

  AppUser({
    required this.id,
    required this.email,
    required this.name,
    required this.npm,
    required this.major,
  });

  // ======================
  // FACTORY FROM MAP
  // ======================
  factory AppUser.fromMaps({
    required Map<String, dynamic> authUser,
    Map<String, dynamic>? profile,
  }) {
    final p = profile ?? {};

    return AppUser(
      id: authUser['id'],
      email: authUser['email'] ?? '',
      name: p['name'] ?? '',
      npm: p['npm'] ?? '',
      major: p['major'] ?? '',
    );
  }


  // ======================
  // COPY WITH (INI YANG ERROR)
  // ======================
  AppUser copyWith({
    String? id,
    String? email,
    String? name,
    String? npm,
    String? major,
  }) {
    return AppUser(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      npm: npm ?? this.npm,
      major: major ?? this.major,
    );
  }
}
