const String notesTable = 'notes_table';

class NoteModel {
  String title;
  String note;
  int id;
  DateTime createdAt;
  DateTime updatedAt;
  bool isSelected = false;

  NoteModel(
      {required this.title,
      required this.note,
      required this.id,
      required this.createdAt,
      required this.updatedAt});

  Map<String, dynamic> toJson() => {
        NoteFields.id: id,
        NoteFields.title: title,
        NoteFields.note: note,
        NoteFields.createdAt: createdAt.toIso8601String(),
        NoteFields.updatedAt: updatedAt.toIso8601String(),
      };

  static NoteModel fromJson(Map<String, dynamic> map) => NoteModel(
        title: map[NoteFields.title] as String,
        note: map[NoteFields.note] as String,
        id: map[NoteFields.id] as int,
        createdAt: DateTime.parse(map[NoteFields.createdAt] as String),
        updatedAt: DateTime.parse(map[NoteFields.updatedAt] as String),
      );

  @override
  int get hashCode => Object.hash(id, title);
}

class NoteFields {
  static const String note = 'note';
  static const String title = 'title';
  static const String id = 'id';
  static const String createdAt = 'created_at';
  static const String updatedAt = 'updated_at';
  static const allFields = [id, title, note, createdAt, updatedAt];
}
