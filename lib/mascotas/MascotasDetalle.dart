import 'package:flutter/material.dart';
import 'Mascota.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MascotasDetalle extends StatefulWidget {
  final Mascota mascota;

  MascotasDetalle({required this.mascota});

  @override
  _MascotasDetalleState createState() => _MascotasDetalleState();
}

class _MascotasDetalleState extends State<MascotasDetalle> {
  List<String> vacunasSeleccionadas = [];
  bool desparasitado = false;

  @override
  void initState() {
    super.initState();
    _loadInformacion();
  }

  Future<void> _loadInformacion() async {
    try {
      // Reemplaza con la URL de tu API para obtener la información de la mascota y las vacunas
      final response = await http.get(Uri.parse(
          'https://back-mascotas.vercel.app/bmpr/vacunas/${widget.mascota.nombreMas}'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          // Actualizar los datos de vacunas y desparasitante
          vacunasSeleccionadas =
              List<String>.from(data['vacunas'].map((v) => v['vacuna'] ?? ''));
          desparasitado = data['desparasitado'] ?? false;
        });
      } else {
        throw Exception('Error al cargar la información de la mascota');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _updateInformacion() async {
    try {
      // Reemplaza con la URL de tu API para actualizar la información de la mascota
      final response = await http.post(
        Uri.parse('https://back-mascotas.vercel.app/bmpr/vacunas/agregar'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'mascota': widget.mascota.nombreMas,
          'vacunas': vacunasSeleccionadas
              .map((vacuna) => {
                    'vacuna': vacuna,
                  })
              .toList(),
          'desparasitado': desparasitado,
        }),
      );

      if (response.statusCode == 200) {
        _loadInformacion(); // Recargar la información actualizada
      } else {
        throw Exception('Error al actualizar la información de la mascota');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _showModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Agregar Información'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Selecciona las vacunas:'),
                  CheckboxListTile(
                    title: Text('Parvovirus'),
                    value: vacunasSeleccionadas.contains('Parvovirus'),
                    onChanged: (bool? checked) {
                      setState(() {
                        if (checked == true) {
                          vacunasSeleccionadas.add('Parvovirus');
                        } else {
                          vacunasSeleccionadas.remove('Parvovirus');
                        }
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: Text('Moquillo'),
                    value: vacunasSeleccionadas.contains('Moquillo'),
                    onChanged: (bool? checked) {
                      setState(() {
                        if (checked == true) {
                          vacunasSeleccionadas.add('Moquillo');
                        } else {
                          vacunasSeleccionadas.remove('Moquillo');
                        }
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: Text('Rabia'),
                    value: vacunasSeleccionadas.contains('Rabia'),
                    onChanged: (bool? checked) {
                      setState(() {
                        if (checked == true) {
                          vacunasSeleccionadas.add('Rabia');
                        } else {
                          vacunasSeleccionadas.remove('Rabia');
                        }
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: Text('Hepatitis Canina'),
                    value: vacunasSeleccionadas.contains('Hepatitis Canina'),
                    onChanged: (bool? checked) {
                      setState(() {
                        if (checked == true) {
                          vacunasSeleccionadas.add('Hepatitis Canina');
                        } else {
                          vacunasSeleccionadas.remove('Hepatitis Canina');
                        }
                      });
                    },
                  ),
                  SwitchListTile(
                    title: Text('¿Está desparasitada?'),
                    value: desparasitado,
                    onChanged: (bool value) {
                      setState(() {
                        desparasitado = value;
                      });
                    },
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el modal
              },
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                await _updateInformacion(); // Guardar los cambios
                Navigator.of(context).pop(); // Cerrar el modal
              },
              child: Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: Color.fromARGB(240, 22, 61, 96),
            width: 2,
          ),
          color: const Color.fromARGB(61, 0, 0, 0),
        ),
        width: 400, // Ajusta el ancho según tus necesidades
        child: TextField(
          controller: TextEditingController(text: value),
          decoration: InputDecoration(
            hintText:
                'Enter $label', // O puedes usar 'Enter value' para un hint genérico
            hintStyle: TextStyle(color: Colors.white54),
            border: InputBorder.none,
            labelText: label,
            labelStyle: TextStyle(color: Colors.white),
            contentPadding: EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0), // Ajusta el padding según tus necesidades
            errorStyle: TextStyle(color: Colors.redAccent),
            suffixIcon:
                null, // Agrega lógica para el icono del sufijo si es necesario
          ),
          style: TextStyle(color: Colors.white),
          enabled: false, // Cambia a true si quieres permitir la edición
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.mascota.nombreMas),
        backgroundColor: Color.fromARGB(255, 22, 61, 96),
      ),
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
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      margin: const EdgeInsets.only(top: 50.0),
                      child: CustomPaint(
                        painter: ContainerPainter(),
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(20, 70, 20, 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  color: Color(0xFF19173d),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildInfoField(
                                        'Nombre', widget.mascota.nombreMas),
                                    _buildInfoField(
                                        'Raza', widget.mascota.raza),
                                    _buildInfoField(
                                        'Sexo', widget.mascota.sexo),
                                    _buildInfoField('Fecha de nacimiento',
                                        widget.mascota.fechaNac),
                                    _buildInfoField('Color de pelaje',
                                        widget.mascota.colorPelaje),
                                    _buildInfoField(
                                        'Tipo', widget.mascota.tipo),
                                    _buildInfoField('Privacidad',
                                        widget.mascota.privacidad),
                                    _buildInfoField('Descripción',
                                        widget.mascota.descripcion),
                                    _buildInfoField('Vacunas',
                                        vacunasSeleccionadas.join(', ')),
                                    _buildInfoField('Desparasitada',
                                        desparasitado ? 'Sí' : 'No'),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                              Center(
                                child: ElevatedButton(
                                  onPressed: _showModal,
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 8), // Reduce el padding
                                    backgroundColor: Color.fromARGB(
                                        60, 23, 68, 165), // Color de fondo
                                    shadowColor: const Color.fromARGB(
                                        61, 0, 0, 0), // Color de la sombra
                                    elevation: 3, // Tamaño de la sombra
                                    side: BorderSide(
                                      color: Color.fromARGB(
                                          239, 40, 125, 199), // Color del borde
                                      width: 1, // Ancho del borde
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          12), // Bordes redondeados
                                    ),
                                  ),
                                  child: Text(
                                    'Agregar más información',
                                    style: TextStyle(
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      fontSize:
                                          14, // Tamaño de la fuente más pequeño
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: MediaQuery.of(context).size.width / 2 - 50,
                      top: 0,
                      child: CircleAvatar(
                        radius: 50.0,
                        backgroundColor: Colors.transparent,
                        backgroundImage: widget.mascota.imagen != null
                            ? MemoryImage(base64Decode(widget.mascota.imagen!))
                            : AssetImage('assets/default_dog.png')
                                as ImageProvider,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ContainerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color.fromARGB(61, 0, 0, 0)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 20)
      ..arcToPoint(Offset(20, 0), radius: Radius.circular(20), clockwise: false)
      ..lineTo(size.width - 20, 0)
      ..arcToPoint(Offset(size.width, 20),
          radius: Radius.circular(20), clockwise: false)
      ..lineTo(size.width, size.height - 20)
      ..arcToPoint(Offset(size.width - 20, size.height),
          radius: Radius.circular(20), clockwise: true)
      ..lineTo(20, size.height)
      ..arcToPoint(Offset(0, size.height - 20),
          radius: Radius.circular(20), clockwise: true)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
