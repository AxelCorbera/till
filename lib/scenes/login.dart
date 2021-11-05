import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:till/provider/authentication_service.dart';
import 'package:till/scripts/request.dart' as request;
import 'package:till/scripts/album.dart' as album;
import 'package:till/scripts/request.dart' as request;
import 'package:till/globals.dart' as globals;
import 'package:till/scripts/request.dart';
import 'package:till/constants/themes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:till/provider/google_sing_in.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _loading = false;
  String userName = '';
  String password = '';
  String _errorMessage = "";
  GlobalKey<FormState> _keyForm = GlobalKey();
  GlobalKey<ScaffoldState> _keyScaf = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _keyScaf,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("lib/assets/images/fondoClaro.jpg",),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.white54, BlendMode.modulate)
          ),
        ),
        child: Form(
          key: _keyForm,
          child: Column(
            children: <Widget>[
              Column(
                children: [
                  SizedBox(height: 30,),
                  Image.asset(
                    'lib/assets/images/tillrojo.png',
                    height: 250,
                  ),
                  Center(
                      child: Text(
                        'Elegí, escaneá y pagá',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      )),
                ],
              ),
              SizedBox(height: 50,),
              Flexible(
                child: Container(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 35, vertical: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: "Usuario",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 1,
                                  style: BorderStyle.none,
                                ),
                              ),
                              //filled: true,
                              contentPadding: EdgeInsets.all(16),
                            ),
                            onSaved: (value) {
                              userName = value!;
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Este campo es obligatorio';
                              }
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            decoration:
                            InputDecoration(labelText: "Clave",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 1,
                                  style: BorderStyle.none,
                                ),
                              ),
                              //filled: true,
                              contentPadding: EdgeInsets.all(16),),
                            obscureText: true,
                            onSaved: (value) {
                              password = value!;
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Este campo es obligatorio';
                              }
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              FlatButton(onPressed: () {}, child: Text(
                                'Olvidé mi contraseña',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xfff4074e)
                                ),
                              ),),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          RaisedButton(
                            onPressed: () {
                              _login(context,true);
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            padding: const EdgeInsets.all(0.0),
                            child: Ink(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.bottomLeft,
                                    end: Alignment.topRight,
                                    colors:
                                    Colores.combinacion1
                                ),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(10.0)),
                              ),
                              child: Container(
                                constraints: const BoxConstraints(
                                    minWidth: 88.0, minHeight: 45.0),
                                // min sizes for Material buttons
                                alignment: Alignment.center,
                                child: Text(
                                  'Ingresar',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20
                                  ),
                                ),
                              ),
                            ),
                          ),
                          FlatButton(
                            textColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            onPressed: () {
                              _login(context, false);
                              _loading;
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text("Crear cuenta",
                                  style: TextStyle(
                                      color: Colores.rojo
                                  ),),
                                if (_loading)
                                  Container(
                                    height: 20,
                                    width: 20,
                                    margin: const EdgeInsets.only(left: 20),
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  )
                              ],
                            ),
                          ),
                          if (_errorMessage.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Text(
                                _errorMessage,
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          RaisedButton(
                            onPressed: () {
                              _loginGoogle();
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            padding: const EdgeInsets.all(0.0),
                            child: Ink(
                              decoration: BoxDecoration(
                                color: Colores.azulOscuro,
                                borderRadius: BorderRadius.all(
                                    Radius.circular(10.0)),
                              ),
                              child: Container(
                                constraints: const BoxConstraints(
                                    minWidth: 88.0, minHeight: 45.0),
                                // min sizes for Material buttons
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    FaIcon(FontAwesomeIcons.google,
                                      size: 30,
                                      color: Colores.rojo,),
                                    SizedBox(width: 10,),
                                    Text(
                                      'Iniciar sesión con Google',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future _loginGoogle() async{
    final provider = await Provider.of<
        GoogleSignInProvider>(context, listen: false);
    provider.googleLogin();

    if(provider.user.id.isNotEmpty){
      Navigator.of(context).pushNamed('/Home');

      globals.usuario!.nombre = provider.user.displayName;
    }

  }

  void _login(BuildContext context, bool autolog) async {
    if (!_loading) {
      if (autolog == true || _keyForm.currentState!.validate()) {
        if (autolog == false)
          _keyForm.currentState!.save();
        setState(() {
          _loading = true;
        });

        String log = await AuthenticationService(FirebaseAuth.instance)
            .signIn(email: userName, password: password);

        print(log);

        //     setState(() {
        //       if (token.id != '' && token.id != '-1') {
        //         _loading = false;
        //         _errorMessage = "";
        //         globals.login = true;
        //         _loginSave();
        //         Navigator.of(context).pushNamed('/Home');
        //       } else if (token.id == '' && token.id != '-1') {
        //         _loading = false;
        //         _errorMessage = "Usuario y/o clave incorrecto";
        //       } else if (token.id != '' && token.id == '-1') {
        //         _loading = false;
        //         _mostrarMensaje('Error de conexion');
        //       }
        //     });
        //   }
        // } else {
        //   setState(() {
        //     _loading = false;
        //     _errorMessage = "";
        //     print(userName + '>>' + password);
        //   });
      }
    }
  }

  void _mostrarMensaje(String msg) {
    SnackBar snackBar = SnackBar(
      content: Text(msg),
    );
    _keyScaf.currentState!.showSnackBar(snackBar);
  }

  // void initState() {
  //   super.initState();
  //   autoLogIn();
  //   }

  void autoLogIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('username');
    final String? pass = prefs.getString('password');

    if (userId != '' && userId != null) {
      userName = userId.toString();
      password = pass.toString();
      _login(context,true);
    }
  }

  Future<Null> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', '');
    prefs.setString('password', '');
  }

  void _loginSave() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', userName);
    prefs.setString('password', password);
  }
}
