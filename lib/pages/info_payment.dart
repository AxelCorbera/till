import 'package:flutter/material.dart';
import 'package:till/constants/themes.dart';
import 'package:till/globals.dart' as globals;
import 'package:till/pages/addcard.dart' as addcard;
import 'package:till/pages/checkout.dart';
import 'package:till/scenes/components/direccion.dart';
import 'package:till/scripts/mercadopago/cuotasJson.dart';
import 'package:till/scripts/mercadopago/mercadoPago.dart';
import 'package:till/scripts/mercadopago/cardsJson.dart';

class Info_Payment extends StatefulWidget {
  @override
  _InfoPaymentState createState() => _InfoPaymentState();
}

class _InfoPaymentState extends State<Info_Payment> {
  List<Cards> tarjetas = [];
  bool efectivo = false;
  bool tarjeta = false;
  bool cuotas = false;
  double total = 0;
  String cuotaSeleccionada = '';
  Domicilio domicilio = Domicilio(
      globals.usuario!.provincia.toString(),
      globals.usuario!.municipio.toString(),
      globals.usuario!.localidad.toString(),
      globals.usuario!.calle.toString(),
      int.parse(globals.usuario!.numero.toString()),
      globals.usuario!.piso.toString(),
      globals.usuario!.departamento.toString());
  Direcciones dir = new Direcciones();
  addcard.TarjetaPago tarjetaSeleccionada =
      new addcard.TarjetaPago(DatosTarjeta(), '', Cuotas());
  GlobalKey<FormState> _keyForm = GlobalKey();
  Widget build(BuildContext context) {
    tarjetas.clear();
    globals.cards.forEach((element) {
      tarjetas.add(element as Cards);
    });

    total = Sumar(globals.carrito.precio, globals.carrito.cantidad);
    return Scaffold(
        appBar: AppBar(
          title: Text("Checkuot"),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: Container(
          constraints: BoxConstraints(
            minHeight: 2000,
            minWidth: double.infinity,
          ),
          decoration: const BoxDecoration(
            image: const DecorationImage(
              image: AssetImage("lib/assets/images/fondoClaro.jpg"),
              fit: BoxFit.fitWidth,
            ),
          ),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Image.asset(
                  "lib/assets/images/nenito_check.png",
                  width: 280,
                ),
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                      alignment: Alignment.centerLeft,
                      width: 280,
                      child: Text(
                        'Domicilio de facturacion',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Container(
                      width: 280,
                      child: RaisedButton(
                        onPressed: () {
                          _direccion(context, '', '', '', '');
                        },
                        child: domicilio.calle.isEmpty
                            ? Text(
                                'Seleccionar domicilio',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              )
                            : Text(
                                'Cambiar',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ),
                      ),
                    ),
                    if (domicilio.calle != '')
                      Text(
                        domicilio.calle +
                            ' ' +
                            domicilio.numero.toString() +
                            ', ' +
                            domicilio.localidad,
                        style: TextStyle(
                          color: Colores.rojo,
                        ),
                      ),
                    Center(
                      child: Container(
                          padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                          width: 280,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Forma de pago',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          )),
                    ),
                    tarjetas.length > 0
                        ? Container(
                            height: 60,
                            width: 280,
                            child: DropdownButtonFormField(
                              value: tarjetas.length > 0 ? tarjetas[0] : null,
                              onTap: () {},
                              onSaved: (value) {},
                              onChanged: (value) {
                                setState(() {});
                              },
                              hint: const Text(
                                'Seleccioná una tarjeta',
                              ),
                              isExpanded: true,
                              items: tarjetas.map((Cards val) {
                                return DropdownMenuItem(
                                  value: val,
                                  child: Text(
                                    val.id.toString() +
                                        ' terminada en ' +
                                        val.lastFourDigits.toString(),
                                  ),
                                );
                              }).toList(),
                            ),
                          )
                        : Container(
                            width: 280,
                            child: RaisedButton(
                              onPressed: () async {
                               _nuevaTarjeta();
                              },
                              child: Text(
                                'Nueva tarjeta',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ),
                            ),
                          ),
                    tarjetaSeleccionada.datosTarj.numeros != null &&
                            tarjetaSeleccionada.idTarjeta != '0'
                        ? Center(
                            child: Container(
                              width: double.infinity,
                              height: 120,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                      padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                                      width: 280,
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Cuotas',
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      )),
                                  Form(
                                    child: Container(
                                      width: 280,
                                      height: 60,
                                      child: DropdownButtonFormField(
                                        onTap: () {},
                                        onSaved: (value) {},
                                        onChanged: (value) {
                                          cuotas = true;
                                          cuotaSeleccionada =
                                              value.toString().substring(0, 2);
                                          cuotaSeleccionada = cuotaSeleccionada
                                              .replaceAll(' ', '');
                                          print('cuotas $cuotaSeleccionada<');
                                          setState(() {});
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
                          )
                        : SizedBox(),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        'Total: \$' + total.toStringAsFixed(2),
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ),
                    Container(
                      child: tarjetaSeleccionada.idTarjeta == '0'
                          ? Text(
                              "Ocurrio un error.",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13),
                            )
                          : tarjeta
                              ? Text(
                                  tarjetaSeleccionada.cuotasTarj.paymentMethodId
                                          .toString() +
                                      " terminada en " +
                                      tarjetaSeleccionada.datosTarj.numeros
                                          .toString()
                                          .substring(12, 16),
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13),
                                )
                              : efectivo
                                  ? Text(
                                      'Pago en efectivo',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13),
                                    )
                                  : Text(
                                      '',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13),
                                    ),
                    ),
                  ],
                ),
                Center(
                  child: RaisedButton(
                      color: Theme.of(context).primaryColor,
                      onPressed:
                              globals.usuario!.calle != '' &&
                                  tarjetaSeleccionada.idTarjeta!=''
                          ? () {
                              String number = total.toStringAsFixed(2);
                              total = double.parse(number);
                              Navigator.of(context).pushNamed('/Checkout',
                                  arguments: ArgumentosCheckout(
                                      tarjetaSeleccionada,
                                      total,
                                      domicilio,
                                      cuotaSeleccionada));
                            }
                          : null,
                      child: Container(
                        alignment: Alignment.center,
                        width: 280,
                        child: Text(
                          "Continuar",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      )),
                )
              ]),
        ));
  }

  void _direccion(
      BuildContext context, String prov, String muni, String loc, String dire) {
    String calle = '';
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                content: SingleChildScrollView(
                  child: Form(
                    key: loc != '' ? _keyForm : null,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        DropdownButtonFormField(
                          value: prov != '' ? prov : null,
                          onTap: () {},
                          onSaved: (value) {},
                          onChanged: (value) {
                            setState(() {
                              prov = value.toString();
                            });
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
                        prov != ''
                            ? DropdownButtonFormField(
                                value: muni != '' ? muni : null,
                                onTap: () {},
                                onSaved: (value) {},
                                onChanged: (value) {
                                  setState(() {
                                    muni = value.toString();
                                  });
                                  // Navigator.pop(context);
                                  //_direccion(context, prov, value.toString(), '', '');
                                },
                                hint: Text(
                                  'Municipio',
                                ),
                                isExpanded: true,
                                items:
                                    dir.ListaMunicipio(prov).map((String val) {
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
                                  setState(() {
                                    loc = value.toString();
                                  });
                                  //Navigator.pop(context);
                                  //_direccion(
                                  //    context, prov, muni, value.toString(), '');
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
                        if (loc != '')
                          TextFormField(
                            initialValue: dire != '' ? dire : null,
                            decoration: InputDecoration(
                              labelText: "Calle: ",
                            ),
                            onSaved: (value) {},
                            onChanged: (value) {
                              domicilio.calle = value.toString().toUpperCase();
                            },
                            validator: (value) {
                              if (value.toString().isEmpty)
                                return 'Este campo es obligatorio';
                            },
                          ),
                        if (loc != '')
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
                        if (loc != '')
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: "Piso: ",
                            ),
                            onSaved: (value) {},
                            onChanged: (value) {
                              domicilio.piso = value.toString().toUpperCase();
                            },
                          ),
                        if (loc != '')
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: "Departamento: ",
                            ),
                            onSaved: (value) {},
                            onChanged: (value) {
                              domicilio.departamento =
                                  value.toString().toUpperCase();
                            },
                          ),
                        if (loc != '')
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
                                    _actualizar();
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
            },
          );
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
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6)),
                                padding: const EdgeInsets.all(0.0),
                                child: Ink(
                                  width: 150,
                                  height: 35,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: Alignment.bottomLeft,
                                        end: Alignment.topRight,
                                        colors: Colores.combinacion1),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(6)),
                                  ),
                                  child: Container(
                                    constraints: const BoxConstraints(
                                        minWidth: 88.0, minHeight: 45.0),
                                    // min sizes for Material buttons
                                    alignment: Alignment.center,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Nueva tarjeta',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            FlatButton(
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

  dynamic Sumar(List<dynamic> lista, List<int> lista2) {
    double total = 0;
    lista.forEach((p) {
      int i = lista.indexOf(p);
      var t = p * lista2[i];
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

  void _actualizar() {
    setState(() {});
  }

  void _nuevaTarjeta() async{
    tarjetaSeleccionada = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => addcard.AddCard(
              pago: false, total: total)),
    );
    //Navigator.pop(context);
    setState(() {

    });
  }
}

class Domicilio {
  String provincia;
  String municipio;
  String localidad;
  String calle;
  int numero;
  String piso;
  String departamento;

  Domicilio(this.provincia, this.municipio, this.localidad, this.calle,
      this.numero, this.piso, this.departamento);
}
