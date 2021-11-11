import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:till/constants/themes.dart';
import 'package:till/scripts/cloud_firestore.dart';
import 'package:till/globals.dart' as globals;
import 'package:till/scripts/db/database.dart';
import 'package:till/scripts/db/json/comercios.dart';
import 'package:till/scripts/mercadopago/json/baseDatos.dart';
import 'dart:developer';
import 'dart:io';

class Scan_QR extends StatefulWidget {
  _Scan_QRState createState() => _Scan_QRState();
}

class _Scan_QRState extends State<Scan_QR> {
  Comercios comercios = Comercios();
  String comercioEncontrado = '';
  @override
  void initState() {
    super.initState();
    _cargarComercios();
  }

  String qr = '';

  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

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
    if (qr != '') _cargarListado();
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
                            CircularProgressIndicator(),
                            if (qr != '')
                              RaisedButton(
                                  onPressed: () {
                                    setState(() {
                                      qr = '';
                                    });
                                  },
                                  child: Text('Reintentar')),
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
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        final s = result!.code;
        qr = s.toString();
        _comericoEncontrado();
      });
    });
    //_comericoEncontrado();
  }

  void _comericoEncontrado() {
    int i = 0;
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

  Future<void> _cargarListado() async {
    for (int i = 0; i < comercios.qr!.length; i++) {
      if (comercios.qr![i] == qr) {
        globals.listado = await cargarListado(comercios.razonsocial![i]);
        print(globals.listado.id!.length.toString() + 'productos cargados');
        Navigator.of(context).pushNamed('/Scan_Products');
      }
    }
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
