import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:ias/shipments/models/prepcenter.dart';
import 'package:ias/shipments/models/shipment.dart';

class PrepcenterProvider extends ChangeNotifier {

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