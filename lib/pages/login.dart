import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:till/provider/authentication_service.dart';
import 'package:till/scripts/db/json/tarjetas_firestore.dart';
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

  final firestoreInstance = FirebaseFirestore.instance;

  bool _loading = false;
  String userName = '';
  String password = '';
  String _errorMessage = "";
  GlobalKey<FormState> _keyForm = GlobalKey();
  GlobalKey<ScaffoldState> _keyScaf = GlobalKey();
  String _authStatus = 'Unknown';
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
                          RaisedButton(
                            onPressed: () {
                              _loading;
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
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Ingresar',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20
                                      ),
                                    ),
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
                            ),
                          ),
                          //if (_errorMessage.isNotEmpty)
                            // Padding(
                            //   padding: const EdgeInsets.all(18.0),
                            //   child: Text(
                            //     _errorMessage,
                            //     style: TextStyle(
                            //         color: Colores.rojo,
                            //         fontWeight: FontWeight.bold),
                            //     textAlign: TextAlign.center,
                            //   ),
                            // ),

                            //MENSAJE DE ERROR
                          SizedBox(
                            height: 10,
                          ),
                          FlatButton(
                            textColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            onPressed: () {
                              Navigator.of(context).pushNamed('/Register')
                              .then((context) => (){setState(() {
                              });});
                            },
                            child: Text("Crear cuenta",
                              style: TextStyle(
                                  color: Colores.rojo
                              ),),
                          ),
                          SizedBox(
                            height: 10,
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
                          SizedBox(
                            height: 10,
                          ),
                          FlatButton(
                            textColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            onPressed: () {
                              Navigator.of(context).pushNamed('/Home')
                                  .then((context) => (){setState(() {
                              });});
                            },
                            child: Text("Ingresar sin cuenta",
                              style: TextStyle(
                                  color: Colores.rojo
                              ),),
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

  Future<void> _loginGoogle() async{
    var provider = await Provider.of<
        GoogleSignInProvider>(context, listen: false);
    provider.googleLogin().then((value) => {
    loginGoogle2(provider.user)
    });
  }

  void loginGoogle2(GoogleSignInAccount user){
    print('inicio sesion google? id: ' + user.id);
    if(user.id.isNotEmpty) {
      firestoreInstance.collection("users").get().then((querySnapshot) {
        querySnapshot.docs.forEach((result) {
          print(result.get('uid') + '<google>' + user.id);
          if (result.get('uid') == user.id) {
            print('cargar info > ' + result.get('uid'));
            globals.usuario!.id = result.get('uid');
            globals.usuario!.correo = result.get('correo');
            globals.usuario!.nombre = result.get('nombre');
            globals.usuario!.documento = result.get('documento');
            globals.usuario!.telefono = result.get('telefono');
            globals.usuario!.persona = result.get('persona');
            globals.usuario!.cuil = result.get('cuil');
            globals.usuario!.razon_social = result.get('razon_social');
            globals.usuario!.token = result.get('token');
            globals.usuario!.id_customer_mp = result.get('id_customer_mp');
            globals.usuario!.id_card_mp = result.get('id_card_mp');
            globals.numeroTarjetas = tarjetasFirestoreFromJson(result.get('id_card_mp'));
            globals.usuario!.provincia = result.get('provincia');
            globals.usuario!.municipio = result.get('municipio');
            globals.usuario!.localidad = result.get('localidad');
            globals.usuario!.calle = result.get('calle');
            globals.usuario!.numero = result.get('numero');
            globals.usuario!.piso = result.get('piso');
            globals.usuario!.departamento = result.get('departamento');
            globals.usuario!.foto = user.photoUrl;
          }
        });
      })
          .then((value) => _loginSave())
          .then((value) => Navigator.of(context).pushNamed('/Home'));

      //Navigator.of(context).pushNamed('/Home');
      globals.login = true;
    }else{
      _mostrarMensaje('Error al iniciar sesion');
      globals.login = true;
    }
  }

  void _login(BuildContext context, bool autolog) async {
    if (!_loading) {
      if (_keyForm.currentState!.validate()) {
        _keyForm.currentState!.save();
        setState(() {
          _loading = true;
        });

        final _auth = FirebaseAuth.instance;
        String log = await AuthenticationService(_auth)
            .signIn(email: userName, password: password);


            setState(() {
              if (log
              == 'Signed in') {
                _loading = false;
                _errorMessage = "";
                globals.login = true;
                firestoreInstance.collection("users").get().then((querySnapshot) {
                  querySnapshot.docs.forEach((result) {
                    print(result.get('uid') + '<login>' + _auth.currentUser!.uid);
                    if (result.get('uid') == _auth.currentUser!.uid){
                      print('cargar info > ' + result.get('uid'));
                      globals.usuario!.id = result.get('uid');
                      globals.usuario!.correo = result.get('correo');
                      globals.usuario!.nombre = result.get('nombre');
                      globals.usuario!.documento = result.get('documento');
                      globals.usuario!.telefono = result.get('telefono');
                      globals.usuario!.persona = result.get('persona');
                      globals.usuario!.cuil = result.get('cuil');
                      globals.usuario!.razon_social = result.get('razon_social');
                      globals.usuario!.token = result.get('token');
                      globals.usuario!.id_customer_mp = result.get('id_customer_mp');
                      globals.usuario!.id_card_mp = result.get('id_card_mp');
                      globals.numeroTarjetas = tarjetasFirestoreFromJson(result.get('id_card_mp'));
                      globals.usuario!.provincia = result.get('provincia');
                      globals.usuario!.municipio = result.get('municipio');
                      globals.usuario!.localidad = result.get('localidad');
                      globals.usuario!.calle = result.get('calle');
                      globals.usuario!.numero = result.get('numero');
                      globals.usuario!.piso = result.get('piso');
                      globals.usuario!.departamento = result.get('departamento');
                      globals.usuario!.foto = result.get('foto');
                    }
                    });
                  })
                .then((value) => _loginSave())
                    .then((value) => Navigator.of(context).pushNamed('/Home'));

                //_loginSave();

                //Navigator.of(context).pushNamed('/Home');
              } else if (log.contains('There is no user record corresponding')) {
                _loading = false;
                _errorMessage = "Usuario incorrecto";
                _mostrarMensaje('Usuario incorrecto');
              } else if (log.contains('The password is invalid')) {
                _loading = false;
                _errorMessage = "Clave incorrecta";
                _mostrarMensaje('Clave incorrecta');
              } else if (log.contains('Try again later')) {
                _loading = false;
                _errorMessage = "Has realizado muchos intentos. Intenta mas tarde";
                _mostrarMensaje('Has realizado muchos intentos. Intenta mas tarde');
              } else{
                _loading = false;
                _errorMessage = "Error de conexion";
                _mostrarMensaje(log);
              }


              //There is no user record corresponding to this identifier. The user may have been deleted.
              //The password is invalid or the user does not have a password

            });
          }
        } else {
          setState(() {
            _loading = false;
            _errorMessage = "";
          });

    }
  }

  void _cargarInformacion(QuerySnapshot result, int i){
    globals.usuario!.id = result.docs[i].get('uid');
    globals.usuario!.correo = result.docs[i].get('correo');
    globals.usuario!.nombre = result.docs[i].get('nombre');
    globals.usuario!.documento = result.docs[i].get('documento');
    globals.usuario!.telefono = result.docs[i].get('telefono');
    globals.usuario!.persona = result.docs[i].get('persona');
    globals.usuario!.cuil = result.docs[i].get('cuit/cuil');
    globals.usuario!.razon_social = result.docs[i].get('razon_social');
    globals.usuario!.token = result.docs[i].get('token');
    globals.usuario!.id_customer_mp = result.docs[i].get('id_customer_mp');
    globals.usuario!.id_card_mp = result.docs[i].get('id_card_mp');
    globals.usuario!.provincia = result.docs[i].get('provincia');
    globals.usuario!.municipio = result.docs[i].get('municipio');
    globals.usuario!.localidad = result.docs[i].get('localidad');
    globals.usuario!.calle = result.docs[i].get('calle');
    globals.usuario!.numero = result.docs[i].get('numero');
    globals.usuario!.piso = result.docs[i].get('piso');
    globals.usuario!.departamento = result.docs[i].get('departamento');
    globals.usuario!.foto = result.docs[i].get('foto');
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
    prefs.setString('gId', globals.usuario!.id.toString());
    prefs.setString('gCorreo', globals.usuario!.correo.toString());
    prefs.setString('gNombre', globals.usuario!.nombre.toString());
    prefs.setString('gDocumento', globals.usuario!.documento.toString());
    prefs.setString('gTelefono', globals.usuario!.telefono.toString());
    prefs.setString('gPersona', globals.usuario!.persona.toString());
    prefs.setString('gCuil', globals.usuario!.cuil.toString());
    prefs.setString('gRazonSocial', globals.usuario!.razon_social.toString());
    prefs.setString('gToken', globals.usuario!.token.toString());
    prefs.setString('gIdCustomerMp', globals.usuario!.id_customer_mp.toString());
    prefs.setString('gIdCardMp', globals.usuario!.id_card_mp.toString());
    prefs.setString('gProvincia', globals.usuario!.provincia.toString());
    prefs.setString('gMunicipio', globals.usuario!.municipio.toString());
    prefs.setString('gLocalidad', globals.usuario!.localidad.toString());
    prefs.setString('gCalle', globals.usuario!.calle.toString());
    prefs.setString('gNumero', globals.usuario!.numero.toString());
    prefs.setString('gPiso', globals.usuario!.piso.toString());
    prefs.setString('gDepartamento', globals.usuario!.departamento.toString());
    prefs.setString('gFoto', globals.usuario!.foto.toString());
    prefs.setBool('login', true);
  }

  Future<void> initPlugin() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      final TrackingStatus status =
      await AppTrackingTransparency.trackingAuthorizationStatus;
      setState(() => _authStatus = '$status');
      // If the system can show an authorization request dialog
      if (status == TrackingStatus.notDetermined) {
        // Show a custom explainer dialog before the system dialog
        if (await showCustomTrackingDialog(context)) {
          // Wait for dialog popping animation
          await Future.delayed(const Duration(milliseconds: 200));
          // Request system's tracking authorization dialog
          final TrackingStatus status =
          await AppTrackingTransparency.requestTrackingAuthorization();
          setState(() => _authStatus = '$status');
        }
      }
    } on PlatformException {
      setState(() => _authStatus = 'PlatformException was thrown');
    }

    final uuid = await AppTrackingTransparency.getAdvertisingIdentifier();
    print("UUID: $uuid");
  }

  Future<bool> showCustomTrackingDialog(BuildContext context) async =>
      await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Dear User'),
          content: const Text(
            'We care about your privacy and data security. We keep this app free by showing ads. '
                'Can we continue to use your data to tailor ads for you?\n\nYou can change your choice anytime in the app settings. '
                'Our partners will collect data and use a unique identifier on your device to show you ads.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("I'll decide later"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Allow tracking'),
            ),
          ],
        ),
      ) ??
          false;

}
