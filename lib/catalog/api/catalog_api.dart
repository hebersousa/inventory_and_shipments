import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ias/catalog/models/catalog_item.dart';


class CatalogApi {

    static Future<QuerySnapshot> getCatalog(
      int limit, {
      DocumentSnapshot? startAfter,
      String? search
      }) async {

      var termR = "Certainty66".split("");//.reversed.join("");

      var refCatalog = FirebaseFirestore.instance
          .collection('catalog')
          .orderBy('title')
          .limit(limit);

      if(search != null)
          refCatalog = refCatalog.where("keywords", arrayContains: search);

      if (startAfter == null) {
          return refCatalog.get();
      } else {
          return refCatalog.startAfterDocument(startAfter).get();
      }
    }
}