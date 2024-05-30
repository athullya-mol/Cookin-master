import 'package:cookin/pages/create_account.dart';
import 'package:cookin/services/auth_services.dart';
import 'package:cookin/utils/navigatio_bar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../utils/utils.dart';
import '../widget/widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool _isLoading = false;

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthService()
        .loginUser(email: _email.text, password: _password.text);
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
            'Successfully Logged In',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          backgroundColor: AppColors.success,
        ));
      if (res == 'Success') {
        
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const BottonNavBar(),
        ));
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 60,
                  ),
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // Align text to the left
                      children: [
                        MyText(
                          text: 'Login',
                          color: AppColors.textColor,
                          fontSize: 35,
                          fontWeight: FontWeight.w600,
                        ),
                         SizedBox(
                    height: 5,
                  ),
                        MyText(
                          text: 'Hello,\nWelcome Back!',
                          color: AppColors.textColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 90,
                  ),
                  Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Align contents to the left
                    children: [
                      const MyText(
                        text: 'Email',
                        fontSize: 18,
                      ),
                      InputBox(
                        height: 50,
                        borderRadius: 10,
                        placeHolder: '\t\tEnter Email',
                        marginVertical: 5,
                        controller: _email,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const MyText(
                        text: 'Password',
                        fontSize: 18,
                      ),
                      InputBoxPassword(
                        height: 50,
                        borderRadius: 10,
                        isPassword: true,
                        placeHolder: '\t\tEnter Password',
                        marginVertical: 5,
                        controller: _password,
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.amber),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : MyFilledButton(
                          color: Colors.white,
                          bgcolor: AppColors.primaryColor,
                          text: 'Sign In',
                          fontsize: 20,
                          icon: SolarIconsOutline.arrowRight,
                          onPressed: () async {
                            loginUser();
                            // final scaffoldContext = context; // Capture the context

                            // User.authenticateUserAsync(_formData, 'signin')
                            //     .then((user) {
                            //       debugPrint('User: $user');
                            // if (user == true) {
                            //   Navigator.push(scaffoldContext, MaterialPageRoute(
                            //     builder: (context) {
                            //       return const BottonNavBar();
                            //     },
                            //   ));
                            // } else {
                            //   User.showFlashError(scaffoldContext, "email or password is incorrect");
                            //       // }
                            //     });
                          },
                        ),
                  // const SizedBox(
                  //   height: 30,
                  // ),
                  // const myDivider(
                  //     text: 'Or Sign in with',
                  //     flex: 2,
                  //     fontsize: 16,
                  //     fontweight: FontWeight.w400,
                  //     height: 0.8),
                  // const SizedBox(
                  //   height: 30,
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
                  Text.rich(TextSpan(
                      text: "Don't have an account?",
                      style: const TextStyle(
                          fontSize: 16,
                          letterSpacing: 0.8,
                          color: AppColors.textColor),
                      children: [
                        TextSpan(
                            text: '\tSign Up',
                            style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                color: AppColors.secondaryColor),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const CreateAccountPage(),
                                  )))
                      ])),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
