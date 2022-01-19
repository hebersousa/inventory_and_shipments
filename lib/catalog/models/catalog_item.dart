
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:ias/utils.dart';

class Category {
      int id;
      String name;

      Category(this.id, this.name);

      Category.fromJson(Map json)
          : id = json['id'],
            name = json['name'];

      Map<String, dynamic> toJson() => {
        "id" : id,
        "name": "\"$name\""
      };

      String toString() => toJson().toString();
}

class CatalogItem  {

  String? key;
  String? asin;
  String? title;
  String? shortTitle;
  String? urlImage;
  int? count;
  double? unitCostAvg = 0;
  String? urlResource;

  CatalogItem({required this.asin,
    required this.title,
    this.shortTitle,
    this.urlImage,
    this.count,
    this.unitCostAvg,
    this.urlResource});

  String get urlAmazon => 'http://www.amazon.com/dp/$asin';

  factory CatalogItem.fromFirebase(DocumentSnapshot document){

    var data = document.data()! as Map<String, dynamic>;
    var instance = CatalogItem.fromJson(data);
    instance.key = document.id;
    return instance;
  }


  CatalogItem.fromJson(Map<String, dynamic> json)
      :
    key = json['key'],
    title = json['title'] ,
    asin = json['asin'] ,
    shortTitle = json['shortTitle'],
    urlImage = json['urlImage'],
    urlResource = json['resourceLink'],
    unitCostAvg = json['unit_cost_avg'] ?? 0,
    count = json['count'];



  Map<String, Object?> toJson() {
    return {
      if(key!=null)'key':key,
      if(title!=null)'title': title,
      'asin': asin,
      'shortTitle' : shortTitle,
      if(urlImage!=null) 'urlImage' : urlImage,
      if(urlResource!=null) 'resourceLink' : urlResource,
      //'query' : '$asin $title $shortTitle'
      'count' : count ?? 0 ,
      if(unitCostAvg!=null)'unit_cost_avg':unitCostAvg,
      if(asin!=null && title!=null)
        'keywords' : Utils.generateKeybyString(asin!.trim()) + Utils.generateKeybyArray(title!.trim().split(' '))
       // generateKeybyString e generateKeybyArray estava apresentando erro com strings terminadas em espaço. Por isso uso do trim()
    };
  }

  Map<String, Object?> toSimpleJson() {
    return {
      'key':key,
      'asin':asin,
      'shortTitle':shortTitle,
      if(urlImage!=null) 'urlImage' : urlImage,
    };
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is CatalogItem && other.title == title && other.asin == asin;
  }

  @override
  int get hashCode => hashValues(title, asin);

  @override
  String toString()=> title!=null ? title!.toLowerCase() : asin!.toLowerCase();
}




