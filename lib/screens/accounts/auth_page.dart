import 'package:flutter/material.dart';
import 'package:sandwich_order_app/screens/accounts/register.dart';
import 'package:sandwich_order_app/screens/accounts/sign_in.dart';

class AuthPage extends StatefulWidget {
  @override
  AuthPageState createState() => AuthPageState();
}

class AuthPageState extends State<AuthPage> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) => isLogin
      ? SignIn(onClickedRegister: toggle)
      : RegisterPage(onClickedSignIn: toggle);

  void toggle() => setState(() {
        isLogin = !isLogin;
      });
}
