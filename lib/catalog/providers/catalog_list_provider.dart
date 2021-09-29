import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:ias/catalog/api/catalog_api.dart';
import 'package:ias/catalog/models/catalog_item.dart';

class CatalogListProvider extends ChangeNotifier {

  final _catalogSnapshot = <DocumentSnapshot>[];
  String _errorMessage = '';
  int documentLimit = 10;
  bool _hasNext = true;
  bool _isFetching = false;
  TextEditingController _editingController =TextEditingController();
  int _lastTypeTime= 0;
  String _oldSearch = "";


  String get errorMessage => _errorMessage;

  bool get hasNext => _hasNext;

  bool get isFetching => _isFetching;

  TextEditingController get editingController => _editingController;

  void reset(){
    _editingController.text='';
    updateText();

  }

  void cleanList() {
    _hasNext = true;
    _catalogSnapshot.clear();
    notifyListeners();
  }


  CatalogListProvider() {

    _editingController.addListener(() {

      if(_editingController.text != _oldSearch )
          updateText();
      _oldSearch = _editingController.text;
    });
  }


  Future updateText() async {
    //_isFetching = true;
      var search = _editingController.text.toLowerCase();
      if( search.length !=1 ) {
        cleanList();
        await Future.delayed(Duration(seconds: 1));
        if (search == _editingController.text.toLowerCase()) {
            fetchNext();
            print('text $search');
      }
    }
  }

  List<CatalogItem> get catalogItems => _catalogSnapshot.map((snap) {
    //Map<String, dynamic> data = snap.data()! as Map<String, dynamic>;
    //return CatalogItem.fromJson(data);
    return CatalogItem.fromFirebase(snap);
  }).toList();

  Future fetchNext() async {
    //print('fetch has called');
    if (_isFetching) return;

    _errorMessage = '';
    _isFetching = true;

    try {
      if(_hasNext){

        var search = _editingController.text.toLowerCase();
        final snap = await CatalogApi.getCatalog(
          documentLimit,
          startAfter: _catalogSnapshot.isNotEmpty ? _catalogSnapshot.last : null,
          search: search.isNotEmpty ? search : null
        );
        print('OUT: '+ search+ ' size ${snap.docs.length }');
        _catalogSnapshot.addAll(snap.docs);

        if (snap.docs.length < documentLimit) _hasNext = false;
    }
        notifyListeners();
    } catch (error) {
      _errorMessage = error.toString();
      notifyListeners();
    }

    _isFetching = false;
  }

}