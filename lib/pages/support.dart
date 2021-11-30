import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:till/constants/themes.dart';
import 'package:till/globals.dart' as globals;

class Support extends StatefulWidget {
  @override
  _SupportState createState() => _SupportState();
}

class _SupportState extends State<Support> {
  TextEditingController _controller = TextEditingController();
  TextEditingController _controller2 = TextEditingController();
  int contador = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ayuda'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: ListView(
            //mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                '¿En que podemos ayudarte?',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20,),
              const Text(
                'Escriba su consulta y nuestros técnicos se pondran'
                    'en contacto con usted',
                style: TextStyle(
                  color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20,),
              TextField(
                controller: _controller,
                onChanged: (String value){
                  contador = value.length;
                  setState(() {

                  });
                },
                decoration: const InputDecoration(labelText: "consulta...",
                alignLabelWithHint: true),
                maxLines: 7,
                maxLength: 500,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Teléfono/Celular',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '(Codigo de área + número)',
                      style: TextStyle(
                          color:Colors.grey,
                          fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: TextField(
                  controller: _controller2,
                  onChanged: (String value){
                    contador = value.length;
                    setState(() {

                    });
                  },
                  decoration: const InputDecoration(labelText: "",
                      alignLabelWithHint: true),
                  maxLines: 1,
                ),
              ),
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.only(top: 100),
                child: RaisedButton(
                  onPressed: () {
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.all(0.0),
                  child: Ink(
                    width: 340,
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
                            'Enviar',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
