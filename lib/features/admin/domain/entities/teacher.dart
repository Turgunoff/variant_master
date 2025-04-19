import 'package:equatable/equatable.dart';

class Teacher extends Equatable {
  final String id;
  final String fullName;
  final String username;
  final List<String> subjects;
  final int testsCount;

  final bool isActive;
  final bool isDeleted;

  const Teacher({
    required this.id,
    required this.fullName,
    required this.username,
    required this.subjects,
    required this.testsCount,
    required this.isActive,
    this.isDeleted = false,
  });

  int get subjectsCount => subjects.length;

  @override
  List<Object?> get props =>
      [id, fullName, username, subjects, testsCount, isActive, isDeleted];
}
