
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ias/shipments/models/address.dart';
import 'package:ias/utils.dart';

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

  factory Prepcenter.fromFirebase(DocumentSnapshot document) {
    var data = document.data()! as Map<String, dynamic>;
    var instance = Prepcenter.fromJson(data);
    instance.key  = document.id;


    return instance;
  }

  Prepcenter.fromJson(Map<String, dynamic> json):
        key = json['key'],
        name = json['name'],
        priceUnit =   json['price_unit']!=null ? json['price_unit'].toDouble() : null,
        pricePack = json['price_pack']!=null ? json['price_pack'].toDouble() : null,
        balance = json['balance']!=null ? json['balance'].toDouble() : null,
        address = json.containsKey('address') && json['address']!= null ?
        Address.fromJson(json['address']) : null;


  Map<String, dynamic>  toJson() => {
    if(key!=null) 'key': key,
    'name' : name,
    if(priceUnit!=null )'price_unit':priceUnit,
    if(pricePack!=null ) 'price_pack':pricePack,
    if(balance!=null ) 'balance':balance,
    if(address!=null ) 'address':address?.toJson(),
    if(name!=null)
      'keywords' :  Utils.generateKeybyArray(name?.split(' '))
  };

  Map<String, dynamic>  toSimpleJson() => {
    if(key!=null) 'key': key,
    'name' : name,
  };
}