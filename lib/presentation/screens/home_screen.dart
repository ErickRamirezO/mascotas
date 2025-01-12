import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'dart:math';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<StaggeredGridTile> items = [];

  @override
  void initState() {
    super.initState();
    fetchData(); // Llama al método para obtener las URLs e información al iniciar la pantalla
  }

  Future<void> fetchData() async {
    final responseImages = await http.get(Uri.parse('https://back-mascotas.vercel.app/bmpr/img')); // Reemplaza con la URL de tu API de imágenes
    final responsePets = await http.get(Uri.parse('https://back-mascotas.vercel.app/bmpr/mascotas')); // Reemplaza con la URL de tu API de mascotas
    
    if (responseImages.statusCode == 200 && responsePets.statusCode == 200) {
      List<dynamic> imagesData = jsonDecode(responseImages.body);
      List<dynamic> petsData = jsonDecode(responsePets.body);

      setState(() {
        items = List.generate(imagesData.length, (index) {
          var image = imagesData[index];
          if (image['privacidad'] != 'Público') {
            return null; // Ignora imágenes que no son públicas
          }

          var pet = petsData.firstWhere((pet) => pet['nombre_mas'] == image['mascota'] && pet['privacidad'] == 'Público', orElse: () => null);

          if (pet == null) {
            return null; // Ignora imágenes que no tienen información de mascota pública correspondiente
          }

          String nombre = pet['nombre_mas'];
          DateTime fechaNac = DateTime.parse(pet['fecha_nac']);
          DateTime now = DateTime.now();
          int years = now.year - fechaNac.year;
          int months = now.month - fechaNac.month;
          int days = now.day - fechaNac.day;

          if (days < 0) {
            months -= 1;
            days += DateTime(now.year, now.month, 0).day;
          }
          if (months < 0) {
            years -= 1;
            months += 12;
          }

          String age;
          if (years > 0) {
            age = '$years años, $months meses, $days días';
          } else if (months > 0) {
            age = '$months meses, $days días';
          } else {
            age = '$days días';
          }

          int crossAxisCellCount = 2; // Valores entre 1 y 3
          int mainAxisCellCount = Random().nextInt(3) + 1; // Valores entre 1 y 3

          return StaggeredGridTile.count(
            crossAxisCellCount: crossAxisCellCount,
            mainAxisCellCount: mainAxisCellCount,
            child: ImageWidget(
              index: index,
              imageBase64: image['imagen'],
              nombre: nombre,
              age: age,
            ),
          );
        }).whereType<StaggeredGridTile>().toList(); // Filtra los elementos nulos
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  void actualizarHome() {
    fetchData(); // Llama al método para actualizar los datos
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 25, 23, 61),
        body: Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.bottomRight,
              radius: 3.5,
              colors: [
                Color.fromARGB(240, 22, 61, 96),
                Color.fromARGB(255, 25, 23, 61),
                Color.fromARGB(255, 25, 23, 61),
                Color.fromARGB(255, 25, 23, 61),
                Color.fromARGB(240, 25, 23, 61),
              ],
            ),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: [
                    SingleChildScrollView(
                      child: StaggeredGrid.count(
                        crossAxisCount: 4,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        children: items.isNotEmpty ? items : [],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          key: const Key('refresh_button'),
          onPressed: actualizarHome,
          child: const Icon(Icons.refresh),
          tooltip: 'Refresh',
        ),
      ),
    );
  }
}

class ImageWidget extends StatelessWidget {
  final int index;
  final String imageBase64;
  final String nombre;
  final String age;

  const ImageWidget({
    Key? key,
    required this.index,
    required this.imageBase64,
    required this.nombre,
    required this.age,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Uint8List imageBytes = base64Decode(imageBase64);

    return Column(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.memory(
              imageBytes,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8.0),
          color: Colors.black54,
          child: Text(
            '$nombre, $age',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}