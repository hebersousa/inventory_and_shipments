import 'package:flutter/material.dart';
import 'package:ias/catalog/pages/catalog_edit_page.dart';
import 'package:ias/catalog/pages/catalog_list_page/catalog_header_widget.dart';
import 'package:ias/catalog/pages/catalog_list_page/catalog_listview_widget.dart';
import 'package:ias/catalog/providers/catalog_list_provider.dart';
import 'package:provider/provider.dart';


class CatalogListPage2 extends StatelessWidget {

  _createAppBar(BuildContext context) {
    var addButton = IconButton(
        color:  Colors.white,
        icon: Icon(Icons.add),
        onPressed: ()=> _goToNew(context)
    );

    var title = Text('Catalog', style: TextStyle(color: Colors.white),);

    var menuButton = IconButton(
      color: Colors.white,
      icon: Icon(Icons.menu),
      onPressed: () => Scaffold.of(context).openDrawer(),
    );

    return  AppBar(title: title,
      actions: [addButton],
      leading: menuButton,);
  }

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (context) => CatalogListProvider(),
    builder:(context, child) =>  _scafold(context),
  );


  _scafold(BuildContext context) {
    return Scaffold(
        appBar: _createAppBar(context),
        body:  Column(children: [
          CatalogHeaderWidget(),
          Expanded(child: CatalogListViewWidget())
        ],)
    );
  }
}




_goToNew(BuildContext context,[var id]) {
  final value2 = Provider.of<CatalogListProvider>(context, listen: false);
  //final value = context.watch<CatalogProvider>();
  Navigator.of(context).push(
    MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider<CatalogListProvider>
            .value(value: value2,
            child: CatalogEditPage(id: id) ,)
    ),
  );
}
//CatalogEditPage(id: id)