import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_mate/models/income_model.dart';

class ChartController extends GetxController {


  /*Future<void> getData() async {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Users').doc(
          'ravindran1307@gmail.com').collection('IncomeGraph').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LinearProgressIndicator();
        } else {
          List<IncomeModel> model = snapshot.data.docs
              .map((documentSnapshot) =>
              IncomeModel.fromMap(documentSnapshot.data()))
              .toList();
          return CategoriesRow(model);
        }
      },);
  }*/

}