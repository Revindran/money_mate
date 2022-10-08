import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:money_mate/Screens/Auth/reset_password_ui.dart';
import 'package:money_mate/Screens/Auth/signin_screen.dart';
import 'package:money_mate/Screens/Pages/transaction_history.dart';
import 'package:money_mate/controllers/user_controller.dart';
import 'package:shimmer/shimmer.dart';

class SettingsPage extends StatelessWidget {
  final storage = GetStorage();

  final _userController = Get.find<UserController>();

  SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 35.0, right: 10.0),
            child: Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  storage.remove('email');
                  Get.offAll(() => const SignInPage());
                },
                child: Container(
                  width: 88,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[100]),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          'Log Out',
                          style: TextStyle(
                              color: Colors.grey[500],
                              fontWeight: FontWeight.w500),
                        ),
                        Icon(
                          Icons.login_outlined,
                          color: Colors.grey[500],
                          size: 20,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: Get.height / 35,
          ),
          InkWell(
            // onTap: () => _userController.getPhotoAndUpload(),
            child: Hero(
              tag: 'tag',
              child: GetBuilder<UserController>(builder: (_) {
                return Container(
                  width: 100.0,
                  height: 100.0,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.contain,
                        image: AssetImage('assets/user_pic.png')),
                  ),
                );
              }),
            ),
          ),
          _sizedBoxVertical(),
          GetBuilder<UserController>(
            builder: (_) => Shimmer.fromColors(
              baseColor: Colors.grey[900] as Color,
              highlightColor: Colors.grey[200] as Color,
              child: Text(_userController.name,
                  style: TextStyle(
                      color: Colors.grey[900], fontWeight: FontWeight.w500)),
            ),
          ),
          Text(
            storage.read('email'),
            style:
                TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w500),
          ),
          _sizedBoxVertical(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Balance',
                style: TextStyle(
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic),
              ),
              Text(
                '₹ ${_userController.totalIncome.value - _userController.totalExpanse.value}',
                style: TextStyle(
                    color: _userController.totalIncome.value >
                            _userController.totalExpanse.value
                        ? Colors.green[500]
                        : Colors.red[400],
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              )
            ],
          ),
          _sizedBoxVertical(),
          Container(
            width: Get.width / 1.1,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[200] as Color,
                  blurRadius: 15.0, // soften the shadow
                  spreadRadius: 5.0, //extend the shadow
                  offset: const Offset(
                    1.0, // Move to right 10  horizontally
                    1.0, // Move to bottom 10 Vertically
                  ),
                )
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Icon(Icons.arrow_drop_up,
                              color: Colors.green, size: 40),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Total Income',
                                style: TextStyle(
                                    color: Colors.grey[500],
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FontStyle.italic),
                              ),
                              GetBuilder<UserController>(
                                  builder: (_) => Text(
                                        _userController.totalIncome.toString(),
                                        style: TextStyle(
                                            color: Colors.green[500],
                                            fontWeight: FontWeight.bold,
                                            fontSize: 25),
                                      ))
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        width: 1,
                        height: 50,
                        child: Container(
                          color: Colors.grey[300],
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.arrow_drop_down,
                              color: Colors.red, size: 40),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                ' Total Expanse',
                                style: TextStyle(
                                    color: Colors.grey[500],
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FontStyle.italic),
                              ),
                              GetBuilder<UserController>(
                                  builder: (_) => Text(
                                        _userController.totalExpanse.toString(),
                                        style: TextStyle(
                                            color: Colors.red[400],
                                            fontWeight: FontWeight.bold,
                                            fontSize: 25),
                                      ))
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5, top: 10, bottom: 10),
                child: Text(
                  "GENERAL",
                  style: TextStyle(
                      color: Colors.grey[500], fontWeight: FontWeight.w500),
                ),
              ),
              Container(
                width: Get.width / 1.05,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: Colors.grey[100]),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Profile Settings",
                        style: TextStyle(
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
              _sizedBoxVertical(),
              InkWell(
                onTap: () => Get.to(() => ResetPasswordUI()),
                child: Container(
                  width: Get.width / 1.05,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: Colors.grey[100]),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Change Password",
                          style: TextStyle(
                              color: Colors.grey[500],
                              fontWeight: FontWeight.w500),
                        ),
                        const Icon(Icons.arrow_right),
                      ],
                    ),
                  ),
                ),
              ),
              _sizedBoxVertical(),
              InkWell(
                onTap: () => Get.to(() => TransactionHistory()),
                child: Container(
                  width: Get.width / 1.05,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: Colors.grey[100]),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Transactions History",
                          style: TextStyle(
                              color: Colors.grey[500],
                              fontWeight: FontWeight.w500),
                        ),
                        const Icon(Icons.arrow_right),
                      ],
                    ),
                  ),
                ),
              ),
              _sizedBoxVertical(),
              Container(
                width: Get.width / 1.05,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: Colors.grey[100]),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Notifications",
                        style: TextStyle(
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w500),
                      ),
                      GetBuilder<UserController>(builder: (_) {
                        return CupertinoSwitch(
                          value: _userController.switchValue,
                          onChanged: (value) {
                            _userController.switchValueChange();
                          },
                        );
                      }),
                    ],
                  ),
                ),
              ),
              _sizedBoxVertical(),
            ],
          ),
          _sizedBoxVertical(),
          // Container(
          //   height: 50,
          //   child: AdWidget(
          //     key: UniqueKey(),
          //     ad: AdMobService.createSettingBannerAd()..load(),
          //   ),
          // )
        ],
      ),
    ));
  }
}

Widget _sizedBoxVertical() {
  return const SizedBox(height: 10);
}
