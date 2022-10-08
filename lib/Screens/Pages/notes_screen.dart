import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:money_mate/Components/add_note.dart';
import 'package:money_mate/Components/notes_fetch.dart';

class NotesPage extends StatefulWidget {

  @override
  _NotesPageState createState() => _NotesPageState();
}

const double _fabDimension = 56;

class _NotesPageState extends State<NotesPage> {
  late String noteText;
  var storage = GetStorage();
  ContainerTransitionType _transitionType = ContainerTransitionType.fade;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notes',
          style:
              TextStyle(color: Colors.grey[400], fontStyle: FontStyle.italic),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ShowNotes(),
      floatingActionButton: OpenContainer(
        transitionType: _transitionType,
        openBuilder: (context, openContainer) => AddNotesPage(),
        closedElevation: 6,
        closedShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(_fabDimension / 2),
          ),
        ),
        closedColor: Colors.amber[200] as Color,
        closedBuilder: (context, openContainer) {
          return SizedBox(
            height: _fabDimension,
            width: _fabDimension,
            child: Center(
              child: Icon(
                CupertinoIcons.doc_on_doc,
                color: colorScheme.onSecondary,
              ),
            ),
          );
        },
      ),
    );
  }
}
