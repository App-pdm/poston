import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    super.initState();
    getNearbyPlaces();
    getDocuments();
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
            alignment: Alignment.center,
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

  ListView buildPlacesList() {
    final placesWidget = places.map((f) {
      List<Widget> list = [];
      List<Widget> listPadding = [
        Padding(
          padding: EdgeInsets.only(bottom: 4.0),
          child: Text(
            f.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ];

      if (f.formattedAddress != null) {
        listPadding.add(
          Flexible(
            child: Padding(
                padding: EdgeInsets.only(bottom: 2.0),
                child: Flexible(
                  child: Text(
                    f.formattedAddress,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                )),
          ),
        );
      }

      if (f.vicinity != null) {
        listPadding.add(Flexible(
          child: Padding(
            padding: EdgeInsets.only(bottom: 2.0),
            child: Text(
              f.types.join(','),
              style: Theme.of(context).textTheme.caption,
            ),
          ),
        ));
      }

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
                    child: Text(
                      "${item.key} = R\$ ${item.value}",
                      style: Theme.of(context).textTheme.subtitle2,
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
              Image.network(f.icon, width: 25, color: Colors.green),
              SizedBox(width: 11),
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
