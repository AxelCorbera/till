import 'dart:convert';

class Compras {
  List<String>? id;
  List<String>? fecha;
  List<String>? hora;
  List<String>? cliente;
  List<String>? comercio;
  List<String>? nombreComercio;
  List<String>? productos;
  List<String>? total;
  List<String>? pago;
  List<String>? estado;
  List<String>? productosCodigo;
  List<String>? tarjeta;
  List<String>? idPago;
  List<String>? documento;
  List<String>? token;
  List<String>? cuotas;
  List<String>? montoCuota;
  List<String>? totalCuota;
  List<String>? detalle;
  List<String>? telefono;

  Compras({
    this.id,
    this.fecha,
    this.hora,
    this.cliente,
    this.comercio,
    this.nombreComercio,
    this.productos,
    this.total,
    this.pago,
    this.estado,
    this.productosCodigo,
    this.tarjeta,
    this.idPago,
    this.documento,
    this.token,
    this.cuotas,
    this.montoCuota,
    this.totalCuota,
    this.detalle,
    this.telefono,
  });

  factory Compras.fromJson(Map<String, dynamic> json) {
    var idJson = json['id'];
    print(idJson.toString());
    var fechaJson = json['fecha'];
    var horaJson = json['hora'];
    var clienteJson = json['cliente'];
    var comercioJson = json['comercio'];
    var nombreComercioJson = json['nombreComercio'];
    var productosJson = json['productos'];
    var totalJson = json['total'];
    var pagoJson = json['pago'];
    var estadoJson = json['estado'];
    var productosCodigoJson = json['productosCodigo'];
    var tarjetaJson = json['tarjeta'];
    var idPagoJson = json['idPago'];
    var documentoJson = json['documento'];
    var tokenJson = json['token'];
    var cuotasJson = json['cuotas'];
    var montoCuotaJson = json['montoCuota'];
    var totalCuotaJson = json['totalCuota'];
    var detalleJson = json['detalle'];
    var telefonoJson = json['telefono'];

    //print(streetsFromJson.runtimeType);
    List<String> idList = new List<String>.from(idJson);
    List<String> fechaList = new List<String>.from(fechaJson);
    List<String> horaList = new List<String>.from(horaJson);
    List<String> cliebnteList = new List<String>.from(clienteJson);
    List<String> comercioList = new List<String>.from(comercioJson);
    List<String> nombreComercioList = new List<String>.from(nombreComercioJson);
    List<String> productoList = new List<String>.from(productosJson);
    List<String> totalList = new List<String>.from(totalJson);
    List<String> pagoList = new List<String>.from(pagoJson);
    List<String> estadoList = new List<String>.from(estadoJson);
    List<String> productosCodigoList =
    new List<String>.from(productosCodigoJson);
    List<String> tarjetaList = new List<String>.from(tarjetaJson);
    List<String> idPagoList = new List<String>.from(idPagoJson);
    List<String> documentoList = new List<String>.from(documentoJson);
    List<String> tokenList = new List<String>.from(tokenJson);
    List<String> cuotasList = new List<String>.from(cuotasJson);
    List<String> montoCuotaList = new List<String>.from(montoCuotaJson);
    List<String> totalCuotaList = new List<String>.from(totalCuotaJson);
    List<String> detalleList = new List<String>.from(detalleJson);
    List<String> telefonoList = new List<String>.from(telefonoJson);

    return new Compras(
        id: idList,
        fecha: fechaList,
        hora: horaList,
        cliente: cliebnteList,
        comercio: comercioList,
        nombreComercio: nombreComercioList,
        productos: productoList,
        total: totalList,
        pago: pagoList,
        estado: estadoList,
        productosCodigo: productosCodigoList,
        tarjeta: tarjetaList,
        idPago: idPagoList,
        documento: documentoList,
        token: tokenList,
        cuotas: cuotasList,
        montoCuota: montoCuotaList,
        totalCuota: totalCuotaList,
        detalle: detalleList,
        telefono: telefonoList);
  }

  static toJson() {}
}

class Compra {
  String id;
  String fecha;
  String? hora;
  String? cliente;
  String? comercio;
  String? nombreComercio;
  String productos;
  String total;
  String? pago;
  String? estado;
  String? productosCodigo;
  String? tarjeta;
  String? idPago;
  String? documento;
  String? token;
  String? cuotas;
  String? montoCuota;
  String? totalCuota;
  String? detalle;
  String? telefono;

  Compra({
    required this.id,
    required this.fecha,
    this.hora,
    this.cliente,
    this.comercio,
    this.nombreComercio,
    required this.productos,
    required this.total,
    this.pago,
    this.estado,
    this.productosCodigo,
    this.tarjeta,
    this.idPago,
    this.documento,
    this.token,
    this.cuotas,
    this.montoCuota,
    this.totalCuota,
    this.detalle,
    this.telefono,
  });

  factory Compra.fromJson(Map<String, dynamic> json) {
    var idJson = json['id'];
    print(idJson.toString());
    var fechaJson = json['fecha'];
    var horaJson = json['hora'];
    var clienteJson = json['cliente'];
    var comercioJson = json['comercio'];
    var nombreComercioJson = json['nombreComercio'];
    var productosJson = json['productos'];
    var totalJson = json['total'];
    var pagoJson = json['pago'];
    var estadoJson = json['estado'];
    var productosCodigoJson = json['productosCodigo'];
    var tarjetaJson = json['tarjeta'];
    var idPagoJson = json['idPago'];
    var documentoJson = json['documento'];
    var tokenJson = json['token'];
    var cuotasJson = json['cuotas'];
    var montoCuotaJson = json['montoCuota'];
    var totalCuotaJson = json['totalCuota'];
    var detalleJson = json['detalle'];
    var telefonoJson = json['telefono'];

    return new Compra(
        id: idJson,
        fecha: fechaJson,
        hora: horaJson,
        cliente: clienteJson,
        comercio: comercioJson,
        nombreComercio: nombreComercioJson,
        productos: productosJson,
        total: totalJson,
        pago: pagoJson,
        estado: estadoJson,
        productosCodigo: productosCodigoJson,
        tarjeta: tarjetaJson,
        idPago: idPagoJson,
        documento: documentoJson,
        token: tokenJson,
        cuotas: cuotasJson,
        montoCuota: montoCuotaJson,
        totalCuota: totalCuotaJson,
        detalle: detalleJson,
        telefono: telefonoJson);
  }
}

// To parse this JSON data, do
//
//     final datos = datosFromJson(jsonString);
Datos datosFromJson(String str) => Datos.fromJson(json.decode(str));

String datosToJson(Datos data) => json.encode(data.toJson());

class Datos {
  Datos({
    required this.items,
  });

  List<Item> items;

  factory Datos.fromJson(Map<String, dynamic> json) => Datos(
    items: List<Item>.from(json["Items"].map((x) => Item.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Items": List<dynamic>.from(items.map((x) => x.toJson())),
  };
}

class Item {
  Item({
    required this.cantidad,
    required this.nombre,
    required this.codigo,
    required this.precio,
  });

  String cantidad;
  String nombre;
  String codigo;
  String precio;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    cantidad: json["cantidad"],
    nombre: json["nombre"],
    codigo: json["codigo"],
    precio: json["precio"],
  );

  Map<String, dynamic> toJson() => {
    "cantidad": cantidad,
    "nombre": nombre,
    "codigo": codigo,
    "precio": precio,
  };
}
