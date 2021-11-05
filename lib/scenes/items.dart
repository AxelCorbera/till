import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:till/scripts/request.dart';
import 'package:till/globals.dart' as globals;

class Items extends StatefulWidget {
  const Items(
      {Key? key, required this.categoria, required this.marca, this.busqueda})
      : super(key: key);

  @override
  final String categoria;
  final String marca;
  final String? busqueda;

  _ItemsState createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  String menu = 'home';
  bool request = false;
  int carrito = globals.carrito.id.length;
  @override
  Widget build(BuildContext context) {
    Uint8List bytes;

    // if (!request) {
    //   _buscaritems(widget.categoria, widget.marca, widget.busqueda as String);
    // }
    carrito = globals.carrito.id.length;
    return Scaffold(

      appBar: appbar(widget.marca),
      body: FutureBuilder(
          future: Buscaritems(
              widget.categoria, widget.marca, widget.busqueda as String),
          builder: (BuildContext context, AsyncSnapshot<Marcas> snapshot) {
            if (snapshot.hasData && snapshot.data!.id.length > 0) {
              print(snapshot.data!.id.length);
              return GridView.count(
                // crossAxisCount is the number of columns
                crossAxisCount: 2,
                // This creates two columns with two items in each column
                children: List.generate(snapshot.data!.id.length, (index) {
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed('/Item',
                          arguments: Marca(
                              snapshot.data!.id[index],
                              snapshot.data!.codigo[index],
                              snapshot.data!.marca[index],
                              snapshot.data!.nombre[index],
                              snapshot.data!.cantidad[index],
                              snapshot.data!.stock[index],
                              snapshot.data!.precio[index],
                              snapshot.data!.imagen[index],
                              snapshot.data!.tamano![index],
                              snapshot.data!.color[index])).then((value) => setState((){}));
                    },
                    child: Hero(
                      tag: snapshot.data!.id[index],
                      child: Container(
                        margin: EdgeInsets.all(5),
                        child: Card(
                          color: Colors.white60,
                          semanticContainer: true,
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  FadeInImage(
                                    image: _imagen(snapshot.data!.imagen[index]),
                                    height: 120,
                                    placeholder: AssetImage(
                                        "lib/assets/images/loader.gif"),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Center(
                                    child: Text(
                                      snapshot.data!.nombre[index],
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 0,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: <Widget>[
                                      if (widget.categoria == 'alimentoPerro' ||
                                          widget.categoria == 'alimentoGato')
                                        Text(
                                          snapshot.data!.cantidad[index] + " Kg",
                                          style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      Text(
                                        "\$ " +
                                            snapshot.data!.precio[index].toString(),
                                        style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          elevation: 5.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                  );
                }),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
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
              Navigator.of(context).pushNamed('/Cart').then((value) => setState((){}));
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

  @override
  void initState() {
    super.initState();
    // new Future.delayed(Duration.zero, () {
    //   showDialog(
    //       context: context,
    //       builder: (BuildContext context) {
    //         return Center(
    //             child: new Container(
    //           child: CircularProgressIndicator(color: Colors.blueAccent),
    //         ));
    //       });
    // });
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

class Marca {
  final String id;
  final String codigo;
  final String marca;
  final String nombre;
  final String cantidad;
  final String stock;
  final dynamic precio;
  final String imagen;
  final String tamano;
  final String color;

  Marca(this.id, this.codigo, this.marca, this.nombre, this.cantidad,
      this.stock, this.precio, this.imagen, this.tamano, this.color);
}
