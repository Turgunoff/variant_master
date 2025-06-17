import 'package:hive/hive.dart';

part 'variant_model.g.dart';

@HiveType(typeId: 1)
class VariantModel extends HiveObject {
  @HiveField(0)
  List<int> testIds; // Hive'dagi TestModel id'lari

  @HiveField(1)
  String subject;

  @HiveField(2)
  DateTime createdAt;

  @HiveField(3)
  String pdfPath; // Saqlangan PDF fayl yo‘li

  VariantModel({
    required this.testIds,
    required this.subject,
    required this.createdAt,
    required this.pdfPath,
  });
}
