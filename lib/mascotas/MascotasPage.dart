import 'package:flutter/material.dart';
import 'package:mascotas/mascotas/registrar_mascota.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'Mascota.dart';
import 'MascotasDetalle.dart'; // Asegúrate de importar el archivo MascotasDetalle.dart

void main() {
  runApp(MaterialApp(
    home: MascotasPage(),
  ));
}

class MascotasPage extends StatefulWidget {
  @override
  _MascotasPageState createState() => _MascotasPageState();
}

class _MascotasPageState extends State<MascotasPage> {
  List<dynamic> mascotas = [];
  String username = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? '';
    });
    _fetchMascotas();
  }

  Future<void> _fetchMascotas() async {
    final response = await http.get(
        Uri.parse('https://back-mascotas.vercel.app/bmpr/mascotas/$username'));
    if (response.statusCode == 200) {
      setState(() {
        mascotas = json.decode(response.body);
      });
    } else {
      throw Exception('Error al cargar las mascotas');
    }
  }

  void _navigateToDetail(Mascota mascota) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MascotasDetalle(mascota: mascota),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.bottomRight,
            radius: 3.5,
            colors: [
              const Color.fromARGB(240, 22, 61, 96),
              const Color.fromARGB(255, 25, 23, 61),
              const Color.fromARGB(255, 25, 23, 61),
              const Color.fromARGB(255, 25, 23, 61),
              const Color.fromARGB(240, 25, 23, 61),
            ],
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 25,
            ),
            Expanded(
              child: ListView.builder(
                key: Key('petList'),
                padding: const EdgeInsets.all(8),
                itemCount: mascotas.length,
                itemBuilder: (BuildContext context, int index) {
                  final mascota = mascotas[index];
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Color.fromARGB(240, 22, 61, 96),
                        width: 2,
                      ),
                      color: const Color.fromARGB(61, 0, 0, 0),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Card(
                      color: Colors
                          .transparent, // Make the card background transparent to show the container color
                      elevation:
                          0, // Remove the card shadow to match the container's look
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        key: ValueKey('petList_item_$index'),
                        leading: Icon(Icons.pets, color: Colors.white),
                        title: Text(
                          key: ValueKey('pet_name_$index'),
                          mascota['nombre_mas'] ?? '',
                          style: TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          mascota['descripcion'] ?? '',
                          style: TextStyle(color: Colors.white70),
                        ),
                        trailing: mascota['imagen'] != null
                            ? Image.memory(
                                base64Decode(mascota['imagen']),
                                width: 50,
                                height: 50,
                              )
                            : Icon(Icons.image_not_supported,
                                color: Colors.grey),
                        onTap: () {
                          _navigateToDetail(Mascota.fromJson(mascota));
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              margin: EdgeInsets.all(16),
              child: ElevatedButton(
                key: Key('addButton'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegistrarMascota(),
                    ),
                  ).then((result) {
                    // Refresh data if a pet was added
                    if (result == true) {
                      _fetchMascotas();
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 22, 61, 96),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                ),
                child: Icon(Icons.add, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
