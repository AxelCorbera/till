import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:till/constants/themes.dart';
import 'package:till/globals.dart' as globals;
import 'package:till/pages/addcard.dart';
import 'package:till/pages/info_payment.dart';
import 'package:till/pages/respuesta_pago.dart';
import 'package:till/scripts/mercadopago/json/baseDatos.dart' as db;
import 'package:till/scripts/mercadopago/cardsJson.dart' as card;
import 'package:till/scripts/mercadopago/mercadoPago.dart';
import 'package:till/scripts/mercadopago/payment.dart';
import 'package:till/scripts/mercadopago/responsePayment2.dart' as payment;
import 'package:till/scripts/request.dart' as request;
import 'package:till/scripts/mercadopago/responsePayment.dart' as response;
import 'package:url_launcher/url_launcher.dart';

import '../globals.dart';

class Checkout extends StatefulWidget {
  const Checkout(
      {Key? key,
      required this.tarjeta,
      required this.total,
      required this.domicilio,
      required this.cuota})
      : super(key: key);

  final TarjetaPago tarjeta;
  final double total;
  final Domicilio domicilio;
  final String cuota;
  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> with TickerProviderStateMixin {
  double _height = 20;
  double _width = 20;
  String cvv = '';
  BorderRadiusGeometry _borderRadius = BorderRadius.circular(300);
  bool realizado1 = false;
  bool realizado2 = false;
  bool anim1 = false;
  bool anim2 = false;
  String telefono = '';
  String ticket = '';
  //String respuestaPago = '';
  GlobalKey<FormState> _keyform = GlobalKey();
  GlobalKey<FormState> _keyform2 = GlobalKey();
  GlobalKey<ScaffoldState> _keyScaf = GlobalKey();

  Widget build(BuildContext context) {
    return Scaffold(
      key: _keyScaf,
      backgroundColor: Colors.white,
      appBar: realizado2
          ? null
          : AppBar(
              title: Text("Checkout"),
              backgroundColor: Colores.azulOscuro,
            ),
      body: Container(
        constraints: const BoxConstraints(
          minHeight: 2000,
          minWidth: double.infinity,
        ),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/assets/images/fondoClaro.jpg"),
            fit: BoxFit.fitWidth,
          ),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 25.0),
                    child: Center(
                      child: Text(
                        '¡Ultimo paso!',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Text(
                        'Direccion de facturacion:',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            //color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      alignment: Alignment.center,
                      child: widget.domicilio.calle != ''
                          ? Text(
                              widget.domicilio.calle +
                                  ' ' +
                                  widget.domicilio.numero.toString() +
                                  ' ' +
                                  widget.domicilio.piso +
                                  ' ' +
                                  widget.domicilio.departamento +
                                  ', ' +
                                  widget.domicilio.localidad +
                                  ', ' +
                                  widget.domicilio.municipio,
                              style: TextStyle(
                                  color: Colores.violeta,
                                  fontWeight: FontWeight.bold),
                            )
                          : Text(
                              'NO',
                              style: TextStyle(
                                  color: Colores.violeta,
                                  fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                  new Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Text(
                        'Forma de pago:',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            //color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      alignment: Alignment.center,
                      child: widget.tarjeta.datosTarj.numeros != null
                          ? Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      widget.tarjeta.cuotasTarj.paymentMethodId
                                              .toString()
                                              .toUpperCase() +
                                          " TERMINADA EN " +
                                          widget.tarjeta.ultimosCuatro
                                              .toString(),
                                      style: TextStyle(
                                          color: Colores.violeta,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Container(
                                      width: 120,
                                      child: Form(
                                        key: _keyform2,
                                        child: TextFormField(
                                          keyboardType: TextInputType.number,
                                          onChanged: (value) {
                                            cvv = value.toString();
                                          },
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[700],
                                          ),
                                          decoration: const InputDecoration(
                                            labelText: 'CVV',
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey),
                                            ),
                                            border: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey),
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value.toString().length < 3)
                                              return 'Codigo invalido';
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (widget.cuota != '1') _cuotasMonto()
                              ],
                            )
                          : Container(
                              child: Text(
                              'EFECTIVO',
                              style: TextStyle(
                                  color: Colores.violeta,
                                  fontWeight: FontWeight.bold),
                            )),
                    ),
                  ),
                  new Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Text(
                        'Telefono: *',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            //color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      width: 300,
                      child: Form(
                        key: _keyform,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            telefono = value;
                          },
                          validator: (value) {
                            if (value.toString().isEmpty)
                              return 'El campo es obligatorio';
                          },
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
                        ),
                      ),
                    ),
                  ),
                  new Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total:',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                //color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: _total(),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Center(
                    child: RaisedButton(
                      onPressed: () {
                        if (_keyform2.currentState!.validate() &&
                            _keyform.currentState!.validate()) {
                          _pagar();
                        }
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.all(0.0),
                      child: Ink(
                        width: 350,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                              colors: Colores.combinacion1),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: Container(
                          constraints: const BoxConstraints(
                              minWidth: 88.0, minHeight: 45.0),
                          // min sizes for Material buttons
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Pagar',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
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
            // _respuestaPago1(),
            // _respuestaPago2(),
          ],
        ),
      ),
    );
  }

  // Widget _respuestaPago1() {
  //   Widget w1 = AnimatedContainer(
  //     width: realizado1
  //         ? realizado2
  //             ? MediaQuery.of(context).size.width
  //             : 100
  //         : 0,
  //     height: realizado1
  //         ? realizado2
  //             ? MediaQuery.of(context).size.height/2
  //             : 100
  //         : 0,
  //     decoration: realizado1
  //         ? BoxDecoration(
  //             color: respuestaPago == 'aprobado'
  //                 ? Colors.white
  //                 : respuestaPago == 'rechazado'
  //                     ? Colors.redAccent
  //                     : Theme.of(context).primaryColor,
  //             borderRadius: _borderRadius,
  //             image: const DecorationImage(
  //                 image: AssetImage('lib/assets/images/fondoAprobado.png'),
  //                 fit: BoxFit.contain,))
  //         : BoxDecoration(
  //             color: Colors.transparent,
  //             borderRadius: _borderRadius,
  //           ),
  //     duration: Duration(seconds: 2),
  //     curve: Curves.fastOutSlowIn,
  //     child: Center(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           AnimatedContainer(
  //             transform: anim1
  //                 ? Matrix4.translationValues(
  //                     0, -(MediaQuery.of(context).size.height / 3.45), 0)
  //                 : Matrix4.translationValues(0, -5, 0),
  //             child: realizado1
  //                 ? Column(
  //                     children: [
  //                       AnimatedContainer(
  //                         width: realizado1 ? 100 : 101,
  //                         height: realizado1 ? 100 : 101,
  //                         duration: Duration(seconds: 1),
  //                         child: realizado1
  //                             ? Icon(
  //                                 respuestaPago == 'aprobado'
  //                                     ? Icons.done_rounded
  //                                     : respuestaPago == 'rechazado'
  //                                         ? Icons.cancel_outlined
  //                                         : Icons.error_outline,
  //                                 color: Colors.green,
  //                                 size: 70,
  //                               )
  //                             : SizedBox(),
  //                         onEnd: () {},
  //                       ),
  //                       SizedBox(
  //                         height: 20,
  //                       ),
  //                       Text(
  //                         'Pago $respuestaPago',
  //                         style: anim2
  //                             ? const TextStyle(
  //                                 color: Colors.white,
  //                                 fontSize: 25,
  //                                 //fontWeight: FontWeight.bold
  //                               )
  //                             : const TextStyle(
  //                                 color: Colors.transparent,
  //                                 fontSize: 25,
  //                                 //fontWeight: FontWeight.bold
  //                               ),
  //                       ),
  //                     ],
  //                   )
  //                 : null,
  //             onEnd: () {
  //               setState(() {
  //                 anim2 = true;
  //               });
  //             },
  //             duration: Duration(seconds: 1),
  //           ),
  //         ],
  //       ),
  //     ),
  //     onEnd: () {
  //       setState(() {
  //         if (realizado2 == false) {
  //           realizado2 = true;
  //           _borderRadius = BorderRadius.circular(0);
  //         } else {
  //           anim1 = true;
  //         }
  //       });
  //     },
  //   );
  //
  //   return w1;
  // }

  // Widget _respuestaPago2() {
  //   Widget _datos = respuestaPago == 'aprobado'
  //       ? Column(
  //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //           children: <Widget>[
  //             const Padding(
  //               padding: EdgeInsets.all(8.0),
  //               child: Text(
  //                 'Su pedido fue realizado!',
  //                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
  //               ),
  //             ),
  //             Padding(
  //               padding: const EdgeInsets.all(8.0),
  //               child: Text(
  //                 'Ticket Nro: $ticket',
  //                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
  //               ),
  //             ),
  //             const Padding(
  //               padding: EdgeInsets.all(8.0),
  //               child: Text(
  //                 'Podras ver el estado del pedido en la pantalla de inicio.',
  //                 style: TextStyle(
  //                   fontSize: 15,
  //                 ),
  //                 textAlign: TextAlign.center,
  //               ),
  //             ),
  //             FlatButton.icon(
  //               icon: Icon(Icons.sms),
  //               onPressed: () {
  //                 _consulta(ticket);
  //               },
  //               label: const Text(
  //                 ''
  //                 'Comunicate con nuestro \n WhatsApp para coordinar la entrega.',
  //                 style: TextStyle(
  //                   fontWeight: FontWeight.bold,
  //                   fontSize: 15,
  //                 ),
  //                 textAlign: TextAlign.center,
  //               ),
  //             ),
  //             RaisedButton(
  //                 onPressed: () {
  //                   Navigator.of(context).pushNamed('/Home');
  //                 },
  //                 child: const Text('Continuar')),
  //             const Padding(
  //               padding: EdgeInsets.all(8.0),
  //               child: Text(
  //                 'Gracias por elegirnos!',
  //                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
  //               ),
  //             ),
  //           ],
  //         )
  //       : respuestaPago == 'rechazado'
  //           ? Column(
  //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //               children: <Widget>[
  //                 const Padding(
  //                   padding: EdgeInsets.all(8.0),
  //                   child: Text(
  //                     'Algo salio mal.',
  //                     style:
  //                         TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
  //                   ),
  //                 ),
  //                 const Padding(
  //                   padding: EdgeInsets.all(8.0),
  //                   child: Text(
  //                     'Revisa los datos de tu tarjeta y volve a intentarlo.',
  //                     style: TextStyle(
  //                       fontSize: 15,
  //                     ),
  //                     textAlign: TextAlign.center,
  //                   ),
  //                 ),
  //                 RaisedButton(
  //                     onPressed: () {
  //                       Navigator.pop(context);
  //                     },
  //                     child: Text('Reintentar')),
  //                 RaisedButton(
  //                     onPressed: () {
  //                       Navigator.of(context).pushNamed('/Home');
  //                     },
  //                     child: const Text('Continuar')),
  //                 const SizedBox(
  //                   height: 100,
  //                 )
  //               ],
  //             )
  //           : Column(
  //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //               children: <Widget>[
  //                 const Padding(
  //                   padding: EdgeInsets.all(8.0),
  //                   child: Text(
  //                     'Procesando el pago.',
  //                     style:
  //                         TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
  //                   ),
  //                 ),
  //                 const Padding(
  //                   padding: EdgeInsets.all(8.0),
  //                   child: Text(
  //                     'El pago se esta procesando. Esto puede demorar unos minutos.',
  //                     style: TextStyle(
  //                       fontSize: 15,
  //                     ),
  //                     textAlign: TextAlign.center,
  //                   ),
  //                 ),
  //                 const Padding(
  //                   padding: EdgeInsets.all(8.0),
  //                   child: Text(
  //                     'Puedes ver el estado del pago en el inicio.',
  //                     style: TextStyle(
  //                       fontSize: 15,
  //                     ),
  //                     textAlign: TextAlign.center,
  //                   ),
  //                 ),
  //                 RaisedButton(
  //                     onPressed: () {
  //                       Navigator.pop(context);
  //                     },
  //                     child: Text('Reintentar')),
  //                 RaisedButton(
  //                     onPressed: () {
  //                       Navigator.of(context).pushNamed('/Home');
  //                     },
  //                     child: Text('Continuar')),
  //                 SizedBox(
  //                   height: 100,
  //                 )
  //               ],
  //             );
  //
  //   Widget w2 = realizado2
  //       ? Column(
  //           mainAxisAlignment: MainAxisAlignment.end,
  //           children: [
  //             AnimatedContainer(
  //               width: MediaQuery.of(context).size.width,
  //               height: MediaQuery.of(context).size.height / 1.6,
  //               color: anim2 ? Colors.white : Colors.transparent,
  //               child: Container(
  //                   child: Card(
  //                       elevation: 0,
  //                       color: Colors.transparent,
  //                       child: anim2 ? _datos : null)),
  //               onEnd: () {},
  //               duration: const Duration(seconds: 1),
  //             ),
  //           ],
  //         )
  //       : const SizedBox();
  //   return w2;
  // }

  Widget _total() {
    if (widget.cuota != '1' && widget.tarjeta.datosTarj.numeros != null) {
      int index = 0;
      for (int i = 0; i < widget.tarjeta.cuotasTarj.payerCosts!.length; i++) {
        if (widget.tarjeta.cuotasTarj.payerCosts![i].installments.toString() ==
            widget.cuota) {
          index = i;
        }
      }
      String number = widget.tarjeta.cuotasTarj.payerCosts![index].totalAmount!
          .toStringAsFixed(2);
      double t = double.parse(number);
      return Text(
        '\$ ' + t.toString(),
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          //color: Colors.black,
          fontSize: 25,
          //fontWeight: FontWeight.bold
        ),
      );
    } else {
      return Text(
        '\$ ' + widget.total.toString(),
        style: TextStyle(
          //color: Colors.black,
          fontSize: 23,
          //fontWeight: FontWeight.bold
        ),
      );
    }
  }

  Widget _cuotasMonto() {
    int index = 0;
    for (int i = 0; i < widget.tarjeta.cuotasTarj.payerCosts!.length; i++) {
      if (widget.tarjeta.cuotasTarj.payerCosts![i].installments.toString() ==
          widget.cuota) {
        index = i;
      }
    }
    return Text(
      widget.tarjeta.cuotasTarj.payerCosts![index].installments.toString() +
          ' cuotas de \$ ' +
          widget.tarjeta.cuotasTarj.payerCosts![index].installmentAmount
              .toString(),
      style: TextStyle(color: Colores.violeta, fontWeight: FontWeight.bold),
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

  void _pagar() async {
    if (_numeroTarjeta(widget.tarjeta.idTarjeta) == '') {
      _mostrarMensaje('Error en datos de tarjeta');
      return;
    }

    DatosTarjeta datos = DatosTarjeta(
        numeros: _numeroTarjeta(widget.tarjeta.idTarjeta),
        nombre: widget.tarjeta.datosTarj.nombre,
        mes: widget.tarjeta.datosTarj.mes,
        ano: widget.tarjeta.datosTarj.ano,
        docTipo: widget.tarjeta.datosTarj.docTipo,
        docNum: widget.tarjeta.datosTarj.docNum,
        cvv: cvv);

    print('numeros: ' + _numeroTarjeta(widget.tarjeta.idTarjeta));
    print('nombre: ' + widget.tarjeta.datosTarj.nombre.toString());
    print('mes: ' + widget.tarjeta.datosTarj.mes.toString());
    print('ano: ' + widget.tarjeta.datosTarj.ano.toString());
    print('docTipo: ' + widget.tarjeta.datosTarj.docTipo.toString());
    print('docNum: ' + widget.tarjeta.datosTarj.docNum.toString());
    print('cvv: ' + cvv);

    String tokenTarj = await CardToken(datos, globals.comercio);

    Payment pago = new Payment();
    pago.additionalInfo = AdditionalInfo();
    pago.additionalInfo!.items = [];
    Item item = Item(
        id: 'PR0001',
        title: 'Till',
        //pictureUrl: '',
        categoryId: 'Shop',
        quantity: 1,
        unitPrice: widget.total);
    pago.additionalInfo!.items!.add(item);
    pago.additionalInfo!.payer = AdditionalInfoPayer();
    pago.additionalInfo!.payer!.firstName = globals.usuario!.nombre.toString();
    pago.additionalInfo!.payer!.lastName = globals.usuario!.apellido.toString();
    pago.additionalInfo!.payer!.phone = Phone();
    pago.additionalInfo!.payer!.phone!.areaCode = 011;
    pago.additionalInfo!.payer!.phone!.number = telefono;
    pago.additionalInfo!.payer!.address = Address();
    pago.additionalInfo!.shipments = Shipments();
    pago.additionalInfo!.shipments!.receiverAddress = ReceiverAddress();
    pago.additionalInfo!.shipments!.receiverAddress!.zipCode = '';
    pago.additionalInfo!.shipments!.receiverAddress!.stateName =
        widget.domicilio.provincia;
    pago.additionalInfo!.shipments!.receiverAddress!.cityName =
        widget.domicilio.localidad;
    pago.additionalInfo!.shipments!.receiverAddress!.streetName =
        widget.domicilio.calle;
    pago.additionalInfo!.shipments!.receiverAddress!.streetNumber =
        widget.domicilio.numero;
    pago.additionalInfo!.shipments!.receiverAddress!.floor =
        widget.domicilio.piso;
    pago.additionalInfo!.shipments!.receiverAddress!.apartment =
        widget.domicilio.departamento;
    // pago.additionalInfo!.barcode = new Barcode();
    // pago.additionalInfo!.barcode!.content = '';
    // pago.additionalInfo!.barcode!.type = '';
    // pago.additionalInfo!.barcode!.width = 0;
    // pago.additionalInfo!.barcode!.height = 0;
    //pago.application_fee = 1;
    pago.binary_mode = false;
    //pago.callback_url = 'https://app-till.com/index.php/contact/';
    pago.campaign_id = 0;
    pago.capture = true;
    //pago.coupon_amount = 10;
    //pago.coupon_code = '';
    //pago.date_of_expiration = '2021-07-10T14:47:58.000Z';
    pago.description = 'Pago por productos';
    pago.differential_pricing_id = 0;
    pago.externalReference = 'TillApp';
    pago.installments = int.parse(widget.cuota);
    //pago.issuer_id = null;
    pago.metadata = Metadata();
    //pago.notification_url = 'https://app-till.com/index.php/contact/';
    pago.order = Order();
    pago.order!.type = 'mercadopago';
    pago.order!.id = 1;
    pago.payer = PaymentPayer();
    //pago.payer!.entityType = 'individual';
    //pago.payer!.type = 'guest';
    //print('customer ' + globals.usuario!.id_customer_mp.toString());
    pago.payer!.id = '';
    pago.payer!.email = globals.usuario!.correo;
    pago.payer!.identification = Identification();
    pago.payer!.identification!.type = widget.tarjeta.datosTarj.docTipo;
    pago.payer!.identification!.number = widget.tarjeta.datosTarj.docNum;
    pago.payer!.first_name = globals.usuario!.nombre;
    pago.payer!.last_name = globals.usuario!.apellido;
    pago.paymentMethodId = widget.tarjeta.cuotasTarj.paymentMethodId;
    print('metodo de pago ' + pago.paymentMethodId.toString());
    pago.statement_descriptor = 'TillAPP';
    pago.token = tokenTarj;
    pago.transactionAmount = widget.total;

    _cargando();

    // while(pago.token == '' || pago.token == null){
    //
    // }

    try {
      print('try payment > card token: $tokenTarj');
      payment.ResponsePayment2 resp = await request.CrearPago(pago);
      print(resp.status.toString());


        await _cargarCompra(resp)
            .then((value) => _respuesta(resp)
    );

    } catch (Exception) {
      print(Exception);
      _mostrarMensaje(Exception.toString());
      print(Exception);
      Navigator.pop(context);
    }
  }

  _respuesta(payment.ResponsePayment2 resp){
    if (resp.status.toString() == 'rejected') {
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>
              Respuesta_Pago(pago: resp,ticket: ticket))
      );
    }else{
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) =>
            Respuesta_Pago(pago: resp,ticket: ticket)),
            (Route<dynamic> route) => false,
      );
    }

  }

  Future<String> _cargarCompra(payment.ResponsePayment2 pago) async {

    db.Datos d = db.Datos(items: []);
    for (int i = 0; i < globals.carrito.cantidad.length; i++) {
      db.Item item = db.Item(
          cantidad: globals.carrito.cantidad[i].toString(),
          nombre: globals.carrito.nombre[i],
          codigo: globals.carrito.codigo[i],
          precio: globals.carrito.precio[i].toString());
      d.items.add(item);
      print('item a cargar: '+item.toJson().toString());
    }

    db.Compra c = db.Compra(
        id: '',
        fecha: DateTime.now().toString(),
        hora: '',
        cliente: globals.usuario!.id.toString(),
        comercio: '',
        nombreComercio: globals.comercio,
        productos: db.datosToJson(d),
        total: widget.total.toString(),
        pago: widget.tarjeta.cuotasTarj.paymentMethodId,
        estado: pago.status,
        productosCodigo: '',
        tarjeta: pago.card!.lastFourDigits,
        idPago: pago.id.toString(),
        documento: widget.tarjeta.datosTarj.numeros,
        token: globals.accessToken,
        cuotas: pago.installments.toString(),
        montoCuota: pago.transactionDetails!.installmentAmount.toString(),
        totalCuota: pago.transactionDetails!.totalPaidAmount.toString(),
        detalle: '',
        telefono: telefono);

    String respuesta = await request.CargarCompra(c);

    if (respuesta == 'Se cargo la compra!') {

      ticket = await request.ConsultarIdCompra(c);
      print('numero ticket: $ticket');
    }
    return respuesta;
  }

  void _mostrarMensaje(String msg) {
    SnackBar snackBar = SnackBar(
      content: Text(msg),
    );
    _keyScaf.currentState!.showSnackBar(snackBar);
  }

  void _consulta(String ticket) async {
    String texto =
        "Hola! Quisiera coordinar la entrega de mi compra Nro. $ticket";
    var url = "https://api.whatsapp.com/send?phone=541151070587&text=$texto";
    if (await canLaunch(url))
      await launch(url);
    else
      // can't launch url, there is some error
      throw "Could not launch $url";
  }

  String _numeroTarjeta(idTarjeta) {
    String resp = '';
    globals.numeroTarjetas.forEach((element) {
      if (element.id == idTarjeta) {
        resp = element.numeros;
      }
    });
    return resp;
  }
}

class ArgumentosCheckout {
  final TarjetaPago tarjeta;
  final double total;
  final Domicilio domicilio;
  final String cuotas;
  ArgumentosCheckout(this.tarjeta, this.total, this.domicilio, this.cuotas);
}
