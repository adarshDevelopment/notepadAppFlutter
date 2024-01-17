import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/models/note_model.dart';
import 'package:notes_app/pages/snackBar.dart';
import 'package:notes_app/routes/routes.dart';
import 'package:notes_app/services/notes_service.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<NoteService>().getNotes();
  }

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
/*
      appBar: AppBar(
        title: Consumer<NoteService>(
          builder: (context, value, child) {
            return value.selectedList.isNotEmpty
                ? Text('${value.selectedList.length.toString()} items selected')
                : const Text('');
          },
        ),
      ),
*/
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 10, 8, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   const Padding(
                     padding: EdgeInsets.only(left: 10),
                     child: Text(
                      'Notes',
                      style: TextStyle(fontSize: 30),
                                       ),
                   ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Consumer<NoteService>(
                      builder: (context, value, child) {
                        return value.selectedList.isNotEmpty
                            ? Text(
                                '${value.selectedList.length.toString()} items selected', style: const TextStyle(fontSize: 16),)
                            : const Text('');
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                onChanged: (value) {
                  runFilter(context, value);
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  hintText: 'Search Notes...',
                  hintStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  fillColor: Colors.grey.shade800,
                  filled: false,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Expanded(
                child: Consumer<NoteService>(
                  builder: (context, value, child) {
                    return ListView.builder(
                        itemCount: value.searchNotes.length,
                        itemBuilder: (context, index) {
                          return NoteList(
                            scaffoldKey: scaffoldKey,
                            noteModel: value.searchNotes[index],
                          );
                        });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: context.watch<NoteService>().selectedList.isEmpty
          ? FloatingActionButton(
              shape: const CircleBorder(),
              backgroundColor: Colors.grey.shade500,
              onPressed: () {
                newNote = true;
                print('new note inside floatingaction button home: $newNote');
                Navigator.pushNamed(context, RouteManager.notePage);
              },
              child: Icon(
                color: Colors.grey.shade100,
                // Icons.add_circle,
                Icons.add,
                size: 40,
              ),
            )
          : FloatingActionButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text(
                          'Delete Notes',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 42),
                          textAlign: TextAlign.center,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              context.read<NoteService>().deleteMultiple(
                                  context.read<NoteService>().selectedList);
                              Navigator.pop(context);
                            },
                            child: const Text('Delete'),
                          ),
                          TextButton(
                            onPressed: () {
                              
                              Navigator.pop(context);
                            },
                            child: const Text('Cancel'),
                          ),
                        ],
                      );
                    });
              },
              shape: const CircleBorder(),
              child: Icon(
                color: Colors.red.shade400,
                // Icons.add_circle,
                Icons.delete,
                size: 40,
              ),
            ),
    );
  }
}

/*
FloatingActionButton(
              onPressed: () {},
              shape: const CircleBorder(),
              child: Icon(
                color: Colors.grey.shade100,
                // Icons.add_circle,
                Icons.add,
                size: 40,
              ),
            )
*/
//allUser = og list ... _foundList = empty but assgined to og list....

// function to filter serach results
void runFilter(BuildContext context, String value) {
  Iterable result = [];
  var ogList = context.read<NoteService>().notes;
  if (value.isEmpty) {
    // result = ogList;
    context.read<NoteService>().setSearchNotes(ogList);
  } else {
    result = ogList.where((element) =>
        element.title.toLowerCase().contains(value.toLowerCase()) ||
        element.note.toLowerCase().contains(value.toLowerCase()));
    print('search result: $result');
    context.read<NoteService>().setSearchNotes(result.toList());
  }
}

class NoteList extends StatelessWidget {
  const NoteList(
      {super.key, required this.noteModel, required this.scaffoldKey});

  final GlobalKey scaffoldKey;
  final NoteModel noteModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onLongPress: () {
          context.read<NoteService>().changeIsSelected(noteModel);
          context.read<NoteService>().selectItems(noteModel);
          //
          /*
          showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      var result = await context
                          .read<NoteService>()
                          .deleteNote(noteModel);
                      Navigator.pop(context);
                      if (result is String) {
                        showSnackBar(context, result);
                      }
                    },
                    child: const Icon(Icons.delete),
                  ),
                );
              });
        */
        },
        onTap: () {
          if (context.read<NoteService>().selectedList.isEmpty) {
            context.read<NoteService>().currentNote = noteModel;
            context.read<NoteService>().editNote(noteModel);
            Navigator.pushNamed(context, RouteManager.notePage);
          } else {
            context.read<NoteService>().changeIsSelected(noteModel);
            context.read<NoteService>().selectItems(noteModel);
          }
        },
        child: Card(
          color: Colors.white,
          child: ListTile(
            title: RichText(
              maxLines: 4,
              text: TextSpan(
                text: '${noteModel.title}\n',
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                    fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                    // text: noteModel.note,
                    // text: noteModel.id.toString(),
                    text: noteModel.note,
                    style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.normal),
                  )
                ],
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 0, bottom: 0),
              child: Text(
                // '${DateFormat.yMMMd().format(DateTime.now())} ${DateFormat.jm().format(DateTime.now())}',
                '${DateFormat.yMMMd().format(noteModel.updatedAt)} ${DateFormat.jm().format(noteModel.updatedAt)}',
                style: const TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            trailing: context.read<NoteService>().selectedList.isNotEmpty
                ? Checkbox(
                    value: noteModel.isSelected,
                    onChanged: (bool? value) {
                      // context.read<NoteService>().changeIsSelected(noteModel);
                    },
                  )
                : const Text(''),
          ),
        ),
      ),
    );
  }
}
