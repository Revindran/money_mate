import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'inkwell_overlay.dart';

class GridCardView extends StatelessWidget {
  final DocumentSnapshot snap;
  final VoidCallback openContainer;

  GridCardView({required this.snap, required this.openContainer});

  @override
  Widget build(BuildContext context) {
    return InkWellOverlay(
      openContainer: openContainer,
      width: Get.width,
      height: Get.height,
      child: new GridTile(
          child: new Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              color: Colors.transparent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Title',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                      Text(
                        snap['created'],
                        style: TextStyle(fontSize: 8),
                      ),
                    ],
                  ),
                  Text(
                    snap['title'] ?? "N/A",
                    softWrap: false,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Note',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                  Text(
                    snap['Note'] ?? "N/A",
                    softWrap: true,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}
