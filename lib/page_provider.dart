import 'package:flutter/material.dart';
import 'package:ias/catalog/pages/catalog_list_page/catalog_list_page2.dart';

class PageProvider extends ChangeNotifier {
  Widget? page;

  PageProvider(){
    page = CatalogListPage2();
  }

  changePage(Widget page){
    this.page = page;
    notifyListeners();
  }

}