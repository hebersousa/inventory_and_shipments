import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ias/shipments/models/prepcenter.dart';
import 'package:ias/shipments/providers/prepcenter_chips_provider.dart';
import 'package:ias/shipments/providers/prepcenter_list_provider.dart';
import 'package:provider/provider.dart';


class PrepcenterAutocompleteWidget extends StatefulWidget {
  @override
  _PrepcenterAutocompleteWidgetState createState() => _PrepcenterAutocompleteWidgetState();
}

class _PrepcenterAutocompleteWidgetState extends State<PrepcenterAutocompleteWidget> {

  final FocusNode _focusNode = FocusNode();
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  PrepcenterChipsProvider? _chipsProvider;

  int MAX_CHIPS = 1;

  @override
  void initState() {

    _chipsProvider = context.read<PrepcenterChipsProvider>();
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

  _insertOverlay() {
    var list =_chipsProvider?.list;
    if( list != null && list.length < MAX_CHIPS) {
      this._overlayEntry = this._createOverlayEntry();
      Overlay.of(context)?.insert(this._overlayEntry!);
    }
  }


  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    final valueProvider = Provider.of<PrepcenterListProvider>(context, listen: false);

    return  OverlayEntry(
        builder: (context) =>
        ChangeNotifierProvider<PrepcenterListProvider>.value(
          value: valueProvider,
          child:  Positioned(
            width: size.width,
            child: CompositedTransformFollower(
              link: this._layerLink,
              showWhenUnlinked: false,
              offset: Offset(0.0, size.height + 0.0),
              child: Material(
                  elevation: 4.0,
                  child:   _optionsListView()
              ),
            ),
          ) ,)

    );

  }

  _optionsListView() {
    return Consumer<PrepcenterListProvider>(
      builder: (context, provider, _) {
        return Container(
          height: 150,
          child: ListView.builder(
            itemCount: provider.prepcenterItems.length+1,
            itemBuilder: (context,index) {
              var itens = provider.prepcenterItems;
              if(index < itens.length)
                return _optionItem(itens[index], provider);

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

  _optionItem(Prepcenter e, PrepcenterListProvider provider){
    return ListTile(
      onTap: () {
        FocusScope.of(context).unfocus();
        provider.editingController.text="";
        _chipsProvider?.add(e);
      },
      key: ObjectKey(e),
      title: Text(e.name!),
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

    return  Consumer<PrepcenterListProvider>(builder: (context, provider, _) {
      // provider.editingController.text = '\u200B';
      return Container(
          decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.black12,width: 2))
          ),
          child: Row(children: [
            Text("Prepcenter: ", style: TextStyle(color:Colors.grey.shade600 ),),
            _chipsStreaming(),
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

  _chip(Prepcenter item) {
    return InputChip(
      label: Text(item.name!),
      onDeleted: () {
        FocusScope.of(context).unfocus();
        _chipsProvider?.remove(item);
      },
    );
  }


  _chipsStreaming(){
    return StreamBuilder<List<Prepcenter>>(
      initialData:[],
      stream: _chipsProvider?.stream ,
      builder: (context, snapshot) {

        List<Prepcenter> items =[];
        if(snapshot.hasData){
          items = snapshot.data!;
        }
        return Row(children: items.map((e) => _chip(e))
            .toList().cast<InputChip>());
      },);
  }
}
