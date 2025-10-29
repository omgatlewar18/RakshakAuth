class AppUser {
  final String id;
  final String screenName;
  final String email;
  bool create;
  bool read;
  bool update;
  bool delete;
  bool isEnabled;

  AppUser({
    required this.id,
    required this.screenName,
    required this.email,
    this.create = false,
    this.read = false,
    this.update = false,
    this.delete = false,
    this.isEnabled = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'screenName': screenName,
      'email': email,
      'create': create,
      'read': read,
      'update': update,
      'delete': delete,
      'isEnabled': isEnabled,
    };
  }

  factory AppUser.fromJson(String id, Map<dynamic, dynamic> data) {
    return AppUser(
      id: id,
      screenName: data['screenName'] ?? 'Unknown',
      email: data['email'] ?? '',
      create: data['create'] ?? false,
      read: data['read'] ?? false,
      update: data['update'] ?? false,
      delete: data['delete'] ?? false,
      isEnabled: data['isEnabled'] ?? false,
    );
  }
}