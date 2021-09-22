import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:ias/catalog/api/catalog_api.dart';
import 'package:ias/catalog/models/catalog_item.dart';

class CatalogProvider extends ChangeNotifier {

  final _catalogSnapshot = <DocumentSnapshot>[];
  String _errorMessage = '';
  int documentLimit = 10;
  bool _hasNext = true;
  bool _isFetching = false;
  TextEditingController _editingController =TextEditingController();
  int _lastTypeTime= 0;

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


  bool lastTypeTimeLimitExceeded(){

    if( (DateTime.now().millisecondsSinceEpoch - _lastTypeTime) > 2000 ) {
      _lastTypeTime = DateTime.now().millisecondsSinceEpoch;
      return true;
    }
    return false;
  }


  CatalogProvider() {
    _editingController.addListener(() {

      if(lastTypeTimeLimitExceeded()) {
       //  print('IN: '+_editingController.text);
    //      cleanList();
      //    fetchNextUsers();
        //  print('text ${_editingController.text}');
      }

     // lateFetch();
    });
  }


  Future updateText() async {
    //_isFetching = true;
      var search = _editingController.text.toLowerCase();
      if( search.length !=1 ) {
        cleanList();
        String oldSearch = search;
        await Future.delayed(Duration(seconds: 1));
        if (oldSearch == search) {
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
          search: search.isNotEmpty ? search
              : null
        );
        print('OUT: '+ search);
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

  Future<void> saveItem(CatalogItem item) async {

    var catalogRef = FirebaseFirestore.instance.collection('catalog').withConverter<CatalogItem>(
      fromFirestore: (snapshot, _) => CatalogItem.fromJson(snapshot.data()!),
      toFirestore: (catalogItem, _) => catalogItem.toJson(),
    );

    if(item.key != null ) {
      await catalogRef.doc(item.key).set(item,
        SetOptions(merge: true),
      );
    } else {
      await catalogRef.add(item);
    }

    notifyListeners();

    return Future.value();

  }
}