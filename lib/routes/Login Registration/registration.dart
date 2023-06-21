import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:khan_dairy/modals/global_widgets.dart';
import 'package:khan_dairy/routes/Dashboard/dashboard.dart';

import '../../constants/constants.dart';
import 'Login.dart';

class Registration extends StatelessWidget {


  static String id = 'Registration';

  //Firebase Auth.
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  //Registering With Email And Password.
  Future<bool> registerUser({required BuildContext context}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("User Succeessfully Registered In"),
      ));
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('The password provided is too weak.'),
        ));
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('The account already exists for that email.'),
        ));
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${e.message}'),
      ));
      return false;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("${e}"),
      ));
      return false;
    }
  }

  //Screen Starts Here
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(14.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 70,
                ),
                Image.asset(
                  "images/eCow.png",
                  height: 200,
                  width: 200,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Sign Up",
                  style: headlineTextStyle,
                ),
                SizedBox(
                  height: 30,
                ),
                Container(),
                CustomTextField(
                  controller: emailController,
                  hintText: "Email",
                  prefix: Icon(Icons.email),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(
                  height: 30,
                ),
                CustomTextField(
                  controller: passwordController,
                  hintText: "Password",
                  obscureText: true,
                  prefix: Icon(Icons.password_outlined),
                ),
                SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 50,
                  ),
                  child: CustomButton(
                    buttonName: "Register",
                    onPressed: () async {
                      if (await registerUser(
                        context: context,
                      )) {
                        Navigator.pushNamed(context, Dashboard.id);
                      } else {}
                    },
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, Login.id);
                    },
                    child: Text("Login"))
              ],
            ),
          ),
        ));
  }
}
