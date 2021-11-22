import 'dart:math';
import 'package:flutter/services.dart';
import 'package:till/constants/themes.dart';
import 'package:till/scripts/cloud_firestore.dart';
import 'package:till/scripts/mercadopago/customerJson.dart';
import 'package:till/scripts/mercadopago/json/crearCustomerJson.dart' as c;
import 'package:till/scripts/mercadopago/cuotasJson.dart';
import 'package:till/scripts/mercadopago/mercadoPago.dart';
import 'package:till/scripts/request.dart' as request;
//import 'package:till/home.dart' as home;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:till/globals.dart' as globals;

class AddCard extends StatefulWidget {
  const AddCard({Key? key, required this.pago, required this.total})
      : super(key: key);
  final bool pago;
  final double total;
  @override
  _AddCardState createState() => _AddCardState();
}

class _AddCardState extends State<AddCard> with SingleTickerProviderStateMixin {
  final _textFieldControllerNumber = TextEditingController();
  final _textFieldControllerName = TextEditingController();
  final _textFieldControllerExpire = TextEditingController();
  final _textFieldControllerSecCode = TextEditingController();
  final _textFieldControllerDocument = TextEditingController();
  GlobalKey<FormState> _keyForm = GlobalKey();
  GlobalKey<ScaffoldState> _keyScaf = GlobalKey();
  String numero = "**** **** **** ****";
  String documento = "** *** ***";
  String cvv = "***";
  String nombre = "NOMBRE APELLIDO";
  String vencimiento = "--/--";
  Cuotas cuotas = Cuotas();
  String metodoPago = "";
  int caracteres = 0;
  int caracteres2 = 0;
  int caracteres3 = 0;
  int caracteres4 = 0;
  int fase = 0;
  late AnimationController _animationController;
  late Animation<double> _animation;
  AnimationStatus _animationStatus = AnimationStatus.dismissed;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animation = Tween<double>(end: 1, begin: 0).animate(_animationController)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        _animationStatus = status;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _keyScaf,
      appBar: AppBar(
        title: widget.pago
            ? Text('Nueva tarjeta')
            : Text('Agregar tarjeta'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        constraints: BoxConstraints(
          minHeight: 2000,
          minWidth: double.infinity,
        ),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/assets/images/fondoClaro.jpg"),
            fit: BoxFit.fitWidth,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Center(child: Padding(
                padding: const EdgeInsets.only(top:15),
                child: Text('Paso ' + (fase + 1).toString() + '/3',
                style: TextStyle(
                  color: Colores.violeta,
                  fontSize: 16
                ),),
              )),
              SizedBox(
                height: 230,
                child: Center(
                  child: Transform(
                      alignment: FractionalOffset.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.002)
                        ..rotateY(pi * _animation.value),
                      child: fase == 2
                          ? _documento()
                          : _animation.value <= 0.5
                              ? _cardFront()
                              : _cardBack()),
                ),
              ),
              SizedBox(height: 40,),
              Form(
                  key: _keyForm,
                  child: fase == 0
                      ? _infoCard()
                      : (fase == 1)
                          ? _cvv()
                          : infoDocumento()),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _infoCard() {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(children: <Widget>[
        TextFormField(
          keyboardType: TextInputType.number,
          maxLength: 19,
          controller: _textFieldControllerNumber,
          decoration: InputDecoration(labelText: "Numero de la tarjeta:"),
          onChanged: (value) {
            _keyForm.currentState!.save();
          },
          onSaved: (value) async {
            if (_textFieldControllerNumber.value.text.length == 7 &&
                _textFieldControllerNumber.value.text.length > caracteres) {
              cuotas = await request.Cuotas(
                  _textFieldControllerNumber.value.text.replaceAll(" ", ""),
                  widget.total.toString());
              _MetodoPago(cuotas.paymentMethodId as String);
            }

            if (_textFieldControllerNumber.value.text.length < 7 &&
                _textFieldControllerNumber.value.text.length < caracteres) {
              cuotas = Cuotas();
              metodoPago = "";
            }

            if (_textFieldControllerNumber.value.text.length < caracteres &&
                    _textFieldControllerNumber.value.text.length == 4 ||
                _textFieldControllerNumber.value.text.length < caracteres &&
                    _textFieldControllerNumber.value.text.length == 9 ||
                _textFieldControllerNumber.value.text.length < caracteres &&
                    _textFieldControllerNumber.value.text.length == 14) {
            } else if (_textFieldControllerNumber.value.text.length == 4 ||
                _textFieldControllerNumber.value.text.length == 9 ||
                _textFieldControllerNumber.value.text.length == 14) {
              _textFieldControllerNumber.text =
                  _textFieldControllerNumber.value.text + " ";
              _textFieldControllerNumber
                ..selection = TextSelection.fromPosition(TextPosition(
                    offset: _textFieldControllerNumber.text.length));
            }
            String a = "**** **** **** ****";
            numero = a.replaceRange(
                0,
                _textFieldControllerNumber.value.text.length,
                _textFieldControllerNumber.value.text);

            setState(() {
              caracteres = _textFieldControllerNumber.value.text.length;
              //print(_textFieldControllerNumber.value.text);
              //print(numero);
            });
          },
          validator: (value) {
            if (value!.isEmpty) {
              return 'Este campo es obligatorio';
            }
          },
        ),
        TextFormField(
          maxLength: 30,
          controller: _textFieldControllerName,
          decoration: InputDecoration(labelText: "Nombre del titular:"),
          onChanged: (value) {
            _keyForm.currentState!.save();
          },
          onSaved: (value) {
            String a = "NOMBRE APELLIDO";
            if (_textFieldControllerName.value.text.length > 0) {
              nombre = _textFieldControllerName.value.text.toUpperCase();
            } else {
              nombre = a;
            }

            setState(() {});
          },
          validator: (value) {
            if (value!.isEmpty) {
              return 'Este campo es obligatorio';
            }
          },
        ),
        TextFormField(
          maxLength: 5,
          controller: _textFieldControllerExpire,
          decoration: InputDecoration(labelText: "Vencimiento:"),
          onChanged: (value) {
            _keyForm.currentState!.save();
          },
          onSaved: (value) {
            if (_textFieldControllerExpire.value.text.length < caracteres2 &&
                _textFieldControllerExpire.value.text.length == 2) {
            } else if (_textFieldControllerExpire.value.text.length == 2) {
              _textFieldControllerExpire.text =
                  _textFieldControllerExpire.value.text + "/";
              _textFieldControllerExpire
                ..selection = TextSelection.fromPosition(TextPosition(
                    offset: _textFieldControllerExpire.text.length));
            }
            String a = "--/--";
            vencimiento = a.replaceRange(
                0,
                _textFieldControllerExpire.value.text.length,
                _textFieldControllerExpire.value.text);

            setState(() {
              caracteres2 = _textFieldControllerExpire.value.text.length;
              //print(_textFieldControllerExpire.value.text);
              //print(vencimiento);
            });
          },
          validator: (value) {
            if (value!.isEmpty) {
              return 'Este campo es obligatorio';
            }
          },
        ),
        ButtonBar(
          children: <Widget>[
            FlatButton(
              onPressed: () {
                fase = 1;
                //if (_animationStatus == AnimationStatus.dismissed) {
                _animationController.forward();
                //} else {
                //  _animationController.reverse();
                //}
              },
              child: Text(
                "Siguiente",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ],
        )
      ]),
    );
  }

  Widget _cvv() {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(children: <Widget>[
        TextFormField(
          keyboardType: TextInputType.number,
          obscureText: false,
          maxLength: 4,
          controller: _textFieldControllerSecCode,
          decoration: InputDecoration(labelText: "Codigo de seguridad:"),
          onChanged: (value) {
            _keyForm.currentState!.save();
          },
          onSaved: (value) {
            print(_textFieldControllerSecCode.value.text.length);
            String a = "";
            for (int b = 0;
                b < _textFieldControllerSecCode.value.text.length;
                b++) {
              a = a + "*";
            }
            if (a == "") {
              a = "***";
            }
            setState(() {
              cvv = a;
            });
          },
          validator: (value) {
            if (value!.isEmpty) {
              return 'Este campo es obligatorio';
            }
          },
        ),
        ButtonBar(
          children: <Widget>[
            FlatButton(
              onPressed: () {
                fase--;
                setState(() {});
                print(fase);
                //if (_animationStatus == AnimationStatus.dismissed) {
                //  _animationController.forward();
                //} else {
                _animationController.reverse();
                //}
              },
              child: Text(
                "Anterior",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            FlatButton(
              onPressed: () {
                fase++;
                _animationController.reverse();
                setState(() {});
                print(fase);
              },
              child: Text(
                "Siguiente",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ],
        )
      ]),
    );
  }

  Widget _cardFront() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 5,
      //color: Colors.grey[300],
      child: Container(
        width: 280,
        height: 180,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [Colors.orangeAccent, Colors.deepOrangeAccent])),
        child: Column(
          children: <Widget>[
            Row(children: <Widget>[
              Container(
                margin: EdgeInsets.all(25),
                alignment: Alignment.centerLeft,
                width: 70,
                height: 50,
                decoration: BoxDecoration(
                    image: metodoPago != ""
                        ? DecorationImage(
                            image: new AssetImage(metodoPago),
                            fit: BoxFit.contain,
                          )
                        : null,
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        colors: [Colors.white70, Colors.white70])),
              ),
            ]),
            Row(children: <Widget>[
              SizedBox(
                width: 18,
              ),
              Padding(
                  padding: EdgeInsets.all(0),
                  child: Text(
                    numero,
                    style: TextStyle(fontSize: 22, color: Colors.white),
                  ))
            ]),
            SizedBox(
              height: 7,
            ),
            Row(children: <Widget>[
              SizedBox(
                width: 15,
              ),
              Padding(
                  padding: EdgeInsets.all(0),
                  child: Text(
                    nombre,
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  )),
              SizedBox(
                width: 20,
              ),
              Text(
                vencimiento,
                style: TextStyle(fontSize: 18, color: Colors.white),
              )
            ]),
          ],
        ),
      ),
    );
  }

