import 'package:bincom_test/View/components/large_buttons.dart';
import 'package:bincom_test/View/components/text_link.dart';
import 'package:bincom_test/View/screens/sign_up_screen.dart';
import 'package:bincom_test/services/firebase_methods.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:provider/provider.dart';
import '../../View_Model/signIn_provider.dart';
import '../utilities/media_query.dart';

class LogInScreen extends StatefulWidget {
  static const String id = 'SignInScreen';

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isClicked = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = ScreenDimension(context: context).getHeight();

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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: height * 0.07,
                      ),
                      Text(
                        "Welcome!",
                        style: TextStyle(
                          fontSize: height * 0.06,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: height * 0.03,
                      ),
                      Text(
                        "report violence today!",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: height * 0.025,
                        ),
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
                        height: height * 0.02,
                      ),
                      LargeButton(
                          inputText: 'Sign in',
                          onPress: () async {
                            FocusScope.of(context).focusedChild?.unfocus();
                            const CircularProgressIndicator();
                            FirebaseApis().signInWithEmailAndPassword(
                                email: emailController.text,
                                password: passwordController.text,
                                context: context);
                            context
                                .read<SignInAndOutProvider>()
                                .setSpinnerAction(false);
                          }),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account?",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          TextLink(
                              text: ' sign up',
                              onTap: () =>
                                  Navigator.pushNamed(context, SignUpScreen.id),
                              decoration: TextDecoration.underline)
                        ],
                      ),
                      SizedBox(
                        height: height * 0.18,
                      ),
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
