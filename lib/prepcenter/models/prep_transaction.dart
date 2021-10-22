
import 'package:cloud_firestore/cloud_firestore.dart';

class PrepTransaction {

  static int INCREASE_BALANCE = 1;
  static int DECREASE_BALANCE = 0;
  String? key;
  DateTime? createdAt;
  String? keyPrepCenter;
  int? countItems;
  int? type = DECREASE_BALANCE;
  double? costItem;
  double? amount;

  PrepTransaction({required this.keyPrepCenter,this.countItems, this.costItem,
    required this.type, required this.amount});

  PrepTransaction.fromJson(Map<String, dynamic> json):
        type = json['type'],
        keyPrepCenter = json['key_prepcenter'],
        amount = json['amount'],
        costItem = json['cost_item'],
        countItems = json['count_items'],
        createdAt = json.containsKey('created_at') &&
            json['created_at'].runtimeType == Timestamp ?
        json['created_at'].toDate() : null;

    factory PrepTransaction.fromFirebase(DocumentSnapshot document) {
      var data = document.data()! as Map<String, dynamic>;
      var instance = PrepTransaction.fromJson(data);
      instance.key  = document.id;
      return instance;
    }

  Map<String, dynamic>  toJson() => {
    if(amount!=null) 'amount' : amount,
    if(countItems!=null) 'count_items':countItems,
    if(costItem!=null) 'cost_item':costItem,
    if(createdAt!=null) 'created_at':createdAt,
    if(keyPrepCenter!=null)'key_prepcenter':keyPrepCenter,
    if(type!=null)'type':type
  };
}