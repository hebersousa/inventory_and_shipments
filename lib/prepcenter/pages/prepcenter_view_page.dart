import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ias/prepcenter/api/prepcenter_api.dart';
import 'package:ias/prepcenter/models/prepcenter.dart';


typedef ChangeFuncrion  = void Function(dynamic newvalue);


class PrepcenterViewPage extends StatefulWidget {

  String prepKey;
  PrepcenterViewPage(this.prepKey);

  @override
  _PrepcenterViewPageState createState() => _PrepcenterViewPageState();
}

class _PrepcenterViewPageState extends State<PrepcenterViewPage> {
  @override
  Widget build(BuildContext context) {
    return _scafold(context);
  }


  _scafold(BuildContext context) {
    return Scaffold(
      appBar: _getAppBar(),
      body: _streamBody(),
    );
  }

  _getAppBar() {
    var title = Text("Prepcenter", style: TextStyle(color: Colors.white));
    var backBt = BackButton(onPressed: ()=>Navigator.pop(context),
      color: Colors.white,);
    return AppBar(title: title ,
      centerTitle: true,
      leading: backBt,
    );
  }

  _streamBody(){
    return StreamBuilder<Prepcenter>(
        stream: PrepcenterApi.getPrepcenterItemStream(widget.prepKey),
        builder: (context, shot){
          if(shot.hasData) {
            return _body(shot.data!);
          }
          return _loadingIcon();
        });
  }

  Widget _body(Prepcenter prep){
    return Padding(padding: EdgeInsets.all(15),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

          _component(prep,
              "name",
              prep.name ,
              confirmChange:  (newValue) {
                prep.name = newValue;
                _save(prep);
              }
          ),

        _label("address"),

        if(prep.address?.name != null )
          _component(prep,
              "Business Name",
              prep.address?.name ,
              confirmChange:  (newValue) {
                prep.address?.name = newValue;
                _save(prep);
              }
          ),
        if(prep.address?.line1 != null )
          _component(prep,
              "Line1",
              prep.address?.line1 ,
              confirmChange:  (newValue) {
                prep.address?.line1 = newValue;
                _save(prep);
              }
          ),
        Row(children: [
          if(prep.address?.city != null )
            _component(prep,
                "City",
                prep.address?.city ,
                confirmChange:  (newValue) {
                  prep.address?.city = newValue;
                  _save(prep);
                }
            ),

          Text("-"),
          if(prep.address?.state != null )
            _component(prep,
                "State",
                prep.address?.state ,
                confirmChange:  (newValue) {
                  prep.address?.state = newValue;
                  _save(prep);
                }
            ),

          if(prep.address?.zipCode != null )
            _component(prep,
                "Zipcode",
                prep.address?.zipCode ,
                confirmChange:  (newValue) {
                  prep.address?.zipCode = newValue;
                  _save(prep);
                }
            ),
        ],
        ),
        if(prep.priceUnit != null )
        _label("price unit"),
        if(prep.priceUnit != null )
          _component(prep,
              "Price Unit",
              prep.priceUnit ,
              confirmChange:  (newValue) {
                prep.priceUnit = newValue;
                _save(prep);
              }
          ),
        if(prep.pricePack != null )
        _label("price pack"),
        if(prep.pricePack != null )
          _component(prep,
              "Price Pack",
              prep.pricePack ,
              confirmChange:  (newValue) {
                prep.pricePack = newValue;
                _save(prep);
              }
          ),
        _label("balance"),
        if(prep.balance != null )
          _component(prep,
              "Balance",
              prep.balance ,
              confirmChange:  (newValue) {
                prep.balance = newValue;
                _save(prep);
              }
          ),
      ],)
    );
  }


 _label(String label) =>
     Padding(
       padding: const EdgeInsets.only(left: 10.0),
       child: Text(label,style: TextStyle(fontSize: 11,color: Colors.grey)),
     );


  _save(Prepcenter prep) {  PrepcenterApi.saveItem(prep); }

  Widget _component(Prepcenter prep,
      String label,
      dynamic value,
      { required Function(dynamic newvalue)? confirmChange }  ) {

    return GestureDetector(onTap: () async {
      var newValue = await _showFieldDialog(label, value.toString());

      if(newValue != null ) {
        print(value.runtimeType);
        if(value.runtimeType == double ) {
            double?  valueConverted = double.tryParse(newValue);
            print(valueConverted.runtimeType);
            confirmChange!(valueConverted);
        }
        else
          confirmChange!(newValue.toString());
      }


      },
      child:  Padding(padding: EdgeInsets.all(10),
      child: Text( (value.runtimeType != String ? "\$ " : "" )+ value.toString(),
          style: TextStyle(
              decoration: TextDecoration.underline,
              decorationStyle: TextDecorationStyle.dashed,
          ),),
      ),
    );

  }


  _loadingIcon()=> Container(
    margin: EdgeInsets.all(15),
    height: 10,width: 20,
    // child: CircularProgressIndicator(color: Colors.white,)
    child: CupertinoActivityIndicator(),
  );


 Future<dynamic>  _showFieldDialog(String label, dynamic value) {

     var editingController = TextEditingController(text: value.toString());

    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () => Navigator.pop(context, editingController.text),
    );

    AlertDialog alert = AlertDialog(
      title: Text(label),
      content: TextField(
        keyboardType: value.runtimeType == String ? TextInputType.text
            : TextInputType.number,
        controller: editingController,
      ),
      actions: [
           okButton,
      ],
    );

    // show the dialog
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

}
