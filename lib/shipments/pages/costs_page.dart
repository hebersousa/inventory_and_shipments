import 'package:ias/shipments/models/shipment.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CostsPage extends StatelessWidget {
  Shipment? shipment;
  CostsPage({required this.shipment});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _table(shipment),
    );
  }
  _table(Shipment? ship){
    var unitCost = shipment?.unitCost ?? 0;
    var shipCost = shipment?.shipCost ?? 0;
    var prepCost = shipment?.prepCost ?? 0;
    var total =  shipment?.totalUnitCost;

    return Table(textDirection: TextDirection.ltr,
      children: [
      TableRow(children: [
        _smallText("Unit Cost"),
        _smallText("\$ $unitCost"),
        _copyIcon(copy: unitCost.toString()),
      ]),
      if(shipment?.type == 'AMZ')
      TableRow(children: [
        _smallText("Ship Cost"),
        _smallText("\$ $shipCost"),
        _copyIcon(copy: shipCost.toString()),

      ]),
        if(shipment?.type == 'AMZ')
        TableRow(children: [
          _smallText("Prep Cost"),
          _smallText("\$ $prepCost"),
          _copyIcon(copy: prepCost.toString()),
        ]),
        TableRow(children: [
          _mediumText("Total Cost"),
          _mediumText("\$ $total"),
          _copyIcon(copy: total.toString()),
        ])

    ],);

  }

  _copyIcon ({required String copy}){
    return IconButton(
        onPressed: ()=> Clipboard.setData(ClipboardData(text: copy)),
        icon: Icon(Icons.copy, size: 16,));

 }

  _smallText(String text)=> Padding(
    padding: const EdgeInsets.only(top: 8, bottom: 8),
    child: Text(text,
      style: TextStyle(fontSize: 13, color: Colors.grey.shade500),),
  );

  _mediumText(String text)=> Text(text,
    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),);


}
