import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LocalData {
  static Future<User?> getUser() async{

    var prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString('user');
    return null;
/*
    return (data != null)
        ? Vinculo.fromJson( json.decode(data))
        : null;
*/
  }
}