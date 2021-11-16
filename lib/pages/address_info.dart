import 'package:flutter/material.dart';
import 'package:till/constants/themes.dart';
import 'package:till/scenes/components/direccion.dart';
import 'package:till/globals.dart' as globals;
import 'info_payment.dart';

class Address_Info extends StatefulWidget {
  _Address_InfoState createState() => _Address_InfoState();
}

class _Address_InfoState extends State<Address_Info> {
  Domicilio domicilio = new Domicilio('', '', '', '', 0, '', '');
  Direcciones dir = new Direcciones();
  GlobalKey<FormState> _keyForm = GlobalKey();
  String prov = '', muni = '', loc = '', dire = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("Datos de facturación"),
      ),
      body: SingleChildScrollView(
        child: Center(
            child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Center(
            child: Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 18.0),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text('Provincia',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),),
                    ),
                  ),
                  TextFormField(
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
          ),
                    initialValue: domicilio.provincia,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 18.0),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text('Municipio',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),),
                    ),
                  ),
                  TextFormField(
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                    initialValue: domicilio.municipio,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 18.0),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text('Localidad',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),),
                    ),
                  ),
                  TextFormField(
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                    initialValue: domicilio.localidad,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 18.0),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text('Direccion',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),),
                    ),
                  ),
                  TextFormField(
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                    initialValue: domicilio.calle
                        + ' '
                        + domicilio.numero.toString(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 18.0),
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Text('Piso',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                ),),
                            ),
                          ),
                          Container(
                            width: 140,
                            child: TextFormField(
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                              ),
                              initialValue: domicilio.piso,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 18.0),
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Text('Departamento',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                ),),
                            ),
                          ),
                          Container(
                            width: 140,
                            child: TextFormField(
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                              ),
                              initialValue: domicilio.departamento,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 18.0),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text('CUIT/CUIL',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),),
                    ),
                  ),
                  TextFormField(
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                    initialValue: '',
                  ),
                  SizedBox(height: 30,),
                  Padding(
                    padding: const EdgeInsets.only(top: 18.0),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text('Ingresa tu clave para guardar los cambios',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Container(
                      height: 50,
                      child: TextFormField(
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      onPressed: () {

                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.all(0.0),
                      child: Ink(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                              colors: Colores.combinacion1),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
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
                                'Guardar',
                                style: TextStyle(color: Colors.white, fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )),
      ),
    );
  }
}
