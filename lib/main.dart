import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request =
    'https://api.hgbrasil.com/finance?format=json-cors&key=101b4c75';

void main() async {
  runApp(MaterialApp(
    home: HomePage(),
    theme: ThemeData(
      hintColor: Colors.amber,
    ),
  ));
}

// ignore: missing_return
Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double dolar;
  double euro;
  double real;

  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();


  void _realChanged(String text){
    double real = double.parse(text);
    dolarController.text = (real/dolar).toStringAsFixed(2);
    euroController.text = (real/euro).toStringAsFixed(2);

  }

  void _dolarChanged(String text){
    double dolar = double.parse(text);
    realController.text = (dolar*this.dolar).toStringAsFixed(2);
    euroController.text = (dolar*this.dolar/euro).toStringAsFixed(2);

  }

  void _euroChanged(String text){
    double euro = double.parse(text);
    realController.text = (euro*this.euro).toStringAsFixed(2);
    dolarController.text = (euro*this.euro/dolar).toStringAsFixed(2);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page - Conversor'),
        backgroundColor: Colors.blueGrey,
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text(
                  'Carregando dados',
                  style: TextStyle(color: Colors.blueGrey, fontSize: 25.0),
                ),
              );
            default:
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error ao carregar dados',
                    style: TextStyle(color: Colors.blueGrey, fontSize: 25.0),
                  ),
                );
              } else {
                dolar = snapshot.data["results"]['currencies']['USD']['buy'];
                euro = snapshot.data['results']['currencies']['EUR']['buy'];
                return SingleChildScrollView(
                  padding: EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.attach_money,
                        size: 150.0,
                        color: Colors.blueGrey,
                      ),
                      buildTextField('Reais', 'R\$', realController, _realChanged),
                      Divider(),
                      buildTextField('Dolares', '\$', dolarController, _dolarChanged),
                      Divider(),
                      buildTextField('Euros', '€', euroController, _euroChanged),
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }
}

Widget buildTextField(String label, String prefix, TextEditingController cambio, Function changes){

  return  TextField(
      controller: cambio,
      decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.blueGrey),
          border: OutlineInputBorder(),
          prefixText: prefix),
      style:
      TextStyle(color: Colors.amber, fontSize: 25.0),
      onChanged: changes,
    keyboardType: TextInputType.number,
  );

}
