
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class Utils {

  static generateKeybyArray(List<String>? array) {
    var ar = array!;
    List<dynamic> arrayFinal = [];
    for (var i = 0; i < ar.length; i++) {
        var subList = ar.sublist(i, ar.length);
        var generated = generateKeybyString(subList.join(" ").toString());
        arrayFinal.addAll(generated);
    }
    return arrayFinal;
  }

  static generateKeybyString(String name) {
    if (name.length > 1)
      return [ name,
        ...?generateKeybyString(name.substring(0, name.length - 1).toLowerCase())
      ];
    else
      return [];
  }

  static formatToDate(DateTime date){
    final DateFormat format = DateFormat('yyyy-MM-dd');
    return format.format(date);
  }


  static Widget refreshListView({
    required int? itemCount,
    required Function? onRefresh,
    required Function(BuildContext context, int index) builder,
    //bool isSeperated = true,
    ScrollController? scrollController,
  }){

    CupertinoSliverRefreshControl _refreshControl;
    _refreshControl = CupertinoSliverRefreshControl(onRefresh: ()=> onRefresh!(),
        builder: Utils.buildSimpleRefreshIndicator);

    return CustomScrollView(
        physics: BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()
        ),
        shrinkWrap: false,
        controller: scrollController ?? ScrollController(),
        slivers: <Widget>[
          _refreshControl,
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                return Center(
                  child: builder(context, index)
                );
              },
              childCount: itemCount,

            ),
          ),
         // SliverSafeArea(sliver: child! )
        ]
    );
  }


  static  Widget buildSimpleRefreshIndicator(BuildContext context, RefreshIndicatorMode refreshState, double pulledExtent, double refreshTriggerPullDistance, double refreshIndicatorExtent,) {
    const Curve opacityCurve = const Interval(0.4, 0.8, curve: Curves.easeInOut);
    return new Align(
      alignment: Alignment.bottomCenter,
      child: new Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: refreshState == RefreshIndicatorMode.drag ? new Opacity(
          opacity: opacityCurve.transform(
              min(pulledExtent / refreshTriggerPullDistance, 1.0)),
          child: const Icon(
            CupertinoIcons.down_arrow,
            color: CupertinoColors.inactiveGray,
            size: 17.0,
          ),
        )
            : new Opacity(
          opacity: opacityCurve
              .transform(min(pulledExtent / refreshIndicatorExtent, 1.0)),
          child: const CupertinoActivityIndicator(radius: 12.0),
        ),
      ),
    );
  }


  static showAlertDialog(BuildContext context, String message, {bool yesNo = false}) {

    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () => Navigator.pop(context, true),
    );

    Widget yesButton = TextButton(
      child: Text("YES"),
      onPressed: () => Navigator.pop(context, true),
    );

    Widget noButton = TextButton(
      child: Text("NO"),
      onPressed: () => Navigator.pop(context, false),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(message),
      content: SizedBox.shrink(),
      actions: [
        if(!yesNo) okButton,
        if(yesNo) yesButton,
        if(yesNo) noButton,
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
