import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ias/shipments/api/prepcenter_api.dart';
import 'package:ias/shipments/models/address.dart';
import 'package:ias/shipments/models/prepcenter.dart';
import 'package:ias/shipments/models/shipment.dart';
import 'package:ias/shipments/pages/shipment_edit_page/shipment_edit_page.dart';
import 'package:ias/shipments/pages/shipment_list_page/shipment_listview_widget.dart';
import 'package:ias/shipments/providers/prepcenter_list_provider.dart';
import 'package:ias/shipments/providers/shipment_list_provider.dart';
import 'package:ias/utils.dart';
import 'package:provider/provider.dart';


class ShipmentListPage extends StatefulWidget {
  @override
  _ShipmentListPageState createState() => _ShipmentListPageState();
}

class _ShipmentListPageState extends State<ShipmentListPage> {

  _createAppBar(BuildContext context) {
    var provider = context.read<ShipmentListProvider>();
    var addButton = IconButton(
        color:  Colors.white,
        icon: Icon(Icons.add),
        onPressed: ()=> _goToNew(provider)
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
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (context) => ShipmentListProvider(),
    builder:(context, child) =>  _scafold(context),
  );


  _scafold(BuildContext context) {
    return Scaffold(
      appBar: _createAppBar(context),
      body:    ShipmentListviewWidget(),


    );
  }

  void _onRefresh() async{
    // monitor network fetch
   // await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()

  }


  _slivesListView(Widget listView) {

    return CustomScrollView(
      slivers: [

        SliverList(
            delegate: SliverChildListDelegate([
              SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      child: listView,
                    ),
                  ],
                ),
              )
            ]))
      ],
    );

  }

  _addPrepcenterItem(){

    var provider = PrepcenterListProvider();
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

/*
  _goToNew(BuildContext context) =>
      Navigator.of(context).push(
          MaterialPageRoute( builder: (context) => ShipmentEditPage() ),
    );
*/
  _goToNew(ShipmentListProvider provider,[var id] ) {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider<ShipmentListProvider>
              .value(value:  provider,
            child: ShipmentEditPage(id: id) ,)
      ),
    );
  }

  _test() {
   PrepcenterApi.getPrepcenter(10).then((QuerySnapshot snapshot) {

     var lsit = snapshot.docs.map((snap) {
       //Map<String, dynamic> data = snap.data()! as Map<String, dynamic>;
       //return CatalogItem.fromJson(data);
       return Prepcenter.fromFirebase(snap);
     }).toList();

     var k = 0;

   });




  }
}
