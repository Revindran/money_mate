import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:money_mate/Components/input_field_with_icon.dart';
import 'package:money_mate/Components/validator.dart';
import 'package:money_mate/controllers/user_controller.dart';

class ResetPasswordUI extends StatelessWidget {
  final _controller = Get.find<UserController>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final storage = GetStorage();

  ResetPasswordUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Password Reset',
          style:
              TextStyle(color: Colors.grey[400], fontStyle: FontStyle.italic),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Hero(
                    tag: 'tag',
                    child: GetBuilder<UserController>(builder: (_) {
                      return Container(
                        width: 150.0,
                        height: 150.0,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.contain,
                            image: AssetImage('assets/user_pic.png'),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 48.0),
                  FormInputFieldWithIcon(
                    controller: emailController,
                    iconPrefix: Icons.email,
                    labelText: 'Enter Your Email',
                    validator: Validator().email,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      if (kDebugMode) {
                        print(value);
                      }
                    },
                    onSaved: (value) => emailController.text = value!,
                  ),
                  const SizedBox(height: 10),
                  PrimaryButton(
                      labelText: 'Reset Password',
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await _controller.sendPasswordResetEmail(context,
                              email: emailController.text);
                        }
                      }),
                  const SizedBox(height: 10),
                  // signInLink(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
