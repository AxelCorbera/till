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
    return Scaffold(
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
                                    producto.nombre.toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                            SizedBox(
                              height: 10,
                            ),
                            producto.nombre == null
                                ? Text(
                                    'intenta nuevamente',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  )
                                : Text(
                                    '\$ ' + producto.precio.toString(),
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
                              child: Text('Reintentar'),
                            )
                          ],
                        ),
                  Container(
                    width: 280,
                    height: 280,
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  Image.asset(
                    "lib/assets/images/nenita_qr.png",
                    height: 250,
                  ),
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
    showDialog(
        context: context,
        builder: (BuildContext context) {
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          IconButton(onPressed: (){}, icon: Icon(Icons.remove)),
                          Text('1',
                            style: TextStyle(
                                fontSize: 20
                            ),),
                          IconButton(onPressed: (){}, icon: Icon(Icons.add)),
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
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                              }
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
