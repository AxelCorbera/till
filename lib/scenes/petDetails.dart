import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:till/scenes/pets.dart';
import 'package:till/scripts/mercadopago/json/historial.dart' as h;
import 'package:till/scripts/mercadopago/json/mascotas.dart';
import 'package:till/globals.dart' as globals;
import 'package:till/scripts/request.dart';
import 'package:image_picker/image_picker.dart';
//import "package:intl/intl.dart" show DateFormat;

class PetDetails extends StatefulWidget {
  const PetDetails({Key? key, required this.argumentos}) : super(key: key);
  final MascotaSeleccionada argumentos;
  _PetDetailState createState() => _PetDetailState();
}

class _PetDetailState extends State<PetDetails> {
  Mascotas mascotas = new Mascotas(items: []);
  h.Historial historial = new h.Historial(items: []);
  String menu = 'home';
  bool busqueda = true;
  List<MemoryImage> fotos = [];
  int carrito = globals.carrito.id.length;
  bool datos = true;
  bool editar = false;
  XFile imageFile = new XFile('');

  GlobalKey<FormState> _keyForm = GlobalKey();
  String date = "";
  DateTime selectedDate = DateTime.now();

  String nombre = '';
  String apellido = '';
  String sexo = '';
  String raza = '';
  String peso = "";
  DateTime nacimiento = DateTime.now();
  DateTime fecha1 = DateTime.now();
  DateTime fecha2 = DateTime.now();
  String alarmas = "";
  String observacion = "";
  String lugar = "";
  String telefono = "";
  String domicilio = "";
  String pelaje = "";
  String especie = "";

  File file = File('');
  bool nueva = false;

