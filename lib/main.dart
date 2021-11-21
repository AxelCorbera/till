import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:till/constants/themes.dart';
import 'package:till/globals.dart' as globals;
import 'package:till/pages/addcard.dart';
import 'package:till/pages/address.dart';
import 'package:till/pages/address_info.dart';
import 'package:till/pages/my_account.dart';
import 'package:till/pages/my_information.dart';
import 'package:till/pages/scan_products.dart';
import 'package:till/provider/google_sing_in.dart';
import 'package:till/pages/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:till/pages/register.dart';
import 'package:till/pages/scan_qr.dart';
import 'package:till/pages/cart.dart';
import 'package:till/scenes/cards.dart';
import 'package:till/pages/checkout.dart';
import 'package:till/pages/info_payment.dart';
import 'package:till/scripts/mercadopago/customerJson.dart';

import 'home.dart';

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
  create: (context) => GoogleSignInProvider(),
  child: MaterialApp(
      title: 'Till',
      initialRoute: '/Home',
      theme: Claro,
      // ThemeData(
      //   fontFamily: 'Raleway',
      //   brightness: Brightness.light,
      //   primarySwatch: Colors.blue,
      //   accentColor: Colors.white,
      //   visualDensity: VisualDensity.adaptivePlatformDensity,
      // ),
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(builder: (BuildContext context) {
          switch (settings.name) {
            case '/Login':
              return Login();
            case '/Home':
              return Home();
            case '/Register':
              return Register();
            case '/Scan_QR':
              return Scan_QR();
            case '/Scan_Products':
              return Scan_Products();
            case '/Cart':
              return Cart();
            case '/InfoPayment':
              return Info_Payment();
            case '/Address':
              return addAddress();
            case '/AddCard':
              final arg = settings.arguments as ArgumentsAddaCard;
              return AddCard(pago: arg.pago, total: arg.total);
            case '/My_Account':
              return My_Account();
            case '/My_Information':
              return My_Information();
            case '/Address_Info':
              return Address_Info();
            case "/Checkout":
              final args = settings.arguments as ArgumentosCheckout;
              return Checkout(
                  tarjeta: args.tarjeta,
                  total: args.total,
                  domicilio: args.domicilio,
                  cuota: args.cuotas);
            default:
              return Home();
          }
        });
      },
    ),
  );
}

