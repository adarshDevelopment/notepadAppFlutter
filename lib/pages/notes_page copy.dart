import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/models/note_model.dart';
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

  @override
  void initState() {
    super.initState();
    titleText = TextEditingController();
    noteText = TextEditingController();
  }

  @override
  void dispose() {
    titleText.dispose();
    noteText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (noteText.text.trim().isNotEmpty ||
              titleText.text.trim().isNotEmpty) {
            NoteModel noteModel = NoteModel(
              id: 1,
              title: titleText.text.trim(),
              note: noteText.text.trim(),
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            );
            var result =
                await context.read<NoteService>().createNote(noteModel);
            if (result is String) {
              showSnackBar(context, result);
            } else {
              showSnackBar(context, 'note saved successfully');
            }
          } else {
            showSnackBar(context, 'Cannot save an empty note');
          }
        },
        child: const Icon(Icons.save),
      ),
      // backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        title: const Text('Take notes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Center(
          child: Column(
            children: [
              NoteTextFields(
                fontSize: 28,
                labelText: 'Title',
                controller: titleText,
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
              Focus(
                onFocusChange: (value) {},
                child: NoteTextFields(
                    fontSize: 16,
                    labelText: 'Start writing',
                    controller: noteText),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NoteTextFields extends StatelessWidget {
  const NoteTextFields(
      {super.key,
      required this.fontSize,
      required this.labelText,
      required this.controller});

  final double fontSize;
  final String labelText;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (String a) {
        controller.text = 'hello world';
      },
      controller: controller,
      style: TextStyle(fontSize: fontSize),
      decoration: InputDecoration(
          alignLabelWithHint: true,
          // hintText: 'Title',
          label: Text(
            labelText,
            style: TextStyle(fontSize: fontSize, color: Colors.grey.shade400),
          ),
          // border: const OutlineInputBorder(),
          border: InputBorder.none),
    );
  }
}
