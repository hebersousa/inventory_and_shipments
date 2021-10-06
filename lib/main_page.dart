import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ias/catalog/pages/catalog_list_page/catalog_list_page.dart';
import 'package:ias/collapsing_navigation_drawer/collapsing_navigation_drawer_widget.dart';
import 'package:ias/my_drawer_widget.dart';
import 'package:ias/page_provider.dart';
import 'package:provider/provider.dart';
import 'package:ias/login/profile_widget.dart';

class MainPage extends StatefulWidget {
  final User user;

  const MainPage({required this.user});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider<PageProvider>(
      create: (_)=>PageProvider(),
        builder: (context, wdg) {
          var provider = context.watch<PageProvider>();
          return _home(provider.page);

        }
    );
  }

  _home(Widget? page) {
    return Scaffold(
        drawer: MyDrawerWidget(user: widget.user,),
      //  appBar: AppBar(title: Text("Inventory and Shipments",
       //   style: TextStyle(color: Colors.white),),),
        body: page
    );
  }


}
