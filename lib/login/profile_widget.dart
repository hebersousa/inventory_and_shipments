import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ias/login/login_page.dart';
import 'package:ias/login/fire_auth.dart';

class ProfileWidget extends StatefulWidget {
  final User user;

  const ProfileWidget({required this.user});

  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  bool _isSigningOut = false;
  late User _currentUser;

  @override
  void initState() {
    _currentUser = widget.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          SizedBox(height: 16.0),
          Text(
            'EMAIL: ${_currentUser.email}',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          SizedBox(width: 16.0),
          _isSigningOut
              ? CircularProgressIndicator()
              : TextButton(
            onPressed: () async {
              setState(() {
                _isSigningOut = true;
              });
              await FirebaseAuth.instance.signOut();
              setState(() {
                _isSigningOut = false;
              });
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ),
              );
            },
            child: Text('Sign out'),

          ),
        ],
      ),
    );
  }
}