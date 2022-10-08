import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:money_mate/Components/bottom_bar.dart';
import 'package:money_mate/Screens/Auth/signin_screen.dart';

class UserController extends GetxController {
  final _fireStore = FirebaseFirestore.instance;
  var storage = GetStorage();
  var name = '...';
  var photoUrl = '...';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  RxInt totalIncome = 0.obs, totalExpanse = 0.obs, totalBalance = 0.obs;
  var switchValue = true;
  var email = "";

  getUser() {
    email = storage.read('email');
    _fireStore.collection('Users').doc(email).get().then((value) {
      name = value['Name'];
      photoUrl = value['photoUrl'];
      update();
    });
  }

  Future<void> sendPasswordResetEmail(BuildContext context,
      {required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      Get.snackbar('Resetting Password Email Send',
          'Check your Email for Resetting the Password',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 5),
          backgroundColor: Get.theme.snackBarTheme.backgroundColor,
          colorText: Get.theme.snackBarTheme.actionTextColor);
      Get.off(() => SignInPage());
    } on FirebaseAuthException catch (error) {
      Get.snackbar('Error', error.message.toString(),
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 10),
          backgroundColor: Get.theme.snackBarTheme.backgroundColor,
          colorText: Get.theme.snackBarTheme.actionTextColor);
    }
  }

  totalAmountCalculations() {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(email)
        .collection('Transactions')
        .get()
        .then((value) {
      for (int i = 0; i < value.docs.length; i++) {
        QueryDocumentSnapshot snapshot = value.docs[i];
        if (snapshot['Type'] == 'Income') {
          totalIncome += int.parse(snapshot['Amount']);
        } else if (snapshot['Type'] == 'Expanse') {
          totalExpanse += int.parse(snapshot['Amount']);
        }
        update();
      }
    });
  }

  void switchValueChange() {
    if (switchValue == true) {
      switchValue = false;
    } else {
      switchValue = true;
    }
    update();
  }

  late File file;
  late String fileUrl;
  late String fileName;
  late FilePickerResult result;
  late firebase_storage.UploadTask uploadTask;
  var fireStore = FirebaseFirestore.instance;

  late Reference reference;

  Future getPhotoAndUpload() async {
    var rng = Random();
    String randomName = "";
    for (var i = 0; i < 20; i++) {
      if (kDebugMode) {
        print(rng.nextInt(100));
      }
      randomName += rng.nextInt(100).toString();
    }
    result = (await FilePicker.platform.pickFiles())!;

    if (result != null) {
      file = File(result.files.single.path.toString());
    } else {
      // User canceled the picker
    }
    fileName = randomName;
    if (kDebugMode) {
      print(fileName);
    }
    if (kDebugMode) {
      print('${file.readAsBytesSync()}');
    }
    savePhoto(file.readAsBytesSync(), fileName);
  }

  Future savePhoto(List<int> asset, String name) async {
    Get.snackbar('Uploading File', 'Uploading File Please Wait',
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.BOTTOM,
        showProgressIndicator: true);
    reference = FirebaseStorage.instance.ref().child("UserImages").child(name);
    uploadTask = reference.putFile(file);

    uploadTask.whenComplete(() async {
      try {
        fileUrl = await reference.getDownloadURL();
      } catch (onError) {
        if (kDebugMode) {
          print("Error");
        }
        Get.snackbar(
          'Error',
          onError.toString(),
          duration: const Duration(seconds: 3),
          snackPosition: SnackPosition.BOTTOM,
          shouldIconPulse: true,
        );
      }
      if (kDebugMode) {
        print(fileUrl);
      }
    }).then((value) {
      Get.snackbar('Upload Successful', 'Upload Successfully Done',
          duration: const Duration(seconds: 3),
          snackPosition: SnackPosition.BOTTOM,
          snackStyle: SnackStyle.FLOATING);
      fireStore.collection('Users').doc(email).update({
        "photoUrl": fileUrl,
      });
      Get.off(const BottomHomeBar(index: 0));
    });
  }
}
