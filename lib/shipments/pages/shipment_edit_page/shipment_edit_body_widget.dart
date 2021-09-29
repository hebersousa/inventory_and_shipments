import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
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
  final _shipingDateController = TextEditingController();
  final _deliverDateController = TextEditingController();

  final _destinationStreamController = BehaviorSubject<List<bool>>();


  bool _loading = true;
  ShipmentListProvider? _shipListProvider;
  Shipment? item;

  @override
  void initState() {
    _destinationStreamController.add([false,false]);
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
        child: CircularProgressIndicator(color: Colors.white,)
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

  @override
  Widget build(BuildContext context) {

    _shipListProvider = context.read<ShipmentListProvider>();

    return FutureBuilder<Shipment>(
        future: _getData(),
        builder: (context, snapshot){

          if(snapshot.connectionState ==  ConnectionState.done) {
            if(snapshot.hasData && snapshot.data != null){
              var it =snapshot.data!;
              item = it;
              if(it.count != null)
                  _countController.text = it.count.toString();
              if(it.shipDate != null)
                  _shipingDateController.text = Utils.formatToDate(it.shipDate!);
              if(it.deliverDate != null)
                  _deliverDateController.text = Utils.formatToDate(it.deliverDate!);

             var catalogChipsProvider = context.read<CatalogChipsProvider>();
              if(it.catalogItem!= null && catalogChipsProvider.list.isEmpty)
                  context.read<CatalogChipsProvider>().add(it.catalogItem!);

              var prepcenterChipsProvider = context.read<PrepcenterChipsProvider>();
              if(it.prepcenter!= null && prepcenterChipsProvider.list.isEmpty)
                context.read<PrepcenterChipsProvider>().add(it.prepcenter!);

              if(it.type!= null && it.type!.contains("PREP"))
                _destinationStreamController.add([true,false]);
              else if(it.type!= null && it.type!.contains("AMZ"))
                _destinationStreamController.add([false,true]);
              else
                _destinationStreamController.add([false,false]);

            }

          }
          return Scaffold(
            appBar: _getAppBar(),
            body: _form(),
          );

        //  return Center(child: CircularProgressIndicator());

        });

  }

  _form() {
    return Padding(padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _destinationButtons(),
          PrepcenterAutocompleteWidget(),
          CatalogAutocompleteWidget(),
          _calendarField(_shipingDateController, "Shipping Date"),
          _calendarField(_deliverDateController, "Deliver Date"),
          _countField(),

        ],),
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
      setState(() => _loading = true );
      var catalogChipProvider = Provider.of<CatalogChipsProvider>(context,listen: false) ;
      var catalogItem =  catalogChipProvider.list.first;

      var prepcenterChipProvider = Provider.of<PrepcenterChipsProvider>(context,listen: false) ;
      var prepItem =  prepcenterChipProvider.list.first;

      if (item == null) {
        item = Shipment(
            count: int.parse(_countController.text),
            shipDate: DateTime.tryParse(_shipingDateController.text),
            deliverDate: DateTime.tryParse(_deliverDateController.text),
            catalogItem: CatalogItem.fromJson(catalogItem.toSimpleJson()),
            prepcenter: Prepcenter.fromJson(prepItem.toSimpleJson()),
            type:  _getDestinationOption()
        );
      } else {
        item?.count = int.parse(_countController.text);
        item?.shipDate = DateTime.tryParse(_shipingDateController.text);
        item?.deliverDate = DateTime.tryParse(_deliverDateController.text);
        item?.catalogItem =
            CatalogItem.fromJson(catalogItem.toSimpleJson());
        item?.prepcenter =
            Prepcenter.fromJson(prepItem.toSimpleJson());
        item?.type =  _getDestinationOption();

      }

      await ShipmentApi.saveItem(item!);
      _shipListProvider?.cleanList();
      _shipListProvider?.fetchNext();
      Navigator.of(context).pop();

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
