import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ias/login/profile_widget.dart';
import 'package:ias/login/validator.dart';
import 'package:ias/login/fire_auth.dart';
import 'package:ias/login/profile_page.dart';
import 'package:ias/login/register_page.dart';
import 'package:ias/main_page.dart';


class Login2Page extends StatefulWidget {
  @override
  _LoginPage2State createState() => _LoginPage2State();
}

class _LoginPage2State extends State<Login2Page> {
  final _formKey = GlobalKey<FormState>();

  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  bool _isProcessing = false;

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    //await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) =>
              MainPage(
                user: user,
              ),
        ),
      );
    }

    return firebaseApp;
  }

  _formField(TextEditingController textEditingController,
      FocusNode focusNode, String hintText, Function(String?) validator,
      [bool obscureText = false]) {

    //textEditingController.text = obscureText ? 'masukan':'hebersousa@gmail.com';
    return  TextFormField(

        controller: textEditingController,
        focusNode: focusNode,
        obscureText: obscureText,
        validator: (value) => validator(value),
        decoration: InputDecoration(
          hintText: hintText,
          errorBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(6.0),
            borderSide: BorderSide(
              color: Colors.red,
            ),
          ),
        ),
      );

}


  _button(String label, Function function) =>  Expanded(
    child: ElevatedButton(
      onPressed: () => function(),
      child: Text(
        label,
        style: TextStyle(color: Colors.white),
      ),
    ),
  );

  _goRegister() => Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) =>
          RegisterPage(),
    ),
  );

  _login() async  {
    _focusEmail.unfocus();
    _focusPassword.unfocus();

    if (_formKey.currentState!
        .validate()) {
      setState(() {
        _isProcessing = true;
      });

      //await FirebaseAuth.instance.setPersistence(Persistence.SESSION);
      User? user = await FireAuth
          .signInUsingEmailPassword(context: context ,
        email: _emailTextController.text,
        password:
        _passwordTextController.text,
      );

      setState(() {
        _isProcessing = false;
      });

      if (user != null) {
        Navigator.of(context)
            .pushReplacement(
          MaterialPageRoute(
            builder: (context) =>
                MainPage(user: user),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusEmail.unfocus();
        _focusPassword.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Firebase Authentication'),
        ),
        body:  Padding(
                padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: Text(
                        'Login',
                        style: Theme.of(context).textTheme.headline1,
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[

                          SizedBox(height: 8.0),
                          _formField(_emailTextController, _focusEmail,
                              "Email", (value) => Validator.validateEmail(
                                email: value.toString(),)
                          ),
                          _formField(_passwordTextController, _focusPassword,
                              "Password", (value) => Validator.validatePassword(
                                password: value.toString(),), true),
                          SizedBox(height: 24.0),
                          _isProcessing
                              ? CircularProgressIndicator()
                              : Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              _button("Sign In", _login),
                              SizedBox(width: 24.0),
                              _button("Register", _goRegister
                              ),

                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
      ),
    );
  }


}