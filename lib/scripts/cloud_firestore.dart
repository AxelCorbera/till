
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:till/scripts/db/json/tarjetas_firestore.dart';
import 'package:till/globals.dart' as globals;

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
      'id_card_mp': '[]',
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

class AddCardDb {
  final String uid;
  final String id;
  final String numeros;
  List<TarjetasFirestore> tarjetas = [];

  AddCardDb(this.uid, this.id, this.numeros);

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<String> docID() async{
    String did = '';
    await FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print(doc['uid'] +' > '+ this.uid);
        if(doc['uid'] == uid) {
          did = doc.id;
          tarjetas = tarjetasFirestoreFromJson(doc['id_card_mp']);
          tarjetas.add(TarjetasFirestore(id: id, numeros: numeros));
          print('tarjetas >: ' +tarjetasFirestoreToJson(this.tarjetas));
        }
      });
    })
        .then((value1) => updateCard(did));
    print('doc > $did');
    return did;
  }

  Future<void> updateCard(String docId) async{
    print('tarjetas a actualizar: ' +tarjetasFirestoreToJson(this.tarjetas));
    Map<String, String> tarj = {
      "id_card_mp":tarjetasFirestoreToJson(this.tarjetas)
    };
    return users
        .doc(docId)
        .update(tarj)
        .then((value2) => done())
        .catchError((error) => print("Failed to update user: $error"));
  }

  done() {
    print('tarjetas actualizadas firestore');
    globals.numeroTarjetas = tarjetas;
  }

}

class DeleteCardDb {
  final String uid;
  final String id;
  List<TarjetasFirestore> tarjetas = [];

  DeleteCardDb(this.uid, this.id);

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<String> docID() async{
    String did = '';
    await FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print(doc['uid'] +' > '+ this.uid);
        if(doc['uid'] == uid) {
          did = doc.id;
          tarjetas = tarjetasFirestoreFromJson(doc['id_card_mp']);
          print('tarjetas: ' + tarjetas.length.toString());
          for(int i =0 ; i < tarjetas.length ; i++){
            if(tarjetas[i].id == this.id){
              tarjetas.remove(tarjetas[i]);
              print('tarjetas >: ' +tarjetasFirestoreToJson(this.tarjetas));
              break;
            }
          }
        }
      });
    })
        .then((value1) => updateCard(did));
    print('doc > $did');
    return did;
  }

  Future<void> updateCard(String docId) async{
    print('tarjetas a actualizar: ' +tarjetasFirestoreToJson(this.tarjetas));
    Map<String, String> tarj = {
      "id_card_mp":tarjetasFirestoreToJson(this.tarjetas)
    };
    return users
        .doc(docId)
        .update(tarj)
        .then((value2) => done())
        .catchError((error) => print("Failed to update user: $error"));
  }

  done() {
    print('tarjetas actualizadas firestore');
    globals.numeroTarjetas = tarjetas;
  }

}
