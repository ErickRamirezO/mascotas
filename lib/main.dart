import 'package:flutter/material.dart';
import 'package:mascotas/Login/LoginPage.dart';
import 'package:mascotas/RegisterUsers/RegisterPage.dart';
import 'package:mascotas/mascotas/MascotasDetalle.dart';
import 'package:mascotas/mascotas/MascotasPage.dart';
import 'package:mascotas/mascotas/registrar_mascota.dart';
import 'package:mascotas/presentation/screens/home_screen.dart';
import 'package:mascotas/widgets/tab_bar.dart';
import 'package:mascotas/mascotas/Mascota.dart'; // Asegúrate de importar la clase Mascota

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Crear una instancia de Mascota para usarla como argumento
    final mascotas = Mascota(
      id: '1',
      nombreMas: 'Firulais',
      raza: 'Labrador',
      sexo: 'Macho',
      fechaNac: '2020-01-01',
      colorPelaje: 'Dorado',
      tipo: 'Perro',
      privacidad: 'Público',
      descripcion: 'Un perro muy amigable y juguetón.',
      user: 'Usuario123',
      imagen: null, // O especifica una URL válida si hay imagen
    );

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: LoginPage(), // Pasar la instancia como argumento
    );
  }
}
