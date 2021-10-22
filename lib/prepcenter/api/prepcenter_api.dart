import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ias/catalog/models/catalog_item.dart';
import '../models/prep_transaction.dart';
import '../models/prepcenter.dart';


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

  static Stream<Prepcenter> getPrepcenterItemStream(String key)  {
    return FirebaseFirestore.instance
        .collection('prepcenter').doc(key).snapshots().map((doc) =>
        Prepcenter.fromFirebase(doc)
    );
  }


  static Future<void> saveItem(Prepcenter item) async {

    var prepRef = FirebaseFirestore.instance.collection('prepcenter')
        .withConverter<Prepcenter>(
      fromFirestore: (snapshot, _) => Prepcenter.fromJson(snapshot.data()!),
      toFirestore: (item, _) => item.toJson(),
    );

    if(item.key != null ) {
      await prepRef.doc(item.key).set(item,
        SetOptions(merge: true),
      );

    } else {
      await prepRef.add(item);
    }

    return Future.value();

  }




  static Future<QuerySnapshot> getTransactions(
      int limit, {
        DocumentSnapshot? startAfter,
        required String? keyPrepcenter
      }) async {

    var ref = FirebaseFirestore.instance
        .collection('preptransaction')
        .orderBy('created_at',descending: true)
        .limit(limit);

    if(keyPrepcenter != null)
      ref = ref.where("key_prepcenter", isEqualTo: keyPrepcenter);

    if (startAfter == null) {
      return ref.get();
    } else {
      return ref.startAfterDocument(startAfter).get();
    }
  }



  static Future<void> insertTransaction(PrepTransaction prepTransaction) async {

    return FirebaseFirestore.instance.runTransaction((transaction) async {

      var prepTransactionRef = FirebaseFirestore.instance.collection('preptransaction')
          .withConverter<PrepTransaction>(
        fromFirestore: (snapshot, _) => PrepTransaction.fromJson(snapshot.data()!),
        toFirestore: (item, _) => item.toJson(),
      );

      prepTransaction.createdAt = DateTime.now();
        var newDocRef = prepTransactionRef.doc();
        transaction.set(newDocRef, prepTransaction);
        await _updateBalance(prepTransaction, transaction);

    } );
  }


  static Future<void> _updateBalance(PrepTransaction prepTransaction, Transaction transaction) async {

    var prepcenterRef = FirebaseFirestore.instance.collection('prepcenter')
        .withConverter<Prepcenter>(
      fromFirestore: (snapshot, _) => Prepcenter.fromJson(snapshot.data()!),
      toFirestore: (item, _) => item.toJson(),
    );

    var doc = await prepcenterRef.doc(prepTransaction.keyPrepCenter).get();
    Prepcenter? prepcenter = doc.data();

    if( prepcenter != null && prepTransaction.amount !=null ) {
      double currentBalance = prepcenter.balance ?? 0.0;

      if(prepTransaction.type == PrepTransaction.INCREASE_BALANCE) {
            prepcenter.balance = currentBalance + prepTransaction.amount!;
      } else if(prepTransaction.type == PrepTransaction.DECREASE_BALANCE ) {
            prepcenter.balance = currentBalance -  prepTransaction.amount!;
      }

      transaction.set(
          prepcenterRef.doc(prepcenter.key),
          prepcenter,
          SetOptions(merge: true)
      );
    }
    return Future.value();
  }


}