import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateView extends StatelessWidget {
  DateTime? date = DateTime.now();
  String? title;
  DateView({required this.date, this.title});
  @override
  Widget build(BuildContext context) {
    final DateFormat monthFormat = DateFormat('MMM');
    return Container(
      margin: EdgeInsets.all(5),
      child:
      Column(mainAxisSize: MainAxisSize.min,
        children: [
          if(title!=null)Text(title!, style: TextStyle(fontSize: 10, color: Colors.grey.shade500),),
          Row(children: [
            if(date!=null)
            Text(monthFormat.format(date!),style: TextStyle(fontSize: 14))
            else Text("Date",style: TextStyle(fontSize: 14,color: Colors.grey.shade500)),
            if(date!=null)
            Text('${date?.day}',style: TextStyle(fontSize: 14),)
            else Text(''),
          ],)
        ],),);
/*
    return Container(
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(3)),
          border: Border.all(width: 1, color: Colors.grey)),
      padding: EdgeInsets.all(1),
      child:
      Column(mainAxisSize: MainAxisSize.min,
        children: [
        Text('${date?.day}',style: TextStyle(fontSize: 14),),
        Text(monthFormat.format(date!).toLowerCase(),style: TextStyle(fontSize: 10))
      ],),);
    */
  }
}
