import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/models/note_model.dart';
import 'package:notes_app/pages/home.dart';
import 'package:notes_app/pages/snackBar.dart';
import 'package:notes_app/services/notes_service.dart';
import 'package:provider/provider.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  late TextEditingController titleText;
  late TextEditingController noteText;

  void listener() {}

  @override
  void initState() {
    super.initState();
    titleText = TextEditingController();
    noteText = TextEditingController();
    //
    if (newNote == false) {
      titleText.text = context.read<NoteService>().currentNote.title;
      noteText.text = context.read<NoteService>().currentNote.note;
    }
  }

  @override
  void dispose() {
    titleText.dispose();
    noteText.dispose();
    super.dispose();
  }

  // void updateObject() {
  //   context.read<NoteService>().currentNote.title = titleText.text.trim();
  //   context.read<NoteService>().currentNote.note = noteText.text.trim();
  //   context.read<NoteService>().currentNote.updatedAt = DateTime.now();
  //   context
  //       .read<NoteService>()
  //       .updateNote(context.read<NoteService>().currentNote);
  // }

  Future saveOnChange() async {
    int id;
    // int id = context.read<NoteService>().notes.length + 1;

    // print('current variable id: $id');
    print(
        'note length: ${context.read<NoteService>().notes.length} || notes:${context.read<NoteService>().notes}');
    // print('notes: ${context.read<NoteService>().notes}');
    var result;
    print('editable bool value start: $newNote');
    // either of the textfields not empty
    if (noteText.text.trim().isNotEmpty || titleText.text.trim().isNotEmpty) {
      //if set to editable
      if (newNote == false) {
        print('new note inside saveOnChange func: $newNote');
        print(
            'current ID inside update: ${context.read<NoteService>().currentNote.id};');
        print(
            'id inside editable: ${context.read<NoteService>().currentNote.id}');

        context.read<NoteService>().currentNote.title = titleText.text.trim();
        context.read<NoteService>().currentNote.note = noteText.text.trim();
        context.read<NoteService>().currentNote.updatedAt = DateTime.now();
        result = await context
            .read<NoteService>()
            .updateNote(context.read<NoteService>().currentNote);
      } else {
        if (context.read<NoteService>().notes.isEmpty) {
          id = 1;
        } else {
          id = 1;
          List<NoteModel> notes = context.read<NoteService>().notes;
          List idNote = [];
          for (int i = 0; i < notes.length; i++) {
            idNote.add(notes[i].id);
          }
          bool found = true;
          while (found == true) {
            if (idNote.contains(id)) {
              found = true;
              id++;
            } else {
              found = false;
            }
          }
        }
        NoteModel noteModel = NoteModel(
          id: id,
          title: titleText.text.trim(),
          note: noteText.text.trim(),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        result = await context.read<NoteService>().createNote(noteModel);
        context.read<NoteService>().editNote(noteModel);
        // NoteService.editable = true;
      }
    } else if (newNote == false &&
        titleText.text.trim().isEmpty &&
        noteText.text.trim().isEmpty) {
      context
          .read<NoteService>()
          .deleteNote(context.read<NoteService>().currentNote);
      newNote = true;
    }
    print('editable bool value end: $newNote');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  floatingActionButton: FloatingActionButtonSave(noteText: noteText, titleText: titleText),
      // backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        title: const Text('Take notes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Consumer<NoteService>(
              builder: (context, value, child) {
                return NoteTextFields(
                  saveOnChange: saveOnChange,
                  multiLine: false,
                  noteService: value,
                  fontSize: 28,
                  labelText: 'Title',
                  controller: titleText,
                );
              },
            ),
            const SizedBox(
                // height: 5,
                ),
            Row(
              children: [
                Text(
                  // DateFormat.yMMMMd().format(DateTime.now()),
                  '${DateFormat.yMMMd().format(DateTime.now())} | ',
                  // DateTime.now().year.toString(),
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                Text(
                  style: TextStyle(color: Colors.grey.shade600),
                  DateFormat.jm().format(DateTime.now()),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            /*
            Consumer<NoteService>(
              builder: (context, value, build) {
                return Expanded(
                  child: EditableText(
                    maxLines: null,
                    focusNode: FocusNode(),
                    controller: noteText,
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                    cursorColor: Theme.of(context).colorScheme.primary,
                    backgroundCursorColor:
                        Theme.of(context).colorScheme.primary,
                  ),
                );
              },
            ),
            */
            Expanded(
              child: Container(
                // color: Colors.blueGrey,
                child: Consumer<NoteService>(
                  builder: (context, value, build) {
                    return NoteTextFields(
                      saveOnChange: saveOnChange,
                      multiLine: true,
                      noteService: value,
                      fontSize: 16,
                      labelText: 'Start writing',
                      controller: noteText,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FloatingActionButtonSave extends StatelessWidget {
  const FloatingActionButtonSave({
    super.key,
    required this.noteText,
    required this.titleText,
  });

  final TextEditingController noteText;
  final TextEditingController titleText;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        print('new notevalue: $newNote');
        int id = context.read<NoteService>().notes.length + 1;
        var result;
        // textfields are not empty
        if (noteText.text.trim().isNotEmpty ||
            titleText.text.trim().isNotEmpty) {
          //if set to editable
          if (newNote == false) {
            print('newNote value is true');
            print(
                'currentNote edit id: ${context.read<NoteService>().currentNote.id}');

            context.read<NoteService>().currentNote.title =
                titleText.text.trim();
            context.read<NoteService>().currentNote.note = noteText.text.trim();
            context.read<NoteService>().currentNote.updatedAt = DateTime.now();
            result = context
                .read<NoteService>()
                .updateNote(context.read<NoteService>().currentNote);
          } else {
            print('newNote vaue is true');
            NoteModel noteModel = NoteModel(
              // id: context.read<NoteService>().notes.length,
              id: id,
              title: titleText.text.trim(),
              note: noteText.text.trim(),
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            );

            result = await context.read<NoteService>().createNote(noteModel);
          }

          if (result is String) {
            showSnackBar(context, result);
          } else {
            // showSnackBar(context, 'note saved successfully');
            Navigator.pop(context);
          }
        } else {
          showSnackBar(context, 'Cannot save an empty note');
        }
      },
      child: const Icon(Icons.save),
    );
  }
}

class NoteTextFields extends StatelessWidget {
  NoteTextFields({
    super.key,
    required this.fontSize,
    required this.labelText,
    required this.controller,
    required this.noteService,
    required this.multiLine,
    required this.saveOnChange,
  });

  final double fontSize;
  final String labelText;
  final TextEditingController controller;
  final NoteService noteService;
  final bool multiLine;
  Future Function() saveOnChange;

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: multiLine ? null : 1,
      onChanged: (String value) async {
        await saveOnChange();
        //  controller.text = noteService.currentNote.title;
      },
      controller: controller,
      style: TextStyle(fontSize: fontSize),
      decoration: InputDecoration(
        alignLabelWithHint: true,
        // hintText: 'Title',
        label: Text(
          // noteService.currentNote.title,
          labelText,
          style: TextStyle(fontSize: fontSize, color: Colors.grey.shade400),
        ),
        // border: const OutlineInputBorder(),
        border: InputBorder.none,
      ),
    );
  }
}

void test() {
  List<A> list = [A(), A(), A()];
  list[0].num;
}

class A {
  int? num;
}
