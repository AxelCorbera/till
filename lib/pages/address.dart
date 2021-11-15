import 'package:flutter/material.dart';
import 'package:till/scenes/components/direccion.dart';

import 'info_payment.dart';

class addAddress extends StatefulWidget {
  _AddressState createState() => _AddressState();
}

class _AddressState extends State<addAddress> {
  Domicilio domicilio = new Domicilio('', '', '', '', 0, '', '');
  Direcciones dir = new Direcciones();
  GlobalKey<FormState> _keyForm = GlobalKey();
  String prov = '', muni = '', loc = '', dire = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("Mi direccion"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _keyForm,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DropdownButtonFormField(
                value: prov != '' ? prov : null,
                onTap: () {},
                onSaved: (value) {},
                onChanged: (value) {
                    prov = value.toString();
                  //Navigator.pop(context);
                  //_direccion(context, value.toString(), '', '', '');
                },
                hint: Text(
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
              DropdownButtonFormField(
                      value: muni != '' ? muni : null,
                      onTap: () {},
                      onSaved: (value) {},
                      onChanged: (value) {
                          muni = value.toString();
                        // Navigator.pop(context);
                        //_direccion(context, prov, value.toString(), '', '');
                      },
                      hint: Text(
                        'Municipio',
                      ),
                      isExpanded: true,
                      items: dir.ListaMunicipio(prov).map((String val) {
                        return DropdownMenuItem(
                          value: val,
                          child: Text(
                            val,
                          ),
                        );
                      }).toList(),
                    ),
              DropdownButtonFormField(
                      value: loc != '' ? loc : null,
                      onTap: () {},
                      onSaved: (value) {},
                      onChanged: (value) {
                          loc = value.toString();
                        //Navigator.pop(context);
                        //_direccion(
                        //    context, prov, muni, value.toString(), '');
                      },
                      hint: Text(
                        'Localidad',
                      ),
                      isExpanded: true,
                      items: dir.ListaLocalidades(prov, muni).map((String val) {
                        return DropdownMenuItem(
                          value: val,
                          child: Text(
                            val,
                          ),
                        );
                      }).toList(),
                    ),
                TextFormField(
                  initialValue: '',
                  decoration: InputDecoration(
                    labelText: "Calle: ",
                  ),
                  onSaved: (value) {},
                  onChanged: (value) {
                  },
                  validator: (value) {
                    if (value.toString().isEmpty)
                      return 'Este campo es obligatorio';
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Nro.: ",
                  ),
                  onSaved: (value) {},
                  onChanged: (value) {
                    domicilio.numero = int.parse(value);
                  },
                  validator: (value) {
                    if (value.toString().isEmpty)
                      return 'Este campo es obligatorio';
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Piso: ",
                  ),
                  onSaved: (value) {},
                  onChanged: (value) {
                    domicilio.piso = value.toString().toUpperCase();
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Departamento: ",
                  ),
                  onSaved: (value) {},
                  onChanged: (value) {
                    domicilio.departamento = value.toString().toUpperCase();
                  },
                ),
                ButtonBar(
                  children: [
                    RaisedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Cancelar'),
                    ),
                    RaisedButton(
                      onPressed: () {
                        if (_keyForm.currentState!.validate()) {
                          domicilio.provincia = prov;
                          domicilio.municipio = muni;
                          domicilio.localidad = loc;
                          Navigator.pop(context);
                          print(domicilio.calle +
                              domicilio.numero.toString() +
                              domicilio.piso +
                              domicilio.departamento +
                              domicilio.localidad +
                              domicilio.municipio +
                              domicilio.provincia);
                          setState(() {});
                        }
                      },
                      child: Text('Aceptar'),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
