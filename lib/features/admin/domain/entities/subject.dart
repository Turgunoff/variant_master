import 'package:equatable/equatable.dart';

class Subject extends Equatable {
  final String id;
  final String name;
  final int testsCount;
  final List<String> topics;

  const Subject({
    required this.id,
    required this.name,
    required this.testsCount,
    required this.topics,
  });

  int get topicsCount => topics.length;

  @override
  List<Object?> get props => [id, name, testsCount, topics];
}
