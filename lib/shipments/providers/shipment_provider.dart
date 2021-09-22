import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:ias/shipments/models/shipment.dart';

class ShipmentProvider extends ChangeNotifier {

  Future<void> saveItem(Shipment item) async {

    var shipmentsRef = FirebaseFirestore.instance.collection('shipment').withConverter<Shipment>(
      fromFirestore: (snapshot, _) => Shipment.fromJson(snapshot.data()!),
      toFirestore: (shipment, _) => shipment.toJson(),
    );

    if(item.key != null ) {
      await shipmentsRef.doc(item.key).set(item,
        SetOptions(merge: true),
      );
    } else {
      await shipmentsRef.add(item);
    }

    notifyListeners();

    return Future.value();

  }
}