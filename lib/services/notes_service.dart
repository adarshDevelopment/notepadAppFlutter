import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:notes_app/database/note_database.dart';
import 'package:notes_app/models/note_model.dart';

bool newNote = true;

class NoteService with ChangeNotifier {
  List<NoteModel> _notes = [];
  List<NoteModel> get notes => _notes;

  List _searchNotes = [];
  List get searchNotes => _searchNotes;
  void setSearchNotes(List searchNotes) {
    _searchNotes = searchNotes;
    notifyListeners();
  }

  late NoteModel _currentNote;
  set currentNote(NoteModel noteModel) {
    _currentNote = noteModel;
    notifyListeners();
  }

  // final List<NoteModel> _selectedList = [];
  final HashSet<NoteModel> _selectedList = HashSet();
  HashSet<NoteModel> get selectedList => _selectedList;

  void selectItems(NoteModel noteModel) {
    noteModel.isSelected ? false : true;
    if (_selectedList.contains(noteModel)) {
      _selectedList.remove(noteModel);
    } else {
      _selectedList.add(noteModel);
    }
    notifyListeners();
  }

  Future deleteMultiple(HashSet<NoteModel> list) async {
    print('inside deleteMultiple');
    dynamic result;
    try {
      for (var element in list) { 
        NoteDatabase.instance.deleteNote(element);
      }
    } catch (e) {
      return e.toString();
    }
    _selectedList.clear();
    notifyListeners();
    getNotes();
  }

  void changeIsSelected(NoteModel noteModel) {
    noteModel.isSelected = !noteModel.isSelected;
    notifyListeners();
  }

  void setNewNote(bool value) => newNote = value;

  NoteModel get currentNote => _currentNote;

  // Future saveNotetoDb(String title, String note) async {
  Future createNote(NoteModel noteModel) async {
    print('inside create. id: ${noteModel.id}');
    try {
      final db = await NoteDatabase.instance.createNote(noteModel);
      print('notemodel id from createNote: ${noteModel.id}');
      newNote = false;
      getNotes();
    } catch (e) {
      return e.toString();
    }
  }

  Future updateNote(NoteModel noteModel) async {
    print('inside updateNote. title: ${noteModel.title}');
    print('inside updateNote. id: ${noteModel.id}');
    try {
      var result = await NoteDatabase.instance.updateNote(noteModel);
      // print('result inside updateNote: $result');
      getNotes();
    } catch (e) {
      return e.toString();
    }
  }

  Future editNote(NoteModel noteModel) async {
    print('insdie edit note id: ${noteModel.id}');
    newNote = false;
    _currentNote = noteModel;
    print('currentNote id: ${_currentNote.id} || titl: ${_currentNote.title}');
    notifyListeners();
  }

  Future deleteNote(NoteModel noteModel) async {
    try {
      var result = await NoteDatabase.instance.deleteNote(noteModel);
      getNotes();
    } catch (e) {
      return e.toString();
    }
  }

  Future getNotes() async {
    _notes = await NoteDatabase.instance.getNotes();
    _searchNotes = _notes;
    notifyListeners();
  }
}
