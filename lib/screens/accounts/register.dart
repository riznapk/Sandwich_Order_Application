import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sandwich_order_app/helpers/utils.dart';
import 'package:sandwich_order_app/screens/accounts/sign_in.dart';

import '../../navigation_bar.dart' as nav;

class RegisterPage extends StatefulWidget {
  final VoidCallback onClickedSignIn;
  RegisterPage({Key? key, required this.onClickedSignIn}) : super(key: key);

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  bool passwordVisibility = true;
  final emailController = TextEditingController();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  Future register() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;
    // showDialog(
    //     context: context,
    //     barrierDismissible: false,
    //     builder: (context) => Center(
    //           child: CircularProgressIndicator(),
    //
    //
    //      ));

    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    try {
      UserCredential user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim());
      String uid = user.user!.uid;
      DatabaseReference ref = FirebaseDatabase.instance.ref('users/${uid}');
      await ref.set({
        "uid": uid,
        "username": userNameController.text,
        "isAdmin": false,
        "email": emailController.text
      });
    } on FirebaseAuthException catch (e) {
      utils.showSnackBar(e.message);
    }
    nav.NavigationBar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   elevation: 0,
      //   leading: IconButton(
      //     onPressed: () {
      //       Navigator.pop(context);
      //     },
      //    Icon(Icons.home)
      //   ),
      // ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 150,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                        child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Register",
                          ),
                          Text(
                            "Create new account to get started.",
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          TextFormField(
                            controller: userNameController,
                            decoration: InputDecoration(
                              hintText: 'Enter user name',
                            ),
                            onChanged: (value) {
                              // TODO: Save password
                            },
                          ),
                          TextFormField(
                            controller: emailController,
                            decoration: InputDecoration(
                              hintText: 'Enter email',
                            ),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
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
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) =>
                                value != null && value.length < 6
                                    ? 'Enter mininum six charactors'
                                    : null,
                          ),
                          // TextField(
                          //   decoration: InputDecoration(
                          //     hintText: 'Confirm password',
                          //   ),
                          //   onChanged: (value) {
                          //     // TODO: Save password
                          //   },
                          // ),
                        ],
                      ),
                    )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Alreday have an account? '),
                              InkWell(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Text(
                                    'Sign In',
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 115, 25, 93),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                onTap: widget.onClickedSignIn,
                              )
                            ])
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      child: Text('Register'),
                      onPressed: register,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
