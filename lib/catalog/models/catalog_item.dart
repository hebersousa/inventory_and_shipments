
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

  CatalogItem({required this.asin,
    required this.title,
    this.shortTitle,
    this.urlImage});

  String get urlAmazon => 'http://www.amazon.com/dp/$asin';

  CatalogItem.fromFirebase(DocumentSnapshot document){

    var data = document.data()! as Map<String, dynamic>;
    key = document.id;
    title  = data['title'];
    asin = data['asin'];
    shortTitle = data['shortTitle'];
    urlImage = data['urlImage'];

  }



  CatalogItem.fromJson(Map<String, dynamic> json)
      :
    key = json['key'],
    title = json['title'] ,
    asin = json['asin'] ,
    shortTitle = json['shortTitle'],
    urlImage = json['urlImage']
  ;

  Map<String, Object?> toJson() {
    return {
      if(key!=null)'key':key,
      if(title!=null)'title': title,
      'asin': asin,
      'shortTitle' : shortTitle,
      if(urlImage!=null) 'urlImage' : urlImage,
      //'query' : '$asin $title $shortTitle'
      if(asin!=null && title!=null)
        'keywords' : Utils.generateKeybyString(asin!) + Utils.generateKeybyArray(title?.split(' '))
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




