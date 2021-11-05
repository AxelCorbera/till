import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:till/scripts/mercadopago/json/baseDatos.dart';
import 'package:till/scripts/request.dart';
import 'package:till/globals.dart' as globals;

class Purchases extends StatefulWidget {
  @override
  _PurchasesState createState() => _PurchasesState();
}

class _PurchasesState extends State<Purchases> {
  bool filtroTodos = true;
  bool filtroApro = false;
  bool filtroRecha = false;
  String menu = 'home';
  bool busqueda = true;
  Compras compras = new Compras(
      id: [],
      fecha: [],
      cliente: [],
      productos: [],
      total: [],
      estado: [],
      tarjeta: [],
      pago: [],
      idPago: [],
      documento: [],
      token: [],
      cuotas: [],
      montoCuota: [],
      totalCuota: [],
      detalle: [],
      telefono: []);
  int carrito = globals.carrito.id.length;
  @override
  Widget build(BuildContext context) {
    Uint8List bytes;

    // if (!request) {
    //   _buscaritems(widget.categoria, widget.marca, widget.busqueda as String);
    // }
    filtroTodos
        ? _buscarCompras("")
        : filtroApro
            ? _buscarCompras("aprobado")
            : _buscarCompras("rechazado");
    print("KKKKK " + busqueda.toString());
    carrito = globals.carrito.id.length;
    return Scaffold(
      appBar: appbar("Ultimas compras"),
      body: !busqueda
          ? Stack(children: <Widget>[
              Container(
                //color: Colors.red,
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.all(5),
                width: double.infinity,
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        if(filtroTodos == false) {
                          busqueda = true;
                          filtroTodos = true;
                          filtroApro = false;
                          filtroRecha = false;
                          setState(() {});
                        }
                      },
                      child: Container(
                          // optional
                          padding: const EdgeInsets.all(5),
                          decoration: filtroTodos
                              ? BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          width: 2.0,
                                          color:
                                              Theme.of(context).primaryColor)))
                              : null,
                          child: Text('Todos')),
                    ),
                    Text("|",
                        style: TextStyle(
                          color: Colors.grey,
                        )),
                    GestureDetector(
                      onTap: () {
                        if(filtroApro == false) {
                          busqueda = true;
                          filtroTodos = false;
                          filtroApro = true;
                          filtroRecha = false;
                          setState(() {});
                        }
                      },
                      child: Container(
                          // optional
                          padding: const EdgeInsets.all(5),
                          decoration: filtroApro
                              ? BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          width: 2.0,
                                          color:
                                              Theme.of(context).primaryColor)))
                              : null,
                          child: Text('Aprobados')),
                    ),
                    Text("|",
                        style: TextStyle(
                          color: Colors.grey,
                        )),
                    GestureDetector(
                      onTap: () {
                        if(filtroRecha == false) {
                          busqueda = true;
                          filtroTodos = false;
                          filtroApro = false;
                          filtroRecha = true;
                          setState(() {});
                        }
                      },
                      child: Container(
                          // optional
                          padding: const EdgeInsets.all(5),
                          decoration: filtroRecha
                              ? BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          width: 2.0,
                                          color:
                                              Theme.of(context).primaryColor)))
                              : null,
                          child: Text('Rechazados')),
                    ),
                  ],
                ),
              ),
              Transform(
                transform: Matrix4.translationValues(0, 60, 0),
                child: Container(
                  child: ListView.builder(
                      itemCount: compras.id!.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed('/PurchaseDetails',
                                    arguments: Compra(
                                        id: compras.id![index],
                                        fecha: compras.fecha![index],
                                        cliente: compras.cliente![index],
                                        productos: compras.productos![index],
                                        total: compras.total![index],
                                        pago: compras.pago![index],
                                        estado: compras.estado[index],
                                        tarjeta: compras.tarjeta![index],
                                        idPago: compras.idPago![index],
                                        documento: compras.documento![index],
                                        token: compras.token![index],
                                        cuotas: compras.cuotas![index],
                                        montoCuota: compras.montoCuota![index],
                                        totalCuota: compras.totalCuota![index],
                                        detalle: compras.detalle![index],
                                        telefono: compras.telefono![index]))
                                .then((value) => setState(() {}));
                          },
                          child: Hero(
                            tag: compras.id!.length,
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.all(0),
                                  child: Card(
                                    margin: EdgeInsets.all(0),
                                    color: Colors.white60,
                                    semanticContainer: true,
                                    child: Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Center(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Container(
                                                    width: 0,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        compras.estado[index] ==
                                                                    "approved" ||
                                                                compras.estado[
                                                                        index] ==
                                                                    "pagado"
                                                            ? Icon(
                                                                Icons.error_outline,
                                                                color: Colors
                                                                    .green[700],
                                                                size: 15,
                                                              )
                                                            : Icon(
                                                            Icons.error_outline,
                                                                color: Colors
                                                                    .red[700],
                                                                size: 15),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 150,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Compra " +
                                                              compras
                                                                  .id![index],
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        SizedBox(
                                                          height: 4,
                                                        ),compras.estado[index]=="approved"?
                                                        Text(
                                                          "Aprobado",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ):compras.estado[index]=="rejected"?
                                                  Text(
                                                    "Rechazado",
                                                    style: TextStyle(
                                                        color:
                                                        Colors.grey,
                                                        fontSize: 12,
                                                        fontWeight:
                                                        FontWeight
                                                            .bold)):Text("Error: "+ compras.estado[index],
                                                    style: TextStyle(
                                                        color:
                                                        Colors.grey,
                                                        fontSize: 12,
                                                        fontWeight:
                                                        FontWeight
                                                            .bold)),
                                                      ],
                                                    ),
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        "\$" +
                                                            compras
                                                                .total![index],
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      SizedBox(
                                                        height: 4,
                                                      ),
                                                      Text(
                                                        compras.fecha![index],
                                                        style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: new Divider(
                                    endIndent: 20,
                                    indent: 20,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              ),
            ])
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  AppBar appbar(String title) {
    return AppBar(
        title: Text(title),
        backgroundColor: Theme.of(context).primaryColor,
        actions: <Widget>[
          RaisedButton(
            color: Theme.of(context).primaryColor,
            elevation: 0,
            onPressed: () {
              Navigator.of(context)
                  .pushNamed('/Cart')
                  .then((value) => setState(() {}));
            },
            child: Row(
              children: [
                Icon(
                  Icons.shopping_cart,
                  size: 30,
                  color: Colors.white,
                ),
                if (carrito > 0)
                  Center(
                    child: Container(
                      width: 25,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                      ),
                      child: Center(
                          child: Text(
                        carrito.toString(),
                        style: TextStyle(fontSize: 22, color: Colors.white),
                      )),
                    ),
                  ),
              ],
            ),
          )
        ]);
  }

  void _buscarCompras(String filtro) async {
    if (busqueda) {
      print("usuario>> " + globals.usuario!.id.toString());
      compras = await BuscarCompras(globals.usuario!.id.toString());
      if (filtro != "") {
        Compras filtroCompra = new Compras(
            id: [],
            fecha: [],
            cliente: [],
            productos: [],
            total: [],
            estado: [],
            tarjeta: [],
            pago: [],
            idPago: [],
            documento: [],
            token: [],
            cuotas: [],
            montoCuota: [],
            totalCuota: [],
            detalle: [],
            telefono: []);

        if (filtro == "aprobado") {
          for (var i in compras.estado) {
            if (i == "approved" || i == "pagado") {
              int a = compras.estado.indexOf(i);
              filtroCompra.id!.add(compras.id![a]);
              filtroCompra.fecha!.add(compras.fecha![a]);
              filtroCompra.cliente!.add(compras.cliente![a]);
              filtroCompra.productos!.add(compras.productos![a]);
              filtroCompra.total!.add(compras.total![a]);
              filtroCompra.estado.add(compras.estado[a]);
              filtroCompra.tarjeta!.add(compras.tarjeta![a]);
              filtroCompra.pago!.add(compras.pago![a]);
              filtroCompra.documento!.add(compras.documento![a]);
              filtroCompra.token!.add(compras.token![a]);
              filtroCompra.cuotas!.add(compras.cuotas![a]);
              filtroCompra.montoCuota!.add(compras.montoCuota![a]);
              filtroCompra.totalCuota!.add(compras.totalCuota![a]);
              filtroCompra.idPago!.add(compras.idPago![a]);
              filtroCompra.detalle!.add(compras.detalle![a]);
              filtroCompra.telefono!.add(compras.telefono![a]);
            }
          }
        } else {
          for (var i in compras.estado) {
            if (i != "approved" && i != "pagado") {
              int a = compras.estado.indexOf(i);
              filtroCompra.id!.add(compras.id![a]);
              filtroCompra.fecha!.add(compras.fecha![a]);
              filtroCompra.cliente!.add(compras.cliente![a]);
              filtroCompra.productos!.add(compras.productos![a]);
              filtroCompra.total!.add(compras.total![a]);
              filtroCompra.estado.add(compras.estado[a]);
              filtroCompra.tarjeta!.add(compras.tarjeta![a]);
              filtroCompra.pago!.add(compras.pago![a]);
              filtroCompra.documento!.add(compras.documento![a]);
              filtroCompra.token!.add(compras.token![a]);
              filtroCompra.cuotas!.add(compras.cuotas![a]);
              filtroCompra.montoCuota!.add(compras.montoCuota![a]);
              filtroCompra.totalCuota!.add(compras.totalCuota![a]);
              filtroCompra.idPago!.add(compras.idPago![a]);
              filtroCompra.detalle!.add(compras.detalle![a]);
              filtroCompra.telefono!.add(compras.telefono![a]);
            }
          }
        }
        compras = filtroCompra;
      }
      busqueda = false;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
  }

  MemoryImage _imagen(String imagen) {
    var bytes = base64.decode(imagen);
    return new MemoryImage(bytes);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
