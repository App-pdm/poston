import 'dart:async';
import 'package:google_maps_webservice/places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:poston/requests/map_request.dart';
import 'package:poston/components/map_pin_pill.dart';
import 'package:poston/models/posto.dart';
import 'package:poston/components/translator.dart';
import 'dart:math' show cos, sqrt, asin;

const apiKey = "AIzaSyBuTlwdWzZXm140ULb3DhocI9znsll8sog";
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: apiKey);

class Map extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MapLocation();
  }
}

class MapLocation extends State<Map> {
  Completer<GoogleMapController> _controller = Completer();
  final homeScaffoldKey = GlobalKey<ScaffoldState>();
  GoogleMapController mapController;
  final Geolocator _geolocator = Geolocator();
  List<PlacesSearchResult> places = [];
  bool isLoading = false;
  String errorMessage;
  Set<Marker> markers = {};
  final Set<Polyline> _polyLines = {};
  Set<Polyline> get polyLines => _polyLines;
  static LatLng latLng;
  GoogleMapsServices _googleMapsServices = GoogleMapsServices();
  Translator tradutor = new Translator();
  String _textImage;

  PostoModel selectedPlaceDestination = new PostoModel();
  Widget mapPinInformation;

  Position _currentPosition;
  Position _destPosition;
  List<Widget> listagem = new List<Widget>();
  //for my custom icons
  BitmapDescriptor sourceIcon;
  BitmapDescriptor destinationIcon;

