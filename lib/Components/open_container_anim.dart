import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'notes_details.dart';

class OpenContainerWrapper extends StatelessWidget {
  const OpenContainerWrapper({Key? key,required this.closedBuilder, required this.transitionType, required this.snap}): super(key: key);

  final CloseContainerBuilder closedBuilder;
  final ContainerTransitionType transitionType;
  final DocumentSnapshot snap;

  @override
  Widget build(BuildContext context) {
    return OpenContainer<bool>(
      transitionType: transitionType,
      openBuilder: (context, openContainer) => NotesDetails(
        snapData: snap,
      ),
      tappable: false,
      closedBuilder: closedBuilder,
    );
  }
}