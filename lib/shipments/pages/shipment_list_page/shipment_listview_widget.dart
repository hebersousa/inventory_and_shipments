import 'package:flutter/material.dart';
import 'package:ias/catalog/models/catalog_item.dart';
import 'package:ias/catalog/providers/catalog_list_provider.dart';
import 'package:ias/date_view.dart';
import 'package:ias/shipments/models/shipment.dart';
import 'package:ias/shipments/providers/shipment_list_provider.dart';
import 'package:ias/shipments/pages/shipment_edit_page/shipment_edit_page.dart';
import 'package:provider/provider.dart';
class ShipmentListviewWidget extends StatefulWidget {
  @override
  _ShipmentListviewWidgetState createState() => _ShipmentListviewWidgetState();
}

class _ShipmentListviewWidgetState extends State<ShipmentListviewWidget> {

  @override
  Widget build(BuildContext context) => Consumer<ShipmentListProvider>(
    builder: (context, provider, _) {

      return ListView.separated(
        //controller: scrollController,
        separatorBuilder: (context, index) => Divider(),
        itemCount: provider.sgipmentItems.length+1,
        itemBuilder: (context,index){
          var itens = provider.sgipmentItems;
          if(index < itens.length)
            return _createItem(itens[index], provider);

          if(index == itens.length)
            if(provider.hasNext) {
              provider.fetchNext();
              return _circularWidget();
            }
          return Container();
        },
      );
    },
  );


  _createItem2(Shipment item, ShipmentListProvider provider) {
    var catalog = item.catalogItem;
    return GestureDetector(
      onTap: ()=>_goToNew(provider,item.key),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(children: [
         if(catalog!=null) Text(catalog.shortTitle.toString()),
          SizedBox(width: 10,),
          Text(item.count.toString()),
          SizedBox(width: 10,),
          Text(item.type.toString()),
        ],),
      ),
    );
  }

  _createItem(Shipment item, ShipmentListProvider provider) {
    var catalog = item.catalogItem;
    return ListTile(
      onTap: ()=>_goToNew(provider,item.key),
      leading:
      _itemImage(catalog),
      title: _contentItem(item)
    );

  }

  _itemImage(CatalogItem? catalog) {

    return catalog!= null && catalog.urlImage != null ?
    SizedBox(width: 40,child:
    Image.network(catalog.urlImage.toString(),)) : null;
  }

  _contentItem(Shipment item) {
    var catalog = item.catalogItem;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          if(catalog!=null) Text(catalog.shortTitle.toString()),
          SizedBox(width: 10,),
          Text( "· ${item.count.toString()} units"),
        ],),
        Row(children: [
          _destinyWidget(item.type),
          SizedBox(width: 10,),
          DateView(date: null,title: 'purchase',),
          SizedBox(width: 10,),
          if(item.shipDate != null)
            DateView(date: item.shipDate,title: 'shipping',),
          SizedBox(width: 10,),
            DateView(date: null,title: 'deliver',),
        ],),
    ],);
  }

  _destinyWidget(String? type) {
    if(type == null)
      return Container();
    else
      return Row(
        children: [

          if(type.contains("PREP"))
            Icon(Icons.arrow_downward,color: Colors.green,size: 16,)
          else if(type.contains("AMZ"))
            Icon(Icons.arrow_upward,color: Colors.blue,size: 16,),
          Text(type.toString(),style: TextStyle(fontSize: 15),)
        ],
      );
  }
  _goToNew(ShipmentListProvider provider,[var id] ) {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider<ShipmentListProvider>
              .value(value:  provider,
            child: ShipmentEditPage(id: id) ,)
      ),
    );
  }

  _circularWidget() {
    return Center(
      child: Container(
        height: 25,
        width: 25,
        child: CircularProgressIndicator(),
      ),
    );
  }
}
