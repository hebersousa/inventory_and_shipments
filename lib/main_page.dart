import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ias/catalog/pages/catalog_list_page/catalog_list_page2.dart';
import 'catalog/pages/catalog_list_page/catalog_list_page.dart';
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

    return Scaffold(
      appBar: AppBar(title: Text("Inventory and Shipments", style: TextStyle(color: Colors.white),),),
      body: Column(
        children: [
          ProfileWidget(user: widget.user),
          Expanded(child: CatalogListPage2())
        ],
      ) ,
    );
  }
}
