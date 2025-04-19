import 'package:equatable/equatable.dart';

class Direction extends Equatable {
  final String id;
  final String name;
  final String code;
  final List<String> subjects;
  final bool isDeleted;

  const Direction({
    required this.id,
    required this.name,
    required this.code,
    required this.subjects,
    this.isDeleted = false,
  });

  int get subjectsCount => subjects.length;

  @override
  List<Object?> get props => [id, name, code, subjects, isDeleted];
}
