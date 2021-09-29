import 'dart:async';
import 'package:ias/shipments/models/prepcenter.dart';

class PrepcenterChipsProvider {


  final _controller = StreamController<List<Prepcenter>>.broadcast();
  final _items = <Prepcenter>[];

  Stream<List<Prepcenter>> get stream => _controller.stream;
  List<Prepcenter> get list => _items;

  void add(Prepcenter item) async {
    _items.add(item);
    _controller.sink.add(_items);
  }

  void remove(Prepcenter item) async {
    _items.remove(item);
    _controller.sink.add(_items);
  }

  void dispose() {
    _controller.close();
  }
}