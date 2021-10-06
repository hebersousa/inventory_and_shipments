import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ias/catalog/models/catalog_item.dart';
import 'package:ias/catalog/providers/catalog_list_provider.dart';
import 'package:ias/date_view.dart';
import 'package:ias/shipments/models/shipment.dart';
import 'package:ias/shipments/pages/shipment_list_page/shipment_list_item.dart';
import 'package:ias/shipments/providers/shipment_list_provider.dart';
import 'package:ias/shipments/pages/shipment_edit_page/shipment_edit_page.dart';
import 'package:ias/utils.dart';
import 'package:provider/provider.dart';
class ShipmentListviewWidget extends StatefulWidget {
  @override
  _ShipmentListviewWidgetState createState() => _ShipmentListviewWidgetState();
}

class _ShipmentListviewWidgetState extends State<ShipmentListviewWidget> {

   Widget build(BuildContext context) => Consumer<ShipmentListProvider>(
       builder: (context, provider, _) {
         return Utils.refreshListView(
             itemCount: provider.sgipmentItems.length+1,
             onRefresh: () async {
               provider.cleanList();
               await provider.fetchNext();
             },
             builder: (context,index){
               var itens = provider.sgipmentItems;
               if(index < itens.length)

                 return ShipmentListItem(item: itens[index],
                   provider: provider,
                 onTap: ()=>_goToNew(provider,itens[index].key),);

               if(index == itens.length)
                 if(provider.hasNext) {
                   provider.fetchNext();
                   return Text("Carregando...");//_progressIndicator();
                 }
               return Container();
             });
       }

   );


  _goToNew(ShipmentListProvider provider,[var id] ) {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider<ShipmentListProvider>
              .value(value:  provider,
            child: ShipmentEditPage(id: id) ,)
      ),
    );
  }

}
