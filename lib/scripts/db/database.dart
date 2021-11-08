import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:till/scripts/db/json/comercios.dart';

import 'json/listado.dart';

Future<Comercios> cargarComercios() async {

  final response = await http.get(
    Uri.parse(
        'http://wh534614.ispot.cc/cargarcomerciosTill.php'),
  );

  print(response.body.toString());

  if (response.statusCode == 200 || response.statusCode == 201) {
    // If the server did return a 200 CREATED response,
    // then parse the JSON.
    print('respuesta ' + jsonDecode(response.body).toString());
    return Comercios.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Fallo cargar comercio.');
  }
}

Future<Listado> cargarListado(String comercio) async {

  final response = await http.get(
    Uri.parse(
        'http://wh534614.ispot.cc/cargarlistadoTill.php?comercio=$comercio'),
  );

  print(response.body.toString());

  if (response.statusCode == 200 || response.statusCode == 201) {
    // If the server did return a 200 CREATED response,
    // then parse the JSON.
    print('respuesta ' + jsonDecode(response.body).toString());
    return Listado.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Fallo cargar listado.');
  }
}