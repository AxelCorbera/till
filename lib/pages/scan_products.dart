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
  Producto producto = Producto(id:'');
  bool scan = true;
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
                  producto.id =='' ?Text(
                    'Pasando el lector por el\n\n'
                    'código de barras',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ):Column(
                    children: [
                      Text(
                        producto.nombre.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '\$ '+ producto.precio.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      RaisedButton(onPressed: (){
                        setState(() {
                          scan=true;
                          producto = Producto(id: '');
                        });
                      },
                      child: Text('Reintentar'),)
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
                child: producto.id =='' ?ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    child: _buildQrView(context), // this is my CameraPreview
                  ),
                ):
                Center(child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CircularProgressIndicator(),
                  ],
                ),),
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
      scan=false;
      result = scanData;
      _producto(result!.code.toString());
      print(result!.code.toString());
    });
  }

  void _producto(String codigo) {
    for(int i =0;i<globals.listado.codigo!.length;i++){
      if(codigo == globals.listado.codigo![i]){
        print('producto encontrado!!');
        producto.id = globals.listado.id![i];
        producto.codigo = globals.listado.codigo![i];
        producto.nombre = globals.listado.nombre![i];
        producto.precio = globals.listado.precio![i];
        producto.descuento = globals.listado.descuento![i];
        producto.acumulable = globals.listado.acumulable![i];
        producto.tipo = globals.listado.tipo![i];
        producto.tope = globals.listado.tope![i];
        break;
      }
      setState(() {

      });
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
