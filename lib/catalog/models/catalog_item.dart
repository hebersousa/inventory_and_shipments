
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
    title = json['title'] ,
    asin = json['asin'] ,
    shortTitle = json['shortTitle'],
    urlImage = json['urlImage']
  ;

  Map<String, Object?> toJson() {
    return {
      'title': title,
      'asin': asin,
      'shortTitle' : shortTitle,
      if(urlImage!=null) 'urlImage' : urlImage,
      //'query' : '$asin $title $shortTitle'
      if(asin!=null && title!=null)
        'keywords' : Utils.generateKeybyString(asin!) + Utils.generateKeybyArray(title?.split(' '))
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
  String toString()=> title!.toLowerCase();
}




