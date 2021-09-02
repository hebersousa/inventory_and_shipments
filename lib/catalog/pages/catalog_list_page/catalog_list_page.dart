import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../catalog_edit_page.dart';
import '../../models/catalog_item.dart';

class CatalogListPage extends StatefulWidget {

  @override
  _CatalogListPageState createState() => _CatalogListPageState();
}


class _CatalogListPageState extends State<CatalogListPage> {

  final Stream<QuerySnapshot> _categoryStream = FirebaseFirestore.instance.collection('catalog').snapshots();


  _goToNew([var id]) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CatalogEditPage(id: id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

      var button = FloatingActionButton(onPressed: () =>_goToNew(),
          child: Icon(Icons.add)
      );
      return Scaffold(

        floatingActionButton: button,
        body: Column(children: [
          Expanded(child: _streamList())
      ],),);
  }

  _streamList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _categoryStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }
        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
            var item = CatalogItem.fromJson(data);

            return ListTile(
              leading:  Image.network(item.urlImage!,
                  errorBuilder: (context,obj,stack)=>SizedBox.shrink(),),
              title: Text(item.title!,  ),
              subtitle:  FittedBox(child: SelectableText(item.asin!,),
                      fit: BoxFit.scaleDown,alignment: Alignment.centerLeft,),
              onTap: ()=>  _goToNew(document.id)

            );
          }).toList(),
        );
      },
    );
  }
}


