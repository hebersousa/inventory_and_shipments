import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ias/catalog/providers/catalog_provider.dart';
import 'package:ias/date_view.dart';
import 'package:ias/shipments/pages/shipment_edit_page/catalog_autocomplete_widget.dart';
import 'package:provider/provider.dart';

class ShipmentEditPage extends StatefulWidget {

  String? id;
  ShipmentEditPage({this.id});

  @override
  _ShipmentEditPageState createState() => _ShipmentEditPageState();
}

class _ShipmentEditPageState extends State<ShipmentEditPage> {

  final _formKey = GlobalKey<FormState>();
  final _countController = TextEditingController();
  final _shipingDateController = TextEditingController();
  final _deliverDateController = TextEditingController();

  _getAppBar() {
    var title = Text("Shipment Item", style: TextStyle(color: Colors.white));
    var backBt = BackButton(onPressed: ()=>Navigator.pop(context),
      color: Colors.white,);
    var saveBt = TextButton(onPressed: (){},
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
    return Scaffold(appBar: _getAppBar(),
      body: ChangeNotifierProvider(
        create: (context) => CatalogProvider(),
          builder:(context, child)=>_body()
      ),
    );
  }

  _body() {
    return Padding(padding: EdgeInsets.all(15),
      child: Column(
        children: [
          CatalogAutocompleteWidget(),
          _calendarField(_shipingDateController, "Shipping Date"),
          _calendarField(_deliverDateController, "Deliver Date"),
          _countField()
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
         TextField(controller: textEditing ,
           onTap: () async{
             var date = await _selectDate(context);
             textEditing.text = "${date.toLocal()}".split(' ')[0];
           },

           decoration: InputDecoration(
             labelText: hintText,
               suffixIcon:   Icon(Icons.calendar_today_rounded)
           ),

         )),
      ],
    );
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
