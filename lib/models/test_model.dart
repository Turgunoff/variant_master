class TestModel {
  final int? id;
  final String question;
  final List<String> answers;
  final int correctIndex;
  final String subject;
  final DateTime createdAt;

  TestModel({
    this.id,
    required this.question,
    required this.answers,
    required this.correctIndex,
    required this.subject,
    required this.createdAt,
  });

  // Создание из Map (из базы данных)
  factory TestModel.fromMap(Map<String, dynamic> map) {
    return TestModel(
      id: map['id'],
      question: map['question'],
      answers: [
        map['answer_a'],
        map['answer_b'],
        map['answer_c'],
        map['answer_d'],
      ],
      correctIndex: map['correct_index'],
      subject: map['subject'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  // Преобразование в Map (для базы данных)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question': question,
      'answer_a': answers[0],
      'answer_b': answers[1],
      'answer_c': answers[2],
      'answer_d': answers[3],
      'correct_index': correctIndex,
      'subject': subject,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // Копирование с изменениями
  TestModel copyWith({
    int? id,
    String? question,
    List<String>? answers,
    int? correctIndex,
    String? subject,
    DateTime? createdAt,
  }) {
    return TestModel(
      id: id ?? this.id,
      question: question ?? this.question,
      answers: answers ?? this.answers,
      correctIndex: correctIndex ?? this.correctIndex,
      subject: subject ?? this.subject,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
