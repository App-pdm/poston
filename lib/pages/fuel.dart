import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:validadores/Validador.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:toast/toast.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:intl/intl.dart';

const apiKey = "AIzaSyBuTlwdWzZXm140ULb3DhocI9znsll8sog";
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: apiKey);

class FuelPage extends StatefulWidget {
  String placeId;

  FuelPage(String placeId) {
    this.placeId = placeId;
  }

  @override
  FuelPageState createState() => FuelPageState();
}

class FuelPageState extends State<FuelPage> {
  final scaffolKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  PlacesDetailsResponse _placeDetails;
  List<DropdownMenuItem> currencyItems;
  bool isLoading = false;
  String errorLoading;
  TextEditingController newFuelPrice = TextEditingController();
  final maskInput = MaskTextInputFormatter(mask: "#,###");

  var selectedCurrency, selectedType, oldPriceText;
  bool pressed = false;

  List<String> _fuelList = <String>[
    'Gasolina',
    'Alcool',
    'Diesel',
    'Gasolina Aditivada'
  ];

  @override
  initState() {
    _getPlaceDetails(widget.placeId);
    super.initState();
  }

  _getPlaceDetails(String placeId) async {
    setState(() {
      this.isLoading = true;
      this.errorLoading = null;
    });

    final result = await _places.getDetailsByPlaceId(placeId);

    if (mounted) {
      setState(() {
        _placeDetails = result;
        this.isLoading = false;
      });
    }
  }

  _showOldPrice(String fuel) async {
    var price = "Não encontrado";
    final QuerySnapshot searchedByPlaceId = await Firestore.instance
        .collection('combustiveis')
        .where('placeId', isEqualTo: widget.placeId)
        .getDocuments()
        .then((value) async {
      if (value.documents.length != 1) {
        await Firestore.instance.collection('combustiveis').document().setData({
          "placeId": widget.placeId,
        });
      } else {
        price = "R\$" + value.documents.first.data[fuel] ?? "Não encontrado";
      }
    }).catchError((e) => print("error fetching data: $e"));
    return price;
  }

  _verifyChanges(String newPrice, String fuel) async {
    final QuerySnapshot searchedByPlaceId = await Firestore.instance
        .collection('historico')
        .where('placeId', isEqualTo: widget.placeId)
        .where(fuel, isEqualTo: newPrice)
        .where('date',
            isEqualTo: DateFormat('dd/MM/yyyy').format(DateTime.now()))
        .getDocuments();

    int qtdDocuments = searchedByPlaceId.documents.length;

    if (qtdDocuments == 3) {
      final QuerySnapshot searchedByPlaceId = await Firestore.instance
          .collection('combustiveis')
          .where('placeId', isEqualTo: widget.placeId)
          .limit(1)
          .getDocuments()
          .then((value) async {
        var documentID = value.documents.first.documentID;
        await Firestore.instance
            .collection('combustiveis')
            .document(documentID)
            .updateData({fuel: newPrice});
      });
    } else {
      await Firestore.instance.collection('historico').add({
        "placeId": widget.placeId,
        "date": DateFormat('dd/MM/yyyy').format(DateTime.now()),
        "datetime": DateTime.now(),
        fuel: newPrice
      });
    }
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
      bodyChild = Form(
        key: _formKey,
        //readOnly: false,
        autovalidate: true,
        child: new ListView(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          children: <Widget>[
            new TextFormField(
              initialValue: _placeDetails.result.name ?? "",
              enabled: false,
              decoration: const InputDecoration(
                icon: const Icon(
                  FontAwesomeIcons.gasPump,
                  color: Color(0xff11b719),
                ),
                hintText: 'Nome do Posto',
                labelText: 'Posto',
              ),
            ),
            new TextFormField(
              initialValue: _placeDetails.result.formattedAddress ?? "",
              enabled: false,
              decoration: const InputDecoration(
                icon: const Icon(
                  FontAwesomeIcons.city,
                  color: Color(0xff11b719),
                ),
                hintText: 'Endereço',
                labelText: 'Endereço',
              ),
            ),
            SizedBox(height: 20.0),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Icon(FontAwesomeIcons.gasPump,
                      size: 25.0, color: Colors.black),
                  SizedBox(width: 15.0),
                  Expanded(
                    child: DropdownButtonHideUnderline(
                      child: ButtonTheme(
                        alignedDropdown: true,
                        child: DropdownButton(
                          items: _fuelList.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (currencyValue) async {
                            var oldPrice =
                                await _showOldPrice(currencyValue.toString());
                            setState(() {
                              oldPriceText = "Preço Atual: ${oldPrice}";
                              pressed = true;
                              selectedCurrency = currencyValue;
                            });
                          },
                          value: selectedCurrency,
                          isExpanded: true,
                          hint: new Text(
                            "Selecione um combustível",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  )
                ]),
            SizedBox(height: 20.0),
            pressed
                ? Row(children: [
                    Icon(FontAwesomeIcons.moneyBill, color: Colors.black),
                    SizedBox(width: 30),
                    Text(
                      oldPriceText,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    )
                  ])
                : SizedBox(),
            SizedBox(height: 15.0),
            pressed
                ? new TextFormField(
                    inputFormatters: [maskInput],
                    controller: newFuelPrice,
                    decoration: const InputDecoration(
                      icon: const Icon(
                        FontAwesomeIcons.moneyBill,
                        color: Color(0xff11b719),
                      ),
                      hintText: 'Preço do Combustível',
                      labelText: 'Novo Preço',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      //Validações
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: 'Preço é obrigatório')
                          .minLength(4)
                          .maxLength(5)
                          .valido(value, clearNoNumber: false);
                    },
                  )
                : SizedBox(),
            SizedBox(height: 20.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  //margin: EdgeInsets.fromLTRB(0, 10, 0, 70),
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xFF5D3EA8),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  //child: Center(
                  child: FlatButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Salvar',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 15),
                        ),
                        Icon(Icons.add_circle, color: Colors.white),
                      ],
                    ),
                    onPressed: () async => {
                      if (_formKey.currentState.validate())
                        {
                          await Firestore.instance
                              .collection('combustiveis')
                              .where('placeId', isEqualTo: widget.placeId)
                              .limit(1)
                              .getDocuments()
                              .then((value) async {
                            var document = value.documents.first.data;
                            var documentID = value.documents.first.documentID;
                            if (document.containsKey(selectedCurrency) ==
                                false) {
                              await Firestore.instance
                                  .collection('combustiveis')
                                  .document(documentID)
                                  .updateData(
                                      {selectedCurrency: newFuelPrice.text});
                            } else {
                              await _verifyChanges(
                                  newFuelPrice.text, selectedCurrency);
                            }
                            FocusScope.of(context).requestFocus(FocusNode());
                            await Toast.show(
                                "Salvo! Agradecemos o seu feedback.", context,
                                duration: 5);
                            setState(() {
                              selectedCurrency = null;
                              _formKey.currentState.reset();
                            });

                            //Navigator.of(context).pop();
                          }),
                        }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Scaffold(
        //backgroundColor: Color(0xFFE5E5E5),
        key: scaffolKey,
        appBar: AppBar(
          backgroundColor: Colors.purple[900],
          title: Container(
            alignment: Alignment.center,
            child: Text("Cadastro de Combustível",
                style: TextStyle(
                  color: Colors.white,
                )),
          ),
        ),
        body: bodyChild);
  }
}
