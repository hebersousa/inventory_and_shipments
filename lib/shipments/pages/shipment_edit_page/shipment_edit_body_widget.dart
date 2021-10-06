import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ias/catalog/models/catalog_item.dart';
import 'package:ias/catalog/providers/catalog_list_provider.dart';
import 'package:ias/date_view.dart';
import 'package:ias/shipments/api/shipment_api.dart';
import 'package:ias/shipments/models/prepcenter.dart';
import 'package:ias/shipments/models/shipment.dart';
import 'package:ias/shipments/pages/shipment_edit_page/catalog_autocomplete_widget.dart';
import 'package:ias/shipments/pages/shipment_edit_page/prepcenter_autocomplete_widget.dart';
import 'package:ias/shipments/pages/shipment_edit_page/track_chips_widget.dart';
import 'package:ias/shipments/providers/catalog_chips_provider.dart';
import 'package:ias/shipments/providers/prepcenter_chips_provider.dart';
import 'package:ias/shipments/providers/shipment_list_provider.dart';
import 'package:ias/utils.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';


class ShipmentEditBodyWidget extends StatefulWidget {

  String? id;
  ShipmentEditBodyWidget({this.id});

  @override
  _ShipmentEditBodyWidgetState createState() => _ShipmentEditBodyWidgetState();
}

class _ShipmentEditBodyWidgetState extends State<ShipmentEditBodyWidget> {

  final _formKey = GlobalKey<FormState>();
  final _countController = TextEditingController();
  final _shippingDateController = TextEditingController();
  final _deliveryDateController = TextEditingController();
  final _purchaseDateController = TextEditingController();

  final _destinationStreamController = BehaviorSubject<List<bool>>();
  final _trackChipsController = BehaviorSubject<List<String>>();


  bool _loading = true;
  ShipmentListProvider? _shipListProvider;
  Shipment? item;

  @override
  void initState() {
    _destinationStreamController.add([false,false]);
    _trackChipsController.add([]);
    super.initState();
  }
  @override
  void dispose() {
    _destinationStreamController.close();
    super.dispose();
  }


  Future<Shipment> _getData() async{
    Shipment? itemValue;
    if(widget.id != null) {
      var doc = await FirebaseFirestore.instance
          .collection('shipment').doc(widget.id).get();
      itemValue = Shipment.fromFirebase(doc);
    }
     _loading = false;
    return Future<Shipment>(()=>itemValue!);
  }

  _getAppBar() {
    var title = Text("Shipment Item", style: TextStyle(color: Colors.white));
    var backBt = BackButton(onPressed: ()=>Navigator.pop(context),
      color: Colors.white,);

    var progress = Container(
      margin: EdgeInsets.all(15),
        height: 10,width: 20,
       // child: CircularProgressIndicator(color: Colors.white,)
      child: CupertinoActivityIndicator(),
    );

    var saveBt = _loading ? progress
    :  TextButton(onPressed: ()=> _saveShipment(),
        child: Text("Save", style: TextStyle(color: Colors.white),)
    );

    return AppBar(title: title ,
      centerTitle: true,
      leading: backBt,
      actions: [ saveBt],
    );
  }

  void _onRefresh() async{
    // monitor network fetch
    // await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
  }

  @override
  Widget build(BuildContext context) {

    _shipListProvider = context.read<ShipmentListProvider>();

    return FutureBuilder<Shipment>(
        future: _getData(),
        builder: (context, snapshot){
          if(snapshot.connectionState ==  ConnectionState.done) {
            if(snapshot.hasData && snapshot.data != null) {
              var it =snapshot.data!;
              item = it;
              _loadFields(it);
            } else {
              _purchaseDateController.text = Utils.formatToDate(DateTime.now());
            }
          }

          return Scaffold(
            appBar: _getAppBar(),
            body: SingleChildScrollView(child: _form(),),
          );

        //  return Center(child: CircularProgressIndicator());

        });
  }

  _loadFields(Shipment shipment) {

          if(shipment.count != null)
            _countController.text = shipment.count.toString();
          if(shipment.shippingDate != null)
            _shippingDateController.text = Utils.formatToDate(shipment.shippingDate!);

          if(shipment.deliveryDate != null)
            _deliveryDateController.text = Utils.formatToDate(shipment.deliveryDate!);

          if(shipment.purchaseDate != null)
            _purchaseDateController.text = Utils.formatToDate(shipment.purchaseDate!);
          else
            _purchaseDateController.text = Utils.formatToDate(DateTime.now());

          var catalogChipsProvider = context.read<CatalogChipsProvider>();
          if(shipment.catalogItem!= null && catalogChipsProvider.list.isEmpty)
            context.read<CatalogChipsProvider>().add(shipment.catalogItem!);

          var prepcenterChipsProvider = context.read<PrepcenterChipsProvider>();
          if(shipment.prepcenter!= null && prepcenterChipsProvider.list.isEmpty)
            context.read<PrepcenterChipsProvider>().add(shipment.prepcenter!);

          if(shipment.tracks != null)
            _trackChipsController.add(shipment.tracks!);

          if(shipment.type!= null && shipment.type!.contains("PREP"))
            _destinationStreamController.add([true,false]);
          else if(shipment.type!= null && shipment.type!.contains("AMZ"))
            _destinationStreamController.add([false,true]);
          else
            _destinationStreamController.add([false,false]);
  }

