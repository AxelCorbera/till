import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:till/constants/themes.dart';
import 'package:till/scripts/db/json/notificaciones.dart';
import 'package:till/scripts/mercadopago/json/baseDatos.dart';
import 'package:till/scripts/request.dart';
import 'package:till/globals.dart' as globals;

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  bool busqueda = true;
  final firestoreInstance = FirebaseFirestore.instance;
  List<NotiFirestore> notificaciones = [];
  @override
  Widget build(BuildContext context) {
    if (busqueda == true) {
      _buscarNotificaciones();
    }
    return Scaffold(
      appBar: appbar("Notificaciones"),
      body: busqueda == false && notificaciones.isNotEmpty
          ? Stack(children: <Widget>[
              Transform(
                transform: Matrix4.translationValues(0, 10, 0),
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    child: ListView.builder(
                        itemCount: notificaciones.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {},
                            child: Hero(
                              tag: notificaciones.length,
                              child: Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 8.0),
                                        child: Container(
                                          child: Text(
                                            notificaciones[index].titulo,
                                            style: TextStyle(
                                              color: Colores.azulOscuro,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 8.0),
                                        child: Container(
                                          child: Text(
                                              notificaciones[index].mensaje,
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 14,
                                              )),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 2.0),
                                        child: new Divider(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ),
              ),
            ])
          : busqueda == false && notificaciones.length == 0
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        'No hay notificaciones',
                        style:
                            TextStyle(color: Colores.azulOscuro, fontSize: 20),
                      ),
                    ),
                  ],
                )
              : Center(
                  child: CircularProgressIndicator(),
                ),
    );
  }

  AppBar appbar(String title) {
    return AppBar(
      title: Text(title),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }

  Future _buscarNotificaciones() async {
    firestoreInstance.collection("notifications").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        print('id de la notificacion: ' + result.id);
        NotiFirestore n = NotiFirestore(
            id: result.get('id'),
            titulo: result.get('titulo'),
            mensaje: result.get('mensaje'));
        notificaciones.add(n);
        busqueda = false;
      });
    }).then((value) => actualizar());
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  actualizar() {
    setState(() {});
  }
}
