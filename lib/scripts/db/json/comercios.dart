// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

Comercios ComerciosFromJson(String str) => Comercios.fromJson(json.decode(str));

String ComerciosToJson(Comercios data) => json.encode(data.toJson());

class Comercios {
  Comercios({
    this.id,
    this.cuil,
    this.razonsocial,
    this.provincia,
    this.localidad,
    this.barrio,
    this.direccion,
    this.qr,
    this.ventas,
    this.idventas,
    this.usuario,
    this.clave,
    this.usaQr,
  });

  List<String>? id;
  List<String>? cuil;
  List<String>? razonsocial;
  List<String>? provincia;
  List<String>? localidad;
  List<String>? barrio;
  List<String>? direccion;
  List<String>? qr;
  List<String>? ventas;
  List<String>? idventas;
  List<String>? usuario;
  List<String>? clave;
  List<String>? usaQr;

  factory Comercios.fromJson(Map<String, dynamic> json) => Comercios(
    id: List<String>.from(json["id"].map((x) => x)),
    cuil: List<String>.from(json["cuil"].map((x) => x)),
    razonsocial: List<String>.from(json["razonsocial"].map((x) => x)),
    provincia: List<String>.from(json["provincia"].map((x) => x)),
    localidad: List<String>.from(json["localidad"].map((x) => x)),
    barrio: List<String>.from(json["barrio"].map((x) => x)),
    direccion: List<String>.from(json["direccion"].map((x) => x)),
    qr: List<String>.from(json["qr"].map((x) => x)),
    ventas: List<String>.from(json["ventas"].map((x) => x)),
    idventas: List<String>.from(json["idventas"].map((x) => x)),
    usuario: List<String>.from(json["usuario"].map((x) => x)),
    clave: List<String>.from(json["clave"].map((x) => x)),
    usaQr: List<String>.from(json["usaQr"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": List<dynamic>.from(id!.map((x) => x)),
    "cuil": List<dynamic>.from(cuil!.map((x) => x)),
    "razonsocial": List<dynamic>.from(razonsocial!.map((x) => x)),
    "provincia": List<dynamic>.from(provincia!.map((x) => x)),
    "localidad": List<dynamic>.from(localidad!.map((x) => x)),
    "barrio": List<dynamic>.from(barrio!.map((x) => x)),
    "direccion": List<dynamic>.from(direccion!.map((x) => x)),
    "qr": List<dynamic>.from(qr!.map((x) => x)),
    "ventas": List<dynamic>.from(ventas!.map((x) => x)),
    "idventas": List<dynamic>.from(idventas!.map((x) => x)),
    "usuario": List<dynamic>.from(usuario!.map((x) => x)),
    "clave": List<dynamic>.from(clave!.map((x) => x)),
    "usaQr": List<dynamic>.from(usaQr!.map((x) => x)),
  };
}
