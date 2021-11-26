import 'package:flutter/material.dart';
import 'package:till/scenes/components/direccion.dart';
import 'package:till/globals.dart' as globals;
import 'info_payment.dart';

class My_Account extends StatefulWidget {
  _my_AccountState createState() => _my_AccountState();
}

class _my_AccountState extends State<My_Account> {
  Domicilio domicilio = new Domicilio('', '', '', '', 0, '', '');
  Direcciones dir = new Direcciones();
  GlobalKey<FormState> _keyForm = GlobalKey();
  String prov = '', muni = '', loc = '', dire = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("Mi cuenta"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(bottom: 0),
                height: 100,
                child:
                    Stack(alignment: Alignment.center, children: <Widget>[
                      Container(
                        width: 97,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey,
                        ),
                      ),
                      Container(
                        width: 95,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        width: 90,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).primaryColor,
                          image: globals.usuario!.foto != null
                              && globals.usuario!.foto != ''?
                          DecorationImage(
                              image:
                              NetworkImage(globals.usuario!.foto.toString()),
                              fit: BoxFit.contain):
                          DecorationImage(
                              image:
                              AssetImage('lib/assets/images/fondoClaro.jpg'),
                              fit: BoxFit.cover),
                        ),
                      ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      globals.usuario!.nombre.toString()==""?
                      'Invitado':
                      globals.usuario!.nombre.toString(),
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    globals.usuario!.nombre.toString()==""?
                    'Mi cuenta':
                    globals.usuario!.correo.toString(),
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(
                height: 60,
              ),
              Center(child: Column(
                children: <Widget>[
                  ListTile(
                    onTap: () => Navigator.of(context).pushNamed('/My_Information'),
                    title: Text('Mis datos',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),),
                    trailing: Icon(Icons.navigate_next,
                    color: Theme.of(context).primaryColor,),
                  ),
                  Divider(
                    color: Theme.of(context).primaryColor,
                    height: 2,
                    indent: 10,
                    endIndent: 10,
                  ),
                  ListTile(
                    title: Text('Seguridad',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),),
                    trailing: Icon(Icons.navigate_next,
                      color: Theme.of(context).primaryColor,),
                  ),
                  Divider(
                    color: Theme.of(context).primaryColor,
                    height: 2,
                    indent: 10,
                    endIndent: 10,
                  ),
                  ListTile(
                    onTap: () => Navigator.of(context).pushNamed('/Address_Info'),
                    title: Text('Datos de facturacion',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),),
                    trailing: Icon(Icons.navigate_next,
                      color: Theme.of(context).primaryColor,),
                  ),
                ],
              ),),
            ],
          ),
        ),
      )
    );
  }
}
