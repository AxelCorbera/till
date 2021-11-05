library till.globals;

import 'package:till/scripts/mercadopago/cardsJson.dart';
import 'package:till/scripts/request.dart';

Usuario? usuario =
    Usuario("", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "");

bool login = false;

List<Cards> cards = <Cards>[];

String accessToken = "";

String publicKey = "";

class Carrito {
  final List<String> id;
  final List<String> codigo;
  final List<String> marca;
  final List<String> nombre;
  final List<String> cantidad;
  final List<String> stock;
  final List<dynamic> precio;
  final List<String> imagen;
  final List<String>? tamano;
  final List<String> color;

  Carrito({
    required this.id,
    required this.codigo,
    required this.marca,
    required this.nombre,
    required this.cantidad,
    required this.stock,
    required this.precio,
    required this.imagen,
    required this.tamano,
    required this.color,
  });
}

Carrito carrito = Carrito(
    id: [],
    codigo: [],
    marca: [],
    nombre: [],
    cantidad: [],
    stock: [],
    precio: [],
    imagen: [],
    tamano: [],
    color: []);
