import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:till/globals.dart' as globals;
import 'package:till/provider/google_sing_in.dart';
import 'package:till/scenes/login.dart';
import 'package:till/scripts/mercadopago/cardsJson.dart';
import 'package:till/scripts/mercadopago/customerJson.dart';
import 'package:till/scripts/request.dart' as request;
import 'package:till/scripts/mercadopago/mercadoPago.dart' as mp;
import 'package:shared_preferences/shared_preferences.dart';

import 'constants/themes.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class argumentsHome {
  final String icono;

  argumentsHome(this.icono);
}

class _HomeState extends State<Home> {
  String menu = 'home';
  List<String> categoriasNombres = [
    'Alimentos',
    'Golosinas',
    'Juguetes',
    'Ropa',
    'Accesorios',
    'Higiene',
    'Piedras',
    'Pipetas'
  ];
  List<String> categoriasIconos = [
    'lib/assets/icons/dog-food-pet.png',
    'lib/assets/icons/snack.png',
    'lib/assets/icons/toy.png',
    'lib/assets/icons/clothes.png',
    'lib/assets/icons/leash.png',
    'lib/assets/icons/shampoo.png',
    'lib/assets/icons/urinary.png',
    'lib/assets/icons/pipette.png'
  ];
  int carrito = globals.carrito.id.length;

  @override
  Widget build(BuildContext context) {
    if (globals.login) {
      _buscarTarjetas();
    }
    this.carrito = globals.carrito.id.length;
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshop) {
              if (snapshop.connectionState == ConnectionState.waiting) {
                return Text("Inicio");
              } else {
                if (globals.login) {
                  return Text(
                      'Hola ' + globals.usuario!.nombre.toString() + '!');
                } else {
                  return Text("Inicio");
                }
              }
            }),
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
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshop) {
          if (snapshop.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshop.hasData) {
            globals.login = true;
            return Center(child: Text('Bienvenido'));
          } else if (snapshop.hasError) {
            return Center(child: Text('Algo salio mal :('));
          } else {
            return Center(child: Text('Home'));
          }
        },
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.white,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Image(
                        image: AssetImage('lib/assets/images/tillrojo.png'),
                        width: 150,
                        height: 150,
                      ),
                      // Text(
                      //   'Till',
                      //   style: TextStyle(color: Colors.white, fontSize: 25),
                      // )
                    ],
                  ),
                ),
              ],
            ),
            // ListTile(
            //   title: Text('Shop'),
            //   leading: Icon(
            //     Icons.shop,
            //     color: Theme.of(context).primaryColor,
            //   ),
            //   onTap: () {
            //     _menu(context, 'home');
            //   },
            // ),
            // ListTile(
            //   title: Text('Mis mascotas'),
            //   leading: Icon(
            //     Icons.pets,
            //     color: Theme.of(context).primaryColor,
            //   ),
            //   onTap: () {
            //     globals.login
            //         ? Navigator.pushNamed(context, '/Pets')
            //         : _unlogin(context);
            //   },
            // ),
            ListTile(
              title: Text('Ultimas compras'),
              leading: Icon(
                Icons.monetization_on,
                color: Theme.of(context).primaryColor,
              ),
              onTap: () {
                globals.login
                    ? Navigator.pushNamed(context, '/Purchases')
                    : _unlogin(context);
              },
            ),
            ListTile(
              title: Text('Mis tarjetas'),
              leading: Icon(
                Icons.credit_card,
                color: Theme.of(context).primaryColor,
              ),
              onTap: () {
                Navigator.pop(context);
                globals.login
                    ? Navigator.pushNamed(context, '/Cards')
                    : _unlogin(context);
              },
            ),
            ListTile(
              title: Text('Soporte'),
              leading: Icon(
                Icons.support,
                color: Theme.of(context).primaryColor,
              ),
              onTap: () {
                Navigator.pop(context);
                globals.login
                    ? Navigator.pushNamed(context, '/Support')
                    : _unlogin(context);
              },
            ),
            ListTile(
              title: globals.login
                  ? Text('Cerrar sesion')
                  : Text('Iniciar sesion'),
              leading: globals.login
                  ? Icon(
                      Icons.close,
                      color: Colors.red,
                    )
                  : Icon(
                      Icons.open_in_browser,
                      color: Colors.green,
                    ),
              onTap: () {
                if (globals.login == true) {
                  logout();
                  final provider =
                      Provider.of<GoogleSignInProvider>(context, listen: false);
                  provider.logout();
                }
                Navigator.of(context).pushNamed('/Login');
              },
            ),
            // ListTile(
            //   title: Text('TOKEN'),
            //   leading: Icon(
            //     Icons.vpn_key,
            //     color: Theme.of(context).primaryColor,
            //   ),
            //   onTap: () async {
            //     //Navigator.pop(context);
            //     //String s = await mp.CardToken();
            //     //mp.GuardarTarjeta(s);
            //   },
            // ),
          ],
        ),
      ),
    );
  }

  Future<Null> logout() async {
    globals.login = false;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', '');
    prefs.setString('password', '');
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

  void _menu(BuildContext context, String pantalla) {
    Navigator.pop(context);
    setState(() {
      menu = pantalla;
    });
    if (pantalla == 'shop') {
      Navigator.of(context).pushNamed('/Shop');
    }
    print(pantalla);
  }

  @override
  void initState() {
    super.initState();
    carrito = globals.carrito.id.length;
    if (globals.login) {
      //_buscarTarjetas();
      _buscarCustomer();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _buscarTarjetas() async {
    if (globals.usuario!.idcustomer != "") {
      List<Cards> tarjetas = await request.BuscarTarjetas(globals
          .usuario!.idcustomer
          .toString()); //globals.usuario!.idcustomer.toString() //819221039-mHUSlOwg4ApZGE
      globals.cards = List.from(tarjetas);
      if (tarjetas.length > 0 && tarjetas[0].error != null) {
        print('error: ' + tarjetas[0].error.toString());
      }
    }
  }

  void _buscarCustomer() async {
    FindCustomer customer = await request.BuscarCustomer("test@hotmail.com");
    print('results: ' + customer.results!.length.toString());
  }
}
