import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'inkwell_overlay.dart';

class GridCardView extends StatelessWidget {
  final DocumentSnapshot snap;
  final VoidCallback openContainer;

  const GridCardView({Key? key,required this.snap, required this.openContainer}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWellOverlay(
      openContainer: openContainer,
      width: Get.width,
      height: Get.height,
      child:  GridTile(
          child:  Column(
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
                      const Text(
                        'Title',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                      Text(
                        snap['created'],
                        style: const TextStyle(fontSize: 8),
                      ),
                    ],
                  ),
                  Text(
                    snap['title'] ?? "N/A",
                    softWrap: false,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Note',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                  Text(
                    snap['Note'] ?? "N/A",
                    softWrap: true,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 20, color: Colors.black),
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
