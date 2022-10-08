import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class NotesDetails extends StatefulWidget {
  DocumentSnapshot snapData;

  NotesDetails({required this.snapData});

  @override
  _NotesDetailsState createState() => _NotesDetailsState();
}

DateTime dateTime = DateTime.now();
String yyMMdd = dateTime.toIso8601String().split('T').first;
var fire = FirebaseFirestore.instance;
var note = fire
    .collection('Users')
    .doc(FirebaseAuth.instance.currentUser!.email)
    .collection('Notes');

class _NotesDetailsState extends State<NotesDetails> {
  bool _isEditingText = false;
  late TextEditingController _titleController, _noteController;
  late String titleText;
  late String noteText;
  late String docID;
  late String createdDate;
  late String updatedDate;

  @override
  void initState() {
    super.initState();
    titleText = widget.snapData['title'] ?? "N/A";
    noteText = widget.snapData['Note'] ?? "N/A";
    createdDate = widget.snapData['created'] ?? "N/A";
    updatedDate = widget.snapData['updated'] ?? "N/A";
    docID = widget.snapData.id;
    _titleController = TextEditingController(text: titleText);
    _noteController = TextEditingController(text: noteText);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          '$titleText',
          style:
              TextStyle(color: Colors.grey[400], fontStyle: FontStyle.italic),
        ),
        actions: [
          IconButton(
            icon: Icon(
              CupertinoIcons.delete_solid,
              color: Colors.grey[500],
            ),
            onPressed: () {
              _deleteNote();
            },
          ),
          IconButton(
            icon: Icon(
              CupertinoIcons.doc_on_doc,
              color: Colors.grey[500],
            ),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: noteText)).then((value) {
                Get.snackbar('Copied', 'Note copied to clipboard',
                    snackPosition: SnackPosition.BOTTOM);
              });
            },
          )
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Created: $createdDate",
                    style: TextStyle(
                        color: Colors.grey[400], fontStyle: FontStyle.italic),
                  ),
                  updatedDate == ""
                      ? Text(
                          "LastUpdated: -",
                          style: TextStyle(
                              color: Colors.grey[400],
                              fontStyle: FontStyle.italic),
                        )
                      : Text(
                          "LastUpdated: $updatedDate",
                          style: TextStyle(
                              color: Colors.grey[400],
                              fontStyle: FontStyle.italic),
                        ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 10,
                bottom: 5,
              ),
              child: Container(
                width: MediaQuery.of(context).size.width / 1.05,
                decoration: BoxDecoration(
                    color: Colors.amber[100],
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _editTitleTextField(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 10,
                bottom: 5,
              ),
              child: Container(
                width: MediaQuery.of(context).size.width / 1.05,
                decoration: BoxDecoration(
                    color: Colors.amber[100],
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _editNoteTextField(),
                ),
              ),
            ),
            titleText == _titleController.text &&
                    noteText == _noteController.text
                ? _nonUpdateText()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                          bottom: 5,
                        ),
                        child: GestureDetector(
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.amberAccent,
                                borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text("Update"),
                            ),
                          ),
                          onTap: () {
                            _updateNote();
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                          bottom: 5,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.amberAccent,
                              borderRadius: BorderRadius.circular(20)),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text('Cancel'),
                          ),
                        ),
                      ),
                    ],
                  )
          ],
        ),
      ),
    );
  }

  Widget _editTitleTextField() {
    if (_isEditingText)
      return TextField(
        keyboardType: TextInputType.multiline,
        minLines: 1,
        maxLines: null,
        onSubmitted: (newValue) {
          setState(() {
            titleText = newValue;
            _isEditingText = false;
          });
        },
        autofocus: true,
        controller: _titleController,
      );
    return InkWell(
      onTap: () {
        setState(() {
          _isEditingText = true;
        });
      },
      child: Text(
        titleText,
        style: TextStyle(
          color: Colors.black,
          fontSize: 18.0,
        ),
      ),
    );
  }

  Widget _editNoteTextField() {
    if (_isEditingText)
      return TextField(
        keyboardType: TextInputType.multiline,
        minLines: 1,
        maxLines: null,
        onSubmitted: (newValue) {
          setState(() {
            noteText = newValue;
            _isEditingText = false;
          });
        },
        autofocus: true,
        controller: _noteController,
      );
    return InkWell(
      onTap: () {
        setState(() {
          _isEditingText = true;
        });
      },
      child: Text(
        noteText,
        style: TextStyle(
          color: Colors.black,
          fontSize: 18.0,
        ),
      ),
    );
  }

  void _deleteNote() {
    note.doc(docID).delete().then((value) {
      Navigator.pop(context);
      Get.snackbar('The Note has deleted successfully..',
          'The Note has deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 3),
          backgroundColor: Get.theme.snackBarTheme.backgroundColor,
          colorText: Get.theme.snackBarTheme.actionTextColor);
    });
  }

  void _updateNote() {
    note.doc(docID).update({
      "Note": _noteController.text,
      "title": _titleController.text,
      "updated": yyMMdd
    }).then((value) {
      Get.snackbar('Updated Successful..', 'The Note has Updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 3),
          backgroundColor: Get.theme.snackBarTheme.backgroundColor,
          colorText: Get.theme.snackBarTheme.actionTextColor);
    });
  }

  Widget _nonUpdateText() {
    return Center(
      child: Text(
        'Change Something to Update',
        style: TextStyle(color: Colors.grey[400], fontStyle: FontStyle.italic),
      ),
    );
  }
}
