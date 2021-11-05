import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:till/globals.dart' as globals;

class Support extends StatefulWidget {
  @override
  _SupportState createState() => _SupportState();
}

class _SupportState extends State<Support> {
  TextEditingController _controller = TextEditingController();
  int contador = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ayuda'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Center(
              child: ListView(
                //mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(
                    '¿En que podemos ayudarte?',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20,),
                  Image.asset(
                    'lib/assets/icons/support.png',
                    height: 250,
                  ),
                  SizedBox(height: 20,),
                  Text(
                    'Escribe tu consulta a soporte',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20,),
                  TextField(
                    controller: _controller,
                    onChanged: (String value){
                      contador = value.length;
                      setState(() {

                      });
                    },
                    decoration: InputDecoration(labelText: "consulta"),
                    maxLines: 3,
                    maxLength: 500,
                  ),
                  SizedBox(height: 10,),
                  RaisedButton(
                    onPressed: () {},
                    color: Theme.of(context).primaryColor,
                    child: Text(
                      'Enviar consulta',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  )
                ],
              ),
            ),
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
