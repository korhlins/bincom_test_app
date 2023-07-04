import 'dart:io' show File;

import 'package:bincom_test/View/utilities/enums.dart';
import 'package:bincom_test/View/components/large_buttons.dart';
import 'package:bincom_test/View/components/text_link.dart';
import 'package:bincom_test/View/screens/home_screen.dart';
import 'package:bincom_test/View/screens/sign_in_screen.dart';
import 'package:bincom_test/View/utilities/utils.dart';
import 'package:bincom_test/services/firebase_methods.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../View_Model/signIn_provider.dart';
import '../utilities/media_query.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';

class SignUpScreen extends StatefulWidget {
  static const String id = 'SignUpScreen';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // List<File> profileImage = [];
  final _formKey = GlobalKey<FormState>();
  TextEditingController controller = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double height = ScreenDimension(context: context).getHeight();
    double width = ScreenDimension(context: context).getWidth();

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: ModalProgressHUD(
        inAsyncCall: context.watch<SignInAndOutProvider>().getSpinnerAction,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SafeArea(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.all(height * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Stack(
                        children: [
                          context
                                      .read<SignInAndOutProvider>()
                                      .getProfilePhoto !=
                                  null
                              ? CircleAvatar(
                                  backgroundImage: FileImage(context
                                      .read<SignInAndOutProvider>()
                                      .getProfilePhoto!),
                                  radius: width / 6,
                                )
                              : CircleAvatar(
                                  radius: width / 6,
                                ),
                          Positioned.fill(
                            left: width / 4.3,
                            top: width / 4.3,
                            child: IconButton(
                              iconSize: width / 15,
                              onPressed: () async {
                                await Utils().pickImage(
                                    context, ImageType.profilePics.toString());
                              },
                              icon: const Icon(
                                Icons.add_a_photo,
                                color: Color(0xff5E6D83),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * 0.03,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Username",
                          hintStyle: const TextStyle(
                            color: Colors.black26,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Color(0xFFF2F6FF)),
                            borderRadius: BorderRadius.circular(height * 0.02),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xFFF2F6FF),
                            ),
                            borderRadius: BorderRadius.circular(height * 0.02),
                          ),
                        ),
                        controller: usernameController,
                      ),
                      SizedBox(
                        height: height * 0.038,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Email",
                          hintText: "kelvin@email.com",
                          hintStyle: const TextStyle(
                            color: Colors.black26,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Color(0xFFF2F6FF)),
                            borderRadius: BorderRadius.circular(height * 0.02),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xFFF2F6FF),
                            ),
                            borderRadius: BorderRadius.circular(height * 0.02),
                          ),
                        ),
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (inputText) {
                          return inputText!.isNotEmpty &&
                                  inputText.contains("@")
                              ? null
                              : "email address incorrect";
                        },
                      ),
                      SizedBox(
                        height: height * 0.038,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Password",
                          hintText: "*******",
                          suffixIcon: IconButton(
                            icon: Icon(context
                                    .watch<SignInAndOutProvider>()
                                    .getPasswordVisibility
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              context
                                  .read<SignInAndOutProvider>()
                                  .toggleVisibility();
                            },
                          ),
                          hintStyle: const TextStyle(
                            color: Colors.black26,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Color(0xFFF2F6FF)),
                            borderRadius: BorderRadius.circular(height * 0.02),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xFFF2F6FF),
                            ),
                            borderRadius: BorderRadius.circular(height * 0.02),
                          ),
                        ),
                        controller: passwordController,
                        keyboardType: TextInputType.emailAddress,
                        obscureText: !context
                            .read<SignInAndOutProvider>()
                            .getPasswordVisibility,
                        validator: (String? passwordInput) {
                          return passwordInput!.isNotEmpty &&
                                  passwordInput.length < 6
                              ? "password must  contain a least 6 characters"
                              : null;
                        },
                      ),
                      SizedBox(
                        height: height * 0.038,
                      ),
                      LargeButton(
                        inputText: 'Create account',
                        onPress: () async {
                          FocusScope.of(context).focusedChild?.unfocus();
                          CircularProgressIndicator();
                          FirebaseApis().signUpWithAndPassword(
                              image: context
                                  .read<SignInAndOutProvider>()
                                  .getProfilePhoto,
                              email: emailController.text,
                              password: passwordController.text,
                              userName: usernameController.text,
                              context: context);

                          context
                              .read<SignInAndOutProvider>()
                              .setSpinnerAction(false);
                          // Navigator.pushNamed(context, HomeScreen.id);
                        },
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account?",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          TextLink(
                              text: ' sign in',
                              onTap: () => {
                                    Navigator.pushNamed(context, LogInScreen.id)
                                  },
                              decoration: TextDecoration.underline)
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
