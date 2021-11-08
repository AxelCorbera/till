import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:till/globals.dart' as globals;
import 'mercadopago/json/baseDatos.dart';

class AddUser {
  final String uid;
  final String nombre;
  final String correo;

  AddUser(this.uid, this.nombre, this.correo);

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> addUser() async {
    // Call the user's CollectionReference to add a new user
    users
        .add({
      'uid': uid, // John Doe
      'nombre': nombre, // Stokes and Sons
      'correo': correo // 42
    })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }
}
