import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sandwich_order_app/helpers/utils.dart';
import 'package:sandwich_order_app/screens/accounts/register.dart';

class SignIn extends StatefulWidget {
  final VoidCallback onClickedRegister;
  SignIn({Key? key, required this.onClickedRegister}) : super(key: key);

  @override
  SignInState createState() => SignInState();
}

class SignInState extends State<SignIn> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String error = "";

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future signIn() async {
    // showDialog(
    //     context: context,
    //     barrierDismissible: false,
    //     builder: (context) => Center(
    //           child: CircularProgressIndicator(),
    //         ));
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      print(e);
      utils.showSnackBar(e.message);
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
                padding: EdgeInsets.all(MediaQuery.of(context).size.width / 10),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: 'Enter email',
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (email) =>
                            email != null && !EmailValidator.validate(email)
                                ? 'Enter a valid email'
                                : null,
                      ),
                      TextFormField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          hintText: 'Enter password',
                        ),
                        onChanged: (value) {
                          // TODO: Save password
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) => value != null && value.length < 6
                            ? 'Enter mininum six charactors'
                            : null,
                      ),
                    ])),
            Container(
              margin: EdgeInsets.all(32.0),
              child: Column(
                children: [
                  ElevatedButton(
                    child: Text('Sign In'),
                    onPressed: signIn,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text('No Account? '),
                    InkWell(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          'Register here.',
                          style: const TextStyle(
                            color: Color.fromARGB(255, 115, 25, 93),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      onTap: widget.onClickedRegister,

                      //                 Navigator.of(context).push(MaterialPageRoute(
                      //                     builder: (context) =>StreamBuilder<User?>(
                      //   stream: FirebaseAuth.instance.authStateChanges(),
                      //   builder: ((context, snapshot) {
                      //     if (snapshot.connectionState == ConnectionState.waiting) {
                      //       return Center(child: CircularProgressIndicator());
                      //     } else if (snapshot.hasError) {
                      //       return Center(child: Text("Something went wrong"));
                      //     } else if (snapshot.hasData) {
                      //       return nav.NavigationBar();
                      //     } else {
                      //       return SignIn();
                      //     }
                      //   })
                      // //RegisterPage()
                      // ))
                    )
                  ])
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
