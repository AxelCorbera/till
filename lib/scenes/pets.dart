import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:till/scripts/mercadopago/json/historial.dart';
import 'package:till/scripts/mercadopago/json/mascotas.dart';
import 'package:till/globals.dart' as globals;
import 'package:till/scripts/request.dart';

class Pets extends StatefulWidget {
  _PetsState createState() => _PetsState();
}

class _PetsState extends State<Pets> {
  Mascotas mascotas = new Mascotas(items: []);
  Historial historial = new Historial();
  FotoMascotas fotoMascotas = new FotoMascotas(
      id: [], idusuario: [], idmascota: [], nombre: [], imagen: []);
  String menu = 'home';
  bool busqueda = true;
  bool mess = false;
  List<bool> abrir = [];
  List<MemoryImage> fotos = [];
  int carrito = globals.carrito.id.length;

  @override
  Widget build(BuildContext context) {
    fotos = [];
    if (busqueda) _consultarMascotas();
    Uint8List bytes;
    // if (!request) {
    //   _buscaritems(widget.categoria, widget.marca, widget.busqueda as String);
    // }
    carrito = globals.carrito.id.length;
    return Scaffold(
        appBar: appbar("Mis mascotas"),
        body: !busqueda
            ? Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
                Flexible(
                  flex: 10,
                  child: _listadoMascotas(mascotas),
                ),
                Flexible(
                  flex: 2,
                  child: FlatButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed('/AddPet',
                              arguments: AgregarMascotas(
                                  mascotas: mascotas, historial: historial))
                          .then((value) => setState(() {}));
                    },
                    child: Text(
                      "Agregar mascota +",
                      style: TextStyle(
                          fontSize: 15,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ])
            : Center(
                child: CircularProgressIndicator(),
              ));
  }

