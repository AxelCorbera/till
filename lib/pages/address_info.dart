import 'package:flutter/material.dart';
import 'package:till/constants/themes.dart';
import 'package:till/scenes/components/direccion.dart';
import 'package:till/globals.dart' as globals;
import 'package:till/scripts/cloud_firestore.dart';
import 'info_payment.dart';

class Address_Info extends StatefulWidget {
  _Address_InfoState createState() => _Address_InfoState();
}

class _Address_InfoState extends State<Address_Info> {
  Domicilio domicilio = new Domicilio('', '', '', '', 0, '', '');
  Direcciones dir = new Direcciones();
  String provincia = '', municipio = '', localidad = '', calle = '',
      numero = '', piso = '', departamento = '', cuil = '';
  GlobalKey<ScaffoldState> _keyScaf = GlobalKey();

  @override
  Widget build(BuildContext context) {
    provincia = globals.usuario!.provincia.toString();
    municipio = globals.usuario!.municipio.toString();
    localidad = globals.usuario!.localidad.toString();
    calle = globals.usuario!.calle.toString();
    numero = globals.usuario!.numero.toString();
    piso = globals.usuario!.piso.toString();
    departamento = globals.usuario!.departamento.toString();
    cuil = globals.usuario!.cuil.toString();

    return Scaffold(
      key: _keyScaf,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text("Datos de facturación"),
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
                  DropdownButtonFormField(
                    value: provincia!=''?
                    provincia:
                    null,
                    onTap: () {},
                    onSaved: (value) {},
                    onChanged: (value) {
                      globals.usuario!.provincia = value.toString();
                      provincia = value.toString();
                      municipio ='';
                      globals.usuario!.municipio = '';
                      setState(() {
                      });
                    },
                    hint: const Text(
                      'Provincia',
                    ),
                    isExpanded: true,
                    items: [
                      "BUENOS AIRES",
                      "CAPITAL FEDERAL",
                      "CATAMARCA",
                      "CHACO",
                      "CHUBUT",
                      "CORDOBA",
                      "CORRIENTES",
                      "ENTRE RIOS",
                      "FORMOSA",
                      "JUJUY",
                      "LA PAMPA",
                      "LA RIOJA",
                      "MENDOZA",
                      "MISIONES",
                      "NEUQUEN",
                      "RIO NEGRO",
                      "SALTA",
                      "SAN JUAN",
                      "SAN LUIS",
                      "SANTA CRUZ",
                      "SANTA FE",
                      "SANTIAGO DEL ESTERO",
                      "TIERRA DEL FUEGO",
                      "TUCUMAN",
                    ].map((String val) {
                      return DropdownMenuItem(
                        value: val,
                        child: Text(
                          val,
                        ),
                      );
                    }).toList(),
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
                  DropdownButtonFormField(
                      value: municipio != ''?
                      municipio:
                      provincia!=''?
                      dir.ListaMunicipio(provincia)[0]:
                    null,
                    onTap: () {},
                    onSaved: (value) {},
                    onChanged: (value) {
                      print(value);
                      globals.usuario!.municipio = value.toString();
                      municipio = value.toString();
                      setState(() {
                      });
                    },
                    hint: const Text(
                      'Municipio',
                    ),
                    isExpanded: true,
                    items:
                    dir.ListaMunicipio(provincia)
                        .map((String val) {
                      return new DropdownMenuItem(
                        value: val,
                        child: Text(
                          val,
                        ),
                      );
                    }).toList(),
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
                  DropdownButtonFormField(
                      value: municipio!=''?
                      dir.ListaLocalidades(globals.usuario!.provincia.toString(),
                          globals.usuario!.municipio.toString())[0]:
                    null,
                    onTap: () {},
                    onSaved: (value) {},
                    onChanged: (value) {
                      setState(() {
                        globals.usuario!.localidad = value.toString();
                      });
                    },
                    hint: const Text(
                      'Localidad',
                    ),
                    isExpanded: true,
                    items:
                    dir.ListaLocalidades(globals.usuario!.provincia.toString(),
                        globals.usuario!.municipio.toString())
                        .map((String val) {
                      return DropdownMenuItem(
                        value: val,
                        child: Text(
                          val,
                        ),
                      );
                    }).toList(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 18.0),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text('Calle',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),),
                    ),
                  ),
                  TextFormField(
                      onChanged: (value){
                        calle = value;
                      },
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                      decoration: const InputDecoration(
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
                      initialValue: globals.usuario!.calle.toString(),
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
                              child: Text('Numero',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                ),),
                            ),
                          ),
                          Container(
                            width: 90,
                            child: TextFormField(
                              onChanged: (value){
                                numero = value;
                              },
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                              decoration: const InputDecoration(
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
                              initialValue: globals.usuario!.numero.toString(),
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
                              child: Text('Piso',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                ),),
                            ),
                          ),
                          Container(
                            width: 90,
                            child: TextFormField(
                              onChanged: (value){
                                piso = value;
                              },
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                              decoration: const InputDecoration(
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
                              initialValue: globals.usuario!.piso.toString(),
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
                            width: 90,
                            child: TextFormField(
                              onChanged: (value){
                                departamento = value;
                              },
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                              decoration: const InputDecoration(
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
                              initialValue: globals.usuario!.departamento.toString(),
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
                    onChanged: (value){
                      cuil = value;
                    },
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                    decoration: const InputDecoration(
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
                    initialValue: globals.usuario!.cuil.toString(),
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
                        globals.usuario!.provincia = provincia;
                        globals.usuario!.municipio = municipio;
                        globals.usuario!.localidad = localidad;
                        globals.usuario!.calle = calle;
                        globals.usuario!.numero = numero;
                        globals.usuario!.piso = piso;
                        globals.usuario!.departamento = departamento;
                        globals.usuario!.cuil = cuil;

                        Map<String,String> map =
                        {
                          'provincia':provincia,
                          'municipio':municipio,
                          'localidad':localidad,
                          'calle':calle,
                          'numero':numero,
                          'piso':piso,
                          'departamento':departamento,
                          'cuil':cuil
                        };
                        UpdateUser(
                          globals.usuario!.id.toString()
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

  void _mostrarMensaje(String msg) {
    SnackBar snackBar = SnackBar(
      content: Text(msg),
    );
    _keyScaf.currentState!.showSnackBar(snackBar);
  }
}
