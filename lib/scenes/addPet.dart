import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:till/scenes/components/imagePickerWidget.dart';
import 'package:till/scenes/items.dart';
import 'package:till/scenes/pets.dart';
import 'package:till/scripts/mercadopago/json/mascotas.dart';
import 'package:till/globals.dart' as globals;
import 'package:till/scripts/request.dart';
import 'package:image_picker/image_picker.dart';

class AddPet extends StatefulWidget {
  const AddPet({Key? key, required this.datos}) : super(key: key);
  final AgregarMascotas datos;
  _AddPetState createState() => _AddPetState();
}

class _AddPetState extends State<AddPet> {
  Mascotas mascotas = new Mascotas(items: []);
  String menu = 'home';
  bool busqueda = true;
  List<MemoryImage> fotos = [];
  int carrito = globals.carrito.id.length;
  bool datos = true;
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
  String alarmas = "";
  String observacion = "";
  String lugar = "";
  String telefono = "";
  String domicilio = "";
  String pelaje = "";
  String especie = "";

  @override
  Widget build(BuildContext context) {
    mascotas = widget.datos.mascotas;
    carrito = globals.carrito.id.length;
    return Scaffold(
      appBar: appbar('Agregar mascota'),
      body: ListView(
        children: [
          Column(children: <Widget>[
            Stack(children: _foto()),
            Column(children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8),
                child: Card(elevation: 2, child: _form()),
              )
            ]),
          ]),
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

  Widget _form() {
    return Form(
      key: _keyForm,
      child: Container(
        margin: EdgeInsets.all(15),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
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
                          _selectDate(context);
                        },
                        child: Text(
                          "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
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
                    _agregarMascota(context);
                  }
                },
                child: Text(
                  'Agregar',
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

  List<Widget> _foto() {
    return <Widget>[
      ImagePickerWidget(
        imageFile: imageFile,
        onImageSelected: (XFile file) {
          setState(() {
            imageFile = file;
          });
        },
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (selected != null && selected != selectedDate)
      setState(() {
        nacimiento = selected;
        selectedDate = selected;
      });
  }

  void _consultarMascotas() async {
    if (globals.usuario!.id.toString() != "") {
      if (busqueda)
        //fotoMascotas = await BuscarFotoMascotas(globals.usuario!.id.toString());
        mascotas = await BuscarMascotas(globals.usuario!.id.toString());
      busqueda = false;
      setState(() {});
    } else {}
  }

  String _imagen(XFile image) {
    File i = File(image.path);
    if(i!=File('')){
      return'';}
    else {
      List<int> imageBytes = i.readAsBytesSync();
      var bytes = base64.encode(imageBytes);
      return bytes;
    }
  }

  Future<void> _agregarMascota(BuildContext context) async {
    _keyForm.currentState!.save();
    print(mascotas.toJson().toString());
    int i = 0;

    for(int j = 0 ; j < mascotas.items.length ; j++){
      if(mascotas.items[j].id == i.toString()){
        i++;
      }
    }

    Item nueva = Item(
        id: i.toString(),
        foto: '',
        especie: especie,
        sexo: sexo,
        raza: raza,
        nombre: nombre,
        apellido: apellido,
        peso: peso,
        nacimiento: nacimiento.toString(),
        alarmas: alarmas,
        observacion: observacion,
        lugar: lugar,
        telefono: telefono,
        domicilio: domicilio,
        pelaje: pelaje);
    widget.datos.mascotas.items.add(nueva);
    mascotas = widget.datos.mascotas;
    cargando(context);
    print('mascotas a actualizad (id) : ' + globals.usuario!.id.toString() + ' / ' + widget.datos.mascotas.toJson().toString());
    String s  = await actualizarMascotas(globals.usuario!.id.toString(), mascotasToJson(widget.datos.mascotas));
    String s2='';
    print('>>> ' + _imagen(imageFile));
    if(_imagen(imageFile).length>0)
    s2  = await CargarFoto(globals.usuario!.id.toString(), i.toString(), nombre, _imagen(imageFile));
    print(s2 + ' ' + _imagen(imageFile));
    Navigator.of(context).pop();
    Navigator.of(context).pop();
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
                SizedBox(height: 20,),
                Text("Agrandando familia!"),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          );
        });
  }
}
