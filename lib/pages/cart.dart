import 'package:flutter/material.dart';
import 'package:till/constants/themes.dart';
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("Mi Carrito"),
      ),
      body: Container(
        constraints: BoxConstraints(
          minHeight: 2000,
          minWidth: double.infinity,
        ),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/assets/images/fondoClaro.jpg"),
            fit: BoxFit.fitWidth,
          ),
        ),
        child: Column(children: <Widget>[
          Center(
            child: Card(
              color: Theme.of(context).primaryColor,
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              margin: EdgeInsets.all(10),
              child: Container(
                  margin: EdgeInsets.all(15),
                  width: 315,
                  height: 320,
                  child: ListView.builder(
                        itemCount: globals.carrito.id.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: (){
                              _editarProducto(
                                  globals.carrito.nombre[index].toString(),
                                globals.carrito.descuento![index].toString(),
                                globals.carrito.precio[index],
                                globals.carrito.cantidad[index],
                                index
                              );
                            },
                            child: Container(
                              height: 60,
                              margin: EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          globals.carrito.cantidad[index].toString(),
                                          style: TextStyle(
                                              color:
                                                  Theme.of(context).primaryColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          globals.carrito.nombre[index].toString(),
                                          style: TextStyle(
                                            color: Theme.of(context).primaryColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 11,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        Text(
                                          '#descuento',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          globals.carrito.precio[index].toString(),
                                          style: TextStyle(
                                              color: Colores.rojo,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                    }
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total: ",
                      style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '\$' + total.toStringAsFixed(2),
                      style: TextStyle(
                          fontSize: 20,
                          color: Colores.rojo,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                RaisedButton(
                  onPressed: globals.carrito.id.length>0?() {
                    Navigator.of(context).pushNamed('/InfoPayment');
                  }:
                  (){},
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6)),
                  padding: const EdgeInsets.all(0.0),
                  child: Ink(
                    width: 160,
                    height: 35,
                    decoration: globals.carrito.id.length>0? BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          colors: Colores.combinacion1),
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                    ):
                    null,
                    child: Container(
                      constraints:
                      const BoxConstraints(minWidth: 88.0, minHeight: 45.0),
                      // min sizes for Material buttons
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Finalizar compra',
                            style: TextStyle(color: Colors.white, fontSize: 15,
                            fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Image.asset(
              "lib/assets/images/nenito_lista.png",
              width: 280,
            ),
          ),
        ]),
      ),
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

  void _editarProducto(String nombre, String descuento, double precio, int cantidad, int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (context, setState){
                return AlertDialog(
                  content: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(nombre.toString(),
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold
                            ),),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('#descuento',
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('\$ ' + precio.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20
                            ),),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              IconButton(onPressed: (){
                                setState((){
                                  if(cantidad>1)
                                    cantidad--;
                                });
                              }, icon: Icon(Icons.remove,
                              color: Theme.of(context).primaryColor,)),
                              Container(
                                height: 32,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Center(
                                  child: Text(cantidad.toString(),
                                    style: TextStyle(
                                        fontSize: 20,
                                      color: Colors.white,
                                    ),),
                                ),
                              ),
                              IconButton(onPressed: (){
                                setState((){
                                  cantidad++;
                                });
                              }, icon: Icon(Icons.add,
                                color: Theme.of(context).primaryColor,)),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            FlatButton(
                              child: Text("Cancelar",
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor
                                ),),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            RaisedButton(
                              onPressed: () {
                                globals.carrito.cantidad[index] = cantidad;
                                Navigator.pop(context);
                                _actualizar();
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6)),
                              padding: const EdgeInsets.all(0.0),
                              child: Ink(
                                width: 100,
                                height: 35,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.bottomLeft,
                                      end: Alignment.topRight,
                                      colors: Colores.combinacion1),
                                  borderRadius: BorderRadius.all(Radius.circular(6)),
                                ),
                                child: Container(
                                  constraints:
                                  const BoxConstraints(minWidth: 88.0, minHeight: 45.0),
                                  // min sizes for Material buttons
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Aceptar',
                                        style: TextStyle(color: Colors.white, fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        FlatButton(
                          child: Text("Eliminar producto",
                            style: TextStyle(
                                color: Colores.rojo
                            ),),
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
                            _actualizar();
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }
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

  void _actualizar() {
    setState(() {

    });
  }
}