  Widget _cardBack() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 5,
      //color: Colors.grey[300],
      child: Container(
        width: 280,
        height: 180,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [Colors.orangeAccent, Colors.deepOrangeAccent])),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            ConstrainedBox(
              constraints: const BoxConstraints.tightFor(
                width: double.infinity,
              ),
              child: Container(
                alignment: Alignment.center,
                width: 280,
                height: 45,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            SizedBox(
              height: 10,
            ),
            Row(mainAxisSize: MainAxisSize.min,
                //crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    width: 60,
                    height: 30,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(0),
                        gradient: LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            colors: [Colors.white, Colors.white])),
                    child: Padding(
                        padding: EdgeInsets.all(0),
                        child: Text(
                          cvv,
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        )),
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: 220,
                    height: 30,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(0),
                        gradient: LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            colors: [Colors.grey, Colors.blueGrey])),
                  ),
                ]),
          ],
        ),
      ),
    );
  }

  Widget infoDocumento() {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(children: <Widget>[
        TextFormField(
          keyboardType: TextInputType.number,
          maxLength: 10,
          controller: _textFieldControllerDocument,
          decoration: InputDecoration(labelText: "Numero de documento:"),
          onChanged: (value) {
            _keyForm.currentState!.save();
          },
          onSaved: (value) {
            if (_textFieldControllerDocument.value.text.length == 2 &&
                    caracteres4 <
                        _textFieldControllerDocument.value.text.length ||
                _textFieldControllerDocument.value.text.length == 6 &&
                    caracteres4 <
                        _textFieldControllerDocument.value.text.length) {
              _textFieldControllerDocument.text =
                  _textFieldControllerDocument.value.text + ".";
              _textFieldControllerDocument
                ..selection = TextSelection.fromPosition(TextPosition(
                    offset: _textFieldControllerDocument.text.length));
            }
            String a = "** *** ***";
            documento = a.replaceRange(
                0,
                _textFieldControllerDocument.value.text.length,
                _textFieldControllerDocument.value.text);
            setState(() {
              caracteres4 = _textFieldControllerDocument.value.text.length;
            });
          },
          validator: (value) {
            if (value!.isEmpty) {
              return 'Este campo es obligatorio';
            }
          },
        ),
        ButtonBar(
          children: <Widget>[
            FlatButton(
              onPressed: () {
                fase--;
                _animationController.forward();
                setState(() {});
                //if (_animationStatus == AnimationStatus.dismissed) {
                //} else {
                //  _animationController.reverse();
                //}
              },
              child: Text(
                "Anterior",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            RaisedButton(
              onPressed: () {
                _nuevaTarjeta();
              },
              color: Theme.of(context).primaryColor,
              child: widget.pago
                  ? Text(
                      "Aceptar",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                      ),
                    )
                  : Text(
                      "Agregar",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                      ),
                    ),
            ),
          ],
        )
      ]),
    );
  }

  Widget _documento() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 5,
      //color: Colors.grey[300],
      child: Container(
        width: 280,
        height: 180,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [Colors.grey, Colors.blueGrey])),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(children: <Widget>[
                Container(
                  child: Image.asset(
                    'lib/assets/icons/avatarDocumento.png',
                    fit: BoxFit.fitHeight,
                  ),
                  height: 70,
                ),
                SizedBox(
                  width: 10,
                ),
                Text('NUMERO DE \n DOCUMENTO DE \n IDENTIDAD',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    )),
              ]),
            ),
            SizedBox(
              height: 15,
            ),
            Row(children: <Widget>[
              SizedBox(
                width: 100,
              ),
              Transform(
                transform: Matrix4.translationValues(0, -20, 0),
                child: Text(
                  documento,
                  style: TextStyle(fontSize: 25, color: Colors.white),
                ),
              )
            ]),
            Row(children: <Widget>[
              SizedBox(
                width: 10,
              ),
            ]),
          ],
        ),
      ),
    );
  }

  void _cargando() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              elevation: 0,
              backgroundColor: Colors.transparent,
              content: Center(
                child: CircularProgressIndicator(),
              ));
        });
  }

  void _pagoTarjeta() async {
    print('volviendo al pago..');
    DatosTarjeta datos = new DatosTarjeta();
    datos.numeros = _textFieldControllerNumber.value.text.replaceAll(" ", "");
    datos.nombre = _textFieldControllerName.value.text.toUpperCase();
    datos.mes =
        _textFieldControllerExpire.value.text.toString().substring(0, 2);
    datos.ano =
        _textFieldControllerExpire.value.text.toString().substring(3, 5);
    datos.docTipo = "DNI";
    datos.docNum = _textFieldControllerDocument.value.text.replaceAll(".", "");
    datos.cvv = _textFieldControllerSecCode.value.text;

    _cargando();

    String token = await CardToken(datos);
    print('token card $token');
    final respuesta = await GuardarTarjeta(token);
    print("respuesta a guardar tarjeta > " + respuesta.toString());

    if (respuesta.toString() != "0") {
      _mostrarMensaje("La tarjeta se guardo correctamente!");
      Navigator.pop(context);
    } else {
      _mostrarMensaje("Ocurrio un error. Vuelva a intentar.");
      Navigator.pop(context);
    }

    // if(respuesta == "0") {
    //   TarjetaPago t = new TarjetaPago(datos, respuesta, cuotas);
    //   Navigator.pop(context, t);
    // }else{
    TarjetaPago t = new TarjetaPago(datos, token, cuotas);
    Navigator.pop(context, t);
    // }
  }

  void _agregarTarjeta() async {
    print('agregando tarjeta');
    DatosTarjeta datos = new DatosTarjeta();
    datos.numeros = _textFieldControllerNumber.value.text.replaceAll(" ", "");
    datos.nombre = _textFieldControllerName.value.text.toUpperCase();
    datos.mes =
        _textFieldControllerExpire.value.text.toString().substring(0, 2);
    datos.ano =
        _textFieldControllerExpire.value.text.toString().substring(3, 5);
    datos.docTipo = "DNI";
    datos.docNum = _textFieldControllerDocument.value.text.replaceAll(".", "");
    datos.cvv = _textFieldControllerSecCode.value.text;

    String token = await CardToken(datos);
    print("token > " + token);
    final respuesta = await GuardarTarjeta(token);
    print("respuesta a guardar tarjeta > " + respuesta.toString());

    if (respuesta.toString() != "0") {
      _mostrarMensaje("La tarjeta se guardo correctamente!");
      Navigator.pop(context);
    } else {
      _mostrarMensaje("Ocurrio un error. Vuelva a intentar.");
    }
  }

  void _crearCustomer() async {
    print('creando customer');
    if (globals.usuario!.correo == "") {
      print(globals.usuario!.correo! +
          globals.usuario!.nombre! +
          globals.usuario!.apellido!);
      return;
    }
    c.Datos customer = c.Datos();
    customer.email = globals.usuario!.correo;
    customer.firstName = globals.usuario!.nombre;
    customer.lastName = "Corbera";
    c.Phone phone = c.Phone();
    phone.areaCode = "011";
    phone.areaCode = "11111111";
    customer.phone = phone;
    c.Identification ident = c.Identification();
    ident.type = "DNI";
    ident.number = "12345678";
    customer.identification = ident;
    c.Address dire = c.Address();
    dire.streetName = "calle falsa";
    dire.streetNumber = 132;
    customer.address = dire;

    CreateCustomer resp = await request.crearCustomer(customer);

    if (resp.id!='') {
      globals.usuario!.id_customer_mp = resp.id;
      Map<String, String> datos = {
        "id_customer_mp": resp.id.toString()
      };
      UpdateUser(globals.usuario!.id.toString()).updateUser(datos);
    }
  }
  void _consultarCustomer() async{
    print('consultando customer...');
    String respuesta = await BuscarCustomer(globals.usuario!.correo.toString());
    if(respuesta != "0") {
      print('hay customer > ' + respuesta);
      globals.usuario!.id_customer_mp = respuesta;
    }else{
      print('no hay customer');
    }

  }

  void _mostrarMensaje(String msg) {
    SnackBar snackBar = SnackBar(
      content: Text(msg),
    );
    _keyScaf.currentState!.showSnackBar(snackBar);
  }

  void _MetodoPago(String id) {
    switch (id) {
      case "diners":
        metodoPago = 'lib/assets/icons/logosMetodoPago/diners.png';
        return;
      case "argencard":
        metodoPago = 'lib/assets/icons/logosMetodoPago/argencard.jpg';
        return;
      case "maestro":
        metodoPago = 'lib/assets/icons/logosMetodoPago/maestro.png';
        return;
      case "debvisa":
        metodoPago = 'lib/assets/icons/logosMetodoPago/visadebito.jpg';
        return;
      case "cencosud":
        metodoPago = 'lib/assets/icons/logosMetodoPago/cencosud.jpg';
        return;
      case "debcabal":
        metodoPago = 'lib/assets/icons/logosMetodoPago/cabalDebito.jpg';
        return;
      case "visa":
        metodoPago = 'lib/assets/icons/logosMetodoPago/visa.png';
        return;
      case "master":
        metodoPago = 'lib/assets/icons/logosMetodoPago/master.png';
        return;
      case "amex":
        metodoPago = 'lib/assets/icons/logosMetodoPago/amex.png';
        return;
      case "naranja":
        metodoPago = 'lib/assets/icons/logosMetodoPago/naranja.png';
        return;
      case "tarshop":
        metodoPago = 'lib/assets/icons/logosMetodoPago/shopping.png';
        return;
      case "cabal":
        metodoPago = 'lib/assets/icons/logosMetodoPago/cabal.png';
        return;
      case "debmaster":
        metodoPago = 'lib/assets/icons/logosMetodoPago/master.png';
        return;
      case "cordobesa":
        metodoPago = 'lib/assets/icons/logosMetodoPago/cordobesa.jpg';
        return;
      case "cmr":
        metodoPago = 'lib/assets/icons/logosMetodoPago/cmr.jpg';
        return;
    }
  }

  void _nuevaTarjeta() {
     _consultarCustomer();
    if (globals.usuario!.id_customer_mp != "") {
      widget.pago ? _pagoTarjeta() : _agregarTarjeta();
    } else {
      _crearCustomer();
      widget.pago ? _pagoTarjeta() : _agregarTarjeta();
    }
  }


}

class TarjetaPago {
  final DatosTarjeta datosTarj;
  final idTarjeta;
  final Cuotas cuotasTarj;
  TarjetaPago(this.datosTarj, this.idTarjeta, this.cuotasTarj);
}