  AppBar appbar(String title) {
    return AppBar(
        title: Text(title),
        backgroundColor: Theme.of(context).primaryColor,
        actions: <Widget>[
          RaisedButton(
            color: Theme.of(context).primaryColor,
            elevation: 1,
            onPressed: () {
              Navigator.of(context)
                  .pushNamed('/Cart')
                  .then((value) => setState(() {}));
            },
            child: Row(
              children: [
                Icon(
                  Icons.shopping_cart,
                  size: 30,
                  color: Colors.white,
                ),
                if (carrito > 0)
                  Center(
                    child: Container(
                      width: 25,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                      ),
                      child: Center(
                          child: Text(
                        carrito.toString(),
                        style: TextStyle(fontSize: 22, color: Colors.white),
                      )),
                    ),
                  ),
              ],
            ),
          )
        ]);
  }

  Widget _listadoMascotas(Mascotas mascotas) {
    return Container(
      child: ListView.builder(
        itemCount: mascotas.items.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.of(context)
                  .pushNamed('/PetDetails',
                      arguments: MascotaSeleccionada(
                          mascotas: mascotas,
                          historial: historial,
                          fotos: fotos,
                          seleccionado: index))
                  .then((value) => setState(() {}));
            },
            child: Column(children: <Widget>[
              Row(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: mascotas.items.length > index
                      ? Container(
                          constraints: BoxConstraints(
                            minWidth: 44,
                            minHeight: 44,
                            maxWidth: 64,
                            maxHeight: 64,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: _imagen(
                                  mascotas.items[index].id.toString(), index),
                            ),
                          ),
                        )
                      : Container(
                          constraints: BoxConstraints(
                            minWidth: 64,
                            minHeight: 64,
                            maxWidth: 64,
                            maxHeight: 64,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.pets,
                            color: Theme.of(context).secondaryHeaderColor,
                          ),
                        ),
                ),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          mascotas.items[index].nombre.toString(),
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          mascotas.items[index].especie.toString() +
                              " " +
                              mascotas.items[index].raza.toString() +
                              " " +
                              _calcularEdad(
                                  mascotas.items[index].nacimiento.toString()),
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ]),
                ),
                Container(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        FlatButton.icon(
                          onPressed: () {
                            _consultaEliminar(context, mascotas, index);
                          },
                          icon: Icon(
                            Icons.delete_rounded,
                            color: Theme.of(context).primaryColor,
                          ),
                          label: Text(""),
                        ),
                      ]),
                ),
              ]),
              Divider(
                indent: 12,
                endIndent: 12,
                height: 10,
                color: Colors.black,
              ),
            ]),
          );
        },
        scrollDirection: Axis.vertical,
      ),
    );
  }

  String _calcularEdad(String fecha) {
    return "";
  }

  Widget _expansionPanel(Mascotas mascotas) {
    return ExpansionPanelList(
      elevation: 0,
      animationDuration: Duration(milliseconds: 1000),
      children: _listExpansion(mascotas),
      expansionCallback: (panelIndex, isExpanded) {
        abrir[panelIndex] = !abrir[panelIndex];
        setState(() {});
      },
      //dividerColor: Colors.grey,
    );
  }

  List<ExpansionPanel> _listExpansion(Mascotas mascotas) {
    List<ExpansionPanel> l = <ExpansionPanel>[];
    int a = 0;

    for (var i in mascotas.items) {
      abrir.add(false);
      ExpansionPanel item = ExpansionPanel(
        //backgroundColor: Colors.transparent,
        headerBuilder: (context, isExpanded) {
          return ListTile(
            leading: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: 44,
                minHeight: 44,
                maxWidth: 64,
                maxHeight: 64,
              ),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: fotos.length > a
                        ? fotos[a]
                        : _imagen(i.id.toString(), a),
                  ),
                ),
              ),
            ),
            title: Text(
              i.nombre.toString(),
              style: TextStyle(color: Colors.black),
            ),
          );
        },
        body: Column(
          children: [
            if (i.especie.toString() != "")
              ListTile(
                title: Text("Especie: " + i.especie.toString(),
                    style: TextStyle(color: Colors.black)),
              ),
            if (i.sexo.toString() != "")
              ListTile(
                title: Text("Sexo: " + i.sexo.toString(),
                    style: TextStyle(color: Colors.black)),
              ),
            if (i.raza.toString() != "")
              ListTile(
                title: Text("Raza: " + i.raza.toString(),
                    style: TextStyle(color: Colors.black)),
              ),
            if (i.nombre.toString() != "")
              ListTile(
                title: Text("Nombre: " + i.nombre.toString(),
                    style: TextStyle(color: Colors.black)),
              ),
            if (i.apellido.toString() != "")
              ListTile(
                title: Text("Apellido: " + i.apellido.toString(),
                    style: TextStyle(color: Colors.black)),
              ),
            if (i.peso.toString() != "")
              ListTile(
                title: Text("Peso: " + i.peso.toString(),
                    style: TextStyle(color: Colors.black)),
              ),
            if (i.nacimiento.toString() != "")
              ListTile(
                title: Text("Fecha de nacimiento: " + i.nacimiento.toString(),
                    style: TextStyle(color: Colors.black)),
              ),
            if (i.observacion.toString() != "")
              ListTile(
                title: Text("Observacion: " + i.observacion.toString(),
                    style: TextStyle(color: Colors.black)),
              ),
            ButtonBar(
              children: <Widget>[
                FlatButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    Icons.edit,
                    color: Theme.of(context).primaryColor,
                  ),
                  label: Text(""),
                ),
                FlatButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  label: Text(""),
                ),
              ],
            ),
          ],
        ),
        isExpanded: abrir[a],
        canTapOnHeader: true,
      );
      a++;
      l.add(item);

      print(a);
    }
    //fotos.forEach((element) {print(element);});

    return l;
  }

  @override
  void initState() {
    super.initState();
  }

  MemoryImage _imagen(String id, int index) {
    // mascotas.items.forEach((element) { print("a>"+element.id.toString());});
    // fotoMascotas.idmascota!.forEach((element) { print("b>"+element.toString());});
    // print(fotoMascotas.toString());
    int num = fotoMascotas.idmascota!.indexOf(id);
    var temp = new Uint8List(500);
    var bytes;
    if (num >= 0) {
      bytes = base64.decode(fotoMascotas.imagen![num]);
      fotos.add(MemoryImage(bytes));
      print("elementos: " + fotos.length.toString());
      return new MemoryImage(bytes);
    } else {
      return new MemoryImage(temp);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _consultarMascotas() async {
    if (globals.usuario!.id.toString() != "") {
      if (busqueda)
        fotoMascotas = await BuscarFotoMascotas(globals.usuario!.id.toString());
      mascotas = await BuscarMascotas(globals.usuario!.id.toString());
      historial = await BuscarHistorial(globals.usuario!.id.toString());
      print('historiales: ' + historial.items!.length.toString());
      historial.items!.forEach((element) {
        print(element.idMascota.toString() + ' ' + element.tipo.toString());
      });
      busqueda = false;
      setState(() {});
    } else {}
  }

  Future<void> _eliminarMascota(
      BuildContext context, Mascotas mascotas, int index) async {
    cargando(context);
    String i2 = await BorrarFoto(
        globals.usuario!.id.toString(), mascotas.items[index].id.toString());
    mascotas.items.removeAt(index);
    String i = await actualizarMascotas(
        globals.usuario!.id.toString(), mascotasToJson(mascotas));
    Navigator.pop(context);
    print('termino: $i y  borro: $i2');
    setState(() {});
  }

  void cargando(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          );
        });
  }

  void _consultaEliminar(BuildContext context, Mascotas mascotas, int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Desea eliminar a \"' +
                      mascotas.items[index].nombre.toString() +
                      '\" de tus mascotas?'),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancelar')),
                    RaisedButton(
                      onPressed: () {
                        _eliminarMascota(context, mascotas, index);
                        Navigator.pop(context);
                      },
                      child: Text('Eliminar'),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          );
        });
  }
}

class MascotaSeleccionada {
  MascotaSeleccionada(
      {required this.mascotas,
      required this.fotos,
      required this.seleccionado,
      required this.historial});

  Mascotas mascotas;
  List<MemoryImage> fotos;
  int seleccionado;
  Historial historial;
}

class AgregarMascotas {
  AgregarMascotas({required this.mascotas, required this.historial});

  Mascotas mascotas;
  Historial historial;
}
