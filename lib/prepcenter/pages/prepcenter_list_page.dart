import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ias/prepcenter/pages/prepcenter_view_page.dart';
import '../models/prepcenter.dart';
import 'package:ias/prepcenter/providers/prepcenter_list_provider.dart';

class PrepcenterListPage extends StatefulWidget {
  @override
  _PrepcenterListPageState createState() => _PrepcenterListPageState();
}

class _PrepcenterListPageState extends State<PrepcenterListPage> {
  var provider = PrepcenterListProvider();

  @override
  Widget build(BuildContext context) {
    return _scafold(context);
  }

  _scafold(BuildContext context) {
    return Scaffold(
        appBar: _createAppBar(context),
        body: _list()

    );
  }

  _createAppBar(BuildContext context) {
    var title = Text('Prepcenter List', style: TextStyle(color: Colors.white),);

    var menuButton = IconButton(
      color: Colors.white,
      icon: Icon(Icons.menu),
      onPressed: () => Scaffold.of(context).openDrawer(),
    );

    return  AppBar(title: title,
      leading: menuButton,);
  }

  _list() {
    return FutureBuilder(
      future: provider.fetchNext(),
        builder: (context, snapshot){
          return ListView.builder(
            itemCount: provider.prepcenterItems.length+1,
            itemBuilder: (context,index) {
              var itens = provider.prepcenterItems;
              if(index < itens.length)
                return _optionItem(itens[index], provider);

              if(index == itens.length)
                if(provider.hasNext) {
                  provider.fetchNext();
                  return _progressIndicator();
                }
              return Container();
            },
          );

    });

  }

  _optionItem(Prepcenter e, PrepcenterListProvider provider){
    return ListTile(
      onTap: () => _goTo(e.key.toString()),
      key: ObjectKey(e),
      title: Text(e.name!),
      trailing: _balance(e),
    );
  }


  _goTo(String id) {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => PrepcenterViewPage(id)
      ),
    );
  }
  
  _balance(Prepcenter prep) {
    return Column(mainAxisSize: MainAxisSize.min,
    children: [
      Text("\$${prep.balance ?? 0.0}",
        style: TextStyle(color: Colors.grey),),
      Text("balance",
        style: TextStyle(color: Colors.grey, fontSize: 11),)
    ],);
  }

  _progressIndicator() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: CupertinoActivityIndicator(),
    );
  }
}
