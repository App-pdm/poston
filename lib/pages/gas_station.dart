import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const apiKey = "AIzaSyBuTlwdWzZXm140ULb3DhocI9znsll8sog";
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: apiKey);

class GasSationList extends StatefulWidget {
  @override
  GasStation createState() => GasStation();
}

class GasStation extends State<GasSationList> {
  bool isLoading = false;
  String errorLoading;
  String errorMessage;
  List<PlacesSearchResult> places = [];
  final Geolocator _geolocator = Geolocator();
  Position _currentPosition;
  List<DocumentSnapshot> documents;

  @override
  initState() {
    getDocuments();
    getNearbyPlaces();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget expandedChild;
    if (isLoading) {
      expandedChild = Center(child: CircularProgressIndicator(value: null));
    } else if (errorMessage != null) {
      expandedChild = Center(
        child: Text(errorMessage),
      );
    } else {
      expandedChild = buildPlacesList();
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple[900],
          title: Container(
            alignment: Alignment.centerLeft,
            child: Text("Lista de Postos",
                style: TextStyle(
                  color: Colors.white,
                )),
          ),
        ),
        body: Container(child: expandedChild));
  }

  getDocuments() async {
    final QuerySnapshot firestoreDocuments =
        await Firestore.instance.collection('combustiveis').getDocuments();

    setState(() {
      documents = firestoreDocuments.documents;
    });
  }

  findIcons(String fuel) {
    switch (fuel) {
      case 'Gasolina':
        return Container(
          margin: EdgeInsets.fromLTRB(0, 0, 8, 0),
          child: CircleAvatar(
            //minRadius: 1,
            maxRadius: 15,
            child: Text("G",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  height: 1,
                  fontWeight: FontWeight.w600,
                )),
            backgroundColor: Colors.black87,
          ),
        );
      case 'Alcool':
        return Container(
          margin: EdgeInsets.fromLTRB(0, 0, 8, 0),
          child: CircleAvatar(
            //minRadius: 1,
            maxRadius: 15,
            child: Text("A",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  height: 1,
                  fontWeight: FontWeight.w600,
                )),
            backgroundColor: Colors.blue[900],
          ),
        );
      case 'Diesel':
        return Container(
          margin: EdgeInsets.fromLTRB(0, 0, 8, 0),
          child: CircleAvatar(
            maxRadius: 15,
            child: Text("D",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  height: 1,
                  fontWeight: FontWeight.w600,
                )),
            backgroundColor: Colors.orange,
          ),
        );
      case 'Gasolina Aditivada':
        return Container(
          margin: EdgeInsets.fromLTRB(0, 0, 8, 0),
          child: CircleAvatar(
            //minRadius: 1,
            maxRadius: 15,
            child: Text("G+",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  height: 1,
                  fontWeight: FontWeight.w600,
                )),
            backgroundColor: Colors.red[900],
          ),
        );
      default:
        return Container(
          margin: EdgeInsets.fromLTRB(0, 0, 8, 0),
          child: CircleAvatar(
            //minRadius: 1,
            maxRadius: 10,
            child: Text("N",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  height: 1,
                  fontWeight: FontWeight.w600,
                )),
            backgroundColor: Colors.grey,
          ),
        );
    }
  }

  getNearbyPlaces() async {
    setState(() {
      this.isLoading = true;
      this.errorMessage = null;
    });

    await _geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      setState(() {
        _currentPosition = position;
      });
    });

    final location =
        Location(_currentPosition.latitude, _currentPosition.longitude);

    final result =
        await _places.searchByText('gas station', location: location);

    setState(() {
      this.isLoading = false;
      if (result.status == "OK") {
        this.places = result.results;
      }
    });
  }

  calculateDistance(LatLng origin, LatLng destination) async {
    double distanceInMeters = await Geolocator().distanceBetween(
      origin.latitude,
      origin.longitude,
      destination.latitude,
      destination.longitude,
    );

    var formatedDistance = distanceInMeters.toString();

    if (distanceInMeters > 1000) {
      var kilometragem = distanceInMeters / 1000;
      formatedDistance = kilometragem.toStringAsFixed(2) + "Km";
    } else {
      formatedDistance = distanceInMeters.toStringAsFixed(2) + " metros";
    }
    return formatedDistance;
  }

  ListView buildPlacesList() {
    final placesWidget = places.map((f) {
      List<Widget> list = [];
      List<Widget> listPadding = [
        Padding(
            padding: EdgeInsets.only(bottom: 4.0),
            child: Row(children: [
              Icon(FontAwesomeIcons.gasPump, color: Colors.green),
              SizedBox(width: 10),
              Flexible(
                child: Text(
                  f.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ]))
      ];

      if (f.formattedAddress != null) {
        listPadding.add(
          Flexible(
            child: Padding(
                padding: EdgeInsets.only(bottom: 2.0),
                child: Flexible(
                    child: Row(children: [
                  SizedBox(width: 35),
                  Flexible(
                    child: Text(
                      f.formattedAddress,
                      style: Theme.of(context).textTheme.caption,
                    ),
                  )
                ]))),
          ),
        );
      }

      listPadding.add(Flexible(
        child: Row(children: [
          SizedBox(width: 35),
          Icon(Icons.star, color: Colors.amber, size: 16),
          Icon(Icons.star, color: Colors.amber, size: 16),
          Icon(Icons.star, color: Colors.amber, size: 16),
          Icon(Icons.star, color: Colors.amber, size: 16),
          Icon(Icons.star_border, color: Colors.grey, size: 16),
        ]),
      ));

      documents.forEach((element) {
        if (element.data["placeId"] == f.placeId) {
          bool price = false;
          element.data.entries.forEach((item) {
            if (item.key != null &&
                item.value != null &&
                item.key != "placeId") {
              if (price == false) {
                listPadding.add(Row(
                  children: [SizedBox(height: 30), Text('Preços: ')],
                ));
                price = true;
              }
              listPadding.add(Row(children: [
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 2.0),
                    child: Row(
                      children: [
                        findIcons("${item.key}"),
                        SizedBox(width: 5),
                        Text("${item.key} = R\$ ${item.value}",
                            style: Theme.of(context).textTheme.subtitle2)
                      ],
                    ),
                  ),
                )
              ]));
            }
          });
        }
      });

      list.add(Wrap(
        children: <Widget>[
          Flexible(
              child: Container(
            padding: EdgeInsets.all(4.0),
            child: Row(children: [
              Flexible(
                child: Wrap(
                  children: listPadding,
                ),
              )
            ]),
          ))
        ],
      ));

      return Flexible(
          child: Padding(
              padding:
                  EdgeInsets.only(top: 4.0, bottom: 4.0, left: 8.0, right: 8.0),
              child: Flexible(
                child: Card(
                  child: Flexible(
                    child: InkWell(
                      onTap: () {},
                      highlightColor: Colors.lightBlueAccent,
                      splashColor: Colors.red,
                      child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Flexible(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: list,
                            ),
                          )),
                    ),
                  ),
                ),
              )));
    }).toList();

    return ListView(shrinkWrap: true, children: placesWidget);
  }
}
