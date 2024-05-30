// ignore_for_file: unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookin/pages/home_page.dart';
import 'package:cookin/pages/login_page.dart';
import 'package:cookin/services/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import '../utils/navigatio_bar.dart';
import '../utils/utils.dart';
import 'package:flutter/material.dart';
import '../widget/widget.dart';
import '../apis/login_api.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({Key? key}) : super(key: key);

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();
    bool _isLoading = false;

    void signUser() async {
      setState(() {
        _isLoading = true;
      });
      String res = await AuthService().signUser(
        email: emailController.text,
        password: passwordController.text,
        username: nameController.text,
      );
      if (res.contains(']')) {
        String errMsg = res.toString().split(']')[1].trim();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            errMsg.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          backgroundColor: AppColors.warning,
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
              'Successfully Account created',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            backgroundColor: AppColors.success,
          ));
        if (res == 'Success') {
          
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const BottonNavBar(),
          ));
        }
      }
      setState(() {
        _isLoading = false;
      });
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  //   IconButtonSolo(
                  //     color: Colors.black38,
                  //    icon: Icons.arrow_back_ios_new_rounded,
                  //   ),
                  const SizedBox(height: 20),
                  const MyText(
                    text: "Create an account",
                    fontSize: 35,
                    fontWeight: FontWeight.w900,
                  ),
                  const SizedBox(height: 5),
                  const MyText(
                    text:
                        "Let’s help you set up your account,\nit won’t take long.",
                    fontSize: 16,
                    color: AppColors.textColor,
                  ),
                  const SizedBox(height: 60),
                  InputWithLabel(
                    label: "Name",
                    placeHolder: "Enter Your Name",
                    height: 50,
                    controller: nameController,
                  ),
                  InputWithLabel(
                    label: "Email",
                    placeHolder: "Enter Your Email",
                    height: 50,
                    controller: emailController,
                  ),
                  InputWithLabel(
                    label: "Password",
                    placeHolder: " Enter your Password",
                    isPassword: true,
                    height: 50,
                    controller: passwordController,
                  ),
                  InputWithLabel(
                    label: "Confirm Password",
                    placeHolder: "Confirm Password",
                    isPassword: true,
                    height: 50,
                    controller: confirmPasswordController,
                  ),
                  const SizedBox(height: 10),
                  const CheckBox("Accept terms & Condition"),
                  const SizedBox(
                    height: 50,
                  ),
                  Center(
                    child: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : MyFilledButton(
                            color: Colors.white,
                            bgcolor: AppColors.primaryColor,
                            text: 'Sign Up',
                            fontsize: 22,
                            resppadding: 0.29,
                            sizebox: 5,
                            onPressed: () async {
                              signUser();
                              // final scaffoldContext = context; // Capture the context
                              // if(_formData['password'] != _formData['confirmPassword']) {
                              //   User.showFlashError(scaffoldContext,
                              //       "passwords do not match");
                              //   return;
                              // }
                              // if(_formData['name'] == '' || _formData['email'] == '' || _formData['password'] == '' || _formData['confirmPassword'] == '') {
                              //   User.showFlashError(scaffoldContext,
                              //       "please fill all field");
                              //   return;
                              // }
                              // User.createUserAsync(_formData)
                              //     .then((user) {
                              //   debugPrint('User: $user');
                              //   if (user == true) {
                              //     Navigator.push(scaffoldContext, MaterialPageRoute(
                              //       builder: (context) {
                              //         return const BottonNavBar();
                              //       },
                              //     ));
                              //   } else {
                              //     User.showFlashError(scaffoldContext,
                              //         "email alread exists");
                              //   }
                              // });
                            },
                            icon: SolarIconsOutline.arrowRight,
                          ),
                  ),
                  // const SizedBox(
                  //   height: 10,
                  // ),
                  // const myDivider(
                  //     text: 'Or Sign in with',
                  //     flex: 2,
                  //     fontsize: 16,
                  //     fontweight: FontWeight.w400,
                  //     height: 0.8),
                  // const SizedBox(
                  //   height: 20,
                  // ),
                  // const Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     MyIconButton(
                  //       icon: DevIcons.googlePlain,
                  //       text: 'Google',
                  //       color: AppColors.primaryColor,
                  //     ),
                  //     SizedBox(width: 10), // Add spacing between buttons
                  //     MyIconButton(
                  //       icon: DevIcons.facebookPlain,
                  //       text: 'Facebook',
                  //       color: Colors.blue,
                  //     ),
                  //   ],
                  // ),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text.rich(TextSpan(
                        text: "Already have an account!",
                        style: const TextStyle(
                            fontSize: 16,
                            letterSpacing: 0.8,
                            color: AppColors.textColor),
                        children: [
                          TextSpan(
                              text: '\tLogin',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.secondaryColor),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginPage(),
                                    )))
                        ])),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
