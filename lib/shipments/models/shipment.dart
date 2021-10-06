


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ias/catalog/models/catalog_item.dart';
import 'package:ias/shipments/models/prepcenter.dart';

class Shipment {

  int count =0;
  String? key;
  DateTime? shippingDate;
  DateTime? deliveryDate;
  DateTime? createdAt;
  DateTime? purchaseDate;
  List<String>? tracks;
  double? priceAvg;
  Prepcenter? prepcenter;
  CatalogItem? catalogItem;

  String? type;

 _test() {}

  Shipment({this.shippingDate, this.deliveryDate,this.purchaseDate, this.priceAvg, this.catalogItem,
  this.prepcenter, required this.count, this.type, this.tracks});

  factory Shipment.fromFirebase(DocumentSnapshot document) {
    var data = document.data()! as Map<String, dynamic>;
    var instance = Shipment.fromJson(data);
    instance.key  = document.id;
    return instance;
  }


  Shipment.fromJson(Map<String, dynamic> json):
      //shipDate = DateTime.parse(json['ship_date']),
        //shipDate = json['ship_date'],

        shippingDate = json.containsKey('shipping_date') &&
            json['shipping_date'].runtimeType == Timestamp ?
        json['shipping_date'].toDate() : null,

        deliveryDate = json.containsKey('delivery_date') &&
            json['delivery_date'].runtimeType == Timestamp ?
        json['delivery_date'].toDate() : null,

        purchaseDate = json.containsKey('purchase_date') &&
            json['purchase_date'].runtimeType == Timestamp ?
        json['purchase_date'].toDate() : null,

      //deliverDate = DateTime.parse(json['deliver_date']),
      //deliverDate = json['deliver_date'],
      count = json['count'],
      priceAvg = json['price_avg'],
      prepcenter = json.containsKey('prepcenter') && json['prepcenter']!=null ?
          Prepcenter.fromJson(json['prepcenter']) : null,

      catalogItem = json['catalog'] != null ?
          CatalogItem.fromJson(json['catalog']) : null,
      //prepcenter = Prepcenter.fromJson(json['prepcenter']),

      tracks = json.containsKey('tracks') && json['tracks']!=null ?
      json['tracks'].toList().cast<String>() : null,

      type = json['type'];


  Map<String, dynamic>  toJson() => {
    if(shippingDate!=null) 'shipping_date' : shippingDate,
    if(deliveryDate!=null) 'delivery_date':deliveryDate,
    if(purchaseDate!=null) 'purchase_date':purchaseDate,
    if(createdAt!=null) 'created_at':createdAt,
    'count':count,
    if(priceAvg!=null)'price_avg':priceAvg,
    if(prepcenter!=null)'prepcenter':prepcenter?.toJson(),
    if(catalogItem!=null)'catalog':catalogItem?.toJson(),
    if(type!=null) 'type':type,
    if(tracks!=null)'tracks':tracks
  };

}