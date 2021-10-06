import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TrackChipsWidget extends StatefulWidget {
  BehaviorSubject<List<String>> streamController;
  final textFieldController = TextEditingController();
  TrackChipsWidget({required this.streamController});

  @override
  _TrackChipsWidgetState createState() => _TrackChipsWidgetState();
}

class _TrackChipsWidgetState extends State<TrackChipsWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _formField(widget.textFieldController, "Url Track",()=> _addNewTrack()),
        _trackChipsWidget()
      ],
    );
  }

  _addNewTrack() {
    FocusScope.of(context).unfocus();
    var value = widget.textFieldController.text;
    var uri = Uri.tryParse(value);

    if(uri!=null  &&  uri.isAbsolute ) {
      var urls = widget.streamController.value;
      urls.add(value);
      widget.streamController.add(urls);
      widget.textFieldController.text="";
    } else {
      Fluttertoast.showToast(msg: "URL Invalid",
          webPosition:"center",
          gravity: ToastGravity.TOP,
          webBgColor: "#686868"
      );
          //ScaffoldMessenger.of(context).showSnackBar(
          //SnackBar(content: Text("URL Invalid")));
    }
  }


  _trackChipsWidget() {
    return StreamBuilder<List<String>>(
      initialData: [],
      stream: widget.streamController.stream,
      builder: (context,snapshot) {
        if(snapshot.hasData && snapshot.data != null) {
          var data = snapshot.data!;
          return Wrap(

              children:
          data.map((e) => _chip(e)).toList().cast<InputChip>()
          );
        }
        return Container();
      },
    );
  }


  _chip(String title) {
    return InputChip(
        label: Text(title),
        onDeleted: (){
          FocusScope.of(context).unfocus();
          var list = widget.streamController.value;
          list.remove(title);
          widget.streamController.add(list);
        }
    );
  }


  _formField( TextEditingController textEditingController, String hintText, [Function? onTap]) {
    var decorator = InputDecoration(
      suffix: onTap!=null ? OutlinedButton(onPressed: ()=>onTap(), child: Text("Add")) : null,
      labelText: hintText,
      errorBorder: UnderlineInputBorder(
        borderRadius: BorderRadius.circular(6.0),
        borderSide: BorderSide(
          color: Colors.red,
        ),
      ),
    );

    return TextFormField(
      controller: textEditingController,
      decoration: decorator,);

  }
}
