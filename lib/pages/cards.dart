import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
                            _showDialog(context, index);
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

  Widget hayTarjeta() {
    return Scaffold(
      key: _keyScaf,
      appBar: AppBar(
        title: Text('Mis tarjetas'),
        actions: <Widget>[
          FlatButton.icon(
            onPressed: () {
              Navigator.of(context)
                  .pushNamed('/AddCard',
                      arguments: ArgumentsAddaCard(false, 1000))
                  .then((value) => setState(() {}));
            },
            icon: Icon(
              Icons.add_circle_outline,
              color: Theme.of(context).secondaryHeaderColor,
            ),
            label: Text(""),
          )
        ],
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ListView.builder(
          itemCount: globals.cards.length,
          itemBuilder: (context, index) {
            return InkWell(
                onTap: () {
                  _showDialog(context, index);
                },
                child: Hero(
                    tag: '',
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: SizedBox(
                        height: 230,
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          elevation: 5,
                          //color: Colors.grey[300],
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: LinearGradient(
                                    begin: Alignment.bottomLeft,
                                    end: Alignment.topRight,
                                    colors: [Colors.black, Colors.black54])),
                            child: Column(
                              children: <Widget>[
                                Row(children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.all(25),
                                    alignment: Alignment.centerLeft,
                                    width: 90,
                                    height: 60,
                                    decoration: BoxDecoration(
                                        image: globals.cards[index]
                                                    .paymentMethod!.id !=
                                                ""
                                            ? DecorationImage(
                                                image: new AssetImage(
                                                    MetodoPago(globals
                                                        .cards[index]
                                                        .paymentMethod!
                                                        .id
                                                        .toString())),
                                                fit: BoxFit.contain,
                                              )
                                            : null,
                                        borderRadius: BorderRadius.circular(10),
                                        gradient: LinearGradient(
                                            begin: Alignment.bottomLeft,
                                            end: Alignment.topRight,
                                            colors: [
                                              Colors.white70,
                                              Colors.white70
                                            ])),
                                  ),
                                ]),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(children: <Widget>[
                                  SizedBox(
                                    width: 23,
                                  ),
                                  Padding(
                                      padding: EdgeInsets.all(0),
                                      child: Text(
                                        '**** **** **** ' +
                                            globals.cards[index].lastFourDigits
                                                .toString(),
                                        style: TextStyle(
                                            fontSize: 40, color: Colors.white),
                                      ))
                                ]),
                                Row(children: <Widget>[
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Padding(
                                      padding: EdgeInsets.all(0),
                                      child: Text(
                                        globals.cards[index].cardholder!.name
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.white),
                                      )),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    globals.cards[index].expirationMonth
                                            .toString() +
                                        '/' +
                                        globals.cards[index].expirationYear
                                            .toString()
                                            .substring(2, 4),
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  )
                                ]),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )));
          }),
    );
  }

  Widget noHayTarjeta() {
    return Scaffold(
      key: _keyScaf,
      appBar: AppBar(
        title: Text('Mis tarjetas'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ListView.builder(
          itemCount: 1,
          itemBuilder: (context, index) {
            return InkWell(
                onTap: () {
                  Navigator.of(context)
                      .pushNamed('/AddCard',
                          arguments: ArgumentsAddaCard(false, 1000))
                      .then((value) => setState(() {
                            busqueda = true;
                          }));
                },
                child: Hero(
                    tag: '',
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: SizedBox(
                        height: 230,
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          elevation: 5,
                          //color: Colors.grey[300],
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: LinearGradient(
                                    begin: Alignment.bottomLeft,
                                    end: Alignment.topRight,
                                    colors: [Colors.grey, Colors.black54])),
                            child: Center(
                              child: Column(children: <Widget>[
                                SizedBox(
                                  height: 30,
                                ),
                                Text(
                                  "Añadir nueva tarjeta",
                                  style: TextStyle(
                                      fontSize: 30, color: Colors.white),
                                ),
                                Text(
                                  "+",
                                  style: TextStyle(
                                      fontSize: 100, color: Colors.white38),
                                )
                              ]),
                            ),
                          ),
                        ),
                      ),
                    )));
          }),
    );
  }

  void _showDialog(BuildContext context, int index) {
    GlobalKey keyText = GlobalKey<EditableTextState>();
    final _textFieldController = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Center(
                        child: Text(
                      '¿Desea eliminar esta tarjeta?',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    )),
                    Center(
                      child: ButtonBar(
                        children: <Widget>[
                          FlatButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "Cancelar",
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                ),
                              )),
                          FlatButton(
                              onPressed: () async {
                                EliminarTarjeta(
                                    globals.usuario!.id_customer_mp.toString(),
                                    globals.cards[index].id.toString());
                                await _buscarTarjetas();
                                Navigator.pop(context);
                                setState(() {
                                  _mostrarMensaje(
                                      "La tarjeta se elimino correctamente!");
                                  busqueda = true;
                                });
                              },
                              child: Text(
                                "Eliminar",
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ))
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
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
