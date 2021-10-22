import 'package:flutter/material.dart';
import 'package:ias/catalog/models/catalog_item.dart';
import 'package:ias/date_view.dart';
import 'package:ias/shipments/api/shipment_api.dart';
import 'package:ias/shipments/models/shipment.dart';
import 'package:ias/shipments/providers/shipment_list_provider.dart';
import 'package:ias/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class ShipmentListItem extends StatefulWidget {
  Shipment? item;
  ShipmentListProvider? provider;
  Function? onTap;

  ShipmentListItem({required this.item, required this.provider, this.onTap});
  @override
  _ShipmentListItemState createState() => _ShipmentListItemState();
}

class _ShipmentListItemState extends State<ShipmentListItem> {
  @override
  Widget build(BuildContext context) {
    var catalog = widget.item?.catalogItem;
    var func =  widget.onTap;

    return Column(children: [
      ListTile(
          onTap: ()=> func != null ?  func() : null,
           leading: _leading(widget.item!),
          title: _contentItem(widget.item!),
         // trailing: _getPopUpMenuTracks(widget.item!),
        trailing: widget.item != null ? _deleteButton(widget.item!):null,
      ),
      Divider()
    ],);
  }

  _leading(Shipment item) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("${item.count.toString()} units"),
        _destinyWidget(item.type),

      ],
    );
  }

  _deleteButton(Shipment shipment) => IconButton(icon: Icon(Icons.delete),
      tooltip: "Delete Item",
      onPressed: ()=>_removeItem(widget.item));

  _itemImage(CatalogItem? catalog) {

    return catalog!= null && catalog.urlImage != null ?
    SizedBox(width: 40,child:
    Image.network(catalog.urlImage.toString(),)) : null;
  }

  _getPopUpMenuTracks(Shipment item) {

    if(item.tracks != null && item.tracks!.length > 0)
      return PopupMenuButton<String>(
          icon: Icon(Icons.local_shipping,color: Colors.grey,),
          tooltip: "Tracking package",
          elevation: 20,
          enabled: true,
          onSelected: (value) {
             launch(value);
          },
          itemBuilder:(context) {
            var i = 0;
            return item.tracks!.map((String choice) {
              i++;
              return PopupMenuItem<String>(
                value: choice,
                child: Text("Tracking #$i"),
              );
            }).toList();
          }
      );
    return Container();
  }
  
  _contentItem(Shipment item) {
    var catalog = item.catalogItem;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          if(catalog!=null) Text(catalog.shortTitle.toString()),
          //SizedBox(width: 10,),
      //  Text( "· ${item.count.toString()} units"),
        ],),
        Wrap(children: [
          _itemImage(catalog),
          //SizedBox(width: 10,),
          if(item.type=="PREP")
          DateView(date: item.purchaseDate,title: 'purchase',),
          SizedBox(width: 10,),
          item.shippingDate!=null ?
          DateView(date: item.shippingDate,title: 'shipping',):_notSent(),
          SizedBox(width: 10,),
          if(item.type=="PREP") if(item.deliveryDate!=null)
          DateView(date: item.deliveryDate,title: 'delivery',)
          else if(item.shippingDate !=null) _inTransit(),
          if(item.type=="PREP")
          _getPopUpMenuTracks(item)
        ],),
      ],);
  }

  _inTransit()=>Text("In transit",
    style: TextStyle(color: Colors.red, fontSize: 10),);

  _notSent()=>Text("Not sent yet",
    style: TextStyle(color: Colors.red, fontSize: 10),);

  _destinyWidget(String? type) {
    if(type == null)
      return Container();
    else
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [

          if(type.contains("PREP"))
            Icon(Icons.arrow_downward,color: Colors.green,size: 16,)
          else if(type.contains("AMZ"))
            Icon(Icons.arrow_upward,color: Colors.blue,size: 16,),
          Text(type.toString(),style: TextStyle(fontSize: 15),)
        ],
      );
  }


  _removeItem(Shipment? shipment) async {

    if(await Utils.showAlertDialog(context, "Delete this item?", yesNo: true)) {
      if (shipment != null)
        await ShipmentApi.removeItem(shipment);

      if (widget.provider != null)
        widget.provider?.cleanList();
    }
  }
}
