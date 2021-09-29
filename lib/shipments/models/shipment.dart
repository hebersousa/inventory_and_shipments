


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ias/catalog/models/catalog_item.dart';
import 'package:ias/shipments/models/prepcenter.dart';

class Shipment {

  int count =0;
  String? key;
  DateTime? shipDate;
  DateTime? deliverDate;
  List<String>? trackers;
  double? priceAvg;
  Prepcenter? prepcenter;
  CatalogItem? catalogItem;
  DateTime? createdAt;
  String? type;

 _test() {}

  Shipment({this.shipDate, this.deliverDate, this.priceAvg, this.catalogItem,
  this.prepcenter, required this.count, this.type});

  factory Shipment.fromFirebase(DocumentSnapshot document) {
    var data = document.data()! as Map<String, dynamic>;
    var instance = Shipment.fromJson(data);
    instance.key  = document.id;
    return instance;
  }


  Shipment.fromJson(Map<String, dynamic> json):
      //shipDate = DateTime.parse(json['ship_date']),
        //shipDate = json['ship_date'],
        shipDate = json.containsKey('ship_date') &&
            json['ship_date'].runtimeType == Timestamp ?
        json['ship_date'].toDate() : null,

      //deliverDate = DateTime.parse(json['deliver_date']),
      //deliverDate = json['deliver_date'],
      count = json['count'],
      priceAvg = json['price_avg'],
      prepcenter = json.containsKey('prepcenter') && json['prepcenter']!=null ?
          Prepcenter.fromJson(json['prepcenter']) : null,

      catalogItem = json['catalog'] != null ?
          CatalogItem.fromJson(json['catalog']) : null,
      //prepcenter = Prepcenter.fromJson(json['prepcenter']),
      type = json['type'];

  Map<String, dynamic>  toJson() => {
    if(shipDate!=null) 'ship_date' : shipDate,
    if(deliverDate!=null) 'deliver_date':deliverDate,
    'count':count,
    if(priceAvg!=null)'price_avg':priceAvg,
    if(prepcenter!=null)'prepcenter':prepcenter?.toJson(),
    if(catalogItem!=null)'catalog':catalogItem?.toJson(),
    if(createdAt!=null) 'created_at':createdAt,
    if(type!=null) 'type':type
  };

}