import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:till/constants/themes.dart';
import 'package:till/scripts/cloud_firestore.dart';
import 'package:till/globals.dart' as globals;
import 'package:till/scripts/db/database.dart';
import 'package:till/scripts/db/json/comercios.dart';
import 'package:till/scripts/db/json/listado.dart';
import 'package:till/scripts/mercadopago/json/baseDatos.dart';
import 'dart:developer';
import 'dart:io';

import '../globals.dart';

class Scan_Products extends StatefulWidget {
  _Scan_ProductsState createState() => _Scan_ProductsState();
}

class _Scan_ProductsState extends State<Scan_Products> {
  AudioCache player = new AudioCache();
  final alarmAudioPath = "sounds/lector.mp3";
  Producto producto = Producto(id: '');
  AudioCache audioCache = AudioCache();
  bool scan = true;
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final _formKey = GlobalKey<FormState>();

  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Quieres salir de la tienda?'),
        content: new Text('Se perderan los productos del carro'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('Salir'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: new Text('Seguir comprando'),
          ),
        ],
      ),
    )) ?? false;
  }


  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  List<int> numCompras = [];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
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
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      height: 35,
                    ),
                    Text(
                      'Escaneá tus productos',
                      style: TextStyle(
                          color: Colores.rojo,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    scan == true
                        ? Text(
                            'Pasando el lector por el\n\n'
                            'código de barras',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          )
                        : Column(
                            children: [
                              producto.nombre == null
                                  ? Text(
                                      'Producto no registrado',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    )
                                  : Text(
                                      'codigo: '+producto.codigo.toString(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                              SizedBox(
                                height: 10,
                              ),
                              if(producto.nombre == null)
                                   Text(
                                      'intenta nuevamente',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                              SizedBox(
                                height: 10,
                              ),
                              RaisedButton(
                                onPressed: () {
                                  scan = true;
                                  setState(() {
                                    producto = Producto(id: '');
                                  });
                                },
                                child: producto.nombre == null
                                    ?Text('Reintentar'):
                                Text('Cambiar'),
                              )
                            ],
                          ),
                    Container(
                      width: 280,
                      height: 330,
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        GestureDetector(
                          onTap: (){
                            Navigator.of(context).pushNamed('/Cart').then((value) => setState(() {
                              controller!.resumeCamera();
                            }));
                            controller!.pauseCamera();
                          },
                          child: Column(
                            children: <Widget>[
                              Image.asset(
                                "lib/assets/images/botones-carrito.png",
                                height: 70,
                              ),
                              Text('Ver carrito',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w400,
                                fontSize: 15
                              ),
                              )
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            Navigator.of(context).pushNamed('/InfoPayment')
                                .then((value) => setState(() {
                              controller!.resumeCamera();
                            }));
                            controller!.stopCamera();
                          },
                          child: Column(
                            children: <Widget>[
                              Image.asset(
                                "lib/assets/images/botones-comprar.png",
                                height: 70,
                              ),
                              Text('Comprar',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w400,
                                    fontSize: 15
                                ),)
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 30,)
                  ],
                ),
              ),
              Center(
                child: Container(
                    width: 330,
                    height: 330,
                    decoration: BoxDecoration(
                        color: Colores.azulOscuro,
                        borderRadius: BorderRadius.circular(20)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        child: _buildQrView(context), // this is my CameraPreview
                      ),
                    )
                    //     :Center(child: Column(
                    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //   children: [
                    //     CircularProgressIndicator(),
                    //   ],
                    // ),),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 300.0
        : 450.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colores.amarillo,
          borderRadius: 10,
          borderLength: 20,
          borderWidth: 15,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    //if(scan == true) {
    controller.scannedDataStream.listen((scanData) {
      // scan = false;
      result = scanData;
      _producto(result!.code.toString());
    });
  }

  void _producto(String codigo) {
    if (scan == true) {
      player.play(alarmAudioPath);
      scan = false;
      for (int i = 0; i < globals.listado.codigo!.length; i++) {
        if (codigo == globals.listado.codigo![i]) {
          print('producto encontrado!!');
          producto.id = globals.listado.id![i];
          producto.codigo = globals.listado.codigo![i];
          producto.nombre = globals.listado.nombre![i];
          producto.precio = globals.listado.precio![i];
          producto.descuento = globals.listado.descuento![i];
          producto.acumulable = globals.listado.acumulable![i];
          producto.tipo = globals.listado.tipo![i];
          producto.tope = globals.listado.tope![i];
          _productoEncontrado();
          break;
        }
        setState(() {});
      }
    }
  }

  void _productoEncontrado() {
    int cantidad = 1;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState){
            return AlertDialog(
              content: Container(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('¡Producto encontrado!',
                          style: TextStyle(
                              fontWeight: FontWeight.bold
                          ),),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(producto.nombre.toString(),
                        style: TextStyle(
                          color: Colores.violeta,
                            fontWeight: FontWeight.bold
                        ),
                        textAlign: TextAlign.center,),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('\$ ' + producto.precio.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                          fontSize: 25
                        ),),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Cuantas unidades desea llevar?'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            IconButton(onPressed: (){
                              setState((){
                                if(cantidad>1)
                               cantidad--;
                              });
                            }, icon: Icon(Icons.remove)),
                            Text(cantidad.toString(),
                              style: TextStyle(
                                  fontSize: 20
                              ),),
                            IconButton(onPressed: (){
                              setState((){
                                cantidad++;
                              });
                            }, icon: Icon(Icons.add)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            RaisedButton(
                              child: Text("Cancelar"),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            RaisedButton(
                              child: Text("Agregar"),
                              onPressed: () {
                                bool existe = false;
                                carrito.codigo.forEach((element) {
                                  if(element == producto.codigo) {
                                    existe = true;
                                  }
                                });
                                if(existe == true){
                                  int i = carrito.codigo.indexOf(producto.codigo.toString());
                                  carrito.cantidad[i] = carrito.cantidad[i] + cantidad;
                                  Navigator.pop(context);
                                }else {
                                  carrito.id.add(carrito.id.length.toString());
                                  carrito.codigo.add(
                                      producto.codigo.toString());
                                  carrito.marca.add('');
                                  carrito.nombre.add(
                                      producto.nombre.toString());
                                  carrito.cantidad.add(cantidad);
                                  carrito.stock.add('100');
                                  carrito.precio.add(
                                      double.parse(producto.precio.toString()));
                                  print(carrito.precio[0]);
                                  carrito.imagen.add('');
                                  carrito.descuento!.add(
                                      producto.descuento.toString());
                                  carrito.tope.add(producto.tope.toString());
                                  Navigator.pop(context);
                                }
                                // if (_formKey.currentState!.validate()) {
                                //   _formKey.currentState!.save();
                                //   carrito.id.add(carrito.id.length.toString());
                                //   carrito.codigo.add(producto.codigo.toString());
                                //   carrito.marca.add('');
                                //   carrito.nombre.add(producto.nombre.toString());
                                //   carrito.cantidad.add(cantidad.toString());
                                //   carrito.stock.add('100');
                                //   carrito.precio.add(producto.precio as double);
                                //   print(carrito.precio[0]);
                                //   carrito.imagen.add('');
                                //   carrito.descuento!.add(producto.descuento.toString());
                                //   carrito.tope.add(producto.tope.toString());
                                //   Navigator.pop(context);
                                // }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
            }
          );
        });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
