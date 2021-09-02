import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ias/catalog/models/catalog_item.dart';


class CatalogApi {

    static Future<QuerySnapshot> getCatalog(
      int limit, {
      DocumentSnapshot? startAfter,
      }) async {
      final refCatalog = FirebaseFirestore.instance
          .collection('catalog')
          .orderBy('title')
          .limit(limit);

      if (startAfter == null) {
          return refCatalog.get();
      } else {
          return refCatalog.startAfterDocument(startAfter).get();
      }
    }
}