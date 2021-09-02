import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ias/login/login2_page.dart';
import 'package:ias/login/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ias/main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inventory and Shipments',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home:  _checkLoginPage(),
    );
  }


  _inicializedPage (){
     //FirebaseAuth.instance.setPersistence(Persistence.SESSION);
    return FutureBuilder(
      future: Firebase.initializeApp(),
        builder: (context,snapshot){
          if (snapshot.connectionState == ConnectionState.done) {
            return _checkLoginPage();
          }
          return Center(
            child: CircularProgressIndicator(),
          );
    });

  }

   _checkLoginPage() {

     final FirebaseAuth _auth = FirebaseAuth.instance;
     //_auth.setPersistence(Persistence.SESSION);
    return StreamBuilder<User?>(
      stream: _auth.authStateChanges(),
      builder: (BuildContext context, snapshot) {
          if (snapshot.hasData ) {
              return MainPage(user: snapshot.data!);
            }
          return Login2Page();
      }
    );
  }
  }