import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:khan_dairy/modals/global_widgets.dart';
import 'package:khan_dairy/routes/Dashboard/dashboard.dart';
import 'package:khan_dairy/routes/Login%20Registration/registration.dart';

class Login extends StatelessWidget {

  static String id = 'Login';

  //Firebase Instance
  FirebaseAuth auth = FirebaseAuth.instance;

  //Defining Controllers
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  //Logging In.
  void loginChanges() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }

  Future<bool> login({required BuildContext context}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("User Succeessfully Logged In"),
      ));
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('No user found for that email.'),
        ));
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Wrong password provided for that user.'),
        ));
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${e.message}'),
      ));
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              children: [
                SizedBox(
                  height: 60,
                ),
                Image.asset(
                  "images/eCow.png",
                  height: 200,
                  width: 200,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Login",
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
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
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 50,
                  ),
                  child: CustomButton(
                    buttonName: "Login",
                    onPressed: () async {

                      if (await login(context: context)) {
                        Navigator.pushNamed(context, Dashboard.id);
                      }
                      // login();
                    },
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, Registration.id);
                    },
                    child: Text("Register"))
              ],
            ),
          ),
        ));
  }
}
