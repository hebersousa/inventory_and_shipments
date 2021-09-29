import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:ias/shipments/api/shipment_api.dart';
import 'package:ias/shipments/models/shipment.dart';

class ShipmentListProvider extends ChangeNotifier {

  final _shipmentSnapshot = <DocumentSnapshot>[];
  String _errorMessage = '';
  int documentLimit = 10;
  bool _hasNext = true;
  bool _isFetching = false;
  TextEditingController _editingController =TextEditingController();
  int _lastTypeTime= 0;
  String _oldSearch = "";
  Shipment? shipmentItemSelected;

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
    _shipmentSnapshot.clear();
    notifyListeners();
  }


  ShipmentListProvider() {

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

  List<Shipment> get sgipmentItems => _shipmentSnapshot.map((snap) {
    return Shipment.fromFirebase(snap);
  }).toList();

  Future fetchNext() async {
    //print('fetch has called');
    if (_isFetching) return;

    _errorMessage = '';
    _isFetching = true;

    try {
      if(_hasNext){

        var search = _editingController.text.toLowerCase();
        final snap = await ShipmentApi.getShipment(
            documentLimit,
            startAfter: _shipmentSnapshot.isNotEmpty ? _shipmentSnapshot.last : null,
            search: search.isNotEmpty ? search : null
        );
        print('OUT: '+ search+ ' size ${snap.docs.length }');
        _shipmentSnapshot.addAll(snap.docs);

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