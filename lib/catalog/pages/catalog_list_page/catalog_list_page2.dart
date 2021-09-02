import 'package:flutter/material.dart';
import 'package:ias/catalog/pages/catalog_edit_page.dart';
import 'package:ias/catalog/pages/catalog_list_page/catalog_header_widget.dart';
import 'package:ias/catalog/pages/catalog_list_page/catalog_listview_widget.dart';
import 'package:ias/catalog/providers/catalog_provider.dart';
import 'package:provider/provider.dart';


class CatalogListPage2 extends StatelessWidget {


  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (context) => CatalogProvider(),
    builder:(context, child) =>  Scaffold(
        floatingActionButton: FloatingActionButton(
            onPressed: () =>_goToNew(context),
            child: Icon(Icons.add)
        ),
        body:  Column(children: [
          CatalogHeaderWidget(),
          Expanded(child: CatalogListViewWidget())
        ],)
    ),
  );
}

_goToNew(BuildContext context,[var id]) {
  final value2 = Provider.of<CatalogProvider>(context, listen: false);
  //final value = context.watch<CatalogProvider>();
  Navigator.of(context).push(
    MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider<CatalogProvider>
            .value(value: value2,
            child: CatalogEditPage(id: id) ,)
    ),
  );
}
//CatalogEditPage(id: id)