  @override
  Widget build(BuildContext context) {
    mascotas = widget.argumentos.mascotas;
    historial = _juntarHistorial(
        widget.argumentos.historial, widget.argumentos.seleccionado);
    print(h.historialToJson(widget.argumentos.historial));
    fotos = widget.argumentos.fotos;
    int seleccionado = widget.argumentos.seleccionado;
    nacimiento =
        DateTime.parse(mascotas.items[seleccionado].nacimiento.toString());
    print(mascotas.items[seleccionado].sexo);
    print('mascota seleccionada: $seleccionado');
    carrito = globals.carrito.id.length;
    return Scaffold(
      backgroundColor: mascotas.items[seleccionado].sexo == "MACHO"
          ? Colors.cyan
          : Colors.pinkAccent,
      appBar: appbar(mascotas.items[seleccionado].nombre.toString() +
          " " +
          mascotas.items[seleccionado].apellido.toString()),
      body: ListView(
        children: [
          Column(children: <Widget>[
            Stack(children: _detalles(mascotas, seleccionado)),
            Column(children: <Widget>[
              !editar
                  ? Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              datos = true;
                              setState(() {});
                            },
                            child: Container(
                                // optional
                                padding: const EdgeInsets.all(5),
                                decoration: datos
                                    ? BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                width: 2.0,
                                                color: Theme.of(context)
                                                    .secondaryHeaderColor)))
                                    : null,
                                child: Text(
                                  'Datos',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .secondaryHeaderColor,
                                      fontWeight: FontWeight.bold),
                                )),
                          ),
                          Text(
                            "|",
                            style: TextStyle(
                                color: Theme.of(context).secondaryHeaderColor,
                                fontWeight: FontWeight.bold),
                          ),
                          GestureDetector(
                            onTap: () {
                              datos = false;
                              setState(() {});
                            },
                            child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: !datos
                                    ? BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                width: 2.0,
                                                color: Theme.of(context)
                                                    .secondaryHeaderColor)))
                                    : null,
                                child: Text(
                                  'Historial clinico',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .secondaryHeaderColor,
                                      fontWeight: FontWeight.bold),
                                )),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                        ],
                      ),
                    )
                  : SizedBox(
                      height: 10,
                    ),
            ]),
          ]),
          editar
              ? _form(seleccionado)
              : datos
                  ? _datos(seleccionado)
                  : _historial(seleccionado),
        ],
      ),
    );
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

  Widget _form(int index) {
    return Form(
      key: _keyForm,
      child: Container(
        padding: EdgeInsets.all(15),
        //color: Colors.white,
        constraints: BoxConstraints(
          minWidth: double.infinity,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.all(5),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      initialValue: mascotas.items[index].nombre,
                      decoration: InputDecoration(
                        labelText: "Nombre: *",
                      ),
                      onSaved: (value) {
                        nombre = value.toString();
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Este campo es obligatorio';
                        }
                      },
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      initialValue: mascotas.items[index].apellido,
                      decoration: InputDecoration(
                        labelText: "Apellido:",
                      ),
                      onSaved: (value) {
                        apellido = value.toString();
                      },
                      // validator: (value) {
                      //   if (value!.isEmpty) {
                      //     return 'Este campo es obligatorio';
                      //   }
                      // },
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      initialValue: mascotas.items[index].especie,
                      decoration: InputDecoration(
                        labelText: "Especie: *",
                      ),
                      onSaved: (value) {
                        especie = value.toString();
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Este campo es obligatorio';
                        }
                      },
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      initialValue: mascotas.items[index].raza,
                      decoration: InputDecoration(
                        labelText: "Raza:",
                      ),
                      onSaved: (value) {
                        raza = value.toString();
                      },
                      // validator: (value) {
                      //   if (value!.isEmpty) {
                      //     return 'Este campo es obligatorio';
                      //   }
                      // },
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                initialValue: mascotas.items[index].pelaje,
                decoration: InputDecoration(
                  labelText: "Pelaje:",
                ),
                onSaved: (value) {
                  pelaje = value.toString();
                },
                // validator: (value) {
                //   if (value!.isEmpty) {
                //     return 'Este campo es obligatorio';
                //   }
                // },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      initialValue: mascotas.items[index].peso,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Peso:",
                      ),
                      onSaved: (value) {
                        peso = value.toString();
                      },
                      // validator: (value) {
                      //   if (value!.isEmpty) {
                      //     return 'Este campo es obligatorio';
                      //   }
                      // },
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButtonFormField(
                      value: 'HEMBRA',
                      onTap: () {},
                      onSaved: (value) {
                        sexo = value.toString();
                      },
                      onChanged: (value) {},
                      hint: Text(
                        'Sexo',
                      ),
                      isExpanded: true,
                      items: [
                        'HEMBRA',
                        'MACHO',
                      ].map((String val) {
                        return DropdownMenuItem(
                          value: val,
                          child: Text(
                            val,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Flexible(
                  flex: 7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Fecha de nacimiento:",
                        style: TextStyle(color: Colors.grey[700], fontSize: 17),
                      ),
                      FlatButton(
                        onPressed: () {
                          _selectDate(context, index);
                        },
                        child: Text(
                          "${nacimiento.day}/${nacimiento.month}/${nacimiento.year}",
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      //Text("${selectedDate.day}/${selectedDate.month}/${selectedDate.year}")
                    ],
                  ),
                ),
                Flexible(
                  flex: 5,
                  child: TextFormField(
                    initialValue: mascotas.items[index].lugar,
                    decoration: InputDecoration(
                      labelText: "Lugar:",
                    ),
                    onSaved: (value) {
                      lugar = value.toString();
                    },
                    // validator: (value) {
                    //   if (value!.isEmpty) {
                    //     return 'Este campo es obligatorio';
                    //   }
                    // },
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      initialValue: mascotas.items[index].telefono,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: "Telefono:",
                      ),
                      onSaved: (value) {
                        telefono = value.toString();
                      },
                      // validator: (value) {
                      //   if (value!.isEmpty) {
                      //     return 'Este campo es obligatorio';
                      //   }
                      // },
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      initialValue: mascotas.items[index].domicilio,
                      decoration: InputDecoration(
                        labelText: "Domicilio:",
                      ),
                      onSaved: (value) {
                        domicilio = value.toString();
                      },
                      // validator: (value) {
                      //   if (value!.isEmpty) {
                      //     return 'Este campo es obligatorio';
                      //   }
                      // },
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: RaisedButton(
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  if (_keyForm.currentState!.validate()) {
                    _actualizarMascota(context, index);
                  }
                },
                child: Text(
                  'Editar',
                  style:
                      TextStyle(color: Theme.of(context).secondaryHeaderColor),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _datos(int index) {
    return Container(
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Nacimiento",
                  style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                _nacimiento(mascotas.items[index].nacimiento.toString()),
                SizedBox(
                  height: 10,
                ),
                Text(
                  mascotas.items[index].lugar.toString(),
                  style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold),
                ),
                new Divider(
                  height: 20,
                  color: Colors.black,
                ),
                Text(
                  "Telefono",
                  style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  mascotas.items[index].telefono.toString(),
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Pelaje",
                  style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  mascotas.items[index].pelaje.toString(),
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  ' ',
                  style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold),
                ),
                new Divider(
                  height: 20,
                  color: Colors.black,
                ),
                Text(
                  "Direccion",
                  style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  mascotas.items[index].domicilio.toString(),
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _nacimiento(String nac) {
    DateTime date = DateTime.parse(nac);
    return Text(
      date.day.toString() +
          '/' +
          date.month.toString() +
          '/' +
          date.year.toString(),
      style: TextStyle(
          fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),
    );
  }

  Widget _historial(int index) {
    return Column(
      children: [
        Container(
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Historias clinicas",
                      style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FlatButton.icon(
                      onPressed: () {
                        _nuevaHistoria(context, index);
                      },
                      icon: Icon(
                        Icons.add_circle,
                        size: 18,
                        color: Theme.of(context).primaryColor,
                      ),
                      label: Text(''),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        _listadoHistorias()
      ],
    );
  }

  List<Widget> _detalles(Mascotas mascotas, int index) {
    return <Widget>[
      Container(
        alignment: Alignment.center,
        constraints: BoxConstraints(
            minHeight: 20,
            maxHeight: 350,
            minWidth: 20,
            maxWidth: double.infinity),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Colors.white,
        ),
        child: Column(
          children: <Widget>[
            Expanded(
                flex: 2,
                child: Container(
                    //color: Colors.red,
                    )),
            Expanded(
                flex: 1,
                child: Container(
                  //color: Colors.blue,
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: _puntos(mascotas, index),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Column(
                                  //mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(children: <Widget>[
                                      Text(
                                        mascotas.items[index].nombre.toString(),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      mascotas.items[index].sexo == "MACHO"
                                          ? Icon(
                                              Icons.male,
                                              color: Colors.grey,
                                            )
                                          : Icon(
                                              Icons.female,
                                              color: Colors.grey,
                                            ),
                                    ]),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Text(
                                      mascotas.items[index].especie.toString() +
                                          ' - ' +
                                          _calcularEdad(mascotas
                                              .items[index].nacimiento
                                              .toString()) +
                                          ' año(s)',
                                      textAlign: TextAlign.start,
                                    )
                                  ]),
                              Column(
                                children: [
                                  Container(child: Text('')),
                                ],
                              ),
                              Column(
                                children: [
                                  Container(
                                      child: FlatButton.icon(
                                          onPressed: () {
                                            editar = !editar;
                                            if (!editar) nueva = false;
                                            setState(() {});
                                          },
                                          icon: !editar
                                              ? Icon(
                                                  Icons.edit,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                )
                                              : Icon(
                                                  Icons.cancel,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                ),
                                          label: Text(''))),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
          ],
        ),
      ),
      fotos.length > index
          ? Container(
              alignment: Alignment.center,
              constraints:
                  BoxConstraints(maxHeight: 230, maxWidth: double.infinity),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                //file!=''?FileImage(file):fotos[index]
                image: nueva
                    ? DecorationImage(
                        image: FileImage(file),
                        fit: BoxFit.cover,
                      )
                    : DecorationImage(
                        image: fotos[index],
                        fit: BoxFit.cover,
                      ),
              ),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.white,
                    gradient: LinearGradient(
                        begin: Alignment.center,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.white])),
              ),
            )
          : nueva
              ? Container(
                  alignment: Alignment.center,
                  constraints:
                      BoxConstraints(maxHeight: 230, maxWidth: double.infinity),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    //file!=''?FileImage(file):fotos[index]
                    image: DecorationImage(
                      image: FileImage(file),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        gradient: LinearGradient(
                            begin: Alignment.center,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.white])),
                  ),
                )
              : Container(
                  alignment: Alignment.center,
                  constraints:
                      BoxConstraints(maxHeight: 230, maxWidth: double.infinity),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                  ),
                  child: Icon(
                    Icons.pets,
                    size: 90,
                    color: Colors.grey,
                  ),
                ),
      Container(
          alignment: Alignment.bottomRight,
          constraints:
              BoxConstraints(maxHeight: 230, maxWidth: double.infinity),
          decoration: BoxDecoration(
              //shape: BoxShape.rectangle,
              ),
          child: editar ? _nuevaFoto(context) : null),
    ];
  }

  List<Widget> _puntos(Mascotas mascotas, int index) {
    List<Widget> cant = [];
    Widget relleno = Flexible(
      flex: 5,
      child: SizedBox(
        width: 200,
        height: 20,
      ),
    );
    cant.add(relleno);
    int i = 0;
    mascotas.items.forEach((element) {
      Widget texto = index == i
          ? Flexible(
              flex: 1,
              child: Icon(
                Icons.circle,
                size: 8,
                color: Theme.of(context).primaryColor,
              ))
          : Flexible(
              flex: 1,
              child: Icon(
                Icons.circle,
                size: 8,
                color: Colors.grey,
              ));
      cant.add(texto);
      i++;
    });
    cant.add(relleno);
    return cant;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _selectDate(BuildContext context, int index) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.parse(mascotas.items[index].nacimiento.toString()),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    nacimiento = DateTime.parse(mascotas.items[index].nacimiento.toString());
    if (selected != null && selected != selectedDate)
      setState(() {
        nacimiento = selected;
        selectedDate = selected;
      });
  }

  String _calcularEdad(String nac) {
    DateTime nacimiento = DateTime.parse(nac);
    DateTime ahora = DateTime.now();
    var cuenta = ahora.difference(nacimiento).inDays;
    double diferencia = cuenta / 365;
    return diferencia.toStringAsPrecision(2);
  }

  Future<void> _actualizarMascota(BuildContext context, int index) async {
    _keyForm.currentState!.save();
    mascotas.items[index].nombre = nombre;
    mascotas.items[index].apellido = apellido;
    mascotas.items[index].sexo = sexo;
    mascotas.items[index].raza = raza;
    mascotas.items[index].peso = peso;
    mascotas.items[index].nacimiento = nacimiento.toString();
    mascotas.items[index].alarmas = alarmas;
    mascotas.items[index].observacion = observacion;
    mascotas.items[index].lugar = lugar;
    mascotas.items[index].telefono = telefono;
    mascotas.items[index].domicilio = domicilio;
    mascotas.items[index].pelaje = pelaje;
    mascotas.items[index].especie = especie;

    cargando(context, 'Editando informacion');
    print('mascotas a actualizad (id) : ' +
        globals.usuario!.id.toString() +
        ' / ' +
        mascotas.toJson().toString());
    String s = await actualizarMascotas(
        globals.usuario!.id.toString(), mascotasToJson(mascotas));
    String s2 = '';
    print('>>> ' + _imagen(imageFile));
    if (_imagen(imageFile).length > 0)
      s2 = await ActualizarFoto(
          globals.usuario!.id.toString(),
          mascotas.items[index].id.toString(),
          mascotas.items[index].nombre.toString(),
          _imagen(imageFile));
    print(s2 + ' <><> ' + _imagen(imageFile));
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  String _imagen(XFile image) {
    File i = File(image.path);

    List<int> imageBytes = i.readAsBytesSync();
    var bytes = base64.encode(imageBytes);
    return bytes;
  }

  void cargando(BuildContext context, String msj) {
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
                Text(msj),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          );
        });
  }

  void _nuevaHistoria(BuildContext context, int index) {
    GlobalKey<FormState> _keyForm2 = GlobalKey();
    h.Item historia = new h.Item(
      id: "",
      idMascota: "",
      tipo: "",
      fecha: "",
      nombre: "",
      peso: "",
      proximaFecha: "",
      lugar: "",
      medicamento: "",
      observaciones: "",
    );
    var d1 = 0;
    var m1 = 0;
    var a1 = 0;
    var d2 = 0;
    var m2 = 0;
    var a2 = 0;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              content: SingleChildScrollView(
            child: Form(
              key: _keyForm2,
              child: Container(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Historia'),
                      DropdownButtonFormField(
                        onTap: () {},
                        onSaved: (value) {},
                        onChanged: (value) {
                          historia.tipo = value.toString();
                        },
                        hint: Text(
                          'historia',
                        ),
                        isExpanded: true,
                        items: [
                          'VACUNA',
                          'DESPARACITACION',
                          'CASTRACION',
                          'OPERACION',
                          'CONTROL',
                          'OTRO'
                        ].map((String val) {
                          return DropdownMenuItem(
                            value: val,
                            child: Text(
                              val,
                            ),
                          );
                        }).toList(),
                        validator: (value) {
                          if (value == null) {
                            return 'Este campo es obligatorio';
                          }
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text('Fecha'),
                      ),
                      Row(
                        children: <Widget>[
                          Flexible(
                            child: DropdownButtonFormField(
                              onTap: () {},
                              onSaved: (value) {},
                              onChanged: (value) {
                                d1 = int.parse(value.toString());
                              },
                              hint: Text(
                                'DIA',
                              ),
                              isExpanded: true,
                              items: [
                                '1',
                                '2',
                                '3',
                                '4',
                                '5',
                                '6',
                                '7',
                                '8',
                                '9',
                                '10',
                                '11',
                                '12',
                                '13',
                                '14',
                                '15',
                                '16',
                                '17',
                                '18',
                                '19',
                                '20',
                                '21',
                                '22',
                                '23',
                                '24',
                                '25',
                                '26',
                                '27',
                                '28',
                                '29',
                                '30',
                                '31'
                              ].map((String val) {
                                return DropdownMenuItem(
                                  value: val,
                                  child: Text(
                                    val,
                                  ),
                                );
                              }).toList(),
                              validator: (value) {
                                if (value == null) {
                                  return 'dia?';
                                }
                              },
                            ),
                          ),
                          Flexible(
                            child: DropdownButtonFormField(
                              onTap: () {},
                              onSaved: (value) {},
                              onChanged: (value) {
                                m1 = int.parse(value.toString());
                              },
                              hint: Text(
                                'MES',
                              ),
                              isExpanded: true,
                              items: [
                                '1',
                                '2',
                                '3',
                                '4',
                                '5',
                                '6',
                                '7',
                                '8',
                                '9',
                                '10',
                                '11',
                                '12'
                              ].map((String val) {
                                return DropdownMenuItem(
                                  value: val,
                                  child: Text(
                                    val,
                                  ),
                                );
                              }).toList(),
                              validator: (value) {
                                if (value == null) {
                                  return 'mes?';
                                }
                              },
                            ),
                          ),
                          Flexible(
                            child: DropdownButtonFormField(
                              onTap: () {},
                              onSaved: (value) {},
                              onChanged: (value) {
                                a1 = int.parse(value.toString());
                              },
                              hint: Text(
                                'AÑO',
                              ),
                              isExpanded: true,
                              items: [
                                '1990',
                                '1991',
                                '1992',
                                '1993',
                                '1994',
                                '1995',
                                '1996',
                                '1997',
                                '1998',
                                '1999',
                                '2000',
                                '2001',
                                '2002',
                                '2003',
                                '2004',
                                '2005',
                                '2006',
                                '2007',
                                '2008',
                                '2009',
                                '2010',
                                '2011',
                                '2012',
                                '2013',
                                '2014',
                                '2015',
                                '2016',
                                '2017',
                                '2018',
                                '2019',
                                '2020',
                                '2021',
                                '2022',
                                '2023',
                                '2024',
                                '2025',
                              ].map((String val) {
                                return DropdownMenuItem(
                                  value: val,
                                  child: Text(
                                    val,
                                  ),
                                );
                              }).toList(),
                              validator: (value) {
                                if (value == null) {
                                  return 'año?';
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Peso: ",
                        ),
                        onSaved: (value) {},
                        onChanged: (value) {
                          historia.peso = value.toString();
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text('Fecha de revision'),
                      ),
                      Row(
                        children: <Widget>[
                          Flexible(
                            child: DropdownButtonFormField(
                              onTap: () {},
                              onSaved: (value) {},
                              onChanged: (value) {
                                d2 = int.parse(value.toString());
                              },
                              hint: Text(
                                'DIA',
                              ),
                              isExpanded: true,
                              items: [
                                '1',
                                '2',
                                '3',
                                '4',
                                '5',
                                '6',
                                '7',
                                '8',
                                '9',
                                '10',
                                '11',
                                '12',
                                '13',
                                '14',
                                '15',
                                '16',
                                '17',
                                '18',
                                '19',
                                '20',
                                '21',
                                '22',
                                '23',
                                '24',
                                '25',
                                '26',
                                '27',
                                '28',
                                '29',
                                '30',
                                '31'
                              ].map((String val) {
                                return DropdownMenuItem(
                                  value: val,
                                  child: Text(
                                    val,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          Flexible(
                            child: DropdownButtonFormField(
                              onTap: () {},
                              onSaved: (value) {},
                              onChanged: (value) {
                                m2 = int.parse(value.toString());
                              },
                              hint: Text(
                                'MES',
                              ),
                              isExpanded: true,
                              items: [
                                '1',
                                '2',
                                '3',
                                '4',
                                '5',
                                '6',
                                '7',
                                '8',
                                '9',
                                '10',
                                '11',
                                '12'
                              ].map((String val) {
                                return DropdownMenuItem(
                                  value: val,
                                  child: Text(
                                    val,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          Flexible(
                            child: DropdownButtonFormField(
                              onTap: () {},
                              onSaved: (value) {},
                              onChanged: (value) {
                                a2 = int.parse(value.toString());
                              },
                              hint: Text(
                                'AÑO',
                              ),
                              isExpanded: true,
                              items: [
                                '2021',
                                '2022',
                                '2023',
                                '2024',
                                '2025',
                              ].map((String val) {
                                return DropdownMenuItem(
                                  value: val,
                                  child: Text(
                                    val,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Lugar: *",
                        ),
                        onSaved: (value) {
                          historia.lugar = value.toString();
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Este campo es obligatorio';
                          }
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text('Medicacion'),
                      ),
                      DropdownButtonFormField(
                        onTap: () {},
                        onSaved: (value) {},
                        onChanged: (value) {
                          historia.medicamento = value.toString();
                        },
                        hint: Text(
                          'medicacion',
                        ),
                        isExpanded: true,
                        items: ['NO', 'SI'].map((String val) {
                          return DropdownMenuItem(
                            value: val,
                            child: Text(
                              val,
                            ),
                          );
                        }).toList(),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Observaciones: ",
                        ),
                        onSaved: (value) {},
                        onChanged: (value) {
                          historia.observaciones = value.toString();
                        },
                      ),
                      ButtonBar(
                        children: <Widget>[
                          RaisedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Cancelar',
                                style: TextStyle(color: Colors.black)),
                          ),
                          RaisedButton(
                            onPressed: () {
                              print(d1 + m1 + a1);
                              if (_keyForm2.currentState!.validate()) {
                                //print('$d1 / $m1 / $a1');
                                var t = DateTime(a1, m1, d1);
                                historia.fecha = t.toString();
                                if (d2 != 0 && m2 != 0 && a2 != 0) {
                                  DateTime t2 = new DateTime(a2, m2, d2);
                                  historia.proximaFecha = t2.toString();
                                } else {
                                  historia.proximaFecha =
                                      DateTime.now().toString();
                                }
                                int i = 0;
                                mascotas.items.forEach((element) {
                                  if (element.id == i.toString()) {
                                    i++;
                                  }
                                });
                                historia.id = i.toString();
                                historia.idMascota = mascotas.items[index].id;
                                historia.nombre = mascotas.items[index].nombre;
                                _agregarHistoria(historia);
                              }
                            },
                            child: Text(
                              'Agregar',
                              style: TextStyle(
                                  color:
                                      Theme.of(context).secondaryHeaderColor),
                            ),
                            color: Theme.of(context).primaryColor,
                          ),
                        ],
                      )
                    ]),
              ),
            ),
          ));
        });
  }

  Widget _nuevaFoto(BuildContext context) {
    return IconButton(
      alignment: Alignment.bottomRight,
      icon: Icon(Icons.camera_alt),
      onPressed: () {
        _showPickerOpcions(context);
      },
      iconSize: 75,
      color: Theme.of(context).secondaryHeaderColor,
    );
  }

  void _showPickerOpcions(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text("Camara"),
                onTap: () {
                  Navigator.pop(context);
                  _showPickImage(context, ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.image),
                title: Text("Galeria"),
                onTap: () {
                  Navigator.pop(context);
                  _showPickImage(context, ImageSource.gallery);
                },
              )
            ],
          );
        });
  }

  void _showPickImage(BuildContext context, source) async {
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      file = File(image.path);
      imageFile = image;
      nueva = true;
      print(_imagen(image));
      print('hay foto');
    } else {
      nueva = false;
      file = File('');
      imageFile = XFile('');
      print('NO hay foto');
    }
    setState(() {});
  }

  void _agregarHistoria(h.Item historia) async {
    h.Historial his = widget.argumentos.historial;
    his.items!.add(historia);
    cargando(context, 'Agregando historia');
    String s = await actualizarHistorial(
        globals.usuario!.id.toString(), h.historialToJson(his));
    Navigator.pop(context);
    Navigator.pop(context);
    setState(() {});
  }

  Widget _listadoHistorias() {
    return Container(
      color: Colors.white,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: historial.items!.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              _historiaSeleccionada(context, historial.items![index]);
            },
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Container(
                          color: Colors.white,
                          constraints: BoxConstraints(
                            minHeight: 30,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              historial.items![index].tipo.toString(),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Container(
                          color: Colors.white,
                          constraints: BoxConstraints(
                            minHeight: 30,
                          ),
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: _fecha(
                                  historial.items![index].fecha.toString())),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider()
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _fecha(String fecha) {
    DateTime date = DateTime.parse(fecha);
    return Text(
      date.day.toString() +
          ' / ' +
          date.month.toString() +
          ' / ' +
          date.year.toString(),
      style: TextStyle(color: Colors.black54),
    );
  }

  h.Historial _juntarHistorial(h.Historial hist, int index) {
    h.Historial his = h.Historial(items: []);
    hist.items!.forEach((element) {
      if (element.idMascota == mascotas.items[index].id) {
        his.items!.add(element);
      }
    });
    return his;
  }

  void _historiaSeleccionada(BuildContext context, h.Item historia) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              content: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Tipo:'),
                SizedBox(
                  height: 15,
                ),
                Text(historia.tipo.toString()),
                SizedBox(
                  height: 15,
                ),
                Text('Fecha:'),
                SizedBox(
                  height: 15,
                ),
                _fecha(historia.fecha.toString()),
                SizedBox(
                  height: 15,
                ),
                historia.peso.toString() != '' ? Text('Peso:') : Text(''),
                historia.peso.toString() != ''
                    ? SizedBox(
                        height: 15,
                      )
                    : SizedBox(
                        height: 0,
                      ),
                historia.peso.toString() != ''
                    ? Text(historia.peso.toString())
                    : SizedBox(
                        height: 0,
                      ),
                historia.peso.toString() != ''
                    ? SizedBox(
                        height: 15,
                      )
                    : SizedBox(
                        height: 0,
                      ),
                Text('Revision:'),
                SizedBox(
                  height: 15,
                ),
                _fecha(historia.proximaFecha.toString()),
                SizedBox(
                  height: 15,
                ),
                historia.lugar.toString() != '' ? Text('Lugar:') : Text(''),
                historia.lugar.toString() != ''
                    ? SizedBox(
                        height: 15,
                      )
                    : SizedBox(
                        height: 0,
                      ),
                historia.lugar.toString() != ''
                    ? Text(historia.lugar.toString())
                    : SizedBox(
                        height: 0,
                      ),
                historia.lugar.toString() != ''
                    ? SizedBox(
                        height: 15,
                      )
                    : SizedBox(
                        height: 0,
                      ),
                Text('Medicacion:'),
                SizedBox(
                  height: 15,
                ),
                Text(historia.medicamento.toString()),
                SizedBox(
                  height: 15,
                ),
                Text('Observaciones:'),
                SizedBox(
                  height: 15,
                ),
                historia.observaciones.toString() != ''
                    ? Text(historia.observaciones.toString())
                    : Text('-'),
                SizedBox(
                  height: 15,
                ),
                ButtonBar(
                  children: [
                    RaisedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _eliminarHistoria(context, historia);
                      },
                      child: Text('Eliminar'),
                      color: Colors.red,
                    ),
                    RaisedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Aceptar'),
                    ),
                  ],
                )
              ],
            ),
          ));
        });
  }

  void _eliminarHistoria(BuildContext context, h.Item historia) async {
    h.Historial his = widget.argumentos.historial;
    his.items!.remove(historia);
    //cargando(context, 'Eliminando historia');
    String s = await actualizarHistorial(
        globals.usuario!.id.toString(), h.historialToJson(his));
    setState(() {
      //Navigator.pop(context);
    });
  }
}
