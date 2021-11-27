import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:till/globals.dart' as globals;
import 'package:till/provider/google_sing_in.dart';
import 'package:till/pages/login.dart';
import 'package:till/scripts/cloud_firestore.dart';
import 'package:till/scripts/mercadopago/cardsJson.dart';
import 'package:till/scripts/mercadopago/customerJson.dart';
import 'package:till/scripts/mercadopago/mercadoPago.dart';
import 'package:till/scripts/request.dart' as request;
import 'package:till/scripts/mercadopago/mercadoPago.dart' as mp;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:till/scripts/request.dart';
import 'package:till/widget/inicio.dart';

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
  int carrito = globals.carrito.id.length;

  @override
  Widget build(BuildContext context) {
    this.carrito = globals.carrito.id.length;
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshop) {
              if (snapshop.connectionState == ConnectionState.waiting) {
                return Text("Inicio");
              } else {
                if (globals.login == true) {
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
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/assets/images/fondoClaro.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshop) {
            if (snapshop.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshop.hasData) {
              globals.login = true;
              return Inicio();
            } else if (snapshop.hasError) {
              return Center(child: Text('Algo salio mal :('));
            } else {
              return Inicio();
            }
          },
        ),
      ),
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Theme.of(context).primaryColor,
                )),
            GestureDetector(
              onTap: () => Navigator.of(context).pushNamed('/My_Account'),
              child: Container(
                margin: const EdgeInsets.only(bottom: 0),
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Theme.of(context).primaryColor,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Stack(alignment: Alignment.center, children: <Widget>[
                      Container(
                        width: 65,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey,
                        ),
                      ),
                      Container(
                        width: 62,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      Container(
                        width: 59,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).primaryColor,
                          image: globals.usuario!.foto != null
                          && globals.usuario!.foto != ''
                              ? DecorationImage(
                                  image: NetworkImage(
                                      globals.usuario!.foto.toString()),
                                  fit: BoxFit.contain)
                              : DecorationImage(
                                  image: AssetImage(
                                      'lib/assets/images/fondoClaro.jpg'),
                                  fit: BoxFit.cover),
                        ),
                      ),
                    ]),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              globals.usuario!.nombre.toString() == ""
                                  ? 'Invitado'
                                  : globals.usuario!.nombre.toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              globals.usuario!.nombre.toString() == ""
                                  ? ''
                                  : 'Mi cuenta',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 100,
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  ListTile(
                    title: Text('Inicio'),
                    leading: Icon(
                      Icons.home,
                      color: Theme.of(context).primaryColor,
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, '/Home');
                    },
                  ),
                  ListTile(
                    title: Text('Notificaciones'),
                    leading: Icon(
                      Icons.campaign,
                      color: Theme.of(context).primaryColor,
                    ),
                    trailing: Container(
                      width: 20,
                      decoration: BoxDecoration(
                          color: Colors.red, shape: BoxShape.circle),
                      child: Center(
                        child: Text(
                          '1',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    onTap: () {
                      globals.login
                          ? Navigator.pushNamed(context, '/Purchases')
                          : _unlogin(context);
                    },
                  ),
                  ListTile(
                    title: Text('Ayuda'),
                    leading: Icon(
                      Icons.help_outline,
                      color: Theme.of(context).primaryColor,
                    ),
                    onTap: () {
                      globals.login
                          ? Navigator.pushNamed(context, '/Purchases')
                          : _unlogin(context);
                    },
                  ),
                  Divider(
                    color: Theme.of(context).primaryColor,
                    height: 2,
                    indent: 20,
                    endIndent: 20,
                  ),
                  ListTile(
                    title: Text('Ultimas compras'),
                    leading: Icon(
                      Icons.shopping_cart,
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
                  new Divider(
                    height: 2,
                    indent: 20,
                    endIndent: 20,
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
            Container(
              child: ListTile(
                title: globals.login
                    ? Text('Cerrar sesion')
                    : Text('Iniciar sesion'),
                leading: globals.login
                    ? Icon(
                        Icons.exit_to_app,
                        color: Theme.of(context).primaryColor,
                      )
                    : Icon(
                        Icons.open_in_browser,
                        color: Theme.of(context).primaryColor,
                      ),
                onTap: () {
                  if (globals.login == true) {
                    logout();
                    final provider = Provider.of<GoogleSignInProvider>(context,
                        listen: false);
                    provider.logout();
                  }
                  Navigator.of(context).pushNamed('/Login');
                },
              ),
            )
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
    globals.usuario = Usuario("", "", "", "", "", "", "", "", "", "", "", "",
        "", "", "", "", "", "", "", "");
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
                          Navigator.of(context).pushNamed('/Login');
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
      _info();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _buscarTarjetas() async {
    List<Cards> tarjetas = await request.BuscarTarjetas(globals
        .usuario!.id_customer_mp
        .toString());
    if(tarjetas.length > 0) {
      globals.cards.clear();
      globals.cards = tarjetas;
    }
    if (tarjetas.length > 0 && tarjetas[0].error != null) {
      print('error: ' + tarjetas[0].error.toString());
    }
  }

  void _info() async {
    if (globals.usuario!.id_customer_mp == '') {
      print('consultando customer...');
      String respuesta =
          await BuscarCustomer(globals.usuario!.correo.toString());
      try {
        if (respuesta == '0') {
          print('No hay customer');
          return;
        }
        print('hay customer > ' + respuesta);
        if (globals.usuario!.id_customer_mp !=
            respuesta) {
          globals.usuario!.id_customer_mp = respuesta;
          Map<String, String> datos = {
            "id_customer_mp": respuesta
          };
          UpdateUser(globals.usuario!.id.toString()).updateUser(datos);
        }

        _buscarTarjetas();
      } catch (Exception) {
        print('Ocurrio un error consultando customer');
      }
    }
  }

//   void _buscarCustomer() async {
//     FindCustomer customer = await request.BuscarCustomer("test@hotmail.com");
//     print('results: ' + customer.results!.length.toString());
//   }
}
