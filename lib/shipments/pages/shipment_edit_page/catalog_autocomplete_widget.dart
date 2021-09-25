import 'package:chips_input/chips_input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ias/catalog/models/catalog_item.dart';
import 'package:ias/catalog/providers/catalog_provider.dart';
import 'package:provider/provider.dart';




class CatalogAutocompleteWidget extends StatefulWidget {
  @override
  _CatalogAutocompleteWidgetState createState() => _CatalogAutocompleteWidgetState();
}

class _CatalogAutocompleteWidgetState extends State<CatalogAutocompleteWidget> {

  final FocusNode _focusNode = FocusNode();
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  var _chips = <CatalogItem>[];
  int MAX_CHIPS = 1;

  @override
  void initState() {
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {

        _insertOverlay();

      } else {
        _removeOverlay();
      }
    });
  }

  _removeOverlay() {
    if(_overlayEntry!= null && _overlayEntry!.mounted)
    this._overlayEntry?.remove();

  }

  _insertOverlay(){
    if(_chips.length < MAX_CHIPS){
        this._overlayEntry = this._createOverlayEntry();
        Overlay.of(context)?.insert(this._overlayEntry!);
    }
  }


  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    final valueProvider = Provider.of<CatalogProvider>(context, listen: false);

    return  OverlayEntry(
        builder: (context) =>
        ChangeNotifierProvider<CatalogProvider>.value(
          value: valueProvider,
          child:  Positioned(
                  width: size.width,
                  child: CompositedTransformFollower(
                    link: this._layerLink,
                    showWhenUnlinked: false,
                    offset: Offset(0.0, size.height + 5.0),
                    child: Material(
                        elevation: 4.0,
                        child:   _optionsListView()
                    ),
                  ),
                ) ,)

    );

  }

  _optionsListView() {
    return Consumer<CatalogProvider>(
        builder: (context, provider, _) {
          return Container(
            height: 200,
            child: ListView.builder(
              itemCount: provider.catalogItems.length+1,
              itemBuilder: (context,index) {
                var itens = provider.catalogItems;
                if(index < itens.length)
                  return _createOptionItem(itens[index], provider);

                if(index == itens.length)
                  if(provider.hasNext) {
                    provider.fetchNext();
                    return _loadingWidget();
                  }
                return Container();
              },
            ),
          );
        },
    );
  }

  _createOptionItem(CatalogItem e, CatalogProvider provider){
    return ListTile(
          onTap: () {
            FocusScope.of(context).unfocus();
            provider.editingController.text="";
            setState(() {
              _chips.add(e);
            });

            },
          key: ObjectKey(e),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(e.urlImage!),
          ),
          title: Text(e.title!),
          subtitle:Text(e.asin!),
    );
  }
  _loadingWidget() {
    return Center(
      child: Container(
        height: 25,
        width: 25,
        child: CircularProgressIndicator(),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
            link: this._layerLink,
            child: _catalogField()
          );
  }


  _catalogField(){

    return  Consumer<CatalogProvider>(builder: (context, provider, _) {
     // provider.editingController.text = '\u200B';
      return Container(
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.black12,width: 2))
        ),
        child: Row(children: [
          Text("Item: ", style: TextStyle(color:Colors.grey.shade600 ),),
          ..._chips.map((e) => _chip(e)).toList(),
          Flexible(
            child: TextFormField(
              controller: provider.editingController,
              focusNode: this._focusNode,
              decoration: InputDecoration(
                  border: InputBorder.none,
                //counterText: ""
              ),
            ),
          ),
        ],)
      );
    });
  }

  _chip(CatalogItem item){
    return InputChip(
        label: Text(item.shortTitle!),

        onDeleted: ()=> setState(() {
          FocusScope.of(context).unfocus();
          _chips.remove(item);
        }),
    );
  }
}
