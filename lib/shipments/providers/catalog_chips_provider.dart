import 'dart:async';

import 'package:ias/catalog/models/catalog_item.dart';

class CatalogChipsProvider {

  final _controller = StreamController<List<CatalogItem>>.broadcast();
  final _items = <CatalogItem>[];

  Stream<List<CatalogItem>> get stream => _controller.stream;
  List<CatalogItem> get list => _items;

  void add(CatalogItem item) async {
    _items.add(item);
    _controller.sink.add(_items);
  }

  void remove(CatalogItem item) async {
    _items.remove(item);
    _controller.sink.add(_items);
  }

  void dispose() {
    _controller.close();
  }
}