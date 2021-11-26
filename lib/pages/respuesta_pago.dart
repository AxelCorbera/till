import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:till/constants/payment_detail.dart';
import 'package:till/constants/themes.dart';
import 'package:till/home.dart';
import 'package:till/scripts/cloud_firestore.dart';
import 'package:till/globals.dart' as globals;
import 'package:till/scripts/db/database.dart';
import 'package:till/scripts/db/json/comercios.dart';
import 'package:till/scripts/mercadopago/json/baseDatos.dart';
import 'package:till/scripts/mercadopago/responsePayment2.dart';
import 'dart:developer';
import 'dart:io';

import 'package:till/scripts/request.dart';

import '../globals.dart';

class Respuesta_Pago extends StatefulWidget {
  Respuesta_Pago({required this.pago, required this.ticket});
  final ResponsePayment2 pago;
  final String ticket;
  _Respuesta_PagoState createState() => _Respuesta_PagoState();
}

class _Respuesta_PagoState extends State<Respuesta_Pago> {
  Payment_Detail respuestas = Payment_Detail();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: widget.pago.status == 'approved'?
            aprobado():
            rechazado(),
    );
  }

  Widget rechazado(){
   return Column(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height/2.5,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("lib/assets/images/fondoRechazado.png"),
                fit: BoxFit.contain
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.cancel_outlined,
                color: Colors.red,
                size: 40,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Pago rechazado',
                  style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                  ),),
              ),
              Text('Su compra fue rechazada',
                style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 13
                ),)
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width/1.15,
          height: MediaQuery.of(context).size.height/1.7,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SizedBox(height: 10,),
              Text('Error al procesar el pago',
                style: TextStyle(
                    color: Colores.rojo,
                    fontWeight: FontWeight.bold,
                    fontSize: 18
                ),),
              Text(respuestas.estado_detalle(
                  widget.pago.statusDetail.toString(),
                  widget.pago.paymentMethodId.toString().toUpperCase(),
                  widget.pago.installments.toString()
              ),
                style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14
                ),),
              // SizedBox(height: 10,),
              // Text('Total a abonar: \$ '+ widget.pago.transactionAmount.toString(),
              //   style: TextStyle(
              //       color: Colores.azulOscuro,
              //       fontWeight: FontWeight.bold,
              //       fontSize: 20
              //   ),),
              SizedBox(height: 10,),
              SizedBox(height: 10,),
              Text('Puedes intentar con otro medio de pago.',
                style: TextStyle(
                    color: Colores.azulOscuro,
                    fontSize: 14
                ),),
              SizedBox(height: 10,),
              Container(
                width: 280,
                child: RaisedButton(onPressed: (){
                  Navigator.pop(context);
                },
                  color: Colores.azulOscuro,
                  child: Text('Reintentar',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold
                    ),),),
              ),
              Container(
                width: 280,
                child: FlatButton(onPressed: (){
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
                  globals.accessTokenComercio = '';
                  globals.publicKeyComercio = '';
                  globals.comercio = '';
                  globals.ingreso = false;
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) =>
                        Home()),
                        (Route<dynamic> route) => false,
                  );
                },
                  color: Colores.azulOscuro,
                  child: Text('Salir',
                    style: TextStyle(
                        color: Colores.rojo,
                        fontSize: 15,
                        fontWeight: FontWeight.bold
                    ),),),
              ),
              Text('¡Gracias por elegirnos!',
                style: TextStyle(
                    color: Colores.rojo,
                    fontWeight: FontWeight.bold,
                    fontSize: 17
                ),),
            ],
          ),
        )
      ],
    );
  }

  Widget aprobado(){
    return Column(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height/2.5,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("lib/assets/images/fondoAprobado.png"),
                fit: BoxFit.contain
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.done,
                color: Colors.green,
                size: 40,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Pago aprobado',
                  style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                  ),),
              ),
              Text('Su compra fue realizada',
                style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 13
                ),)
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width/1.15,
          height: MediaQuery.of(context).size.height/1.7,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SizedBox(height: 10,),
              Text('Ticket Nro. '+widget.ticket,
                style: TextStyle(
                    color: Colores.rojo,
                    fontWeight: FontWeight.bold,
                    fontSize: 18
                ),),
              Text('Podras ver el estado del pedido \n '
                  'en la pantalla de inicio',
                style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 15
                ),),
              SizedBox(height: 10,),
              Text('Total: \$ '+ widget.pago.transactionAmount.toString(),
                style: TextStyle(
                    color: Colores.azulOscuro,
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                ),),
              Text('Pago con ' +
                  widget.pago.paymentMethodId.toString().toUpperCase() +
                  ' terminada en '+
                  widget.pago.card!.lastFourDigits.toString(),
                style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 15
                ),),
              if(widget.pago.installments! > 1)
                Text(widget.pago.installments!.toString() +
                    ' cuotas de '+
                    widget.pago.transactionDetails!.installmentAmount.toString(),
                  style: TextStyle(
                      color: Colores.azulOscuro,
                      fontSize: 15
                  ),),
              SizedBox(height: 10,),
              Container(
                width: 280,
                child: RaisedButton(onPressed: (){
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
                  globals.accessTokenComercio = '';
                  globals.publicKeyComercio = '';
                  globals.comercio = '';
                  globals.ingreso = false;
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) =>
                        Home()),
                        (Route<dynamic> route) => false,
                  );
                },
                  color: Colores.azulOscuro,
                  child: Text('Continuar',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold
                    ),),),
              ),
              Text('¡Gracias por elegirnos!',
                style: TextStyle(
                    color: Colores.rojo,
                    fontWeight: FontWeight.bold,
                    fontSize: 17
                ),),
            ],
          ),
        )
      ],
    );
  }
}
