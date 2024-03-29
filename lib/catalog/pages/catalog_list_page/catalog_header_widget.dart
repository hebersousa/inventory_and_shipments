import 'package:flutter/material.dart';
import 'package:ias/catalog/pages/catalog_list_page/catalog_listview_widget.dart';
import 'package:ias/catalog/providers/catalog_list_provider.dart';
import 'package:provider/provider.dart';


class CatalogHeaderWidget extends StatefulWidget {
  @override
  _CatalogHeaderWidgetState createState() => _CatalogHeaderWidgetState();
}

class _CatalogHeaderWidgetState extends State<CatalogHeaderWidget> {
  TextEditingController? _editingController;

  @override
  Widget build(BuildContext context) =>
      Consumer<CatalogListProvider>(builder:(context, provider, _) =>
        _buscaField(provider)
  );

  Widget _buscaField(CatalogListProvider provider) {

    _editingController = provider.editingController;

    var border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(10)
    );

    var iconButton =IconButton(splashRadius: 10,
      icon: Icon(Icons.close, color: Colors.grey, size: 20),
      onPressed: ()=>provider.reset(),

    );

    var decoration = InputDecoration(
        suffixIcon: iconButton,
       hintText: 'Catalog Search',
       // labelText: 'Catalog Search',
        hintStyle: TextStyle(fontSize: 14),
        //border: border
    );

    return Padding(
      padding: EdgeInsets.all(10),
      child: TextField(
        controller: _editingController,
       // onChanged: (_)=>provider.updateText(),
        style: TextStyle(color: Colors.black),
        decoration: decoration,
      ),
    );

  }

}
