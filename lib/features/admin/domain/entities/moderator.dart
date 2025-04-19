class Moderator {
  final String id;
  final String fullName;
  final String username;
  final int testsChecked;
  final bool isActive;
  final bool isDeleted;

  Moderator({
    required this.id,
    required this.fullName,
    required this.username,
    required this.testsChecked,
    required this.isActive,
    this.isDeleted = false,
  });

  Moderator copyWith({
    String? id,
    String? fullName,
    String? username,
    int? testsChecked,
    bool? isActive,
    bool? isDeleted,
  }) {
    return Moderator(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      username: username ?? this.username,
      testsChecked: testsChecked ?? this.testsChecked,
      isActive: isActive ?? this.isActive,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}
