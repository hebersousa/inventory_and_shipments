import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ias/catalog/models/catalog_item.dart';
import 'package:ias/catalog/pages/catalog_edit_page.dart';
import 'package:ias/catalog/providers/catalog_provider.dart';
import 'package:provider/provider.dart';


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


  void scrollListener() {

/*
    if (scrollController.offset ==
        scrollController.position.maxScrollExtent  ) {
      if (widget.catalogProvider.hasNext
      ) {
        widget.catalogProvider.fetchNextUsers();
      }

    }
    */
  }

/*
  @override
  Widget build2(BuildContext context) {
    
    widget.catalogProvider = Provider.of<CatalogProvider>(context)!;
    return ListView(
        controller: scrollController,
        padding: EdgeInsets.all(12),
        children: [
          ...widget.catalogProvider!.catalogItems
              .map((item) => _createItem(item))
              .toList(),
          if (widget.catalogProvider!.hasNext )
            Center(
              child: GestureDetector(
                onTap: widget.catalogProvider!.fetchNextUsers,
                child: _circularWidget(),
              ),
            ),
        ],
      );
}
*/
  @override
  Widget build(BuildContext context) => Consumer<CatalogProvider>(
    builder: (context, provider, _){

      return ListView.builder(
        //controller: scrollController,
        itemCount: provider.catalogItems.length+1,
        itemBuilder: (context,index){
          print("index $index");
          var itens = provider.catalogItems;
          if(index < itens.length)
            return _createItem2(itens[index], provider);

          if(index == itens.length)
            if(provider.hasNext) {
              provider.fetchNextUsers();
              return _circularWidget();
            }

          return Container();

        },
      );
    },
  );

  _createItem(CatalogItem item){
      return ListTile(contentPadding: EdgeInsets.all(50),
        title: Text(item.title!),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(item.urlImage!),
        ),
      );
  }

  _createItem2(CatalogItem item, CatalogProvider provider) {
    return ListTile(
        leading:  SizedBox(child: Image.network(item.urlImage!,
          errorBuilder: (context,obj,stack)=>SizedBox.shrink(),),width: 60,),
        title: Text(item.title!,  ),
        subtitle:  FittedBox(child: SelectableText(item.asin!,),
          fit: BoxFit.scaleDown,alignment: Alignment.centerLeft,),
        onTap: ()=>  _goToNew2(provider,item.key)

    );


  }



  _goToNew([var id]) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CatalogEditPage(id: id),
      ),
    );
  }

  _goToNew2(CatalogProvider provider,[var id] ) {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider<CatalogProvider>
              .value(value:  provider,
            child: CatalogEditPage(id: id) ,)
      ),
    );

  }

  _circularWidget() {

    return Center(
      child: Container(
        height: 25,
        width: 25,
        child: CircularProgressIndicator(),
      ),
    );
  }

}
