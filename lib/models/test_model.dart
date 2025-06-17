import 'package:hive/hive.dart';

part 'test_model.g.dart';

@HiveType(typeId: 0)
class TestModel extends HiveObject {
  @HiveField(0)
  String question;

  @HiveField(1)
  List<String> answers; // [A, B, C, D]

  @HiveField(2)
  int correctIndex; // 0-3

  @HiveField(3)
  String subject; // Yo'nalish (masalan: Matematika)

  TestModel({
    required this.question,
    required this.answers,
    required this.correctIndex,
    required this.subject,
  });
}
