import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:till/scripts/mercadopago/customerJson.dart';
import 'package:till/scripts/mercadopago/cardsJson.dart';
import 'package:till/scripts/mercadopago/cuotasJson.dart' as cuotas;
import 'package:till/scripts/mercadopago/json/crearCustomerJson.dart';
import 'package:till/scripts/mercadopago/json/historial.dart';
import 'package:till/scripts/mercadopago/json/mascotas.dart';
import 'package:till/scripts/mercadopago/payment.dart';
import 'package:till/scripts/mercadopago/responsePayment.dart';
import 'package:http/http.dart' as http;
import 'package:till/globals.dart' as globals;
import 'package:till/scripts/request.dart' as request;
import 'mercadopago/customerJson.dart';
import 'mercadopago/json/baseDatos.dart' as db;
import 'mercadopago/responsePayment2.dart';

class Album {
  final String id;
  final String token;

  Album({required this.id, required this.token});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['id'],
      token: json['token'],
    );
  }
}

class Categorias {
  final List<String> cate;

  Categorias({required this.cate});

  factory Categorias.fromJson(Map<String, dynamic> json) {
    var streetsFromJson = json['marca'];
    //print(streetsFromJson.runtimeType);
    List<String> streetsList = new List<String>.from(streetsFromJson);

    return new Categorias(
      cate: streetsList,
    );
  }
}

class Credenciales {
  String? id;
  String? fecha;
  String? usuario;
  String? codigoAutorizacion;
  String? accessToken;
  String? publicKey;
  String? refreshToken;
  String? userId;
  String? numero;

  Credenciales(
    this.id,
    this.fecha,
    this.usuario,
    this.codigoAutorizacion,
    this.accessToken,
    this.publicKey,
    this.refreshToken,
    this.userId,
    this.numero,
  );

  factory Credenciales.fromJson(Map<String, dynamic> json) {
    var idJson = json['id'];
    var fechaJson = json['fecha'];
    var usuarioJson = json['usuario'];
    var codigoAutorizacionJson = json['codigoAutorizacion'];
    var accessTokenJson = json['accessToken'];
    var publicKeyJson = json['publicKey'];
    var refreshTokenJson = json['refreshToken'];
    var userIdJson = json['userId'];
    var numeroJson = json['numero'];

    return new Credenciales(
      idJson,
      fechaJson,
      usuarioJson,
      codigoAutorizacionJson,
      accessTokenJson,
      publicKeyJson,
      refreshTokenJson,
      userIdJson,
      numeroJson,
    );
  }
}

class Usuario {
  String? id;
  String? nombre;
  String? apellido;
  String? correo;
  String? documento;
  String? telefono;
  String? token;
  String? persona;
  String? cuil;
  String? razon_social;
  String? id_customer_mp;
  String? id_card_mp;
  String? provincia;
  String? municipio;
  String? localidad;
  String? calle;
  String? numero;
  String? piso;
  String? departamento;
  String? foto;

  Usuario(
      this.id,
      this.nombre,
      this.apellido,
      this.correo,
      this.documento,
      this.telefono,
      this.token,
      this.persona,
      this.cuil,
      this.razon_social,
      this.id_customer_mp,
      this.id_card_mp,
      this.provincia,
      this.municipio,
      this.localidad,
      this.calle,
      this.numero,
      this.piso,
      this.departamento,
      this.foto);

  factory Usuario.fromJson(Map<String, dynamic> json) {
    var idJson = json['id'];
    var nombreJson = json['nombre'];
    var apellidoJson = json['aprellido'];
    var correoJson = json['correo'];
    var documentoJson = json['documento'];
    var telefonoJson = json['telefono'];
    var tokenJson = json['token'];
    var personaJson = json['persona'];
    var cuilJson = json['cuil'];
    var razon_socialJson = json['razon_social'];
    var customerJson = json['id_customer_mp'];
    var cardJson = json['id_card_mp'];
    var provinciaJson = json['provincia'];
    var municipioJson = json['municipio'];
    var localidadJson = json['localidad'];
    var calleJson = json['calle'];
    var numeroJson = json['numero'];
    var pisoJson = json['piso'];
    var departamentoJson = json['departamento'];
    var fotoJson = json['foto'];


    return new Usuario(
        idJson,
        nombreJson,
        apellidoJson,
        correoJson,
        documentoJson,
        telefonoJson,
        tokenJson,
        personaJson,
        cuilJson,
        razon_socialJson,
        customerJson,
        cardJson,
        provinciaJson,
        municipioJson,
        localidadJson,
        calleJson,
        numeroJson,
    pisoJson,
    departamentoJson,
    fotoJson);
  }
}

