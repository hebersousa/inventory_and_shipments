import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ias/catalog/models/catalog_item.dart';


class PrepcenterApi {

  static Future<QuerySnapshot> getPrepcenter(
      int limit, {
        DocumentSnapshot? startAfter,
        String? search
      }) async {

    var ref = FirebaseFirestore.instance
        .collection('prepcenter')
        .orderBy('name')
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