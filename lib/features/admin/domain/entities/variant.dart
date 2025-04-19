import 'package:equatable/equatable.dart';

class Variant extends Equatable {
  final String id;
  final String name;
  final String directionId;
  final String directionName;
  final List<String> subjectIds;
  final List<String> subjectNames;
  final int testsPerSubject;
  final bool isNewPage;
  final String exportFormat;
  final bool isDeleted;

  const Variant({
    required this.id,
    required this.name,
    required this.directionId,
    required this.directionName,
    required this.subjectIds,
    required this.subjectNames,
    required this.testsPerSubject,
    this.isNewPage = true,
    this.exportFormat = 'PDF',
    this.isDeleted = false,
  });

  // Nusxa olish va o'zgartirish
  Variant copyWith({
    String? id,
    String? name,
    String? directionId,
    String? directionName,
    List<String>? subjectIds,
    List<String>? subjectNames,
    int? testsPerSubject,
    bool? isNewPage,
    String? exportFormat,
    bool? isDeleted,
  }) {
    return Variant(
      id: id ?? this.id,
      name: name ?? this.name,
      directionId: directionId ?? this.directionId,
      directionName: directionName ?? this.directionName,
      subjectIds: subjectIds ?? this.subjectIds,
      subjectNames: subjectNames ?? this.subjectNames,
      testsPerSubject: testsPerSubject ?? this.testsPerSubject,
      isNewPage: isNewPage ?? this.isNewPage,
      exportFormat: exportFormat ?? this.exportFormat,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        directionId,
        directionName,
        subjectIds,
        subjectNames,
        testsPerSubject,
        isNewPage,
        exportFormat,
        isDeleted,
      ];
}
