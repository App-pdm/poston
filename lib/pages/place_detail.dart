import 'dart:async';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:poston/models/fuel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const kGoogleApiKey = "AIzaSyBuTlwdWzZXm140ULb3DhocI9znsll8sog";
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class PlaceDetailWidget extends StatefulWidget {
  String placeId;

  PlaceDetailWidget(String placeId) {
    this.placeId = placeId;
  }

  @override
  State<StatefulWidget> createState() {
    return PlaceDetailState();
  }
}

class PlaceDetailState extends State<PlaceDetailWidget> {
  GoogleMapController mapController;
  PlacesDetailsResponse place;
  bool isLoading = false;
  String errorLoading;
  Set<Marker> markers = {};
  Completer<GoogleMapController> _controller = Completer();
  DocumentSnapshot document;

  BitmapDescriptor sourceIcon;
  BitmapDescriptor destinationIcon;

  @override
  void initState() {
    setSourceAndDestinationIcons();
    fetchPlaceDetail();
    super.initState();
  }

  getDocuments() async {
    final QuerySnapshot searchedByPlaceId = await Firestore.instance
        .collection('combustiveis')
        .where('placeId', isEqualTo: widget.placeId)
        .limit(1)
        .getDocuments()
        .then((value) {
      setState(() {
        document = value.documents.first;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget bodyChild;
    String title;
    if (isLoading) {
      title = "Loading";
      bodyChild = Center(
        child: CircularProgressIndicator(
          value: null,
        ),
      );
    } else if (errorLoading != null) {
      title = "";
      bodyChild = Center(
        child: Text(errorLoading),
      );
    } else {
      final placeDetail = place.result;
      final location = place.result.geometry.location;
      final lat = location.lat;
      final lng = location.lng;
      final center = LatLng(lat, lng);

      title = placeDetail.name;
      bodyChild = Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
              child: SizedBox(
            height: 200.0,
            child: GoogleMap(
              markers: markers,
              onMapCreated: _onMapCreated,
              myLocationEnabled: true,
              initialCameraPosition: CameraPosition(target: center, zoom: 15.0),
            ),
          )),
          Row(
            children: [
              Expanded(
                child: buildPlaceDetailList(placeDetail),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Flexible(
            child: Row(children: [
              Padding(
                padding: EdgeInsets.only(left: 20),
              ),
              Expanded(child: buildFuelList())
            ]),
          )
        ],
      );
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple[900],
          title: Container(
            alignment: Alignment.centerLeft,
            child: Text(title,
                style: TextStyle(
                  color: Colors.white,
                )),
          ),
        ),
        body: bodyChild);
  }

  void setSourceAndDestinationIcons() async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/img/driving_pin.png');
    destinationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5, size: Size(20, 20)),
        'assets/img/noun_gas_station_pin.png');
  }

  void fetchPlaceDetail() async {
    setState(() {
      this.isLoading = true;
      this.errorLoading = null;
    });

    PlacesDetailsResponse place =
        await _places.getDetailsByPlaceId(widget.placeId);

    await getDocuments();

    if (mounted) {
      setState(() {
        this.isLoading = false;
        if (place.status == "OK") {
          this.place = place;
        } else {
          this.errorLoading = place.errorMessage;
        }
      });
    }
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    final placeDetail = await place.result;
    final location = place.result.geometry.location;
    final lat = location.lat;
    final lng = location.lng;
    final center = LatLng(lat, lng);
    Marker marker = Marker(
        position: center,
        icon: destinationIcon,
        infoWindow: InfoWindow(
            title: "${placeDetail.name}",
            snippet: "${placeDetail.formattedAddress}"));
    markers.add(marker);
  }

  String buildPhotoURL(String photoReference) {
    return "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=${photoReference}&key=${kGoogleApiKey}";
  }

  ListView buildFuelList() {
    List<Widget> list = [];
    bool price = false;
    document.data.entries.forEach((element) {
      if (element.key != null &&
          element.value != null &&
          element.key != "placeId") {
        if (price == false) {
          list.add(Row(
            children: [SizedBox(height: 30), Text("Preços: ")],
          ));
          price = true;
        }
        list.add(Row(
          children: [
            findIcons("${element.key.toString()}"),
            Text("${element.key.toString()} = R\$ ${element.value.toString()}"),
          ],
        ));
      }
    });

    return ListView(
      shrinkWrap: true,
      children: list,
    );
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

  ListView buildPlaceDetailList(PlaceDetails placeDetail) {
    List<Widget> list = [];
    if (placeDetail.photos != null) {
      final photos = placeDetail.photos;
      list.add(SizedBox(
          height: 100.0,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: photos.length,
              itemBuilder: (context, index) {
                return Padding(
                    padding: EdgeInsets.only(right: 1.0),
                    child: SizedBox(
                      height: 100,
                      child: Image.network(
                          buildPhotoURL(photos[index].photoReference)),
                    ));
              })));
    }

    list.add(Padding(
      padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 8.0, bottom: 4.0),
      child: Row(children: [
        Icon(FontAwesomeIcons.gasPump, color: Colors.green),
        SizedBox(
          width: 10,
        ),
        Text(
          placeDetail.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ]),
    ));

    if (placeDetail.formattedAddress != null) {
      list.add(
        Padding(
            padding:
                EdgeInsets.only(top: 4.0, left: 55.0, right: 8.0, bottom: 4.0),
            child: Flexible(
                child: Row(children: [
              Flexible(
                child: Text(
                  placeDetail.formattedAddress,
                  style: Theme.of(context).textTheme.caption,
                ),
              )
            ]))),
      );
    }

    list.add(Flexible(
      child: Row(children: [
        SizedBox(width: 55),
        Icon(Icons.star, color: Colors.amber, size: 16),
        Icon(Icons.star, color: Colors.amber, size: 16),
        Icon(Icons.star, color: Colors.amber, size: 16),
        Icon(Icons.star, color: Colors.amber, size: 16),
        Icon(Icons.star_border, color: Colors.grey, size: 16),
      ]),
    ));

    if (placeDetail.formattedPhoneNumber != null) {
      list.add(Padding(
          padding:
              EdgeInsets.only(top: 4.0, left: 20.0, right: 8.0, bottom: 4.0),
          child: Row(children: [
            Icon(FontAwesomeIcons.phone, color: Colors.blue),
            SizedBox(
              width: 10,
            ),
            Text(
              "Telefone: ${placeDetail.formattedPhoneNumber}",
              style: Theme.of(context).textTheme.button,
            )
          ])));
    }

    if (placeDetail.openingHours != null) {
      final openingHour = placeDetail.openingHours;
      var text = '';
      if (openingHour.openNow) {
        text = 'Opening Now';
      } else {
        text = 'Closed';
      }
      list.add(
        Padding(
            padding:
                EdgeInsets.only(top: 0.0, left: 8.0, right: 8.0, bottom: 4.0),
            child: Text(
              text,
              style: Theme.of(context).textTheme.caption,
            )),
      );
    }

    if (placeDetail.website != null) {
      list.add(
        Padding(
            padding:
                EdgeInsets.only(top: 0.0, left: 8.0, right: 8.0, bottom: 4.0),
            child: Text(
              placeDetail.website,
              style: Theme.of(context).textTheme.caption,
            )),
      );
    }

    return ListView(
      shrinkWrap: true,
      children: list,
    );
  }
}
