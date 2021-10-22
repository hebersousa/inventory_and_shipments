import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:ias/prepcenter/api/prepcenter_api.dart';
import '../models/prepcenter.dart';
import 'package:ias/shipments/models/shipment.dart';
import 'package:flutter/cupertino.dart';

class PrepcenterListProvider extends ChangeNotifier {

  final _prepcenterSnapshot = <DocumentSnapshot>[];
  String _errorMessage = '';
  int documentLimit = 10;
  bool _hasNext = true;
  bool _isFetching = false;
  TextEditingController _editingController =TextEditingController();
  int _lastTypeTime= 0;
  String _oldSearch = "";
  Prepcenter? prepcenterItemSelected;

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
    _prepcenterSnapshot.clear();
    notifyListeners();
  }


  PrepcenterListProvider() {

    _editingController.addListener(() {

      if(_editingController.text != _oldSearch )
        updateText();
      _oldSearch = _editingController.text;
    });
  }


  Future updateText() async {
    var search = _editingController.text.toLowerCase();
    if( search.length !=1 ) {
      cleanList();
      await Future.delayed(Duration(seconds: 1));
      if (search == _editingController.text.toLowerCase()) {
        fetchNext();
        //print('text $search');
      }
    }
  }

  List<Prepcenter> get prepcenterItems => _prepcenterSnapshot.map((snap) {
    return Prepcenter.fromFirebase(snap);
  }).toList();

  Future fetchNext() async {
    //print('fetch has called');
    if (_isFetching) return;

    _errorMessage = '';
    _isFetching = true;

    try {
      if(_hasNext){

        var search = _editingController.text.toLowerCase();
        final snap = await PrepcenterApi.getPrepcenter(
            documentLimit,
            startAfter: _prepcenterSnapshot.isNotEmpty ? _prepcenterSnapshot.last : null,
            search: search.isNotEmpty ? search : null
        );
        print('OUT: '+ search+ ' size ${snap.docs.length }');
        _prepcenterSnapshot.addAll(snap.docs);

        if (snap.docs.length < documentLimit) _hasNext = false;
      }
      notifyListeners();
    } catch (error) {
      _errorMessage = error.toString();
      notifyListeners();
    }

    _isFetching = false;
  }


  Future<void> saveItem(Prepcenter item) async {

    var prepRef = FirebaseFirestore.instance.collection('prepcenter').withConverter<Prepcenter>(
      fromFirestore: (snapshot, _) => Prepcenter.fromJson(snapshot.data()!),
      toFirestore: (prepcenter, _) => prepcenter.toJson(),
    );

    if(item.key != null ) {
      await prepRef.doc(item.key).set(item,
        SetOptions(merge: true),
      );
    } else {
      await prepRef.add(item);
    }

    notifyListeners();

    return Future.value();

  }
}