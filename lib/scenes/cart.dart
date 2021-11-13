import 'package:flutter/material.dart';
import 'package:till/globals.dart' as globals;

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  double total = 0;
  bool editar = false;
  Widget build(BuildContext context) {
    total = Sumar(globals.carrito.precio, globals.carrito.cantidad);
    return Scaffold(
      backgroundColor: Colors.white38,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("Mi Carrito"),
        actions: <Widget>[
          RaisedButton.icon(
            elevation: 0,
            color: Colors.transparent,
            icon: Icon(
              editar ? Icons.done : Icons.edit,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                editar = !editar;
              });
            },
            label: Text(''),
          ),
        ],
      ),
      body: Column(children: <Widget>[
        Center(
          child: Card(
            elevation: 5,
            margin: EdgeInsets.all(10),
            child: Container(
                width: 375,
                height: 450,
                child: ListView.builder(
                    itemCount: globals.carrito.id.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Text(globals.carrito.cantidad[index].toString()),
                        title: Text(
                          globals.carrito.marca[index].toString() +
                              " " +
                              globals.carrito.nombre[index].toString(),
                          textAlign: TextAlign.start,
                        ),
                        trailing: editar
                            ? ButtonBar(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  IconButton(
                                      onPressed: () {
                                        int i =
                                            globals.carrito.cantidad[index];
                                        i++;
                                        globals.carrito.cantidad[index] =
                                            i;
                                        setState(() {});
                                      },
                                      icon: Icon(Icons.add)),
                                  IconButton(
                                      onPressed: () {
                                        int i =
                                            globals.carrito.cantidad[index];
                                        if (i > 1) {
                                          i--;
                                        } else {
                                          _eliminarArticulo(index);
                                          setState(() {});
                                        }
                                        setState(() {});
                                        globals.carrito.cantidad[index] =
                                            i;
                                      },
                                      icon: Icon(Icons.remove))
                                ],
                              )
                            : Text(globals.carrito.precio[index].toString()),
                      );
                    })),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            "Total: " + total.toStringAsFixed(2),
            style: TextStyle(
                fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton.icon(
                  onPressed: total>0?() {
                    Navigator.of(context).pushNamed('/InfoPayment');
                  }:null,
                  icon: Icon(Icons.navigate_next),
                  label: Text("Finalizar compra"))
            ],
          ),
        )
      ]),
    );
  }

  void _eliminarArticulo(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Desea eliminar el articulo?',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(globals.carrito.marca[index] +
                    ' ' +
                    globals.carrito.nombre[index]),
                SizedBox(
                  height: 20,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    RaisedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancelar')),
                    RaisedButton.icon(
                        onPressed: () {
                          globals.carrito.id.removeAt(index);
                          globals.carrito.codigo.removeAt(index);
                          globals.carrito.marca.removeAt(index);
                          globals.carrito.nombre.removeAt(index);
                          globals.carrito.cantidad.removeAt(index);
                          globals.carrito.stock.removeAt(index);
                          globals.carrito.precio.removeAt(index);
                          globals.carrito.imagen.removeAt(index);
                          globals.carrito.descuento!.removeAt(index);
                          globals.carrito.tope.removeAt(index);
                          Navigator.pop(context);
                          setState(() {});
                        },
                        icon: Icon(Icons.done),
                        label: Text('Eliminar')),
                  ],
                )
              ],
            ),
          );
        });
  }

  dynamic Sumar(List<dynamic> lista, List<int> lista2) {
    double total = 0;
    lista.forEach((p) {
      int i = lista.indexOf(p);
      double t = p * lista2[i];
      total = total + t;
    });
    return total;
  }
}
