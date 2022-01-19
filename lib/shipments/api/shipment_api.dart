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


  
  
  
  static Future<void> oldSaveItem(Shipment item) async {

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

  static Future<void> saveItem(Shipment item) async {

    return FirebaseFirestore.instance.runTransaction((transaction) async {
      var shipmentsRef = FirebaseFirestore.instance.collection('shipment').withConverter<Shipment>(
        fromFirestore: (snapshot, _) => Shipment.fromJson(snapshot.data()!),
        toFirestore: (shipment, _) => shipment.toJson(),
      );

      if(item.key != null ) {
        transaction.set(
            shipmentsRef.doc(item.key),
            item,
            SetOptions(merge: true)
        );
      } else {
          item.createdAt = DateTime.now();
          var newDocRef = shipmentsRef.doc();
          transaction.set(newDocRef, item);
         // await shipmentsRef.add(item);
          await _updateCatalog(item, transaction);
      }

    } );
  }


  static Future<void> _updateCatalog(Shipment shipment, Transaction transaction) async {

    var catalogRef = FirebaseFirestore.instance.collection('catalog')
        .withConverter<CatalogItem>(
      fromFirestore: (snapshot, _) => CatalogItem.fromJson(snapshot.data()!),
      toFirestore: (catalogItem, _) => catalogItem.toJson(),
    );

    var doc = await catalogRef.doc(shipment.catalogItem?.key).get();
    CatalogItem? catalogItem = doc.data();

    if(catalogItem != null) {
      int currentCount =   catalogItem.count ?? 0;
      double unitCostAvg  = catalogItem.unitCostAvg ?? 0;
      double unitCost = shipment.unitCost ?? 0.0;
      int shipCount = shipment.count;

      if(shipment.type=='PREP') {
          catalogItem.count = currentCount + shipCount;
          if(shipment.count != 0 && unitCost != 0 ) {
            double factor1 = unitCostAvg*currentCount + unitCost*shipCount;
            int factor2 = currentCount + shipCount;
            catalogItem.unitCostAvg = factor1/ factor2 ;
          }

      } else if(shipment.type=='AMZ') {
          catalogItem.count = currentCount - shipment.count;
          if(catalogItem.count == 0)
              catalogItem.unitCostAvg = 0;
      }
      transaction.set(
          catalogRef.doc(catalogItem.key),
          catalogItem,
          SetOptions(merge: true)
      );

    }
    return Future.value();
  }



  static Future<void> removeItem(Shipment item) async {

    await FirebaseFirestore.instance.collection("shipment").doc(item.key).delete();

  }
}