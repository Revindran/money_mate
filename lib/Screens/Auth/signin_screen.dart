import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:money_mate/Components/bottom_bar.dart';
import 'package:money_mate/Screens/Auth/reset_password_ui.dart';
import 'package:money_mate/Screens/Auth/signup_screen.dart';
import 'package:money_mate/Screens/Pages/home_screen.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  late String _email;

  late String _password;

  bool _isLoading = false;

  var storage = GetStorage();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    _email = "";
    _password = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade300,
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 1.8,
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(40)),
                    color: Colors.amber),
              )
            ],
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 70),
                  child: Text(
                    "Money Mate",
                    style: Theme.of(context).textTheme.headline4!.copyWith(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                  ),
                ),
                Text(
                  "Track Your Money Flow",
                  style: Theme.of(context).textTheme.headline4!.copyWith(
                        fontStyle: FontStyle.italic,
                        fontSize: 16,
                        color: Colors.grey.shade800,
                      ),
                ),
              ],
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: ListView(
              children: [
                const SizedBox(height: 150.0),
                Container(
                  margin: const EdgeInsets.all(30.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Text(
                        "Hello",
                        style: Theme.of(context).textTheme.headline4!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade800,
                            ),
                      ),
                      Text(
                        "Sign in Your Account",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      const SizedBox(height: 20.0),
                      TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Email address",
                        ),
                        onChanged: (value) {
                          _email = value;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Password",
                        ),
                        onChanged: (value) {
                          _password = value;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      InkWell(
                        onTap: () => Get.to(() => ResetPasswordUI()),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Forgot your Password?")),
                      ),
                      const SizedBox(height: 20.0),
                      _isLoading
                          ? CircularProgressIndicator()
                          : Container(
                              width: MediaQuery.of(context).size.width / 1.5,
                              // ignore: deprecated_member_use
                              child: RaisedButton(
                                padding: const EdgeInsets.all(16.0),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0)),
                                color: Colors.amber,
                                textColor: Colors.white,
                                onPressed: () {
                                  _validateAndAuth();
                                },
                                child: Text("Login"),
                              ),
                            ),
                      const SizedBox(height: 20.0),
                      Text(
                        "Or Login using social media",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(FontAwesomeIcons.google),
                            color: Colors.indigo,
                            onPressed: () => Get.snackbar("Under Development",
                                "This Function is not available at the moment.Please Use Email Login!.",
                                snackPosition: SnackPosition.BOTTOM,
                                snackStyle: SnackStyle.FLOATING),
                          ),
                          IconButton(
                            icon: Icon(FontAwesomeIcons.twitter),
                            color: Colors.blue,
                            onPressed: () => Get.snackbar("Under Development",
                                "This Function is not available at the moment.Please Use Email Login!.",
                                snackPosition: SnackPosition.BOTTOM,
                                snackStyle: SnackStyle.FLOATING),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10.0),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?"),
                    const SizedBox(height: 5.0),
                    InkWell(
                      child: Text(
                        "Register Now",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue.shade900,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      onTap: () {
                        Get.to(() => SignUpPage());
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _validateAndAuth() {
    if (_email.isEmpty || _password.isEmpty) {
      Get.snackbar(
        'Please Fill all the fields..',
        'Please Fill all the fields...',
        duration: Duration(seconds: 3),
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      setState(() {
        _isLoading = true;
      });
      _authUser();
    }
  }

  void _authUser() async {
      try {
        await _auth
            .signInWithEmailAndPassword(email: _email, password: _password)
            .then((result) {
          Get.snackbar(
              'User Signing Successful..', 'User Signing Successfully Completed',
              snackPosition: SnackPosition.BOTTOM,
              duration: Duration(seconds: 3),
              backgroundColor: Get.theme.snackBarTheme.backgroundColor,
              colorText: Get.theme.snackBarTheme.actionTextColor);
          storage.write('email', _email);
          Get.offAll(() => BottomHomeBar(index: 0,));
        });
      } on Exception catch (e) {
        setState(() {
          _isLoading = false;
        });
        Get.snackbar(
            'Sign In Error', 'Your Email/Password is Incorrect',
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 7),
            backgroundColor: Get.theme.snackBarTheme.backgroundColor,
            colorText: Get.theme.snackBarTheme.actionTextColor);
      }

  }
}
