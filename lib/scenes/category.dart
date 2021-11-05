import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:till/scripts/request.dart';
import 'package:till/globals.dart' as globals;

import '../Home.dart';

class Category extends StatefulWidget {
  const Category({Key? key, required this.categoria}) : super(key: key);
  final String categoria;

  @override
  _categoryState createState() => _categoryState();
}

class _categoryState extends State<Category> {
  List<String> marca = <String>[];
  GlobalKey<ScaffoldState> _keyScaf = GlobalKey();
  int carrito = globals.carrito.id.length;
  @override
  Widget build(BuildContext context) {
    carrito = globals.carrito.id.length;
    if (widget.categoria == "Alimentos") {
      return _scaff(context, widget.categoria, marca);
    } else {
      return Scaffold(
        body: FutureBuilder(
          future: BuscarCategoria(widget.categoria),
          builder:
              (BuildContext context, AsyncSnapshot<List<String>> snapshop) {
            if (snapshop.hasData) {
              return _scaff(context, widget.categoria, snapshop.data!);
            } else {
              return Scaffold(
                  appBar: appbar(widget.categoria),
                  body: Center(
                    child: CircularProgressIndicator(),
                  ));
            }
          },
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  static Route<Object?> _dialogBuilder(BuildContext context) {
    return DialogRoute<void>(
      context: context,
      builder: (BuildContext context) =>
          const AlertDialog(title: Text('Material Alert!')),
    );
  }

  Widget _scaff(BuildContext context, String categoria, List<String> marcas) {
    @override
    List<String> categoriasNombres = [
      'Alimento perro',
      'Alimento gato',
      'cereales'
    ];
    List<String> categoriasIconos = [
      'lib/assets/icons/dogFood.png',
      'lib/assets/icons/catFood.png',
      'lib/assets/icons/dog-food-pet.png'
    ];
    if (categoria == "Alimentos") {
      return Scaffold(
        key: _keyScaf,
        //extendBodyBehindAppBar: true, //backgroundColor de APPBARR tiene que ser BLACK12
        appBar: appbar(categoria),
        body: GridView.count(
          // crossAxisCount is the number of columns
          crossAxisCount: 2,
          // This creates two columns with two items in each column
          children: List.generate(categoriasNombres.length, (index) {
            return InkWell(
              onTap: () {
                String categ = "";
                if (categoriasNombres[index] == "Alimento perro") {
                  categ = "alimentoPerro";
                } else if (categoriasNombres[index] == "Alimento gato") {
                  categ = "alimentoGato";
                } else {
                  categ = "cereales";
                }
                Navigator.of(context)
                    .pushNamed('/Category', arguments: argumentsHome(categ)).then((value) => setState((){}));
                // print('envia ' + categoriasNombres[index].toString());
              },
              child: Hero(
                tag: categoriasNombres[index],
                child: Column(children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(5),
                    child: Card(
                      color: Colors.white60,
                      semanticContainer: true,
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              FadeInImage(
                                image: AssetImage(categoriasIconos[index]),
                                height: 120,
                                placeholder:
                                    AssetImage("lib/assets/images/loader.gif"),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Center(
                                child: Text(
                                  categoriasNombres[index],
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
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
                ]),
              ),
            );
          }),
        ),
      );
    } else {
      // CUANDO NO ES ALIMENTO
      return Scaffold(
        //extendBodyBehindAppBar: true, //backgroundColor de APPBARR tiene que ser BLACK12
        appBar: appbar(categoria),
        body: ListView.builder(
            itemCount: marcas.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed('/Items',
                      arguments: argumentsItems(categoria, marcas[index], "")).then((value) => setState((){}));
                },
                child: Hero(
                  tag: marcas[index],
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.all(3),
                        child: Card(
                          color: Colors.white60,
                          semanticContainer: true,
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Center(
                                    child: Text(
                                      marcas[index],
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
      );
    }
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
}

class argumentsItems {
  final String categoria;
  final String marca;
  final String? busqueda;

  argumentsItems(this.categoria, this.marca, this.busqueda);
}
