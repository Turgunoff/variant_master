class VariantModel {
  final int? id;
  final String subject;
  final String pdfPath;
  final DateTime createdAt;
  final List<int> testIds;

  VariantModel({
    this.id,
    required this.subject,
    required this.pdfPath,
    required this.createdAt,
    required this.testIds,
  });

  // Создание из Map (из базы данных)
  factory VariantModel.fromMap(Map<String, dynamic> map) {
    return VariantModel(
      id: map['id'],
      subject: map['subject'],
      pdfPath: map['pdf_path'],
      createdAt: DateTime.parse(map['created_at']),
      testIds: [], // Будет загружено отдельно
    );
  }

  // Преобразование в Map (для базы данных)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subject': subject,
      'pdf_path': pdfPath,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // Копирование с изменениями
  VariantModel copyWith({
    int? id,
    String? subject,
    String? pdfPath,
    DateTime? createdAt,
    List<int>? testIds,
  }) {
    return VariantModel(
      id: id ?? this.id,
      subject: subject ?? this.subject,
      pdfPath: pdfPath ?? this.pdfPath,
      createdAt: createdAt ?? this.createdAt,
      testIds: testIds ?? this.testIds,
    );
  }
}
