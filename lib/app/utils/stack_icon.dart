import 'package:flutter/material.dart';

class StakedIcons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Stack(
      alignment: Alignment.center,
      children: <Widget>[
        new Container(
          margin: EdgeInsets.only(bottom: 30.0),
          height: 60.0,
          width: 60.0,
          decoration: new BoxDecoration(
              borderRadius: new BorderRadius.circular(50.0),
              color: Colors.green),
          child: new Icon(
            Icons.local_offer,
            color: Colors.white,
          ),
        ),
        new Container(
          margin: new EdgeInsets.only(right: 60.0, top: 20.0),
          height: 60.0,
          width: 60.0,
          decoration: new BoxDecoration(
              borderRadius: new BorderRadius.circular(50.0),
              color: Color(0xFFFC6A7F)),
          child: new Icon(
            Icons.home,
            color: Colors.white,
          ),
        ),
        new Container(
          margin: new EdgeInsets.only(left: 10.0, top: 70.0),
          height: 60.0,
          width: 60.0,
          decoration: new BoxDecoration(
              borderRadius: new BorderRadius.circular(50.0),
              color: Color(0xFFFFCE56)),
          child: new Icon(
            Icons.airline_seat_recline_extra,
            color: Colors.white,
          ),
        ),
        new Container(
          margin: new EdgeInsets.only(left: 70.0, top: 20.0),
          height: 60.0,
          width: 60.0,
          decoration: new BoxDecoration(
              borderRadius: new BorderRadius.circular(50.0),
              color: Color(0xFF45E0EC)),
          child: new Icon(
            Icons.shopping_cart,
            color: Colors.white,
          ),
        )
      ],
    );
  }
}
