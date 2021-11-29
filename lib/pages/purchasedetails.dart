import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:till/scripts/mercadopago/json/baseDatos.dart';
import 'package:till/globals.dart' as globals;

class PurchaseDetails extends StatefulWidget {
  const PurchaseDetails({Key? key, required this.compra}) : super(key: key);
  static const routeName = '/Item';
  final Compra compra;

  @override
  _purchaseDetailsState createState() => _purchaseDetailsState();
}

class _purchaseDetailsState extends State<PurchaseDetails>
    with TickerProviderStateMixin {
  bool cant = false;
  int carrito = globals.carrito.id.length;
  final _scaffKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  Datos productos = Datos(items: []);

  @override
  Widget build(BuildContext context) {
    productos = _productos(widget.compra.productos);
    print("> " + cant.toString());
    return Scaffold(
      key: _scaffKey,
      backgroundColor: Colors.white38,
      appBar: appbar("Detalle de la compra"),
      body: Center(
        child: Hero(
          tag: widget.compra.id,
          child: Card(
            margin: EdgeInsets.only(left: 15, right: 15, top: 25, bottom: 25),
            color: Colors.grey[200],
            elevation: 20,
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: cardConteiner(widget.compra, context),
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

  Widget cardConteiner(Compra compra, BuildContext context) {
    DateTime date = DateTime.parse(compra.fecha);
    AnimationController controller = AnimationController(
      vsync: this,
    );
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(children: <Widget>[
        SizedBox(
          height: 20,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Operacion #" + compra.id,
                  style: TextStyle(fontSize: 13),
                ),
                Text(
                  "  ·  Creadada el " +
                      date.day.toString() +
                  '-'+
                  date.month.toString() +
                  '-'+
                  date.year.toString(),
                  style: TextStyle(fontSize: 13),
                ),
              ],
            ),
            Divider(
              height: 50,
              color: Colors.black,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    children: [
                      Text("Cantidad"),
                    ],
                  ),
                  Column(
                    children: [
                      Text("Producto"),
                    ],
                  ),
                  Column(
                    children: [
                      Text("Precio"),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _buildRowList(productos),
            ),
            new Divider(
              height: 50,
              color: Colors.grey,
            ),
            Text('Total: \$ ' + compra.total.toString(),
                style: TextStyle(fontSize: 20)),
          ],
        ),
        new Divider(
          height: 50,
          color: Colors.grey,
        ),
        Container(
          margin: EdgeInsets.all(5),
          alignment: Alignment.centerLeft,
          width: 60,
          height: 40,
          decoration: BoxDecoration(
              image: compra.pago != "" || compra.pago != "efectivo"
                  ? DecorationImage(
                image: new AssetImage(
                    _MetodoPago(compra.pago.toString())),
                fit: BoxFit.contain,
              )
                  : null,
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: [
                    Colors.white70,
                    Colors.transparent
                  ])),
        ),
        Column(
          children: <Widget>[
            compra.pago != "" || compra.pago != "efectivo"
                ?
            Text(" ** terminada en " + compra.tarjeta.toString()+" ** "):
            Text("Efectivo"),
            SizedBox(
              height: 20,
            ),
            Text("#" + compra.id.toString(),style: TextStyle(color: Colors.grey[600]),),
            Text("status > " + compra.estado.toString(),style: TextStyle(color: Colors.grey[600]),),
            Text(compra.fecha.toString() ,style: TextStyle(color: Colors.grey[600]),),
          ],
        )
      ]),
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

  void _showDialog(BuildContext context) {
    GlobalKey keyText = GlobalKey<EditableTextState>();
    final _textFieldController = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Center(
                          child: Text(
                        '¿Cuantas unidades quieres llevar?',
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                      )),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _textFieldController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'cantidad',
                          ),
                          validator: (String? value) {
                            return value!.isEmpty
                                ? 'El campo esta vacio'
                                : value == "0"
                                    ? 'Seleccione una cantidad valida'
                                    : value.contains(',') ||
                                            value.contains('.') ||
                                            value.contains('-') ||
                                            value.contains(' ')
                                        ? 'Seleccione una cantidad valida'
                                        : null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                          child: Text("Agregar"),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              setState(() {
                                // _agregarProducto(
                                //     widget.item, _textFieldController.text);
                                _mostrarMensaje("El producto se ha añadido!");
                                Navigator.pop(context);
                                carrito = globals.carrito.id.length;
                              });
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
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

  List<Widget> _buildRowList(Datos lista) {
    List<Widget> lines = []; // this will hold Rows according to available lines
    for (var line in lista.items) {
      lines.add(Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
          Text(line.cantidad),
          line.nombre.length<30?
          Text(line.nombre):Text(line.nombre.substring(0,25) + "\n" + line.nombre.substring(25,line.nombre.length)),
          Text("\$ " + _precio(line.precio.toString())),
        ]),
      ));
    }
    return lines;
  }

  String _precio(String a){
    double d = double.parse(a);
    return d.toStringAsFixed(2);
  }

  Datos _productos(String prod) {
    print('producto: $prod');
    Datos datos = Datos.fromJson(jsonDecode(prod));
        //datos.fromJson(jsonDecode(prod));
    return datos;
  }

  String _MetodoPago(String id) {
    switch (id) {
      case "diners":
        return 'lib/assets/icons/logosMetodoPago/diners.png';
      case "argencard":
        return 'lib/assets/icons/logosMetodoPago/argencard.jpg';
      case "maestro":
        return 'lib/assets/icons/logosMetodoPago/maestro.png';
      case "debvisa":
        return 'lib/assets/icons/logosMetodoPago/visadebito.jpg';
      case "cencosud":
        return 'lib/assets/icons/logosMetodoPago/cencosud.jpg';
      case "debcabal":
        return 'lib/assets/icons/logosMetodoPago/cabalDebito.jpg';
      case "visa":
        return 'lib/assets/icons/logosMetodoPago/visa.png';
      case "master":
        return 'lib/assets/icons/logosMetodoPago/master.png';
      case "amex":
        return 'lib/assets/icons/logosMetodoPago/amex.png';
      case "naranja":
        return 'lib/assets/icons/logosMetodoPago/naranja.png';
      case "tarshop":
        return 'lib/assets/icons/logosMetodoPago/shopping.png';
      case "cabal":
        return 'lib/assets/icons/logosMetodoPago/cabal.png';
      case "debmaster":
        return 'lib/assets/icons/logosMetodoPago/master.png';
      case "cordobesa":
        return 'lib/assets/icons/logosMetodoPago/cordobesa.jpg';
      case "cmr":
        return 'lib/assets/icons/logosMetodoPago/cmr.jpg';
    }
    return "";
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
}
