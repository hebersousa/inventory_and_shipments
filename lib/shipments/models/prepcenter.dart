
import 'dart:core';

import 'package:ias/shipments/models/address.dart';

class Prepcenter {

  String? key;
  String? name;
  Address? address;
  double? priceUnit;
  double? pricePack;
  double? balance;

  Prepcenter({required this.name,
    this.key,
    this.priceUnit,
    this.pricePack,
    this.balance,
    this.address});

  Prepcenter.fromJson(Map<String, dynamic> json):
        key = json['key'],
        name = json['name'],
        priceUnit = json['price_unit'],
        pricePack = json['price_pack'],
        balance = json['balance'],
        address = Address.fromJson(json['address']);

  Map<String, dynamic>  toJson() => {
    if(key!=null) 'key': key,
    'name' : name,
    if(priceUnit!=null )'price_unit':priceUnit,
    if(pricePack!=null ) 'price_pack':pricePack,
    if(balance!=null ) 'balance':balance,
    if(address!=null ) 'address':address?.toJson()
  };
}