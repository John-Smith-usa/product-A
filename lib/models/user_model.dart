enum UserRole { member, admin, owner }

class UserModel {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String? avatarUrl;
  final UserRole role;
  final DateTime createdAt;
  final DateTime lastLoginAt;
  final bool isActive;
  final UserPreferences preferences;

  const UserModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.avatarUrl,
    this.role = UserRole.member,
    required this.createdAt,
    required this.lastLoginAt,
    this.isActive = true,
    required this.preferences,
  });

  String get fullName => '$firstName $lastName';

  String get initials {
    final first = firstName.isNotEmpty ? firstName[0].toUpperCase() : '';
    final last = lastName.isNotEmpty ? lastName[0].toUpperCase() : '';
    return '$first$last';
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? avatarUrl,
    UserRole? role,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    bool? isActive,
    UserPreferences? preferences,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      isActive: isActive ?? this.isActive,
      preferences: preferences ?? this.preferences,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class UserPreferences {
  final bool darkMode;
  final bool pushNotifications;
  final bool emailNotifications;
  final String language;
  final String timeZone;
  final bool showCompletedTasks;

  const UserPreferences({
    this.darkMode = false,
    this.pushNotifications = true,
    this.emailNotifications = true,
    this.language = 'en',
    this.timeZone = 'UTC',
    this.showCompletedTasks = true,
  });

  UserPreferences copyWith({
    bool? darkMode,
    bool? pushNotifications,
    bool? emailNotifications,
    String? language,
    String? timeZone,
    bool? showCompletedTasks,
  }) {
    return UserPreferences(
      darkMode: darkMode ?? this.darkMode,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      language: language ?? this.language,
      timeZone: timeZone ?? this.timeZone,
      showCompletedTasks: showCompletedTasks ?? this.showCompletedTasks,
    );
  }
} 