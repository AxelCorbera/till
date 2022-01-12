import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:till/constants/themes.dart';
import 'package:till/scripts/cloud_firestore.dart';
import 'package:till/globals.dart' as globals;
import 'package:till/scripts/db/database.dart';
import 'package:till/scripts/db/json/comercios.dart';
import 'package:till/scripts/mercadopago/json/baseDatos.dart';
import 'dart:developer';
import 'dart:io';

import 'package:till/scripts/request.dart';

class Scan_QR extends StatefulWidget {
  _Scan_QRState createState() => _Scan_QRState();
}

class _Scan_QRState extends State<Scan_QR> {
  Comercios comercios = Comercios();
  String comercioEncontrado = '';
  PermissionStatus _permissionStatus = PermissionStatus.denied;
  @override
  void initState() {
    super.initState();
    _cargarComercios();
  }

  String qr = '';

  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  List<int> numCompras = [];
  final Permission _permission = Permission.camera;
  @override
  Widget build(BuildContext context) {
    print(globals.ingreso);
    if (qr != '' && globals.ingreso == false) _cargarListado();
    return Scaffold(
      body: Container(
        constraints: const BoxConstraints(
          minHeight: 2000,
          minWidth: double.infinity,
        ),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/assets/images/fondoClaro.jpg"),
            fit: BoxFit.fitWidth,
          ),
        ),
        child: Stack(
          children: [
            if (Platform.isIOS)
              Transform(
                transform: Matrix4.translationValues(
                    0, MediaQuery.of(context).size.height / 20, 0),
                child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back_ios_outlined)),
              ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(
                    height: 35,
                  ),
                  qr == ''
                      ? Text(
                          'Empezá a comprar',
                          style: TextStyle(
                              color: Colores.rojo,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        )
                      : Text(
                          comercioEncontrado,
                          style: TextStyle(
                              color: Colores.rojo,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                  qr == ''
                      ? Text(
                          'Escaneando el código QR en el comercio\n\n'
                          'y accediendo a la lista de precios',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        )
                      : Text(
                          'Ingresando...',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                  Container(
                    width: 280,
                    height: 280,
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  Image.asset(
                    "lib/assets/images/nenita_qr2.png",
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
                child: qr == ''
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          child:
                              _buildQrView(context), // this is my CameraPreview
                        ),
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const CircularProgressIndicator(),
                            if (qr != '')
                              RaisedButton(
                                  onPressed: () {
                                    controller!.resumeCamera();
                                    setState(() {
                                      qr = '';
                                    });
                                  },
                                  child: const Text('Reintentar')),
                          ],
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> requestPermission(Permission permission) async {
    final status = await permission.request();
    print('permiso camara2: ' + status.toString());
    // setState(() {
    //   print(status);
    //   _permissionStatus = status;
    //   print(_permissionStatus);
    // });
  }

  Widget _buildQrView(BuildContext context) {
    // print('permiso camara: ' + _permissionStatus.toString());
    // if (_permissionStatus == PermissionStatus.denied) {
    //   requestPermission(_permission);
    //   return SizedBox();
    // } else {
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
    // }
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        final s = result!.code;
        qr = s.toString();
        _comericoEncontrado();
      });
    });
  }

  void _comericoEncontrado() async {
    int i = 0;
    controller!.stopCamera();
    comercios = await cargarComercios();
    comercios.qr!.forEach((element) {
      if (element == qr) {
        comercioEncontrado = comercios.razonsocial![i];
        return;
      }
      i++;
    });
  }

  void _cargarComercios() async {
    comercios = await cargarComercios();
  }

  void _cargarListado() async {
    if (globals.ingreso == false) {
      for (int i = 0; i < comercios.qr!.length; i++) {
        if (comercios.qr![i] == qr) {
          globals.comercio = comercios.razonsocial![i];
          await ClavesComercio(comercios.razonsocial![i]);
          globals.ingreso = true;
          globals.listado = await cargarListado(comercios.razonsocial![i]);
          print(globals.listado.id!.length.toString() + 'productos cargados');
          Navigator.of(context).pushNamed('/Scan_Products');
        }
      }
    }
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
      showDialog(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
            title: const Text('Permiso para utilizar camara'),
            content: const Text(
                'Till necesita utilizar la camara para comenzar a escanear'),
            actions: <Widget>[
              CupertinoDialogAction(
                child: const Text('Denegar'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              CupertinoDialogAction(
                child: const Text('Configuracion'),
                onPressed: () => openAppSettings(),
              ),
            ],
          ));
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