  _form() {
    return  StreamBuilder<List<bool>>(
        stream:  _destinationStreamController.stream,
        builder: (context,snapshot) {

         return Padding(padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _destinationButtons(),
                PrepcenterAutocompleteWidget(),
                CatalogAutocompleteWidget(),
                if(_getDestinationOption() == "PREP")
                    _calendarField(_purchaseDateController, "Purchase Date"),
                _calendarField(_shippingDateController, "Shipping Date"),
                if(_getDestinationOption() == "PREP")
                    _calendarField(_deliveryDateController, "Deliver Date"),
                _countField(),
                if(_getDestinationOption() == "PREP")
                  TrackChipsWidget(streamController: _trackChipsController)

              ],),
          );
        }
    );
  }


  _countField() {
    return Container(
      child: TextField(controller: _countController,
        decoration: InputDecoration(labelText: 'Number of Items',),
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      ),
    );
  }


  _calendarField(TextEditingController textEditing, String hintText ){
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        //DateView(date: _selectedDate),
        Flexible(child:
        InkWell(
          onTap: () async{

            var date = await _selectDate(context);
            textEditing.text = "${date.toLocal()}".split(' ')[0];
          },
          child: TextField(controller: textEditing ,
            enabled: false,
            onTap: () async{

              var date = await _selectDate(context);
              textEditing.text = "${date.toLocal()}".split(' ')[0];
            },

            decoration: InputDecoration(
                labelText: hintText,
                suffixIcon:   Icon(Icons.today)
            ),

          ),
        )),
      ],
    );
  }


  _destinationButtons() {

    return StreamBuilder<List<bool>>(
      initialData: [false,false],
      stream:  _destinationStreamController.stream,
        builder: (context,snapshot){

          List<bool>? destinationOptions =[false,false];
          if(snapshot.hasData)
            destinationOptions = snapshot.data;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Destination",
                style: TextStyle(fontSize: 11,color: Colors.grey.shade600),),
              ToggleButtons(
                children: [
                  Text("PREP"),
                  Text("AMZ")
                ],
                isSelected: destinationOptions!,
                onPressed: (index) {

                  var selected = [false,false];
                  selected[index] = true;
                  _destinationStreamController.add(selected);

                },

              ),
            ],
          );

    });


  }
  String? _getDestinationOption() {

    var options =  _destinationStreamController.value;

    if(options[0]) return "PREP";
    if(options[1]) return "AMZ";

    return null;
  }

  _saveShipment() async {

    if(_validateForm()) {
      setState(() => _loading = true);
      var catalogChipProvider = Provider.of<CatalogChipsProvider>(
          context, listen: false);
      var catalogItem = catalogChipProvider.list.first;

      var prepcenterChipProvider = Provider.of<PrepcenterChipsProvider>(
          context, listen: false);
      var prepItem = prepcenterChipProvider.list.first;

      var urlTracks = _trackChipsController.value;

      if (item == null) {
        item = Shipment(
            count: int.parse(_countController.text),
            shippingDate: DateTime.tryParse(_shippingDateController.text),
            deliveryDate: DateTime.tryParse(_deliveryDateController.text),
            purchaseDate: DateTime.tryParse(_purchaseDateController.text),
            catalogItem: CatalogItem.fromJson(catalogItem.toSimpleJson()),
            prepcenter: Prepcenter.fromJson(prepItem.toSimpleJson()),
            tracks: urlTracks ,
            type: _getDestinationOption()
        );
      } else {
        item?.count = int.parse(_countController.text);
        item?.shippingDate = DateTime.tryParse(_shippingDateController.text);
        item?.deliveryDate = DateTime.tryParse(_deliveryDateController.text);
        item?.purchaseDate = DateTime.tryParse(_purchaseDateController.text);
        item?.catalogItem =
            CatalogItem.fromJson(catalogItem.toSimpleJson());
        item?.prepcenter =
            Prepcenter.fromJson(prepItem.toSimpleJson());
        item?.type = _getDestinationOption();
        item?.tracks = urlTracks;
      }

      await ShipmentApi.saveItem(item!);
      _shipListProvider?.cleanList();
      _shipListProvider?.fetchNext();
      Navigator.of(context).pop();
    }

  }

  bool _validateForm() {

    if(!_destinationStreamController.value.any((element){

      return element;
    } )){
      Utils.showAlertDialog(context, "Please choice a destination.");
      return false;
    }

    var prepcenterChipProvider = Provider.of<PrepcenterChipsProvider>(
        context, listen: false);
    if(prepcenterChipProvider.list.length <= 0) {
      Utils.showAlertDialog(context, "Please choice a prepcenter.");
      return false;
    }

    var catalogChipProvider = Provider.of<CatalogChipsProvider>(
        context, listen: false);
    if(catalogChipProvider.list.length <= 0) {
      Utils.showAlertDialog(context, "Please choice a catalog item");
      return false;
    }

    int? count = int.tryParse(_countController.text);
    if(count==null || count < 1 ) {
      Utils.showAlertDialog(context, "Please fill in the item number.");
      return false;
    }
    return true;
  }

  Future<DateTime> _selectDate(BuildContext context) async {

    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015,8),
        lastDate: DateTime(2150));

    if (picked != null )
      return Future<DateTime>.value(picked);
    else
      return Future<DateTime>.value();
  }

}
