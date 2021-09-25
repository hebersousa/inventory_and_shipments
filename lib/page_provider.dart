import 'package:flutter/material.dart';
import 'package:ias/catalog/pages/catalog_list_page/catalog_list_page2.dart';
import 'package:ias/shipments/pages/shipment_edit_page/shipment_edit_page.dart';
import 'package:ias/shipments/pages/shipment_list_page/shipment_list_page.dart';

class PageProvider extends ChangeNotifier {
  Widget? page;

  PageProvider(){
    page = ShipmentListPage();
  }

  changePage(Widget page){
    this.page = page;
    notifyListeners();
  }

}