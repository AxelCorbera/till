// To parse this JSON data, do
//
//     final mascotas = mascotasFromJson(jsonString);

import 'dart:convert';

Mascotas mascotasFromJson(String str) => Mascotas.fromJson(json.decode(str));

String mascotasToJson(Mascotas data) => json.encode(data.toJson());

class Mascotas {
  Mascotas({
    required this.items,
  });

  List<Item> items;

  factory Mascotas.fromJson(Map<String, dynamic> json) => Mascotas(
    items: List<Item>.from(json["Items"].map((x) => Item.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Items": List<dynamic>.from(items.map((x) => x.toJson())),
  };
}

class Item {
  Item({
    this.id,
    this.foto,
    this.especie,
    this.sexo,
    this.raza,
    this.nombre,
    this.apellido,
    this.peso,
    this.nacimiento,
    this.alarmas,
    this.observacion,
    this.lugar,
    this.telefono,
    this.domicilio,
    this.pelaje
  });

  String? id;
  String? foto;
  String? especie;
  String? sexo;
  String? raza;
  String? nombre;
  String? apellido;
  String? peso;
  String? nacimiento;
  String? lugar;
  String? pelaje;
  String? telefono;
  String? domicilio;
  String? alarmas;
  String? observacion;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    id: json["id"],
    foto: json["foto"],
    especie: json["especie"],
    sexo: json["sexo"],
    raza: json["raza"],
    nombre: json["nombre"],
    apellido: json["apellido"],
    peso: json["peso"],
    nacimiento: json["nacimiento"],
    lugar: json["lugar"],
    pelaje: json["pelaje"],
    telefono: json["telefono"],
    domicilio: json["domicilio"],
    alarmas: json["alarmas"],
    observacion: json["observacion"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "foto": foto,
    "especie": especie,
    "sexo": sexo,
    "raza": raza,
    "nombre": nombre,
    "apellido": apellido,
    "peso": peso,
    "nacimiento": nacimiento,
    "alarmas": alarmas,
    "observacion": observacion,
    "lugar": lugar,
    "pelaje": pelaje,
    "telefono": telefono,
    "domicilio": domicilio,

  };
}

class FotoMascotas {
  FotoMascotas({
    required this.id,
    required this.idusuario,
    required this.idmascota,
    required this.nombre,
    required this.imagen,

  });

  List<String>? id;
  List<String>? idusuario;
  List<String>? idmascota;
  List<String>? nombre;
  List<String>? imagen;


  factory FotoMascotas.fromJson(Map<String, dynamic> json) => FotoMascotas(
    id: List<String>.from(json["id"]),
    idusuario: List<String>.from(json["idusuario"]),
    idmascota: List<String>.from(json["idmascota"]),
    nombre: List<String>.from(json["nombre"]),
    imagen: List<String>.from(json["imagen"])

  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "idusuario" : idusuario,
    "idmascota" : idmascota,
    "nombre" : nombre,
    "imagen" : imagen
  };
}
