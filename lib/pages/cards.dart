import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:till/constants/themes.dart';
import 'package:till/scripts/cloud_firestore.dart';
import 'package:till/scripts/mercadopago/cardsJson.dart' as c;
import 'package:till/globals.dart' as globals;
import 'package:till/pages/addcard.dart' as addcard;
import 'package:till/scripts/mercadopago/method_payment_id.dart';
import 'package:till/scripts/request.dart';
import 'package:till/scripts/request.dart' as request;

class Cards extends StatefulWidget {
  @override
  _CardsState createState() => _CardsState();
}

class _CardsState extends State<Cards> {
  GlobalKey<ScaffoldState> _keyScaf = GlobalKey();
  bool busqueda = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<c.Cards> lista = [];
    lista.add(c.Cards());
    globals.cards.forEach((element) {
      print(element.id);
      lista.add(element as c.Cards);
    });
    if (busqueda) _buscarTarjetas();
    return Scaffold(
        key: _keyScaf,
        appBar: AppBar(
          title: Text('Mis tarjetas'),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: busqueda
            ? Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
              )
            : globals.cards.length > 0
                ? ListView.builder(
                    itemCount: lista.length,
                    itemBuilder: (context, index) {
                      print(lista[index].id);
                      if (index == 0) {
                        return Padding(
                          padding: const EdgeInsets.all(20),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed('/AddCard',
                                      arguments: ArgumentsAddaCard(false, 1000))
                                  .then((value) => setState(() {
                                        busqueda = true;
                                      }));
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Agregar una nueva tarjeta',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                      return InkWell(
                          onTap: () {
                            _showDialog(context, index, lista);
                          },
                          child: Hero(
                              tag: '',
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: SizedBox(
                                  height: 100,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.grey[300],
                                    ),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: 70,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  image: lista[index]
                                                              .paymentMethod!
                                                              .id !=
                                                          ""
                                                      ? DecorationImage(
                                                          image: new AssetImage(
                                                              MetodoPago(lista[
                                                                      index]
                                                                  .paymentMethod!
                                                                  .id
                                                                  .toString())),
                                                          fit: BoxFit.contain,
                                                        )
                                                      : null,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                              Text(
                                                lista[index]
                                                    .cardholder!
                                                    .name
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Container(
                                                alignment: Alignment.centerLeft,
                                                width: 70,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  image: lista[index]
                                                              .paymentMethod!
                                                              .id !=
                                                          ""
                                                      ? DecorationImage(
                                                          image: new AssetImage(
                                                              MetodoPago(lista[
                                                                      index]
                                                                  .paymentMethod!
                                                                  .id
                                                                  .toString())),
                                                          fit: BoxFit.contain,
                                                        )
                                                      : null,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                              Text(
                                                '**** **** **** ' +
                                                    lista[index]
                                                        .lastFourDigits
                                                        .toString(),
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                              )
                                            ],
                                          ),
                                          Container(
                                            width: 10,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Icon(
                                                  Icons.navigate_next,
                                                  size: 30,
                                                ),
                                              ],
                                            ),
                                          )
                                        ]),
                                  ),
                                ),
                              )));
                    })
                : Padding(
                    padding: const EdgeInsets.all(20),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed('/AddCard',
                                arguments: ArgumentsAddaCard(false, 1000))
                            .then((value) => setState(() {
                                  busqueda = true;
                                }));
                      },
                      child: Container(
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Agregar una nueva tarjeta',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ));
  }

  void _showDialog(BuildContext context, int index, List<c.Cards> tarjetas) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Quieres eliminar esta tarjeta?',
              style: TextStyle(
                color: Color(0xff02253d),
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              tarjetas[index].paymentMethod!.id.toString()+
              ' terminada en ' +
                  tarjetas[index].lastFourDigits.toString(),
              style: TextStyle(
                color: Color(0xff02253d),
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: new Text(
                  'Cancelar',
                  style: TextStyle(
                    color: Color(0xfff4074e),
                  ),
                ),
              ),
              RaisedButton(
                onPressed: () async {
                  EliminarTarjeta(globals.usuario!.id_customer_mp.toString(),
                      globals.cards[index-1].id.toString());
                  DeleteCardDb delete = DeleteCardDb(globals.usuario!.id.toString(),
                      globals.cards[index-1].id.toString());
                  delete.docID();
                  await _buscarTarjetas();
                  Navigator.pop(context);
                  setState(() {
                    _mostrarMensaje("La tarjeta se elimino correctamente!");
                    busqueda = true;
                  });
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
                padding: const EdgeInsets.all(0.0),
                child: Ink(
                  width: 160,
                  height: 35,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        colors: Colores.combinacion1),
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                  ),
                  child: Container(
                    constraints:
                        const BoxConstraints(minWidth: 88.0, minHeight: 45.0),
                    // min sizes for Material buttons
                    alignment: Alignment.center,
                    child: Text(
                      'Eliminar tarjeta',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }

  Future _buscarTarjetas() async {
    print("buscando tarjetas..");
    if (globals.usuario!.id_customer_mp != "") {
      List<c.Cards> tarjetas = await request.BuscarTarjetas(globals
          .usuario!.id_customer_mp
          .toString()); //globals.usuario!.idcustomer.toString() //819221039-mHUSlOwg4ApZGE
      globals.cards = List.from(tarjetas);
      if (tarjetas.length > 0 && tarjetas[0].error != null) {
        print('error: ' + tarjetas[0].error.toString());
      }
    } else {
      print("no hay customer");
      busqueda = false;
      setState(() {
        print("actualizando estado...");
      });
      print("actualizando estado 2...");
      setState(() {
        print("actualizando estado 3...");
      });
    }

    setState(() {
      busqueda = false;
      print("actualizando estado 4...");
    });
  }

  void _mostrarMensaje(String msg) {
    SnackBar snackBar = SnackBar(
      content: Text(msg),
    );
    _keyScaf.currentState!.showSnackBar(snackBar);
  }
}

class ArgumentsAddaCard {
  final bool pago;
  final double total;
  ArgumentsAddaCard(this.pago, this.total);
}
