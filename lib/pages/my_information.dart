import 'package:flutter/material.dart';
import 'package:till/constants/themes.dart';
import 'package:till/scenes/components/direccion.dart';
import 'package:till/globals.dart' as globals;
import 'package:till/scripts/cloud_firestore.dart';
import 'info_payment.dart';

class My_Information extends StatefulWidget {
  _my_InformationState createState() => _my_InformationState();
}

class _my_InformationState extends State<My_Information> {
  Domicilio domicilio = new Domicilio('', '', '', '', 0, '', '');
  Direcciones dir = new Direcciones();
  GlobalKey<FormState> _keyForm = GlobalKey();
  String nombre = globals.usuario!.nombre.toString(),
      correo = globals.usuario!.correo.toString(),
      documento = globals.usuario!.documento.toString(),
      telefono = globals.usuario!.telefono.toString();

  @override
  Widget build(BuildContext context) {
    nombre = globals.usuario!.nombre.toString();
    correo = globals.usuario!.correo.toString();
    documento = globals.usuario!.documento.toString();
    telefono = globals.usuario!.telefono.toString();
    print(globals.usuario!.documento.toString());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("Mis datos"),
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
                      child: Text('Nombre y apellido',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),),
                    ),
                  ),
                  TextFormField(
                    onChanged: (value){
                      nombre = value;
                    },
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
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
                    initialValue: globals.usuario!.nombre.toString(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 18.0),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text('E-mail',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),),
                    ),
                  ),
                  TextFormField(
                    onChanged: (value){
                      correo = value;
                    },
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
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
                    initialValue: globals.usuario!.correo.toString(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 18.0),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text('Documento',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),),
                    ),
                  ),
                  TextFormField(
                    onChanged: (value){
                      documento = value;
                    },
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
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
                    initialValue: globals.usuario!.documento.toString(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 18.0),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text('Telefono',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),),
                    ),
                  ),
                  TextFormField(
                    onChanged: (value){
                      telefono = value;
                    },
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
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
                    initialValue: globals.usuario!.telefono.toString(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 18.0),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text('Domicilio',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),),
                    ),
                  ),
                  TextFormField(
                    readOnly: true,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
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
                    initialValue: globals.usuario!.calle!=''?
                    globals.usuario!.calle.toString() +
                        ' ' + globals.usuario!.numero.toString():
                    '',
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
                    padding: const EdgeInsets.only(top: 8.0),
                    child: RaisedButton(
                      onPressed: () {
                        Map<String,String> map =
                        {
                          'nombre':nombre,
                          'correo':correo,
                          'documento':documento,
                          'telefono':telefono,
                        };
                        globals.usuario!.nombre = nombre;
                        globals.usuario!.correo = correo;
                        globals.usuario!.documento = documento;
                        globals.usuario!.telefono = telefono;
                        UpdateUser(globals.usuario!.id.toString()
                        ).updateUser(map);
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
