import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import 'grid_card_view.dart';
import 'open_container_anim.dart';

class ShowNotes extends StatelessWidget {
  final noteText = "";
  final storage = GetStorage();
  final ContainerTransitionType _transitionType = ContainerTransitionType.fade;

  ShowNotes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height / 1.2,
        width: MediaQuery.of(context).size.width,
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Users')
                .doc(storage.read('email'))
                .collection('Notes')
                .orderBy("timeStamp", descending: true)
                .snapshots(),
            // ignore: missing_return
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot> querySnapshot) {
              if (querySnapshot.hasError) {
                return const Center(child: Text('Has Error'));
              }
              if (querySnapshot.connectionState == ConnectionState.waiting) {
                const CircularProgressIndicator();
              }
              if (querySnapshot.data == null) {
                return _emptyNotes();
              }
              if (querySnapshot.data!.size == 0) {
                return _noNotes();
              } else {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    itemCount: querySnapshot.data!.docs.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10),
                    itemBuilder: (context, index) {
                      final DocumentSnapshot myNotes =
                          querySnapshot.data!.docs[index];
                      return OpenContainerWrapper(
                        snap: myNotes,
                        transitionType: _transitionType,
                        closedBuilder: (context, openContainer) {
                          return GridCardView(
                              snap: myNotes, openContainer: openContainer);
                        },
                      );
                    },
                  ),
                );
              }
            }),
      ),
    );
  }
}

Widget _emptyNotes() {
  return const Center(child: CupertinoActivityIndicator());
}

Widget _noNotes() {
  return Center(
      child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Image(
        image: AssetImage('assets/empty_notes.png'),
      ),
      Text(
        'No Notes Found in your History 🧐',
        style: TextStyle(color: Colors.grey[400], fontStyle: FontStyle.italic),
      ),
      Text(
        'Try create one',
        style: TextStyle(color: Colors.grey[400], fontStyle: FontStyle.italic),
      ),
    ],
  ));
}
