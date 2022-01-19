import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ias/catalog/models/catalog_item.dart';
import 'package:ias/catalog/pages/catalog_edit_page.dart';
import 'package:ias/catalog/providers/catalog_list_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';


class CatalogListViewWidget extends StatefulWidget {

  @override
  _CatalogListViewWidgetState createState() => _CatalogListViewWidgetState();
}

class _CatalogListViewWidgetState extends State<CatalogListViewWidget> {
 // final scrollController = ScrollController();
 //  CatalogProvider? catalogProvider;

  @override
  void initState() {
    super.initState();

   // scrollController.addListener(scrollListener);
   // catalogProvider?.fetchNextUsers();
  }

  @override
  void dispose() {
    //scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Consumer<CatalogListProvider>(
    builder: (context, provider, _) {

      return ListView.builder(
        //controller: scrollController,
        itemCount: provider.catalogItems.length+1,
        itemBuilder: (context,index){
         // print("index $index");
          var itens = provider.catalogItems;
          if(index < itens.length)
            return _createItem2(itens[index], provider);

          if(index == itens.length)
            if(provider.hasNext) {
                provider.fetchNext();
                return _progressIndicator();
            }
          return Container();
        },
      );
    },
  );

  _createItem2(CatalogItem item, CatalogListProvider provider) {
    return ListTile(
        leading:  SizedBox(child: Image.network(item.urlImage!,
          errorBuilder: (context,obj,stack)=>SizedBox.shrink(),),width: 60,),
        title: Text(item.title!,overflow: TextOverflow.ellipsis,maxLines: 3,  ),
        subtitle:  FittedBox(child: SelectableText(item.asin!,),
          fit: BoxFit.scaleDown,alignment: Alignment.centerLeft,),
        onTap: ()=>  _goToNew2(provider,item.key),
      trailing: _trailingWidget(item,provider)

    );
  }

  _trailingWidget(CatalogItem item, CatalogListProvider provider) {
    int count = item.count ?? 0;
    var color = count > 0 ? Colors.grey : Colors.red.shade200;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("$count units ", style: TextStyle(color: color),),
        Text(" • ", style: TextStyle(color: color),),
        Text(" \$${item.unitCostAvg?.toStringAsFixed(2)}  " , style: TextStyle(color: color),),
        //Text("• ", style: TextStyle(color: color),),

       // CircleAvatar(child: Text("${item.count ?? 0}"),),
        if(item.urlResource!=null) _linkResource(item),
        SizedBox(width: 8,),
        _linkAmazon(item)
    ],);

  }

  _linkAmazon(CatalogItem item) {
    return GestureDetector(onTap: ()=>launch(item.urlAmazon),
          child: CircleAvatar(radius: 15,
              child: Text("Amz",
                  style: TextStyle(color: Colors.orange.shade700,
                      fontWeight: FontWeight.bold,
                      fontSize: 10) ),
              backgroundColor:Colors.black87 ,
          ),
    );
  }

  _linkResource(CatalogItem item) {
    return GestureDetector(onTap: ()=>launch(item.urlResource.toString()),
      child: CircleAvatar(radius: 15,
        child: Icon(Icons.link, color: Colors.white,),
        backgroundColor:Colors.grey ,
      ),
    );
  }


  _goToNew2(CatalogListProvider provider,[var id] ) {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider<CatalogListProvider>
              .value(value:  provider,
            child: CatalogEditPage(id: id) ,)
      ),
    );
  }


  _progressIndicator() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: CupertinoActivityIndicator(),
    );
  }


}