  @override
  void initState() {
    super.initState();
    setSourceAndDestinationIcons();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: homeScaffoldKey,
      appBar: AppBar(
        title: const Text("Pra onde vamos?"),
        backgroundColor: Colors.black,
        actions: <Widget>[
          isLoading
              ? IconButton(
                  icon: Icon(Icons.timer),
                  onPressed: () {},
                )
              : IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () {
                    refresh();
                  },
                ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              //_handlePressButton();
            },
          ),
        ],
      ),
      body: Center(
        child: Container(
          child: Stack(children: [
            GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              polylines: polyLines,
              markers: markers,
              scrollGesturesEnabled: true,
              zoomGesturesEnabled: true,
              indoorViewEnabled: false,
              trafficEnabled: false,
              mapToolbarEnabled: true,
              mapType: MapType.normal,
              zoomControlsEnabled: true,
              myLocationEnabled: true,
              initialCameraPosition: CameraPosition(
                target: LatLng(40.712776, -74.005974),
                bearing: 30,
                tilt: 0,
              ),
            ),
            selectedPlaceDestination.placeId != null
                ? MapPinPillComponent(place: selectedPlaceDestination)
                : Container()
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: getFuelPrice,
          backgroundColor: Colors.black,
          child: IconButton(
              icon: Icon(
                Icons.local_gas_station,
                color: Colors.white,
              ),
              onPressed: () => getFuelPrice())),
    );
  }

  showAlertDialog(BuildContext context, String title, String message) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Iterable<String> _allStringMatches(String text, RegExp regExp) =>
      regExp.allMatches(text).map((m) => m.group(0));

  void getFuelPrice() async {
    // Alerta caso não tiver nenhum local selecionado
    if (selectedPlaceDestination.placeId == null ||
        selectedPlaceDestination.placeId == '') {
      String alertTitle = "Alerta";
      String alertMessage = "Selecione o marcador do posto que você abasteceu";
      showAlertDialog(context, alertTitle, alertMessage);
    } else {
      setState(() async {
        // Capturar texto da foto através da API
        _textImage = await tradutor.translateTextImage();
        final regex = RegExp('[+-]?([0-9]*[.])?[0-9]+', multiLine: true);

        // Filtrando preços através da RegExp
        Iterable<String> matches = _allStringMatches(_textImage, regex);
        List<double> prices = [];

        print(matches);

        // Formatando números com 3 casas decimais
        matches.forEach((item) {
          double n = double.parse(item);
          n.toStringAsFixed(3);
        });

        // Convertendo para uma lista de números decimais
        matches.map((e) => prices.add(double.parse(e)));
        print(prices);

        showAlertDialog(context, "Alerta", _textImage);
      });
    }
  }

  List<LatLng> _convertToLatLng(List points) {
    List<LatLng> result = <LatLng>[];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    return result;
  }

  List _decodePoly(String poly) {
    var list = poly.codeUnits;
    var lList = new List();
    int index = 0;
    int len = poly.length;
    int c = 0;
    do {
      var shift = 0;
      int result = 0;

      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);
      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);

    for (var i = 2; i < lList.length; i++) lList[i] += lList[i - 2];

    print(lList.toString());

    return lList;
  }

  void createRoute(String encondedPoly) {
    setState(() {
      _polyLines.add(Polyline(
          polylineId: PolylineId(latLng.toString()),
          width: 6,
          points: _convertToLatLng(_decodePoly(encondedPoly)),
          color: Colors.black));
    });
  }

  void showConfirmationDialog(
      BuildContext context, LatLng origin, PlacesSearchResult place) {
    // Set Pin Place Selected
    setState(() {
      selectedPlaceDestination.placeId = place.placeId;
      selectedPlaceDestination.name = place.name.toString();
      selectedPlaceDestination.icon = place.icon;
      selectedPlaceDestination.formattedAddress = place.formattedAddress;
      selectedPlaceDestination.vicinity =
          place.vicinity != null ? place.types.join(',') : '';
    });

    // set up the buttons
    Widget cancelButton = FlatButton(
        child: Text("Cancelar"),
        onPressed: () {
          Navigator.of(context).pop();
        });
    Widget continueButton = FlatButton(
        child: Text("Continuar"),
        onPressed: () async {
          String route = await _googleMapsServices.getRouteCoordinates(origin,
              LatLng(place.geometry.location.lat, place.geometry.location.lng));
          _polyLines.clear();
          createRoute(route);
          Navigator.of(context).pop();
        });
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alerta"),
      content: Text("Deseja exibir a rota até o destino selecionado?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void setSourceAndDestinationIcons() async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/img/driving_pin.png');
    destinationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5, size: Size(20, 20)),
        'assets/img/noun_gas_station_pin.png');
  }

  void refresh() async {
    final center =
        LatLng(_currentPosition.latitude, _currentPosition.longitude);
    //await _getCurrentLocation(); //LatLng(-20.8128082, -49.3808274)
    final GoogleMapController controller = await _controller.future;

    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: center == null ? LatLng(0, 0) : center, zoom: 15.0)));
    await getNearbyPlaces(center);
  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
        Marker(markerId: markerId, icon: descriptor, position: position);
    markers.add(marker);
  }

  // Method for retrieving the current location
  _getCurrentLocation() async {
    final GoogleMapController controller = await _controller.future;
    await _geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      setState(() {
        // Store the position in the variable
        _currentPosition = position;

        // For moving the camera to current location
        controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude,
                  position.longitude), //LatLng(-20.8128082, -49.3808274)
              zoom: 15.0,
            ),
          ),
        );
      });
      await getNearbyPlaces(
          LatLng(_currentPosition.latitude, _currentPosition.longitude));

      await _addMarker(
          LatLng(_currentPosition.latitude, _currentPosition.longitude),
          "origin",
          sourceIcon); //LatLng(-20.8128082, -49.3808274)
    }).catchError((e) {
      print(e);
    });
  }

  void getNearbyPlaces(LatLng center) async {
    setState(() {
      this.isLoading = true;
      this.errorMessage = null;
    });

    final location = Location(center.latitude, center.longitude);

    final result =
        await _places.searchByText('gas station', location: location);
    setState(() {
      this.isLoading = false;
      if (result.status == "OK") {
        this.places = result.results;
        result.results.forEach((place) {
          final markerOptions = Marker(
              markerId: MarkerId('${place.id}'),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueViolet,
              ),
              position: LatLng(
                  place.geometry.location.lat, place.geometry.location.lng),
              infoWindow: InfoWindow(title: "${place.name}"));

          MarkerId markerId = MarkerId("${place.name}");
          Marker marker = Marker(
              markerId: markerId,
              icon: destinationIcon,
              position: LatLng(
                  place.geometry.location.lat, place.geometry.location.lng),
              onTap: () => showConfirmationDialog(context, center, place));
          markers.add(marker);
        });
      } else {
        this.errorMessage = result.errorMessage;
      }
    });
  }
}
