import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:till/scenes/items.dart';
import 'package:till/globals.dart' as globals;
import 'package:url_launcher/url_launcher.dart';

class Item extends StatefulWidget {
  const Item({Key? key, required this.item}) : super(key: key);
  static const routeName = '/Item';
  final Marca item;

  @override
  _itemState createState() => _itemState();
}

class _itemState extends State<Item> with TickerProviderStateMixin {
  bool cant = false;
  int carrito = globals.carrito.id.length;
  final _scaffKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    print("> " + cant.toString());
    return Scaffold(
      key: _scaffKey,
      backgroundColor: Colors.white38,
      appBar: appbar("Producto"),
      body: Center(
        child: Hero(
          tag: widget.item.id,
          child: Card(
            margin: EdgeInsets.only(left: 15, right: 15, top: 25, bottom: 25),
            color: Colors.grey[200],
            elevation: 20,
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: cardConteiner(widget.item, context),
            ),
          ),
        ),
      ),
    );
  }

//   void toggleIcon()=> setState((){
// isPlaying = !isPlaying;
// isPlaying ? controller.forward() : controller.reverse();
//   });
  // ANIMATIONICON

  Widget cardConteiner(Marca item, BuildContext context) {
    AnimationController controller = AnimationController(
      vsync: this,
    );
    return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Center(
            child: FadeInImage(
              image: _imagen(item.imagen),
              height: 200,
              fit: BoxFit.fill,
              placeholder: AssetImage("lib/assets/images/loader.gif"),
              fadeInCurve: Curves.decelerate,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  item.nombre,
                  style: TextStyle(fontSize: 25),
                ),
              ),
              ListView(
                padding: const EdgeInsets.all(20.0),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: <Widget>[
                  if (item.cantidad != "0")
                    Text("Producto de " +
                        item.cantidad +
                        " Kg.\n\n"
                            "~Consultar stock antes de comprar~"),
                ],
              ),
              Text('Precio: \$ ' + item.precio.toStringAsFixed(2),
                  style: TextStyle(fontSize: 20)),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  RaisedButton.icon(
                      icon: Icon(Icons.chat),
                      label: Text(
                        'Consultar Stock',
                      ),
                      onPressed: () {
                        if (globals.login) {
                          _consulta(item.nombre, item.marca, item.cantidad);
                        } else {
                          _unlogin(context);
                        }
                      }),
                  RaisedButton.icon(
                      icon: Icon(Icons.add_shopping_cart),
                      label: Text('Agregar al carrito'),
                      onPressed: () {
                        if (globals.login) {
                          _showDialog(context,1);
                        } else {
                          _unlogin(context);
                        }
                      }),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
        ]);
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

  void _unlogin(BuildContext context) {
    GlobalKey keyText = GlobalKey<EditableTextState>();
    final _textFieldController = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text("Debes iniciar sesion"),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RaisedButton(
                        child: Text("Aceptar"),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                    RaisedButton(
                        child: Text("Iniciar sesion"),
                        onPressed: () {
                          Navigator.of(context).pushNamed('/');
                        }),
                  ],
                ),
              ],
            ),
          );
        });
  }

  void _showDialog(BuildContext context, int cant) {
    GlobalKey keyText = GlobalKey<EditableTextState>();
    final _textFieldController = TextEditingController();
    int cantidad = cant;
    _textFieldController.text = cantidad.toString();
    showDialog(
        context: context,
        builder: (BuildContext context)
    {
      String contentText = "Content of Dialog";
      return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              content: Stack(
                overflow: Overflow.visible,
                children: <Widget>[
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Center(
                          child: Text(
                            '¿Cuantas unidades quieres llevar?',
                            style: TextStyle(fontSize: 20),
                            textAlign: TextAlign.center,
                          )),
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          RaisedButton(
                          shape: CircleBorder(
                            side: BorderSide.none
                          ),
                              onPressed: () {
                            if (cantidad > 1)
                              setState(() {
                                cantidad--;
                              });
                          },
                              child: Icon(Icons.remove),),
                          Text(cantidad.toString(),
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold
                          ),),
                          RaisedButton(
                            shape: CircleBorder(
                                side: BorderSide.none
                            ),
                            onPressed: () {
                                setState(() {
                                  cantidad++;
                                });
                            },
                            child: Icon(Icons.add),),

                          // TextFormField(
                          //   controller: _textFieldController,
                          //   keyboardType: TextInputType.number,
                          //   decoration: InputDecoration(
                          //     labelText: 'cantidad',
                          //   ),
                          //   validator: (String? value) {
                          //     return value!.isEmpty
                          //         ? 'El campo esta vacio'
                          //         : value == "0"
                          //             ? 'Seleccione una cantidad valida'
                          //             : value.contains(',') ||
                          //                     value.contains('.') ||
                          //                     value.contains('-') ||
                          //                     value.contains(' ')
                          //                 ? 'Seleccione una cantidad valida'
                          //                 : null;
                          //   },
                          // ),
                        ],
                      ),
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RaisedButton(
                              child: Text("Cancelar"),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RaisedButton(
                              child: Text("Agregar"),
                              onPressed: () {
                                  setState(() {
                                    _agregarProducto(
                                        widget.item, cantidad.toString());
                                    _mostrarMensaje("El producto se ha añadido!");
                                    Navigator.pop(context);
                                    carrito = globals.carrito.id.length;
                                  });
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            );
          });
    });
  }

  @override
  void initState() {
    super.initState();

    // controller = AnimationController(
    //   vsync: this,
    //   duration: Duration(milliseconds: 1000),
    // );
  }

  @override
  void dispose() {
    super.dispose();
  }

  MemoryImage _imagen(String imagen) {
    var bytes = base64.decode(imagen);
    return new MemoryImage(bytes);
  }

  void _agregarProducto(Marca item, String cant) {
    if (globals.carrito.marca.contains(item.marca)) {
      int i = globals.carrito.marca.indexOf(item.marca);
      if (globals.carrito.id[i] == item.id &&
          globals.carrito.nombre[i] == item.nombre) {
        var cant1 = int.parse(globals.carrito.cantidad[i]);
        var cant2 = int.parse(cant);
        var total = cant1 + cant2;
        print('total: $total');
        globals.carrito.cantidad[i] = total.toString();
      } else {
        globals.carrito.id.add(widget.item.id);
        globals.carrito.codigo.add(widget.item.codigo);
        globals.carrito.marca.add(widget.item.marca);
        globals.carrito.nombre.add(widget.item.nombre);
        globals.carrito.cantidad.add(cant);
        globals.carrito.stock.add(widget.item.stock);
        globals.carrito.precio.add(widget.item.precio);
        globals.carrito.imagen.add(widget.item.imagen);
        globals.carrito.tamano!.add(widget.item.tamano);
        globals.carrito.color.add(widget.item.color);
      }
    } else {
      globals.carrito.id.add(widget.item.id);
      globals.carrito.codigo.add(widget.item.codigo);
      globals.carrito.marca.add(widget.item.marca);
      globals.carrito.nombre.add(widget.item.nombre);
      globals.carrito.cantidad.add(cant);
      globals.carrito.stock.add(widget.item.stock);
      globals.carrito.precio.add(widget.item.precio);
      globals.carrito.imagen.add(widget.item.imagen);
      globals.carrito.tamano!.add(widget.item.tamano);
      globals.carrito.color.add(widget.item.color);
    }

    setState(() {

    });
  }

  void _mostrarMensaje(String msg) {
    SnackBar snackBar = SnackBar(
      duration: Duration(seconds: 1),
      backgroundColor: Colors.greenAccent,
      content: Text(
        msg,
        style: TextStyle(color: Colors.black),
      ),
    );
    _scaffKey.currentState!.showSnackBar(snackBar);
  }

  void _consulta(String name, String marca, String kg) async{
    //String texto = '¡Hola!,%20Queria%20consultar%20info/stock%20de%20$marca%20$name%20$kg%20kg';
    var url = "https://api.whatsapp.com/send?phone=541151070587&text=Hola,%20Queria%20consultar%20info/stock%20de%20$marca%20$name%20$kg%20kg";
    //var url ="https://google.com";
    if (await canLaunch(url))
    await launch(url);
    else
    // can't launch url, there is some error
    throw "Could not launch $url";
  }
}
