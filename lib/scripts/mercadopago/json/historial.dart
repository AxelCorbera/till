// To parse this JSON data, do
//
//     final historial = historialFromJson(jsonString);

import 'dart:convert';

Historial historialFromJson(String str) => Historial.fromJson(json.decode(str));

String historialToJson(Historial data) => json.encode(data.toJson());

class Historial {
  Historial({
    this.items,
  });

  List<Item>? items;

  factory Historial.fromJson(Map<String, dynamic> json) => Historial(
    items: List<Item>.from(json["Items"].map((x) => Item.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Items": List<dynamic>.from(items!.map((x) => x.toJson())),
  };
}

class Item {
  Item({
    this.id,
    this.idMascota,
    this.tipo,
    this.fecha,
    this.nombre,
    this.peso,
    this.proximaFecha,
    this.lugar,
    this.medicamento,
    this.observaciones,
  });

  String? id;
  String? idMascota;
  String? tipo;
  String? fecha;
  String? nombre;
  String? peso;
  String? proximaFecha;
  String? lugar;
  String? medicamento;
  String? observaciones;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    id: json["id"],
    idMascota: json["idMascota"],
    tipo: json["tipo"],
    fecha: json["fecha"],
    nombre: json["nombre"],
    peso: json["peso"],
    proximaFecha: json["proxima_fecha"],
    lugar: json["lugar"],
    medicamento: json["medicamento"],
    observaciones: json["observaciones"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "idMascota": idMascota,
    "tipo": tipo,
    "fecha": fecha,
    "nombre": nombre,
    "peso": peso,
    "proxima_fecha": proximaFecha,
    "lugar": lugar,
    "medicamento": medicamento,
    "observaciones": observaciones,
  };
}
