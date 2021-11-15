import 'package:flutter/material.dart';

class Colores {
  static final Color azulOscuro = Color(0xff02253d);
  static final Color violeta = Color(0xffb00097);
  static final Color rojo = Color(0xfff4074e);
  static final Color naranja = Color(0xffff6b28);
  static final Color amarillo = Color(0xfff9ae00);

  static List<Color> combinacion1 = [
    amarillo, rojo, violeta
  ];
}


final ThemeData Claro = ThemeData(
    primaryColor: Colores.azulOscuro,
    secondaryHeaderColor: Colores.rojo,
    fontFamily: 'Manrope',
    brightness: Brightness.light,
    //canvasColor: Colores.azulOscuro,
    primaryColorLight: Colores.azulOscuro,
    focusColor: Colores.azulOscuro,
    hoverColor: Colores.azulOscuro,
    hintColor: Colores.azulOscuro,
    cursorColor: Colores.azulOscuro,
    inputDecorationTheme: const InputDecorationTheme(
      focusColor: Color(0xff02253d),
      labelStyle: TextStyle(
        color: Color(0xff02253d),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(
          //color: Color(0xff02253d),
          width: 0.5,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(
          color: Color(0xff02253d),
          width: 2.0,
        ),
      ),
    ), colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colores.azulOscuro));
