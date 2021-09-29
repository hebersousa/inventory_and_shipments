import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ias/catalog/api/catalog_api.dart';
import 'package:ias/catalog/providers/catalog_list_provider.dart';
import 'package:provider/provider.dart';
import '../models/catalog_item.dart';
import 'package:url_launcher/url_launcher.dart';

class CatalogEditPage extends StatefulWidget {

  String? id;
  CatalogEditPage({this.id});

  @override
  _CatalogEditPageState createState() => _CatalogEditPageState();
}

class _CatalogEditPageState extends State<CatalogEditPage> {

  final _formKey = GlobalKey<FormState>();

  final _asinController = TextEditingController();
  final _titleController = TextEditingController();
  final _shortTitleController = TextEditingController();
  final _urlImageController = TextEditingController();
  late var _streamController = StreamController<String>();
  bool _loading = false;
  CatalogListProvider? _provider;
  CatalogItem? item;

  @override
  void initState() {

    _asinController.addListener(() {
      _streamController.add(_asinController.text);
    });
    super.initState();
  }

 Future<CatalogItem> _getData() async{
    CatalogItem? itemValue;
    if(widget.id != null) {
      var doc = await FirebaseFirestore.instance
          .collection('catalog').doc(widget.id).get();
      itemValue = CatalogItem.fromFirebase(doc);
    }
    return Future<CatalogItem>(()=>itemValue!);
  }

_linkImage() {
   return StreamBuilder(stream: _streamController.stream,

    builder: (_,snapshot){
      if(snapshot.hasData) {
        var asin = snapshot.data.toString();
        if(asin.isNotEmpty) {
          var link ="https://ws-na.amazon-adsystem.com/widgets/"
              "q?_encoding=UTF8&ASIN=$asin&Format=_SL160_&ID=AsinImage&"
              "MarketPlace=US&ServiceVersion=20070822&WS=1";
          return GestureDetector(child: Text("Get URL Image",
            style: TextStyle(
                color: Colors.blue[800],
                decoration: TextDecoration.underline),),
            onTap: ()=> launch(link),
          );
        }
      }
      return Container();
    },);
}

  _salvar2() async {
    setState(() => _loading = true );
    // /catalog/ARnx0vUqHTqbvabN5KbN
    if(item==null)
       item = CatalogItem(asin: _asinController.text,
          title: _titleController.text,
          shortTitle: _shortTitleController.text,
          urlImage: _urlImageController.text );
    else {
        item?.asin = _asinController.text;
        item?.title = _titleController.text;
        item?.shortTitle = _shortTitleController.text;
        item?.urlImage = _urlImageController.text;
    }

    CatalogApi.saveItem(item!);
    _provider?.cleanList();
    _provider?.fetchNext();
    Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {

    _provider = context.watch<CatalogListProvider>();

    return FutureBuilder<CatalogItem>(
        future: _getData(),
        builder: (context, snapshot){
          if(snapshot.connectionState ==  ConnectionState.done) {
            if(snapshot.hasData && snapshot.data != null){
              var it =snapshot.data!;
              item = it;
              _asinController.text = it.asin!;
              _titleController.text = it.title!;
              _shortTitleController.text = it.shortTitle!;
              _urlImageController.text = it.urlImage!;
            }

            return Scaffold(
              appBar: _getAppBar(),
              body: _form(),
            );
          }

        return Center(child: CircularProgressIndicator());

    });

  }

  _getAppBar() {
    var title = Text("Catalog Item", style: TextStyle(color: Colors.white));
    var backBt = BackButton(onPressed: ()=>Navigator.pop(context),
      color: Colors.white,);
    var saveBt = TextButton(onPressed: ()=> _salvar2(),
        child: Text("Save", style: TextStyle(color: Colors.white),)
    );

    return  AppBar(title: title ,
      centerTitle: true,
      leading: backBt,
      actions: [ saveBt],
    );
  }


  _formField( TextEditingController textEditingController, String hintText) {
    var decorator = InputDecoration(
      labelText: hintText,
      errorBorder: UnderlineInputBorder(
        borderRadius: BorderRadius.circular(6.0),
        borderSide: BorderSide(
          color: Colors.red,
        ),
      ),
    );

    return TextFormField(

        controller: textEditingController,
        decoration: decorator,);

  }

  _form(){
    return Form(
      key: _formKey,
      child: Padding(padding: const EdgeInsets.all(20),
      child: Column( children: [
        _loading ? CircularProgressIndicator() : Container(),
        _linkImage(),
        _formField(_asinController, "ASIN"),
        _formField(_titleController, "Title"),
        _formField(_shortTitleController, "Short Title"),
        _formField(_urlImageController, "URL Image")

      ],),),
    );

  }
}
