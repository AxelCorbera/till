import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:till/globals.dart' as globals;
import 'package:till/scenes/addcard.dart';
import 'package:till/scenes/infoPayment.dart';
import 'package:till/scripts/mercadopago/json/baseDatos.dart' as db;
import 'package:till/scripts/mercadopago/json/cardsJson.dart' as card;
import 'package:till/scripts/mercadopago/payment.dart';
import 'package:till/scripts/mercadopago/responsePayment2.dart'as payment;
import 'package:till/scripts/request.dart' as request;
import 'package:till/scripts/mercadopago/responsePayment.dart'
    as response;
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
  BorderRadiusGeometry _borderRadius = BorderRadius.circular(300);
  bool realizado1 = false;
  bool realizado2 = false;
  bool anim1 = false;
  bool anim2 = false;
  String telefono = '';
  String ticket = '';
  String respuestaPago = '';
  GlobalKey<FormState> _keyform = GlobalKey();
  GlobalKey<ScaffoldState> _keyScaf = GlobalKey();

  Widget build(BuildContext context) {
    return Scaffold(
      key: _keyScaf,
      backgroundColor: Colors.grey[200],
      appBar: realizado2
          ? null
          : AppBar(
              title: Text("Checkout"),
            ),
      body: Stack(children: <Widget>[
        SingleChildScrollView(
          child: Column(children: <Widget>[
            Card(
              elevation: 5,
              margin: EdgeInsets.all(10),
              child: Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Center(
                        child: Text(
                          '¡Ultimo paso!',
                          style: TextStyle(
                              //color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.grey[200],
                      margin: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Container(
                              child: Text(
                                'Direccion:',
                                style: TextStyle(
                                    //color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Container(
                              child: Text(widget.domicilio.calle +
                                  ' ' +
                                  widget.domicilio.numero.toString() +
                                  ' ' +
                                  widget.domicilio.piso +
                                  ' ' +
                                  widget.domicilio.departamento +
                                  ', ' +
                                  widget.domicilio.localidad +
                                  ' ' +
                                  widget.domicilio.municipio),
                            ),
                          ),
                          new Divider(),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Container(
                              child: Text(
                                'Forma de pago:',
                                style: TextStyle(
                                    //color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Container(
                              child: widget.tarjeta.datosTarj.numeros != null
                                  ? Column(
                                      children: [
                                        ListTile(
                                          leading: Icon(Icons.payment),
                                          title: Text(widget.tarjeta.cuotasTarj
                                                  .paymentMethodId
                                                  .toString() +
                                              " terminada en " +
                                              widget.tarjeta.datosTarj.numeros
                                                  .toString()
                                                  .substring(12, 16)),
                                        ),
                                        widget.cuota != '1'
                                            ? _cuotasMonto()
                                            : SizedBox(),
                                      ],
                                    )
                                  : ListTile(
                                      leading: Icon(Icons.payments_outlined),
                                      title: Text('Efectivo'),
                                    ),
                            ),
                          ),
                          new Divider(),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Container(
                              child: Text(
                                'Telefono: *',
                                style: TextStyle(
                                    //color: Colors.black,
                                    fontSize: 15,
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
                                ),
                              ),
                            ),
                          ),
                          new Divider(),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Envio:',
                              style: TextStyle(
                                  //color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '¡Envio gratis!',
                              style: TextStyle(
                                //color: Colors.black,
                                fontSize: 20,
                                //fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total:',
                              style: TextStyle(
                                  //color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            _total()
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            RaisedButton.icon(
              color: Colors.green,
              onPressed: () {
                if (_keyform.currentState!.validate()) {
                  _pagar();
                }
              },
              icon: Icon(Icons.payment),
              label: Text(
                "Pagar",
                style: TextStyle(
                  //color: Colors.black,
                  fontSize: 20,
                  //fontWeight: FontWeight.bold
                ),
              ),
            ),
          ]),
        ),
        _respuestaPago1(),
        _respuestaPago2(),
      ]),
    );
  }

  Widget _respuestaPago1() {
    Widget w1 = Center(
        child: new AnimatedContainer(
      width: realizado1
          ? realizado2
              ? MediaQuery.of(context).size.width
              : 100
          : 0,
      height: realizado1
          ? realizado2
              ? MediaQuery.of(context).size.height
              : 100
          : 0,
      decoration: realizado1
          ? BoxDecoration(
              color: respuestaPago == 'aprobado'
                  ? Colors.green
                  : respuestaPago == 'rechazado'
                      ? Colors.redAccent
                      : Theme.of(context).primaryColor,
              borderRadius: _borderRadius,
            )
          : BoxDecoration(
              color: Colors.transparent,
              borderRadius: _borderRadius,
            ),
      duration: Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            new AnimatedContainer(
              transform: anim1
                  ? Matrix4.translationValues(
                      0, -(MediaQuery.of(context).size.height / 3.45), 0)
                  : Matrix4.translationValues(0, -5, 0),
              child: realizado1
                  ? Column(
                      children: [
                        new AnimatedContainer(
                          width: realizado1 ? 100 : 101,
                          height: realizado1 ? 100 : 101,
                          duration: Duration(seconds: 1),
                          child: realizado1
                              ? Icon(
                                  respuestaPago == 'aprobado'
                                      ? Icons.done_rounded
                                      : respuestaPago == 'rechazado'
                                          ? Icons.cancel_outlined
                                          : Icons.error_outline,
                                  color: Theme.of(context).secondaryHeaderColor,
                                  size: 70,
                                )
                              : SizedBox(),
                          onEnd: () {},
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Pago $respuestaPago',
                          style: anim2
                              ? TextStyle(
                                  color: Theme.of(context).secondaryHeaderColor,
                                  fontSize: 25,
                                  //fontWeight: FontWeight.bold
                                )
                              : TextStyle(
                                  color: Colors.transparent,
                                  fontSize: 25,
                                  //fontWeight: FontWeight.bold
                                ),
                        ),
                      ],
                    )
                  : null,
              onEnd: () {
                setState(() {
                  anim2 = true;
                });
              },
              duration: Duration(seconds: 1),
            ),
          ],
        ),
      ),
      onEnd: () {
        setState(() {
          if (realizado2 == false) {
            realizado2 = true;
            _borderRadius = BorderRadius.circular(0);
          } else {
            anim1 = true;
          }
        });
      },
    ));

    return w1;
  }

  Widget _respuestaPago2() {

    Widget _datos = respuestaPago == 'aprobado'?Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Su pedido fue realizado!',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20
          ),),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Ticket Nro: $ticket',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15
            ),),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Podras ver el estado del pedido en la pantalla de inicio.',
            style: TextStyle(
                fontSize: 15,
            ),
          textAlign: TextAlign.center,),
        ),
        FlatButton.icon(
          icon: Icon(Icons.sms),
          onPressed: (){
            _consulta(ticket);
          }, label: Text(''
            'Comunicate con nuestro \n WhatsApp para coordinar la entrega.',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          textAlign: TextAlign.center,),),
        RaisedButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/Home');
            },
            child: Text('Continuar')),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Gracias por elegirnos!',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15
            ),),
        ),
      ],
    ):
    respuestaPago == 'rechazado'?
    Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Algo salio mal.',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20
            ),),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Revisa los datos de tu tarjeta y volve a intentarlo.',
            style: TextStyle(
              fontSize: 15,
            ),
            textAlign: TextAlign.center,),
        ),
        RaisedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Reintentar')),
        RaisedButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/Home');
            },
            child: Text('Continuar')),
        SizedBox(height: 100,)
      ],
    ):
    Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Procesando el pago.',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20
            ),),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('El pago se esta procesando. Esto puede demorar unos minutos.',
            style: TextStyle(
              fontSize: 15,
            ),
            textAlign: TextAlign.center,),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Puedes ver el estado del pago en el inicio.',
            style: TextStyle(
              fontSize: 15,
            ),
            textAlign: TextAlign.center,),
        ),
        RaisedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Reintentar')),
        RaisedButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/Home');
            },
            child: Text('Continuar')),
        SizedBox(height: 100,)
      ],
    );

    Widget w2 = realizado2
        ? Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              new AnimatedContainer(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 1.6,
                color: anim2 ? Colors.white : Colors.transparent,
                child: Container(
                    child: Card(
                        elevation: 0,
                        color: Colors.transparent,
                        child: anim2 ? _datos : null)),
                onEnd: () {},
                duration: Duration(seconds: 1),
              ),
            ],
          )
        : SizedBox();
    return w2;
  }

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
          //color: Colors.black,
          fontSize: 20,
          //fontWeight: FontWeight.bold
        ),
      );
    } else {
      return Text(
        '\$ ' + widget.total.toString(),
        style: TextStyle(
          //color: Colors.black,
          fontSize: 20,
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
                child: CircularProgressIndicator(

                ),
              ));
        });
  }

  void _pagar() async {
    if (widget.tarjeta.datosTarj.numeros != null) {
      print(widget.tarjeta.idTarjeta);

      Payment pago = new Payment();
      pago.additionalInfo = AdditionalInfo();
      pago.additionalInfo!.items = [];
      Item item = new Item(
          id: 'PR0001',
          title: 'Moritas PetShop',
          //pictureUrl: '',
          categoryId: 'Pets',
          quantity: 1,
          unitPrice: widget.total);
      pago.additionalInfo!.items!.add(item);
      pago.additionalInfo!.payer = new AdditionalInfoPayer();
      pago.additionalInfo!.payer!.firstName =
          globals.usuario!.nombre.toString();
      pago.additionalInfo!.payer!.lastName =
          globals.usuario!.apellido.toString();
      pago.additionalInfo!.payer!.phone = new Phone();
      pago.additionalInfo!.payer!.phone!.areaCode = 11;
      pago.additionalInfo!.payer!.phone!.number = telefono;
      pago.additionalInfo!.payer!.address = new Address();
      pago.additionalInfo!.shipments = new Shipments();
      pago.additionalInfo!.shipments!.receiverAddress = new ReceiverAddress();
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
      pago.application_fee = 1;
      pago.binary_mode = false;
      //pago.callback_url = 'https://app-till.com/index.php/contact/';
      pago.campaign_id = 0;
      pago.capture = true;
      //pago.coupon_amount = 10;
      //pago.coupon_code = '';
      //pago.date_of_expiration = '2021-07-10T14:47:58.000Z';
      pago.description = 'Pago por productos';
      pago.differential_pricing_id = 0;
      pago.externalReference = 'Moritas Petshop';
      pago.installments = int.parse(widget.cuota);
      //pago.issuer_id = null;
      pago.metadata = new Metadata();
      //pago.notification_url = 'https://app-till.com/index.php/contact/';
      pago.order = new Order();
      pago.order!.type = 'mercadopago';
      pago.order!.id = 1;
      pago.payer = PaymentPayer();
      pago.payer!.entityType = 'individual';
      pago.payer!.type = 'customer';
      pago.payer!.id = globals.usuario!.idcustomer;
      pago.payer!.email = globals.usuario!.correo;
      pago.payer!.identification = new Identification();
      pago.payer!.identification!.type = widget.tarjeta.datosTarj.docTipo;
      pago.payer!.identification!.number = widget.tarjeta.datosTarj.docNum;
      pago.payer!.first_name = globals.usuario!.nombre;
      pago.payer!.last_name = globals.usuario!.apellido;
      pago.paymentMethodId = widget.tarjeta.cuotasTarj.paymentMethodId;
      pago.statement_descriptor = 'Moritas Petshop';
      pago.token = widget.tarjeta.idTarjeta;
      pago.transactionAmount = widget.total;

      _cargando();

      try {
        print('try');
        payment.ResponsePayment2 resp = await request.CrearPago(pago);
        print(resp.status.toString());

        if(resp.status.toString() == 'approved'){
        respuestaPago = 'aprobado';
        globals.carrito = Carrito(
            id: [],
            codigo: [],
            marca: [],
            nombre: [],
            cantidad: [],
            stock: [],
            precio: [],
            imagen: [],
            descuento: [],
            tope: []);
        await _cargarCompra(resp);
        }else if(resp.status.toString() == 'rejected'){
          respuestaPago = 'rechazado';
        }else{
          respuestaPago = 'en revision';
          await _cargarCompra(resp);
        }
        setState(() {
          //respuestaPago = 'rechazado';
          realizado1 = true;
        });

        Navigator.pop(context);
      } catch (Exception) {
        print('catch');
        _mostrarMensaje(Exception.toString());
        print(Exception);
        Navigator.pop(context);
      }

    } else {
      await _cargarPedido();
      respuestaPago = 'aprobado';
      globals.carrito = Carrito(
          id: [],
          codigo: [],
          marca: [],
          nombre: [],
          cantidad: [],
          stock: [],
          precio: [],
          imagen: [],
          descuento: [],
          tope: []);
      setState(() {
        //respuestaPago = 'rechazado';
        realizado1 = true;
      });

    }
  }

  Future<String> _cargarPedido() async {
    db.Datos d = new db.Datos(items: []);
    for(int i = 0; i < globals.carrito.cantidad.length; i++){
      db.Item item = new db.Item(cantidad: globals.carrito.cantidad[i].toString(),
          nombre: globals.carrito.nombre[i],
          codigo: globals.carrito.codigo[i],
          precio: globals.carrito.precio[i].toString());
      d.items.add(item);
    }
    db.Compra c = new db.Compra(
        id: '',
        fecha: DateTime.now().toString(),
        hora: '',
        cliente: globals.usuario!.id.toString(),
        comercio: '',
        nombreComercio: '',
        productos: db.datosToJson(d),
        total: widget.total.toString(),
        pago: 'efectivo',
        estado: 'no pagado',
        productosCodigo: '',
        tarjeta: '',
        idPago: '',
        documento: '',
        token: '',
        cuotas: '',
        montoCuota: '',
        totalCuota: '',
        detalle: 'no entregado',
        telefono: telefono);

    String respuesta =await request.CargarCompra(c);
    print('cargarpedido: $respuesta');
    if(respuesta == 'Se cargo la compra!'){
      ticket = await request.ConsultarIdCompra(c);
      print('ticket: $ticket');
    }
    return respuesta;
  }

  Future<String> _cargarCompra(payment.ResponsePayment2 pago) async {

    print('cargar compra 1');
    db.Datos d = new db.Datos(items: []);
    for(int i = 0; i < globals.carrito.cantidad.length; i++){
      db.Item item = new db.Item(cantidad: globals.carrito.cantidad[i].toString(),
          nombre: globals.carrito.nombre[i],
          codigo: globals.carrito.codigo[i],
          precio: globals.carrito.precio[i].toString());
      d.items.add(item);
    }
    print('cargar compra 2');
    db.Compra c = new db.Compra(
        id: '',
        fecha: DateTime.now().toString(),
        hora: '',
        cliente: globals.usuario!.id.toString(),
        comercio: '',
        nombreComercio: '',
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
    print('cargar compra 4');
    String respuesta = await request.CargarCompra(c);
    print('cargar compra 5');
    if(respuesta == 'Se cargo la compra!'){
      print('cargar compra 6');
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

  void _consulta(String ticket) async{
    String texto = "Hola! Quisiera coordinar la entrega de mi compra Nro. $ticket";
    var url = "https://api.whatsapp.com/send?phone=541151070587&text=$texto";
    if (await canLaunch(url))
      await launch(url);
    else
      // can't launch url, there is some error
      throw "Could not launch $url";
  }
}

class ArgumentosCheckout {
  final TarjetaPago tarjeta;
  final double total;
  final Domicilio domicilio;
  final String cuotas;
  ArgumentosCheckout(this.tarjeta, this.total, this.domicilio, this.cuotas);
}
