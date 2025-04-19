class Direction {
  final String id;
  final String name;
  final String code;
  final String createdDate;
  final bool isDeleted;

  Direction({
    required this.id,
    required this.name,
    required this.code,
    required this.createdDate,
    this.isDeleted = false,
  });
}
