import 'package:equatable/equatable.dart';

class Test extends Equatable {
  final String id;
  final String text;
  final String correctAnswer;
  final List<String> options;
  final bool isDeleted;

  const Test({
    required this.id,
    required this.text,
    required this.correctAnswer,
    required this.options,
    this.isDeleted = false,
  });

  // Nusxa olish va o'zgartirish
  Test copyWith({
    String? id,
    String? text,
    String? correctAnswer,
    List<String>? options,
    bool? isDeleted,
  }) {
    return Test(
      id: id ?? this.id,
      text: text ?? this.text,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      options: options ?? this.options,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  List<Object?> get props => [id, text, correctAnswer, options, isDeleted];
}