class Marcas {
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

  Marcas({
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

  factory Marcas.fromJson(Map<dynamic, dynamic> json) {
    var idJson = json['id'];
    var codigoJson = json['codigo'];
    var marcaJson = json['marca'];
    var nombreJson = json['nombre'];
    var cantidadJson = json['cantidad'];
    var stockJson = json['stock'];
    var precioJson = json['precio'];
    var imagenJson = json['imagen'];
    var tamanoJson = json['tamano'];
    var colorJson = json['color'];

    //print(streetsFromJson.runtimeType);
    List<String> idList = new List<String>.from(idJson);
    List<String> codigoList = new List<String>.from(codigoJson);
    List<String> marcaList = new List<String>.from(marcaJson);
    List<String> nombreList = new List<String>.from(nombreJson);
    List<String> cantidadList = new List<String>.from(cantidadJson);
    List<String> stockList = new List<String>.from(stockJson);
    List<dynamic> precioList = new List<dynamic>.from(precioJson);
    List<String> imagenList = new List<String>.from(imagenJson);
    if (tamanoJson == "null") {
      print('ES NULL: ' + tamanoJson.toString());
    } else {
      {
        print('NO ES NULL: ' + tamanoJson.toString());
      }
    }
    List<String>? tamanoList = new List<String>.from(tamanoJson);
    List<String> colorList = new List<String>.from(colorJson);

    return new Marcas(
      id: idList,
      codigo: codigoList,
      marca: marcaList,
      nombre: nombreList,
      cantidad: cantidadList,
      stock: stockList,
      precio: precioList,
      imagen: imagenList,
      tamano: tamanoList,
      color: colorList,
    );
  }
}

Future<Album> IniciarSesion(String email, String clave) async {
  Map map = new Map<String, dynamic>();
  map['email'] = email;
  map['clave'] = clave;
  final response = await http.post(
    Uri.parse('http://wh534614.ispot.cc/mypetshop/flutter/consultaToken.php?'),
    headers: <String, String>{
      'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
    },
    body: map,
  );
  print(response.statusCode);
  if (response.statusCode == 200 || response.statusCode == 201) {
    // If the server did return a 200 CREATED response,
    // then parse the JSON.
    print(jsonDecode(response.body));
    return Album.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to create album.');
  }
}

Future<Usuario> DatosUsuario(String id, String token) async {
  Map map = new Map<String, dynamic>();
  map['id'] = id;
  map['token'] = token;
  final response = await http.post(
    Uri.parse('http://wh534614.ispot.cc/mypetshop/flutter/ingreso.php?'),
    headers: <String, String>{
      'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
    },
    body: map,
  );

  print('> '+response.body);
  print(response.statusCode);
  if (response.statusCode == 200 || response.statusCode == 201) {
    // If the server did return a 200 CREATED response,
    // then parse the JSON.
    print(jsonDecode(response.body));
    return Usuario.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to create album.');
  }
}

Future<String> Registrarse(
    String name, String lastName, String email, String password) async {
  Map map = new Map<String, dynamic>();
  map['name'] = name;
  map['lastname'] = lastName;
  map['email'] = email;
  map['password'] = password;

  final response = await http.post(
    Uri.parse('http://wh534614.ispot.cc/mypetshop/flutter/crearUsuario.php?'),
    headers: <String, String>{
      'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
    },
    body: map,
  );
  print(response.statusCode);
  if (response.statusCode == 200 || response.statusCode == 201) {
    // If the server did return a 200 CREATED response,
    // then parse the JSON.
    print(jsonDecode(response.body));
    return response.body;
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to create album.');
  }
}

//TILL
Future<db.Compras> BuscarCompras(
    String idUsuario) async {
  Map map = new Map<String, dynamic>();
    map['idusuario'] = idUsuario;

  final response = await http.get(
    Uri.parse('http://wh534614.ispot.cc/consultaCompras.php?idusuario=$idUsuario'),
    headers: <String, String>{
      'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
    },
  );
  print('http://wh534614.ispot.cc/consultaCompras.php?idusuario=$idUsuario');
  if (response.statusCode == 200 || response.statusCode == 201) {

    //DEVUELVE ARRAY

    return db.Compras.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Fallo la busqueda de compras.');
  }
}

// Future<FotoMascotas> BuscarFotoMascotas(
//     String idUsuario) async {
//
//   final response = await http.get(
//     Uri.parse('http://wh534614.ispot.cc/mypetshop/consultarFotoMascota.php?id=$idUsuario'),
//     headers: <String, String>{
//       'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
//     },
//   );
//   print('http://wh534614.ispot.cc/mypetshop/consultarFotoMascota.php?id=$idUsuario');
//   if (response.statusCode == 200 || response.statusCode == 201) {
//
//     //DEVUELVE ARRAY
//
//     return FotoMascotas.fromJson(jsonDecode(response.body));
//   } else {
//     // If the server did not return a 201 CREATED response,
//     // then throw an exception.
//     throw Exception('Fallo la busqueda de foto de mascota.');
//   }
// }

// Future<String> CargarFoto(String idUsuario, String idMascota, String nombre, String imagen) async {
//   Map datos = new Map<String, String>();
//   datos["idusuario"] = idUsuario;
//   datos["idmascota"] = idMascota;
//   datos["nombre"] = nombre;
//   datos["imagen"] = imagen;
//
//   final response = await http.post(
//     Uri.parse(
//         'http://wh534614.ispot.cc/mypetshop/cargarFoto.php?'),
//     body: datos,
//   );
//   return response.body.toString();
// }
//
// Future<String> ActualizarFoto(String customer, String mascotas, String nombre, String imagen) async {
//   Map datos = new Map<String, String>();
//   datos["idusuario"] = customer;
//   datos["idmascota"] = mascotas;
//   datos["nombre"] = nombre;
//   datos["imagen"] = imagen;
//
//   final response = await http.post(
//     Uri.parse(
//         'http://wh534614.ispot.cc/mypetshop/actualizarFoto.php?'),
//     body: datos,
//   );
//   return response.body.toString();
// }
//
// Future<String> BorrarFoto(
//     String idUsuario, String idMascota) async {
//
//   final response = await http.get(
//     Uri.parse('http://wh534614.ispot.cc/mypetshop/eliminarFoto.php?idusuario=$idUsuario&idmascota=$idMascota'),
//     headers: <String, String>{
//       'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
//     },
//   );
//
//   if (response.statusCode == 200 || response.statusCode == 201) {
//
//     return response.body;
//   } else {
//     // If the server did not return a 201 CREATED response,
//     // then throw an exception.
//     throw Exception('Fallo la busqueda de Mascotas.');
//   }
// }

Future<List<Cards>> BuscarTarjetas(String idCustomer) async {
  //    SI NO HAY TARJETAS, TIRA ERROR !

  while (globals.accessToken == "") {
    await request.Claves("Till");
  }
  String accessToken = globals.accessToken;

  final response = await http.get(
    Uri.parse('https://api.mercadopago.com/v1/customers/$idCustomer/cards'),
    headers: <String, String>{
      'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      'Authorization': 'Bearer $accessToken'
    },
  );
  print("buscarTarjetas? "+response.body.toString() +" "+ response.statusCode.toString());
  if (response.statusCode == 200 || response.statusCode == 201) {
    // If the server did return a 200 CREATED response,
    // then parse the JSON.
    print('respuesta ' + jsonDecode(response.body).toString());
    return cardsFromJson(response.body);
  } else {
    // If the server did not return a 201 CREATED response,
    print(Exception('Fallo la busqueda de tarjetas.'));
    List<Cards> resp = [];
    return resp;
  }
}

// Future<FindCustomer> BuscarCustomer(String email) async {
//   final response = await http.get(
//     Uri.parse('http://wh534614.ispot.cc/buscarcustomer.php?comercio=MoritasPet&'
//         'email=$email'),
//     headers: <String, String>{
//       'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
//     },
//   );
//   print(response.statusCode);
//   if (response.statusCode == 200 || response.statusCode == 201) {
//     // If the server did return a 200 CREATED response,
//     // then parse the JSON.
//     print('respuesta ' + jsonDecode(response.body).toString());
//     return findCustomerFromJson(response.body);
//   } else {
//     // If the server did not return a 201 CREATED response,
//     // then throw an exception.
//     throw Exception('Failed to create album.');
//   }
//}

Future<Cards> EliminarTarjeta(String idCustomer, String idTarjeta) async {
  while (globals.accessToken == "") {
    await request.Claves("Till");
  }
  String accessToken = globals.accessToken;

  final response = await http.delete(
    Uri.parse(
        'https://api.mercadopago.com/v1/customers/$idCustomer/cards/$idTarjeta'),
    headers: <String, String>{
      'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      'Authorization': 'Bearer $accessToken'
    },
  );
  print(response.body.toString());
  if (response.statusCode == 200 || response.statusCode == 201) {
    // If the server did return a 200 CREATED response,
    // then parse the JSON.
    print('respuesta ' + jsonDecode(response.body).toString());
    return Cards.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Fallo el Delete.');
  }
}

Future<CreateCustomer> crearCustomer(Datos customerDatos) async {
  while (globals.accessToken == "") {
    await request.Claves("Till");
  }
  String accessToken = globals.accessToken;

  final response = await http.post(
    Uri.parse('https://api.mercadopago.com/v1/customers/'),
    headers: <String, String>{
      'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      'Authorization': 'Bearer $accessToken'
    },
    body: jsonEncode(customerDatos),
  );
  print(jsonEncode(customerDatos));
  print(">> " + response.body.toString());
  print(response.statusCode);
  if (response.statusCode == 200 || response.statusCode == 201) {
    // If the server did return a 200 CREATED response,
    // then parse the JSON.
    print('respuesta ' + jsonDecode(response.body).toString());
    CreateCustomer c = CreateCustomer.fromJson(jsonDecode(response.body));
    return c;
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Fallo la creacion de customer.');
  }
}

Future<ResponsePayment2> CrearPago(Payment payment) async {

  while (globals.accessTokenComercio == "") {
    await request.ClavesComercio(globals.accessTokenComercio);
  }

  final response = await http.post(
    Uri.parse('https://api.mercadopago.com/v1/payments?'),
    headers: <String, String>{
      'Authorization': 'Bearer '+ globals.accessTokenComercio,
      'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
    },
    body: jsonEncode(payment),
  );
  print(response.statusCode);
  debugPrint(response.body);
  Clipboard.setData(ClipboardData(text: response.body));
  if (response.statusCode == 200 || response.statusCode == 201) {

    //print(response.body);

    return ResponsePayment2.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Fallo la creacion del pago.');
  }
}

Future<String> _actualizarCustomerDB(String customer, String correo) async {
  Map datos = new Map<String, String>();
  datos["customer"] = customer;
  datos["email"] = correo;

  final response = await http.post(
    Uri.parse(
        'http://wh534614.ispot.cc/mypetshop/flutter/guardarCustomer.php?'),
    body: datos,
  );
  print("datos a actualizar: " + datos.toString());
  return response.body.toString();
}

Future<cuotas.Cuotas> Cuotas(String bin, String total) async {
  Map map = new Map<String, dynamic>();
  map['bin'] = bin;
  map['total'] = total;
  if (globals.accessToken == "") {
    Credenciales cred = await Claves('MoritasPet');
    globals.accessToken = cred.accessToken.toString();
    map['access_token'] = cred.accessToken.toString();
  } else {
    map['access_token'] = globals.accessToken;
  }

  final response = await http.post(
    Uri.parse('http://wh534614.ispot.cc/mypetshop/flutter/cuotas.php?'),
    headers: <String, String>{
      'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
    },
    body: map,
  );
  print(response.statusCode);
  if (response.statusCode == 200 || response.statusCode == 201) {
    // If the server did return a 200 CREATED response,
    // then parse the JSON.
    print('map ' + map.values.toString());
    print('CUOTAS ' + jsonDecode(response.body).toString());
    return cuotas.Cuotas.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to create album.');
  }
}


Future<Credenciales> Claves(String usuario) async { ///// TILL
  Map map = new Map<String, dynamic>();
  map['usuario'] = usuario;

  final response = await http.post(
    Uri.parse('http://wh534614.ispot.cc/credenciales.php'),
    headers: <String, String>{
      'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
    },
    body: map,
  );
  print(response.statusCode);
  if (response.statusCode == 200) {
    // If the server did return a 200 CREATED response,
    // then parse the JSON.
    print('credenciales ' + jsonDecode(response.body).toString());
    Credenciales cred = Credenciales.fromJson(jsonDecode(response.body));
    globals.accessToken = cred.accessToken!;
    globals.publicKey = cred.publicKey!;
    return cred;
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to create album.');
  }
}
Future<Credenciales> ClavesComercio(String usuario) async {

  print('comercio $usuario');
  ///// TILL
  Map map = new Map<String, dynamic>();
  map['usuario'] = usuario;

  final response = await http.post(
    Uri.parse('http://wh534614.ispot.cc/credenciales.php'),
    headers: <String, String>{
      'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
    },
    body: map,
  );
  print(response.statusCode);
  if (response.statusCode == 200) {
    // If the server did return a 200 CREATED response,
    // then parse the JSON.
    print('credencialesComercio ' + jsonDecode(response.body).toString());
    Credenciales cred = Credenciales.fromJson(jsonDecode(response.body));
    globals.accessTokenComercio = cred.accessToken!;
    globals.publicKeyComercio = cred.publicKey!;
    return cred;
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to create album.');
  }
}

Future<String> CargarCompra(db.Compra c)
     async {

  String query = "INSERT INTO `COMPRAS`(`fecha`, `cliente`, `productos`,"
      " `total`, `pago`, `estado`, `tarjeta`, `idPago`, `documento`, `token`,"
      " `cuotas`, `montoCuota`, `totalCuota`, `detalle`) "
      "VALUES ('"+c.fecha+"','"+c.cliente.toString()+"','"+c.productos+"','"+
      c.total+"','"+c.pago.toString()+"','"+c.estado.toString()+"','"+
      c.tarjeta.toString()+"','"+ c.idPago.toString()+"','"+c.documento.toString()+
      "','"+c.token.toString()+"','"+ c.cuotas.toString()+"','"+
      c.montoCuota.toString()+"','"+c.totalCuota.toString()+
      "','"+c.detalle.toString()+"')";

  Map map = new Map<String, dynamic>();
  map['query'] = query;

  final response = await http.get(
    Uri.parse('http://wh534614.ispot.cc/cargarcompra.php?query=$query'),
    headers: <String, String>{
      'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
    }
  );

  print('cargar >> $query');

  print(response.statusCode);
  if (response.statusCode == 200 || response.statusCode == 201) {
    // If the server did return a 200 CREATED response,
    // then parse the JSON.
    print('cergar compra: ' + response.body);
    return response.body;
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to create album.');
  }
}

Future<String> ConsultarIdCompra(db.Compra c)
async {

  String query = "SELECT * FROM `COMPRAS` WHERE `fecha`='"+c.fecha+
      "' AND `cliente`='"+c.cliente.toString()+"'";

  print('consultarid: $query');

  Map map = new Map<String, dynamic>();
  map['query'] = query;

  final response = await http.get(
      Uri.parse('http://wh534614.ispot.cc/consultaridcompra.php?query=$query'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      }
  );
  print(response.statusCode);
  if (response.statusCode == 200 || response.statusCode == 201) {

    db.Compra compra = db.Compra.fromJson(jsonDecode(response.body));
    print('id de la compra: ' + compra.id);
    return compra.id;
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to create album.');
  }
}