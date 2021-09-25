import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateView extends StatelessWidget {
  DateTime? date = DateTime.now();
  DateView({required this.date});
  @override
  Widget build(BuildContext context) {
    final DateFormat monthFormat = DateFormat('MMM');

    return Container(child:
      Column(children: [
        Text('${date?.day}'),
        Text(monthFormat.format(date!).toLowerCase())
      ],),);
  }
}
