import 'dart:convert';

Listado listadoFromJson(String str) => Listado.fromJson(json.decode(str));

String listadoToJson(Listado data) => json.encode(data.toJson());

class Listado {
  Listado({
    this.id,
    this.codigo,
    this.nombre,
    this.precio,
    this.descuento,
    this.acumulable,
    this.tipo,
    this.tope,
  });

  List<String>? id;
  List<String>? codigo;
  List<String>? nombre;
  List<String>? precio;
  List<String>? descuento;
  List<String>? acumulable;
  List<String>? tipo;
  List<String>? tope;

  factory Listado.fromJson(Map<String, dynamic> json) => Listado(
    id: List<String>.from(json["id"].map((x) => x)),
    codigo: List<String>.from(json["codigo"].map((x) => x)),
    nombre: List<String>.from(json["nombre"].map((x) => x)),
    precio: List<String>.from(json["precio"].map((x) => x)),
    descuento: List<String>.from(json["descuento"].map((x) => x)),
    acumulable: List<String>.from(json["acumulable"].map((x) => x)),
    tipo: List<String>.from(json["tipo"].map((x) => x)),
    tope: List<String>.from(json["tope"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": List<dynamic>.from(id!.map((x) => x)),
    "codigo": List<dynamic>.from(codigo!.map((x) => x)),
    "nombre": List<dynamic>.from(nombre!.map((x) => x)),
    "precio": List<dynamic>.from(precio!.map((x) => x)),
    "descuento": List<dynamic>.from(descuento!.map((x) => x)),
    "acumulable": List<dynamic>.from(acumulable!.map((x) => x)),
    "tipo": List<dynamic>.from(tipo!.map((x) => x)),
    "tope": List<dynamic>.from(tope!.map((x) => x)),
  };
}

class Producto {
  Producto({
    required this.id,
    this.codigo,
    this.nombre,
    this.precio,
    this.descuento,
    this.acumulable,
    this.tipo,
    this.tope,
  });

  String id;
  String? codigo;
  String? nombre;
  String? precio;
  String? descuento;
  String? acumulable;
  String? tipo;
  String? tope;

  factory Producto.fromJson(Map<String, dynamic> json) => Producto(
    id: json["id"],
    codigo: json["codigo"],
    nombre: json["nombre"],
    precio: json["precio"],
    descuento: json["descuento"],
    acumulable: json["acumulable"],
    tipo: json["tipo"],
    tope: json["tope"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "codigo": codigo,
    "nombre": nombre,
    "precio": precio,
    "descuento": descuento,
    "acumulable": acumulable,
    "tipo": tipo,
    "tope": tope,
  };
}
