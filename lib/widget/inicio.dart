import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:till/constants/themes.dart';
import 'package:till/scripts/cloud_firestore.dart';
import 'package:till/globals.dart' as globals;
import 'package:till/scripts/mercadopago/json/baseDatos.dart';

class Inicio extends StatefulWidget {
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  final compras = FirebaseFirestore.instance
      .collection('compras')
      .withConverter<Compras>(
        fromFirestore: (snapshots, _) => Compras.fromJson(snapshots.data()!),
        toFirestore: (compras, _) => Compras.toJson(),
      );

  List<int> numCompras = [];

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              "lib/assets/images/nenita.png",
              width: 280,
            ),
            RaisedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/Scan_QR');
                // FirebaseFirestore.instance.collection("compras").add({
                //   "id": "00000009",
                //   "fecha": DateTime.now().toString(),
                //   "cliente": globals.usuario!.id,
                //   "comercio": "00004",
                //   "nombreComercio": "Makro",
                //   "productos": "{\"items\":[{\"cantidad\":\"1\","
                //       "\"producto\":\"CocaCola 1.25l\",\"precio\":\"250.0\"}]}",
                //   "total": "250.0",
                //   "pago": "visa",
                //   "estado": "approved",
                //   "tarjeta": "1234",
                //   "idpago": "123054654",
                //   "documento": "38044534",
                //   "token": "%TOKEN%",
                //   "cuotas": "1",
                //   "montoCuota": "250.0",
                //   "totalCuota": "250.0",
                //   "detalle":
                //       "" //your data which will be added to the collection and collection will be created after this
                // }).then((_) {
                //   print("collection created");
                // }).catchError((_) {
                //   print("an error occured");
                // });
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.all(0.0),
              child: Ink(
                width: 310,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: Colores.combinacion1),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: Container(
                  constraints:
                      const BoxConstraints(minWidth: 88.0, minHeight: 45.0),
                  // min sizes for Material buttons
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Comprar',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Últimas compras',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox()
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              constraints: const BoxConstraints(minWidth: 360, maxWidth: 360),
              // min sizes for Material buttons
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      height: 30,
                      child: TextField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'Buscar comercio',
                          labelStyle:
                              TextStyle(color: Colors.grey, fontSize: 15),
                          floatingLabelStyle:
                              TextStyle(color: Colors.transparent),
                          prefixIcon: Icon(Icons.search),
                          contentPadding: const EdgeInsets.only(
                              left: 14.0, bottom: 8.0, top: 8.0),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: StreamBuilder<QuerySnapshot<Compras>>(
                        stream: compras
                            .queryBy(ComprasQuery.uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData)
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          final data = snapshot.requireData;
                          List<String> comercios = _comercios(data);
                          return Container(
                            width: 328,
                            child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                itemExtent: 60,
                                shrinkWrap: true,
                                itemCount: comercios.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8)),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            comercioLogo(comercios[index]),
                                            Container(
                                              margin: const EdgeInsets.fromLTRB(10,0,10,0),
                                              width: 1.5,
                                              height: 40,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    numCompras[index]
                                                            .toString() +
                                                        ' listas de compras',
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12),
                                                  ),
                                                  SizedBox(
                                                    height: 6,
                                                  ),
                                                  Text(
                                                    'ultima visita 06-11-2021',
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 10,
                                                    fontWeight: FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          );
                        }),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  List<String> _comercios(QuerySnapshot<Compras> s) {
    List<String> c = [];
    List<int> l = [];
    s.docs.forEach((element) {
      if (!c.contains(element.get('nombreComercio'))) {
        c.add(element.get('nombreComercio'));
        int i = 0;
        for (int j = 0; j < s.docs.length; j++) {
          if (element.get('nombreComercio') == s.docs[j].get('nombreComercio'))
            i++;
        }
        l.add(i);
      }
    });

    numCompras = l;
    return c;
  }

  Widget comercioLogo(String nombre) {
    String image = '';
    switch(nombre){
      case "Walmart":
        image = "lib/assets/icons/logosComercios/Walmart.png";
        break;
      case "Makro":
        image = "lib/assets/icons/logosComercios/Makro.png";
        break;
      case "Carrefour":
        image = "lib/assets/icons/logosComercios/Carrefour.png";
        break;
      case "Coto":
        image = "lib/assets/icons/logosComercios/Coto.png";
        break;
      case "Sodimac":
        image = "lib/assets/icons/logosComercios/Sodimac.png";
        break;
      default:
        image = '';
        break;
    }
    return Container(
      width: 65,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }
}

enum ComprasQuery {
  id,
  fecha,
  hora,
  cliente,
  comercio,
  nombreComercio,
  productos,
  total,
  pago,
  estado,
  productosCodigo,
  tarjeta,
  idPago,
  documento,
  token,
  cuotas,
  montoCuota,
  totalCuota,
  detalle,
  telefono,
  uid,
}

extension on Query<Compras> {
  /// Create a firebase query from a [Compras]
  Query<Compras> queryBy(ComprasQuery query) {
    switch (query) {
      case ComprasQuery.uid:
        print(globals.usuario!.id);
        return where('uid', isEqualTo: globals.usuario!.id);

      case ComprasQuery.productos:
        return where('genre', arrayContainsAny: ['Sci-Fi']);

      case ComprasQuery.productos:
        return orderBy('productos', descending: true);

      case ComprasQuery.nombreComercio:
        return orderBy('nombreComercio', descending: true);

      case ComprasQuery.estado:
        return orderBy('estado', descending: true);
      default:
        return orderBy('estado', descending: true);
    }
  }
}
