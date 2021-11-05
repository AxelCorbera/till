import 'package:flutter/material.dart';
import 'package:till/globals.dart' as globals;
import 'package:till/scenes/addcard.dart' as addcard;
import 'package:till/scenes/checkout.dart';
import 'package:till/scenes/components/direccion.dart';
import 'package:till/scripts/mercadopago/cuotasJson.dart';
import 'package:till/scripts/mercadopago/mercadoPago.dart';

import 'cards.dart';

class InfoPayment extends StatefulWidget {
  @override
  _InfoPaymentState createState() => _InfoPaymentState();
}

class _InfoPaymentState extends State<InfoPayment> {
  bool efectivo = false;
  bool tarjeta = false;
  bool cuotas = false;
  double total = 0;
  String cuotaSeleccionada = '';
  Domicilio domicilio = new Domicilio('', '', '', '', 0, '', '');
  Direcciones dir = new Direcciones();
  addcard.TarjetaPago tarjetaSeleccionada =
      new addcard.TarjetaPago(DatosTarjeta(),'', Cuotas());
  GlobalKey<FormState> _keyForm = GlobalKey();
  Widget build(BuildContext context) {
    total = Sumar(globals.carrito.precio, globals.carrito.cantidad);
    return Scaffold(
      backgroundColor: Colors.white38,
      appBar: AppBar(
        title: Text("Checkuot"),
      ),
      body: Column(children: <Widget>[
        Center(
          child: Card(
            elevation: 5,
            margin: EdgeInsets.all(10),
            child: Container(
              width: double.infinity,
              height: 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Domicilio:'),
                      SizedBox(
                        width: 25,
                      ),
                      domicilio.calle != ''
                          ? Icon(
                              Icons.done,
                              color: Colors.green,
                            )
                          : SizedBox(
                              width: 0,
                            )
                    ],
                  ),
                  RaisedButton(
                    onPressed: () {
                      _direccion(context, '', '', '', '');
                    },
                    child: Text('Seleccionar domicilio'),
                  ),
                  domicilio.calle!=''?
                  Text(domicilio.calle+' '+
                      domicilio.numero.toString()+', '+
                      domicilio.localidad+' '+
                      domicilio.municipio
                      ):SizedBox(),
                ],
              ),
            ),
          ),
        ),
        Center(
          child: Card(
            elevation: 5,
            margin: EdgeInsets.all(10),
            child: Container(
              width: double.infinity,
              height: 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Forma de pago:'),
                      SizedBox(
                        width: 25,
                      ),tarjetaSeleccionada.idTarjeta == '0'?
                      Icon(
                        Icons.error_outline,
                        color: Colors.red,
                      ):
                      efectivo || tarjeta
                          ? Icon(
                              Icons.done,
                              color: Colors.green,
                            )
                          : SizedBox(
                              width: 0,
                            )
                    ],
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        RaisedButton(
                          onPressed: () {
                            efectivo = true;
                            tarjeta = false;
                            cuotas = false;
                            tarjetaSeleccionada = new addcard.TarjetaPago(
                                DatosTarjeta(),'', Cuotas());
                            setState(() {});
                          },
                          child: Text('Efectivo'),
                          color: efectivo ? Colors.green : null,
                        ),
                        RaisedButton(
                          onPressed: () {
                            //efectivo = false;
                            //tarjeta = true;
                            //setState(() {});
                            _mostrarTarjetas();
                          },
                          child: Text('Tarjeta credito/debito'),
                          color: tarjeta ? Colors.green : null,
                        ),
                      ],
                    ),
                  ),
                  tarjetaSeleccionada.idTarjeta == '0'?
                  Text("Ocurrio un error.",
                  style: TextStyle(
                    color: Colors.red
                  ),):
                  tarjeta
                      ? Text(tarjetaSeleccionada.cuotasTarj.paymentMethodId
                              .toString() +
                          " terminada en " +
                          tarjetaSeleccionada.datosTarj.numeros
                              .toString()
                              .substring(12, 16))
                      : efectivo
                          ? Text('Pago en efectivo')
                          : Text('Seleccionar forma de pago')
                ],
              ),
            ),
          ),
        ),
        tarjetaSeleccionada.datosTarj.numeros != null &&
            tarjetaSeleccionada.idTarjeta != '0'
            ? Center(
                child: Card(
                  elevation: 5,
                  margin: EdgeInsets.all(10),
                  child: Container(
                    width: double.infinity,
                    height: 150,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Cuotas:'),
                            SizedBox(
                              width: 25,
                            ),
                            cuotas
                                ? Icon(
                                    Icons.done,
                                    color: Colors.green,
                                  )
                                : SizedBox(
                                    width: 0,
                                  )
                          ],
                        ),
                        Form(
                          child: Container(
                            width: 250,
                            child: DropdownButtonFormField(
                              onTap: () {},
                              onSaved: (value) {},
                              onChanged: (value) {
                                  cuotas = true;
                                  cuotaSeleccionada = value.toString().substring(0,2);
                                  cuotaSeleccionada = cuotaSeleccionada.replaceAll(' ', '');
                                  print('cuotas $cuotaSeleccionada<');
                                  setState(() {

                                  });
                              },
                              hint: Text(
                                'Seleccionar cuotas',
                              ),
                              isExpanded: true,
                              items: _cuotas().map((String val) {
                                return DropdownMenuItem(
                                  value: val,
                                  child: Text(
                                    val,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : SizedBox(),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            "Total: " + total.toString(),
            style: TextStyle(
                fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton.icon(
                  onPressed: domicilio != '' && efectivo == true ||
                          domicilio != '' && tarjeta == true && cuotas == true
                      ? () {
                    String number = total.toStringAsFixed(2);
                    total = double.parse(number);
                          Navigator.of(context).pushNamed('/Checkout',
                              arguments: ArgumentosCheckout(
                                  tarjetaSeleccionada, total, domicilio, cuotaSeleccionada));
                        }
                      : null,
                  icon: Icon(Icons.navigate_next),
                  label: Text("Continuar"))
            ],
          ),
        )
      ]),
    );
  }

  void _direccion(
      BuildContext context, String prov, String muni, String loc, String dire) {
    String calle = '';
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              content: SingleChildScrollView(
            child: Form(
              key: loc != ''
                  ? _keyForm:null,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  DropdownButtonFormField(
                    value: prov != '' ? prov : null,
                    onTap: () {},
                    onSaved: (value) {},
                    onChanged: (value) {
                      Navigator.pop(context);
                      _direccion(context, value.toString(), '', '', '');
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
                  prov != ''
                      ? DropdownButtonFormField(
                          value: muni != '' ? muni : null,
                          onTap: () {},
                          onSaved: (value) {},
                          onChanged: (value) {
                            Navigator.pop(context);
                            _direccion(context, prov, value.toString(), '', '');
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
                        )
                      : SizedBox(
                          height: 0,
                        ),
                  muni != ''
                      ? DropdownButtonFormField(
                          value: loc != '' ? loc : null,
                          onTap: () {},
                          onSaved: (value) {},
                          onChanged: (value) {
                            Navigator.pop(context);
                            _direccion(
                                context, prov, muni, value.toString(), '');
                          },
                          hint: Text(
                            'Localidad',
                          ),
                          isExpanded: true,
                          items: dir.ListaLocalidades(prov, muni)
                              .map((String val) {
                            return DropdownMenuItem(
                              value: val,
                              child: Text(
                                val,
                              ),
                            );
                          }).toList(),
                        )
                      : SizedBox(
                          height: 0,
                        ),
                  loc != ''
                      ? TextFormField(
                          initialValue: dire != '' ? dire : null,
                          decoration: InputDecoration(
                            labelText: "Calle: ",
                          ),
                          onSaved: (value) {},
                          onChanged: (value) {
                            domicilio.calle = value.toString().toUpperCase();
                          },
                    validator: (value){
                            if(value.toString().isEmpty)
                              return 'Este campo es obligatorio';
                    },
                        )
                      : SizedBox(
                          height: 0,
                        ),
                  loc != ''
                      ? TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Nro.: ",
                    ),
                    onSaved: (value) {},
                    onChanged: (value) {
                      domicilio.numero = int.parse(value);
                    },
                    validator: (value){
                      if(value.toString().isEmpty)
                        return 'Este campo es obligatorio';
                    },
                  )
                      : SizedBox(
                    height: 0,
                  ),
                  loc != ''
                      ? TextFormField(
                    decoration: InputDecoration(
                      labelText: "Piso: ",
                    ),
                    onSaved: (value) {},
                    onChanged: (value) {
                      domicilio.piso = value.toString().toUpperCase();
                    },
                  )
                      : SizedBox(
                    height: 0,
                  ),
                  loc != ''
                      ? TextFormField(
                    decoration: InputDecoration(
                      labelText: "Departamento: ",
                    ),
                    onSaved: (value) {},
                    onChanged: (value) {
                      domicilio.departamento = value.toString().toUpperCase();
                    },
                  )
                      : SizedBox(
                    height: 0,
                  ),
                  loc != ''
                      ? ButtonBar(
                          children: [
                            RaisedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Cancelar'),
                            ),
                            RaisedButton(
                              onPressed: () {
                                if(_keyForm.currentState!.validate()) {
                                  domicilio.provincia = prov;
                                  domicilio.municipio = muni;
                                  domicilio.localidad = loc;
                                  Navigator.pop(context);
                                  print(domicilio.calle+
                                  domicilio.numero.toString()+
                                  domicilio.piso+
                                  domicilio.departamento+
                                  domicilio.localidad+
                                  domicilio.municipio+
                                  domicilio.provincia);
                                  setState(() {});
                                }
                              },
                              child: Text('Aceptar'),
                            ),
                          ],
                        )
                      : SizedBox(
                          height: 0,
                        ),
                ],
              ),
            ),
          ));
        });
  }

  void _mostrarTarjetas() {
    String calle = '';
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              content: SingleChildScrollView(
            child: Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  globals.cards.length > 0
                      ? Column(
                          children: [
                            DropdownButtonFormField(
                              onTap: () {},
                              onSaved: (value) {},
                              onChanged: (value) {
                                Navigator.pop(context);
                                _direccion(
                                    context, value.toString(), '', '', '');
                              },
                              hint: Text(
                                'Elegir tarjeta',
                              ),
                              isExpanded: true,
                              items: _tarjetas().map((String val) {
                                return DropdownMenuItem(
                                  value: val,
                                  child: Text(
                                    val,
                                  ),
                                );
                              }).toList(),
                            ),
                            RaisedButton(
                              onPressed: () {},
                              child: Text('Aceptar'),
                            ),
                            RaisedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Cancelar'),
                            )
                          ],
                        )
                      : Column(
                          children: [
                            Center(
                                child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text('No hay tarjetas guardadas'),
                            )),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: RaisedButton(
                                onPressed: () async {
                                  // Navigator.of(context).pushNamed('/AddCard', arguments: ArgumentsAddaCard(true)).
                                  // then((value) => setState((){}));

                                  tarjetaSeleccionada = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => addcard.AddCard(
                                            pago: true, total: total)),
                                  );
                                  //Navigator.pop(context);
                                  setState(() {
                                    Navigator.pop(context);
                                    cuotas = false;
                                    tarjeta = true;
                                    efectivo = false;
                                  });
                                },
                                child: Text('Nueva tarjeta'),
                                color: Colors.green,
                              ),
                            ),
                            RaisedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Cancelar'),
                            )
                          ],
                        ),
                ],
              ),
            ),
          ));
        });
  }

  List<String> _tarjetas() {
    List<String> t = [];
    for (int i = 0; i < globals.cards.length; i++) {
      t.add(globals.cards[i].paymentMethod.toString() +
          " terminada en " +
          globals.cards[i].lastFourDigits.toString());
    }
    return t;
  }

  dynamic Sumar(List<dynamic> lista, List<String> lista2) {
    double total = 0;
    lista.forEach((p) {
      int i = lista.indexOf(p);
      var t = p * int.parse(lista2[i]);
      total = total + t;
    });
    return total;
  }

  List<String> _cuotas() {
    List<String> c = [];
    for (int i = 0;
        i < tarjetaSeleccionada.cuotasTarj.payerCosts!.length;
        i++) {
      String s = tarjetaSeleccionada.cuotasTarj.payerCosts![i].installments
              .toString() +
          ' cuotas de ' +
          tarjetaSeleccionada.cuotasTarj.payerCosts![i].installmentAmount
              .toString();
      c.add(s);
    }
    return c;
  }
}

class Domicilio{
  String provincia;
  String municipio;
  String localidad;
  String calle;
  int numero;
  String piso;
  String departamento;

  Domicilio(this.provincia,
      this.municipio,
      this.localidad,
      this.calle,
      this.numero,
      this.piso,
      this.departamento);
}
