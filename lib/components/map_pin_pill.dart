import 'package:flutter/material.dart';
import 'package:poston/models/posto.dart';
import 'package:poston/pages/place_detail.dart';

class MapPinPillComponent extends StatefulWidget {

  PostoModel place;
  
  MapPinPillComponent({ this.place });



  @override
  State<StatefulWidget> createState() => MapPinPillComponentState();
}

class MapPinPillComponentState extends State<MapPinPillComponent> {

  @override
  Widget build(BuildContext context) {

    Future<Null> showDetailPlace(String placeId) async {
      if (placeId != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PlaceDetailWidget(placeId)),
        );
      }
    }

    if(widget.place != null){
      return Container(
        child: GestureDetector(
          onTap: () => showDetailPlace("${widget.place.placeId}"),
          child: AnimatedPositioned(
            bottom: 0,
            right: 0,
            left: 0,
            duration: Duration(milliseconds: 200),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.all(20),
                  height: 90,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    //borderRadius: BorderRadius.all(Radius.circular(50)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(blurRadius: 20, offset: Offset.zero, color: Colors.grey.withOpacity(0.5))
                    ]
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 50, height: 50,
                        margin: EdgeInsets.only(left: 10),
                        child: Image.network("${widget.place.icon}",width: 25, color: Colors.green),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("${widget.place.name.toString()}"),
                              Text("${widget.place.formattedAddress.toString()}", style: TextStyle(fontSize: 12, color: Colors.grey)),
                              Text("${widget.place.vicinity.toString()}", style: TextStyle(fontSize: 12, color: Colors.grey)),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(15),
                        child: Image.asset("", width: 50, height: 50),
                      )
                    ],
                  ),
                ),
              ),
            ),
        )
      );
    }
  }
}