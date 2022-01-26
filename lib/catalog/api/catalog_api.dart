import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ias/catalog/models/catalog_item.dart';
import 'package:ias/shipments/models/shipment.dart';


class CatalogApi {

    static Future<QuerySnapshot> getCatalog(
      int limit, {
      DocumentSnapshot? startAfter,
      String? search
      }) async {

      //var termR = "Certainty66".split("");//.reversed.join("");

      var refCatalog = FirebaseFirestore.instance
          .collection('catalog')
          .orderBy('count',descending: true)
          .limit(limit);

      if(search != null)
          refCatalog = refCatalog.where("keywords", arrayContains: search);

      if (startAfter == null) {
          return refCatalog.get();
      } else {
          return refCatalog.startAfterDocument(startAfter).get();
      }
    }

    @deprecated
    static Future<void> oldSaveItem(CatalogItem item) async {

      var catalogRef = FirebaseFirestore.instance.collection('catalog')
          .withConverter<CatalogItem>(
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

      return Future.value();

    }


    static Future<void> saveItem(CatalogItem catalogItem) async {

      return FirebaseFirestore.instance.runTransaction((transaction) async {

        try {
          var catalogRef = FirebaseFirestore.instance.collection('catalog')
              .withConverter<CatalogItem>(
            fromFirestore: (snapshot, _) =>
                CatalogItem.fromJson(snapshot.data()!),
            toFirestore: (catalogItem, _) => catalogItem.toJson(),
          );

          if(catalogItem.count == 0 )
            catalogItem.unitCostAvg = 0;

          if (catalogItem.key != null) {
            transaction.set(
                catalogRef.doc(catalogItem.key),
                catalogItem,
                SetOptions(merge: true)
            );

            await _updateShipments(catalogItem, transaction);
          } else {

             var doc =  FirebaseFirestore.instance.collection('catalog').doc();
             catalogItem.key = doc.id;
             transaction.set(
                 catalogRef.doc(catalogItem.key),
                 catalogItem,
                 SetOptions(merge: true)
             );
              //await catalogRef.add(catalogItem);
          }
        }catch(e){

          print(e);
        }


      } );

    }


    static Future<void> _updateShipments(CatalogItem catalog,
        Transaction transaction) async{

      var snapshot = await FirebaseFirestore.instance.collection('shipment')
          .withConverter<Shipment>(
        fromFirestore: (snapshot, _) => Shipment.fromJson(snapshot.data()!),
        toFirestore: (shipment, _) => shipment.toJson(),
      ).where("catalog.key", isEqualTo: catalog.key).get();

      snapshot.docs.forEach((doc) {
        var shipment = doc.data();
        shipment.catalogItem = catalog;
        transaction.set(doc.reference, shipment, SetOptions(merge: true) );
      });

      return Future<void>.value();

    }
}