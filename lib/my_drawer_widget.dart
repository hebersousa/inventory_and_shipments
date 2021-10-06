import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ias/catalog/pages/catalog_list_page/catalog_list_page.dart';
import 'package:ias/login/profile_widget.dart';
import 'package:ias/page_provider.dart';
import 'package:ias/shipments/pages/shipment_list_page/shipment_list_page.dart';
import 'package:provider/provider.dart';

class MyDrawerWidget extends StatefulWidget {
  final User user;
  MyDrawerWidget({required this.user});
  @override
  _MyDrawerWidgetState createState() => _MyDrawerWidgetState();
}

class _MyDrawerWidgetState extends State<MyDrawerWidget> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<PageProvider>(context);
    return Drawer(
      child: ListView(children: [
        ProfileWidget(user: widget.user,),
        ListTile(title: const Text('Prepcenter Inventory'),
            onTap: (){
                provider.changePage(CatalogListPage());
                Navigator.pop(context);
            }
        ),
        ListTile(title: const Text('Shipments'),
            onTap: () {
                provider.changePage(ShipmentListPage(),);
                Navigator.pop(context);
        }),

      ],),
    );
  }
}
