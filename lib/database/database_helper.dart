import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'variant_master.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    // Таблица тестов
    await db.execute('''
      CREATE TABLE tests (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        question TEXT NOT NULL,
        answer_a TEXT NOT NULL,
        answer_b TEXT NOT NULL,
        answer_c TEXT NOT NULL,
        answer_d TEXT NOT NULL,
        correct_index INTEGER NOT NULL,
        subject TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    // Таблица вариантов
    await db.execute('''
      CREATE TABLE variants (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        subject TEXT NOT NULL,
        pdf_path TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    // Таблица связи тестов с вариантами
    await db.execute('''
      CREATE TABLE variant_tests (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        variant_id INTEGER NOT NULL,
        test_id INTEGER NOT NULL,
        FOREIGN KEY (variant_id) REFERENCES variants (id) ON DELETE CASCADE,
        FOREIGN KEY (test_id) REFERENCES tests (id) ON DELETE CASCADE
      )
    ''');
  }

  // Методы для работы с тестами
  Future<int> insertTest(Map<String, dynamic> test) async {
    final db = await database;
    return await db.insert('tests', test);
  }

  Future<List<Map<String, dynamic>>> getAllTests() async {
    final db = await database;
    return await db.query('tests', orderBy: 'created_at DESC');
  }

  Future<List<Map<String, dynamic>>> getTestsBySubject(String subject) async {
    final db = await database;
    return await db.query(
      'tests',
      where: 'subject = ?',
      whereArgs: [subject],
      orderBy: 'created_at DESC',
    );
  }

  Future<int> deleteTest(int id) async {
    final db = await database;
    return await db.delete('tests', where: 'id = ?', whereArgs: [id]);
  }

  // Методы для работы с вариантами
  Future<int> insertVariant(Map<String, dynamic> variant) async {
    final db = await database;
    return await db.insert('variants', variant);
  }

  Future<List<Map<String, dynamic>>> getAllVariants() async {
    final db = await database;
    return await db.query('variants', orderBy: 'created_at DESC');
  }

  Future<int> deleteVariant(int id) async {
    final db = await database;
    return await db.delete('variants', where: 'id = ?', whereArgs: [id]);
  }

  // Методы для работы со связями тестов и вариантов
  Future<void> insertVariantTests(int variantId, List<int> testIds) async {
    final db = await database;
    final batch = db.batch();

    for (int testId in testIds) {
      batch.insert('variant_tests', {
        'variant_id': variantId,
        'test_id': testId,
      });
    }

    await batch.commit(noResult: true);
  }

  Future<List<Map<String, dynamic>>> getTestsForVariant(int variantId) async {
    final db = await database;
    return await db.rawQuery(
      '''
      SELECT t.* FROM tests t
      INNER JOIN variant_tests vt ON t.id = vt.test_id
      WHERE vt.variant_id = ?
      ORDER BY vt.id
    ''',
      [variantId],
    );
  }

  Future<void> deleteVariantTests(int variantId) async {
    final db = await database;
    await db.delete(
      'variant_tests',
      where: 'variant_id = ?',
      whereArgs: [variantId],
    );
  }

  // Закрытие базы данных
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
