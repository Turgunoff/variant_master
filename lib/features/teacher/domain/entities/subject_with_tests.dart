import 'package:equatable/equatable.dart';
import 'package:variant_master/features/teacher/domain/entities/test.dart';

class SubjectWithTests extends Equatable {
  final String id;
  final String name;
  final List<Test> tests;
  final bool isDeleted;

  const SubjectWithTests({
    required this.id,
    required this.name,
    required this.tests,
    this.isDeleted = false,
  });

  // Testlar soni
  int get testsCount => tests.where((test) => !test.isDeleted).length;

  // Nusxa olish va o'zgartirish
  SubjectWithTests copyWith({
    String? id,
    String? name,
    List<Test>? tests,
    bool? isDeleted,
  }) {
    return SubjectWithTests(
      id: id ?? this.id,
      name: name ?? this.name,
      tests: tests ?? this.tests,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  List<Object?> get props => [id, name, tests, isDeleted];
}
