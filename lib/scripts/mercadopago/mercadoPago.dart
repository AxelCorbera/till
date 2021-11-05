import 'dart:convert';

import 'package:till/globals.dart' as globals;
import 'package:till/scripts/request.dart' as request;
import 'package:till/scripts/mercadopago/json/saveCardJson.dart';
import 'package:till/scripts/mercadopago/json/cardsJson.dart' as cards;
import 'package:mercadopago_sdk/mercadopago_sdk.dart';
import 'package:http/http.dart' as http;


class DatosTarjeta {
  DatosTarjeta(
      {this.numeros,
      this.nombre,
      this.mes,
      this.ano,
      this.docTipo,
      this.docNum,
      this.cvv});
  String? numeros;
  String? nombre;
  String? mes;
  String? ano;
  String? docTipo;
  String? docNum;
  String? cvv;
}

Future<String> CardToken(DatosTarjeta datos) async {
  while (globals.publicKey == "") {
    await request.Claves("MoritasPet");
  }
  String publicKey = globals.publicKey;
  var mp = MP.fromAccessToken(globals.accessToken);

  Map identification = new Map<String, dynamic>();
  identification["type"] = datos.docTipo;
  identification["number"] = datos.docNum;
  Map cardholder = new Map<String, dynamic>();
  cardholder["name"] = datos.nombre;
  cardholder["identification"] = identification;
  Map jsonData = new Map<String, dynamic>();
  jsonData["card_number"] = datos.numeros;
  jsonData["security_code"] = datos.cvv;
  jsonData["expiration_month"] = datos.mes;
  jsonData["expiration_year"] = "20" + datos.ano.toString();
  jsonData["cardholder"] = cardholder;
  Map key = new Map<String, String>();
  key["public_key"] = publicKey;

  final result = await mp.post("/v1/card_tokens/",
      data: jsonData as Map<String, dynamic>,
      params: key as Map<String, String>);
  try {
    return result["response"]["id"];
  } catch (Exception) {
    print(Exception);
    return "0";
  }
}

Future<String> GuardarTarjeta(String cardToken) async {
  while (globals.accessToken == "") {
    await request.Claves("MoritasPet");
  }
  var mp = MP.fromAccessToken(globals.accessToken);

  String accessToken = globals.accessToken;

  String customer_id = globals.usuario!.idcustomer.toString();
  Map token = new Map<String, String>();
  token["token"] = cardToken;

  String url = "https://api.mercadopago.com/v1/customers/$customer_id/cards";

  // final result = await mp.post(url,
  //     data: {"token": "$cardToken"});

  final result = await http.post(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      'Authorization': 'Bearer $accessToken'
    },
    body: json.encode({"token": "$cardToken"}),
  );

  print(url);
  try {
    print(globals.accessToken);
    print(result);
    return result.body;
  } catch (Exception) {
    print(Exception);
    return "0";
  }
}

Future<List<cards.Cards>> BuscarTarjetas(String customerId) async {
  while (globals.accessToken == "") {
    await request.Claves("MoritasPet");
  }
  var mp = MP.fromAccessToken(globals.accessToken);

  Map customer_id = new Map<String, String>();
  customer_id["customer_id"] = customerId;

  final result = await mp.get("/v1/customers/",
      params: customer_id as Map<String, String>);

  try {
    print(globals.accessToken);
    print(result);
    return cards
        .cardsFromJson(jsonDecode(result["response"]) as Map<String, dynamic>);
  } catch (Exception) {
    print(Exception);
    return <cards.Cards>[];
  }
}
