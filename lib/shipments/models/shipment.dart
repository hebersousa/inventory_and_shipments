


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

 _test() {}

  Shipment({this.shipDate, this.deliverDate, this.priceAvg, this.catalogItem,
  this.prepcenter, required this.count});

  Shipment.fromJson(Map<String, dynamic> json):
      shipDate = DateTime.parse(json['ship_date']),
      deliverDate = DateTime.parse(json['deliver_date']),
      count = json['count'],
      priceAvg = json['price_avg'],
      prepcenter = Prepcenter.fromJson(json['prepcenter']);

  Map<String, dynamic>  toJson() => {
    if(shipDate!=null) 'ship_date' : shipDate?.toString(),
    if(deliverDate!=null) 'deliver_date':deliverDate?.toString(),
    'count':count,
    if(priceAvg!=null)'price_avg':priceAvg,
    if(prepcenter!=null)'prepcenter':prepcenter?.toJson()
  };

}