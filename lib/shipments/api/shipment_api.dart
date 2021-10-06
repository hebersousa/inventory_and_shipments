import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ias/catalog/models/catalog_item.dart';
import 'package:ias/shipments/models/shipment.dart';


class ShipmentApi {

  static Future<QuerySnapshot> getShipment(
      int limit, {
        DocumentSnapshot? startAfter,
        String? search
      }) async {

    var ref = FirebaseFirestore.instance
        .collection('shipment')
        .orderBy('created_at', descending: true)
        .limit(limit);

    if(search != null)
      ref = ref.where("keywords", arrayContains: search);

    if (startAfter == null) {
      return ref.get();
    } else {
      return ref.startAfterDocument(startAfter).get();
    }
  }


  
  
  
  static Future<void> saveItem(Shipment item) async {

    var shipmentsRef = FirebaseFirestore.instance.collection('shipment').withConverter<Shipment>(
      fromFirestore: (snapshot, _) => Shipment.fromJson(snapshot.data()!),
      toFirestore: (shipment, _) => shipment.toJson(),
    );

    if(item.key != null ) {
      await shipmentsRef.doc(item.key).set(item,
        SetOptions(merge: true),
      );
    } else {
      item.createdAt = DateTime.now();
      await shipmentsRef.add(item);
    }

    return Future.value();

  }

  static Future<void> removeItem(Shipment item) async {

    await FirebaseFirestore.instance.collection("shipment").doc(item.key).delete();

  }
}