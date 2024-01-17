import 'package:notes_app/models/note_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class NoteDatabase {
  static Database? _database;

  static final NoteDatabase instance = NoteDatabase._initialize();
  NoteDatabase._initialize();

  Future<Database?> get database async {
    if (_database != null) {
      // alterTable(_database!);
      return _database;
    } else {
      _database = await initDatabase('note_draft4');
      return _database;
    }
  }

  Future initDatabase(String fileName) async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, fileName);
    return await openDatabase(
      path,
      version: 1,
      onCreate: createDatabaseTables,
      // onUpgrade: _onUpgrade,
    );
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      print('inside onupgrade');
      db.execute(
          " ALTER TABLE $notesTable add column ${NoteFields.createdAt} text, ${NoteFields.updatedAt} text");
    } else {
      print('onupgrade not working');
    }
  }

  Future createDatabaseTables(Database db, int version) async {
    const standardText = 'TEXT';
    await db.execute('''CREATE TABLE $notesTable(
        ${NoteFields.id} INTEGER PRIMARY KEY,
        ${NoteFields.title} $standardText,
        ${NoteFields.note} $standardText,
        ${NoteFields.createdAt} $standardText,
        ${NoteFields.updatedAt} $standardText)

    ''');
  }

  Future alterTable(Database db) async {
    await db.execute(
        " ALTER TABLE $notesTable add column ${NoteFields.createdAt} text, ${NoteFields.updatedAt} text");
  }

  Future createNote(NoteModel noteModel) async {
    print('id inside createNote db note: ${noteModel.id}');
    final db = await instance.database;
    try {
      final result = await db!.insert(notesTable, noteModel.toJson());
    } catch (e) {
      print('inside create note: ${e.toString()}');
    }
  }

  Future updateNote(NoteModel noteModel) async {
    try {
      final db = await instance.database;
      var result = db!.update(notesTable, noteModel.toJson(),
          where: 'id = ?', whereArgs: [noteModel.id]);
      return true;
    } catch (e) {
      return e.toString();
    }
  }

  Future getNotes() async {
    final db = await instance.database;
    try {
      final result = await db?.query(notesTable,
          columns: NoteFields.allFields,
          orderBy: '${NoteFields.updatedAt} DESC');
      return result != null
          ? result.map((e) => NoteModel.fromJson(e)).toList()
          : [];
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }

  Future deleteNote(NoteModel noteModel) async {
    print('inside DeleteNote db. title: ${noteModel.id}');
    final db = await instance.database;
    try {
      var result = await db!
          .delete(notesTable, where: 'id = ?', whereArgs: [noteModel.id]);
      print('inside DeleteNote db. result: $result');
    } catch (e) {
      return e.toString();
    }
    return true;
  }
}
