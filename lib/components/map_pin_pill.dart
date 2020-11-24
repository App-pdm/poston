import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:poston/models/posto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:poston/pages/place_detail.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';

class MapPinPillComponent extends StatefulWidget {
  PostoModel place;

  MapPinPillComponent({this.place});

  @override
  State<StatefulWidget> createState() => MapPinPillComponentState();
}

class MapPinPillComponentState extends State<MapPinPillComponent> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.place != null) {
      return Container(
          child: GestureDetector(
        onTap: () {},
        child: AnimatedPositioned(
          bottom: 0,
          right: 0,
          left: 0,
          duration: Duration(milliseconds: 200),
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: EdgeInsets.all(20),
              height: 90,
              decoration: BoxDecoration(color: Colors.white,
                  //borderRadius: BorderRadius.all(Radius.circular(50)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        blurRadius: 20,
                        offset: Offset.zero,
                        color: Colors.grey.withOpacity(0.5))
                  ]),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      width: 50,
                      height: 50,
                      margin: EdgeInsets.only(left: 10),
                      child: Center(
                        child: Icon(FontAwesomeIcons.gasPump,
                            size: 40, color: Colors.green),
                      )),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("${widget.place.name.toString()}"),
                          Text("${widget.place.formattedAddress.toString()}",
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey)),
                          Text("Distância: ${widget.place.distance}",
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey)),
                          Text("${widget.place.vicinity.toString()}",
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ));
    }
  }
}
