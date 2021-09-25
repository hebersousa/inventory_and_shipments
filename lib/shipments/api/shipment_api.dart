import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ias/catalog/models/catalog_item.dart';


class ShipmentApi {

  static Future<QuerySnapshot> getCatalog(
      int limit, {
        DocumentSnapshot? startAfter,
        String? search
      }) async {

    var ref = FirebaseFirestore.instance
        .collection('shipment')
        .orderBy('created_at')
        .limit(limit);

    if(search != null)
      ref = ref.where("keywords", arrayContains: search);

    if (startAfter == null) {
      return ref.get();
    } else {
      return ref.startAfterDocument(startAfter).get();
    }
  }
}