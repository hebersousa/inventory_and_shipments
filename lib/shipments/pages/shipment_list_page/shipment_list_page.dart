import 'package:flutter/material.dart';
import 'package:ias/base_provider.dart';
import 'package:ias/shipments/models/address.dart';
import 'package:ias/shipments/models/prepcenter.dart';
import 'package:ias/shipments/models/shipment.dart';
import 'package:ias/shipments/pages/shipment_edit_page/shipment_edit_page.dart';
import 'package:ias/shipments/providers/prepcenter_provider.dart';
import 'package:ias/shipments/providers/shipment_provider.dart';

class ShipmentListPage extends StatefulWidget {
  @override
  _ShipmentListPageState createState() => _ShipmentListPageState();
}

class _ShipmentListPageState extends State<ShipmentListPage> {

  _createAppBar(BuildContext context) {
    var addButton = IconButton(
        color:  Colors.white,
        icon: Icon(Icons.add),
        onPressed: ()=> _goToNew(context)
    );

    var title = Text('Shipments', style: TextStyle(color: Colors.white),);

    var menuButton = IconButton(
        color: Colors.white,
        icon: Icon(Icons.menu),
        onPressed: () => Scaffold.of(context).openDrawer(),
    );

    return  AppBar(title: title,
      actions: [addButton],
      leading: menuButton,);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: _createAppBar(context),
      body: Container(),
    );
  }

  _addPrepcenterItem(){

    var provider = PrepcenterProvider();
    var address = Address(line1:'2721 Forsyth Rd, Suite 107-1155',
        city:  'winter Park',
        state: 'Florida',
        zipCode: '32792',
        name: 'Ana Souza');

    var prep = Prepcenter(
      name: 'DirectBox',
      address: address,
      balance: 0.0,
      //pricePack: 1.1,
      priceUnit: 0.9
    );

    provider.saveItem(prep);
  }

  _addShipmentItem(){
    var provider = ShipmentProvider();

    var prep2 = Prepcenter(name: "FlashBox", key:"HHh0N7iwCQkoBeTb6Xan");
    var shipment = Shipment(
        count: 2,
        prepcenter: prep2,
        shipDate: DateTime.parse('2021-09-21'),
        deliverDate: DateTime.now()
    );
    provider.saveItem(shipment);
  }

  _goToNew(BuildContext context) =>
      Navigator.of(context).push(
          MaterialPageRoute( builder: (context) => ShipmentEditPage() ),
    );

}
