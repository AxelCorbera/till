import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:till/globals.dart' as globals;
import 'mercadopago/json/baseDatos.dart';

class AddUser {
  final String uid;
  final String nombre;
  final String correo;
  final String token;

  AddUser(this.uid, this.nombre, this.correo, this.token);

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> addUser() async {
    // Call the user's CollectionReference to add a new user
    users
        .add({
      'uid': uid,
      'nombre': nombre,
      'correo': correo,
      'documento': '',
      'telefono': '',
      'provincia': '',
      'municipio': '',
      'localidad': '',
      'calle': '',
      'numero': '',
      'piso': '',
      'departamento': '',
      'cuil': '',
      'id_customer_mp': '',
      'id_card_mp': '',
      'persona': 'fisica',
      'razon_social': '',
      'token': token,
      'foto': '',
    })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }
}

class UpdateUser
{
  final String uid;
  String? nombre;
  String? correo;
  String? documento;
  String? telefono;
  String? provincia;
  String? municipio;
  String? localidad;
  String? calle;
  String? numero;
  String? piso;
  String? departamento;
  String? cuit;
  String? id_customer_mp;
  String? id_card_mp;
  String? cuil;
  String? razon_social;
  String? token;
  String? foto;

  UpdateUser(this.uid,{this.nombre, this.correo, this.documento, this.telefono,
  this.provincia, this.municipio, this.localidad, this.calle, this.numero,
  this.piso, this.departamento, this.cuit, this.id_customer_mp,
  this.id_card_mp, this.cuil, this.razon_social, this.token, this.foto});

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<String> docID() async{
    String did = '';
    await FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print(doc['uid']);
        if(doc['uid'] == uid) {
          did = doc.id;
        }
      });
    });
    print('doc > $did');
  return did;
  }

  Future<void> updateUser(Map<String,dynamic> datos) async{
    String docId = await docID();
    return users
    .doc(docId)
        .update(datos)
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }
}