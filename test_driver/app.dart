import "package:flutter_driver/driver_extension.dart";
import 'package:flutter/material.dart';
import 'package:mascotas/Login/LoginPage.dart';
import 'package:mascotas/RegisterUsers/RegisterPage.dart';
import 'package:mascotas/main.dart';
import 'package:mascotas/mascotas/MascotasDetalle.dart';
import 'package:mascotas/mascotas/MascotasPage.dart';
import 'package:mascotas/presentation/screens/home_screen.dart';

//Creación de una instancia de la app
void main(){
  enableFlutterDriverExtension(); // Habilita Flutter Driver
  runApp(MaterialApp(
    home: RegisterPage(),
  ));
}