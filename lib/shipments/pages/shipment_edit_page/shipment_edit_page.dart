
import 'package:flutter/material.dart';
import 'package:ias/catalog/providers/catalog_list_provider.dart';
import 'package:ias/shipments/pages/shipment_edit_page/shipment_edit_body_widget.dart';
import 'package:ias/shipments/providers/catalog_chips_provider.dart';
import 'package:ias/shipments/providers/prepcenter_chips_provider.dart';
import 'package:ias/prepcenter/providers/prepcenter_list_provider.dart';
import 'package:ias/shipments/providers/shipment_list_provider.dart';
import 'package:provider/provider.dart';


class ShipmentEditPage extends StatefulWidget {
  String? id;
  ShipmentEditPage({this.id});

  @override
  _ShipmentEditPageState createState() => _ShipmentEditPageState();
}

class _ShipmentEditPageState extends State<ShipmentEditPage> {


  @override
  Widget build(BuildContext context) {

    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => CatalogListProvider()),
      ChangeNotifierProvider(create: (context) => PrepcenterListProvider()),
      Provider(create: (context) => CatalogChipsProvider()),
      Provider(create: (context) => PrepcenterChipsProvider()),
      //  ChangeNotifierProvider(create: (context) => ShipmentProvider())
    ],
        builder:(context, child)=>
            ShipmentEditBodyWidget(id:widget.id) );
  }

}


