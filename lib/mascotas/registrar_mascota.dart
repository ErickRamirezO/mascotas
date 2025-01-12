import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mascotas/widgets/Background.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' as io;
import 'package:image/image.dart' as img;
import 'dart:typed_data';
import '../Validations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RegistrarMascota extends StatefulWidget {
  const RegistrarMascota({super.key});

  @override
  State<RegistrarMascota> createState() => _RegistrarMascotaState();
}

class _RegistrarMascotaState extends State<RegistrarMascota> {
  final _formKey = GlobalKey<FormState>();
  final Validations _validations = Validations();
  final TextEditingController _nombre_mas = TextEditingController();
  final TextEditingController _raza = TextEditingController();
  final TextEditingController _sexo = TextEditingController();
  final TextEditingController _fecha_nac = TextEditingController();
  final TextEditingController _color = TextEditingController();
  final TextEditingController _tipo = TextEditingController();
  final TextEditingController _privacidad = TextEditingController();
  final TextEditingController _descripcion = TextEditingController();
  final TextEditingController _image1 = TextEditingController();
  final TextEditingController _image2 = TextEditingController();
  final TextEditingController _image3 = TextEditingController();
  String? _imageBase64;
  String privacidad = 'Privado';
  String sexoSeleccionado = 'Macho'; // Default value
  int contador = 0;
  bool insertar = false;
  io.File? _image; // Variable para almacenar la imagen seleccionada
  List<io.File?> images = List.filled(3, null);
  List<String?> imagePaths = List.filled(3, null);
  List<String?> imageBase = List.filled(3, null);
  String? imagePath; // Ruta de la imagen seleccionada

  //manejo de errores
  String? _nameMascotaError;
  String? _razaError;
  String? _colorPelajeError;
  String? _tipoMascotaError;
  String? _descriptionError;

  final ImagePicker _picker = ImagePicker();

  Future<String?> _getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  Future<void> postImage(String image, String nombre, String privacidad) async {
    try {
      final response = await http.post(
        Uri.parse('https://back-mascotas.vercel.app/bmpr/img/crear'),
        body: json.encode(
            {'mascota': nombre, 'privacidad': privacidad, 'imagen': image}),
        headers: {'Content-Type': 'application/json'},
      );
      print("---------------------------------------------");
      print("Response body: ${response.body}");
      if (response.statusCode == 200) {
        setState(() {
          insertar = true;
        });
      }
    } catch (e) {
      print("Error posting image: $e");
    }
  }

  Future<void> postMascota(
      String nombre,
      String raza,
      String sexo,
      String fecha_nac,
      String color,
      String tipo,
      String privacidad,
      String descripcion,
      String username) async {
    try {
      final response = await http.post(
        Uri.parse('https://back-mascotas.vercel.app/bmpr/mascotas/crear'),
        body: json.encode({
          'nombre_mas': nombre,
          'raza': raza,
          'sexo': sexo,
          'fecha_nac': fecha_nac,
          'color_pelaje': color,
          'tipo': tipo,
          'privacidad': privacidad,
          'descripcion': descripcion,
          'user': username
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        setState(() {
          insertar = true;
        });
        _nombre_mas.clear();
        _raza.clear();
        _sexo.clear();
        _fecha_nac.clear();
        _color.clear();
        _tipo.clear();
        _privacidad.clear();
        _descripcion.clear();
        // Actualizar la lista de usuarios después de la inserción
      }
    } catch (error) {
      print('Error : $error');
      // Manejar errores según sea necesario
    }
  }

  //__________________________________________________________________________________________________________________-
  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _fecha_nac.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  // Método para abrir la cámara y seleccionar una imagen
  Future<void> _openCamera(int i) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        images[contador] =
            io.File(pickedFile.path); // Guardar la imagen seleccionada
        imagePaths[contador] = pickedFile.path;
        contador++; // Guardar la ruta de la imagen
      });

      _saveImagePath(pickedFile.path);
      // Guarda la ruta en SharedPreferences
    }
  }

  // Método para abrir la galería y seleccionar una imagen
  Future<void> _openGallery(int i) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        print(
            "-----------------------------------------------------------------------------------------------------------------------------\N----------------------------${contador}----------------------------------------------------");

        images[contador] =
            io.File(pickedFile.path); // Guardar la imagen seleccionada
        imagePaths[contador] = pickedFile.path;
        contador++; // Guardar la ruta de la imagen
      });

      _saveImagePath(pickedFile.path);
      // Guarda la ruta en SharedPreferences
    }
  }

  // Método para guardar la ruta de la imagen en SharedPreferences
  Future<void> _saveImagePath(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('imagePath', path);
  }

  // Método para cargar la imagen guardada desde SharedPreferences
  Future<void> _loadImage(int i) async {
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString('imagePath');
    // Validación si existe una imagen guardada

    if (path != null) {
      setState(() {
        images[i] = io.File(path); // Guardar la imagen seleccionada
        imagePaths[i] = path; // Guardar la ruta de la imagen
        //imagePath = path; // Asigna la ruta de la imagen
        //_image = io.File(path); // Carga la imagen en _image (solo para web)
      });
    }
  }

  //--------------------------------------------------------------------------------------------------------------------
  //TRANSFORMAR LA IMAGEN A BASE64
  Future<void> _convertImageToBase64() async {
    for (int i = 0; i < images.length; i++) {
      if (images[i] != null) {
        List<int> imageBytes = await images[i]!.readAsBytes();
        Uint8List uint8ImageBytes = Uint8List.fromList(imageBytes);
        img.Image? image = img.decodeImage(uint8ImageBytes);

        if (image != null) {
          // Redimensiona la imagen
          img.Image resizedImage = img.copyResize(image, width: 600);

          // Codifica la imagen a JPG y reduce la calidad
          List<int> compressedImageBytes =
              img.encodeJpg(resizedImage, quality: 50);

          // Convierte a base64
          String imageBase64 = base64Encode(compressedImageBytes);
          imageBase[i] = imageBase64;

          // Imprime solo los primeros 100 caracteres para debug
          print(imageBase64.substring(0, 100));

          // Agrega un retraso para evitar problemas de rendimiento
          await Future.delayed(Duration(seconds: 2));
        }
      }
    }
  }

  /////////////carga
  Future<void> _showLoadingDialog(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible:
          false, // No permite que el diálogo se cierre tocando fuera de él
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(240, 22, 61, 96),
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text("Cargando...", style: TextStyle(color: Colors.white)),
            ],
          ),
        );
      },
    );
  }

  Future<void> _hideLoadingDialog(BuildContext context) async {
    Navigator.of(context).pop();
  }

  void _showAlertDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(240, 22, 61, 96),
          title: Text(
            title,
            style: TextStyle(color: Colors.white),
          ),
          content: Text(message, style: TextStyle(color: Colors.white)),
          actions: <Widget>[
            TextButton(
              child: Text('Ok', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Mascotas'),
          backgroundColor: Color.fromARGB(255, 22, 61, 96),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Stack(
          children: [
            Background(),
            SingleChildScrollView(
              child: Container(
                child: Column(children: [
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Container(
                        child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(height: 300),
                        if (images[0] == null &&
                            images[1] == null &&
                            images[2] == null)
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(
                                color: Colors.black,
                                width: 2,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FaIcon(
                                  FontAwesomeIcons
                                      .dog, // Aquí usa el ícono que desees
                                  color: Colors.black,
                                  size:
                                      40, // Ajusta el tamaño del ícono según sea necesario
                                ),
                                SizedBox(
                                    height:
                                        8), // Espacio entre el ícono y el texto
                                Text(
                                  'Ingresar\nImagen',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize:
                                        10, // Ajusta el tamaño del texto según sea necesario
                                  ),
                                  textAlign:
                                      TextAlign.center, // Centra el texto
                                ),
                              ],
                            ),
                          ),
                        if (images[0] != null)
                          Container(
                            margin: EdgeInsets.only(top: 1),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                  color: Color.fromARGB(240, 22, 61, 96),
                                  width: 2),
                              color: Color.fromARGB(26, 23, 104, 170),
                              image: DecorationImage(
                                image: FileImage(images[0]!),
                                fit: BoxFit.cover,
                              ),
                            ),
                            width: 300,
                            height: 250,
                          ),
                        if (images[1] != null)
                          Container(
                            margin: EdgeInsets.only(top: 70),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                  color: Color.fromARGB(240, 22, 61, 96),
                                  width: 2),
                              color: Color.fromARGB(26, 23, 104, 170),
                              image: DecorationImage(
                                image: FileImage(images[1]!),
                                fit: BoxFit.cover,
                              ),
                            ),
                            width: 350,
                            height: 250,
                          ),
                        if (images[2] != null)
                          Container(
                              width: 400,
                              height: 250,
                              margin: EdgeInsets.only(top: 130),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                    color: Color.fromARGB(240, 22, 61, 96),
                                    width: 2),
                                color: Color.fromARGB(26, 23, 104, 170),
                                image: DecorationImage(
                                  image: FileImage(images[2]!),
                                  fit: BoxFit.cover,
                                ),
                              )),
                      ],
                    )),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _openCamera(contador -
                                3); // Abre la cámara para el contenedor 0
                          },
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 30),
                        GestureDetector(
                          onTap: () {
                            _openGallery(contador -
                                3); // Abre la galería para el contenedor 2
                          },
                          child: Icon(
                            Icons.image,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Center(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                    color: Color.fromARGB(240, 22, 61, 96),
                                    width: 2),
                                color: const Color.fromARGB(61, 0, 0, 0),
                              ),
                              width: 400,
                              child: TextFormField(
                                controller: _nombre_mas,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'ingresa el nombre de tu mascota',
                                  hintStyle: TextStyle(color: Colors.white54),
                                  labelText: 'Nombre Mascota',
                                  labelStyle: TextStyle(color: Colors.white),
                                  prefixIcon: Icon(
                                    Icons.pets,
                                    color: Colors.white,
                                  ),
                                  errorStyle:
                                      TextStyle(color: Colors.redAccent),
                                  // Color del texto de error
                                  errorText: _nameMascotaError,
                                  suffixIcon: _nameMascotaError != null
                                      ? Icon(Icons.error,
                                          color: Colors.redAccent)
                                      : null,
                                ),
                                style: TextStyle(color: Colors.white),
                                onChanged: (value) {
                                  setState(() {
                                    _nameMascotaError =
                                        _validations.validateNamePet(value);
                                  });
                                },
                                validator: (value) =>
                                    _validations.validateNamePet(value),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                    color: Color.fromARGB(240, 22, 61, 96),
                                    width: 2),
                                color: const Color.fromARGB(61, 0, 0, 0),
                              ),
                              width: 400,
                              child: TextFormField(
                                controller: _raza,
                                decoration: InputDecoration(
                                  hintText: 'ingresa la raza de tu mascota',
                                  hintStyle: TextStyle(color: Colors.white54),
                                  border: InputBorder.none,
                                  labelText: 'Raza',
                                  labelStyle: TextStyle(color: Colors.white),
                                  prefixIcon: Icon(
                                    Icons.pets,
                                    color: Colors.white,
                                  ),
                                  errorStyle:
                                      TextStyle(color: Colors.redAccent),
                                  // Color del texto de error
                                  errorText: _razaError,
                                  suffixIcon: _razaError != null
                                      ? Icon(Icons.error,
                                          color: Colors.redAccent)
                                      : null,
                                ),
                                style: TextStyle(color: Colors.white),
                                onChanged: (value) {
                                  setState(() {
                                    _razaError =
                                        _validations.validateOnlyLetters(value);
                                  });
                                },
                                validator: (value) =>
                                    _validations.validateOnlyLetters(value),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                    color: Color.fromARGB(240, 22, 61, 96),
                                    width: 2),
                                color: const Color.fromARGB(61, 0, 0, 0),
                              ),
                              width: 400,
                              child: DropdownButtonFormField<String>(
                                value: sexoSeleccionado,
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    setState(() {
                                      sexoSeleccionado = newValue;
                                    });
                                  }
                                },
                                items: <String>[
                                  'Macho',
                                  'Hembra'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  );
                                }).toList(),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: 'Sexo',
                                  labelStyle: TextStyle(color: Colors.white),
                                  prefixIcon: Icon(
                                    Icons.person,
                                    color: Colors.white,
                                  ),
                                ),
                                style: TextStyle(color: Colors.white),
                                dropdownColor: Colors
                                    .black, // Fondo negro para las opciones
                              ),
                            ),
                            // Container(
                            //   decoration: BoxDecoration(
                            //     borderRadius: BorderRadius.circular(30),
                            //     border: Border.all(
                            //         color: Color.fromARGB(240, 22, 61, 96),
                            //         width: 2),
                            //     color: const Color.fromARGB(61, 0, 0, 0),
                            //   ),
                            //   width: 400,
                            //   child: TextFormField(
                            //     controller: _sexo,
                            //     decoration: InputDecoration(
                            //       border: InputBorder.none,
                            //       labelText: 'Sexo',
                            //       labelStyle: TextStyle(color: Colors.white),
                            //       prefixIcon: Icon(
                            //         Icons.person,
                            //         color: Colors.white,
                            //       ),
                            //     ),
                            //     style: TextStyle(color: Colors.white),
                            //     keyboardType: TextInputType.name,
                            //   ),
                            // ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: Color.fromARGB(240, 22, 61, 96),
                                  width: 2,
                                ),
                                color: const Color.fromARGB(61, 0, 0, 0),
                              ),
                              width: 400,
                              child: TextFormField(
                                controller: _fecha_nac,
                                readOnly: true,
                                onTap: () => _selectDate(context),
                                decoration: InputDecoration(
                                  labelText: 'Fecha de nacimiento',
                                  border: InputBorder.none,
                                  labelStyle: TextStyle(color: Colors.white),
                                  prefixIcon: Icon(
                                    Icons.calendar_today,
                                    color: Colors.white,
                                  ),
                                ),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),

                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                    color: Color.fromARGB(240, 22, 61, 96),
                                    width: 2),
                                color: const Color.fromARGB(61, 0, 0, 0),
                              ),
                              width: 400,
                              child: TextFormField(
                                controller: _color,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: 'Color del pelaje',
                                  labelStyle: TextStyle(color: Colors.white),
                                  prefixIcon: Icon(
                                    Icons.color_lens_rounded,
                                    color: Colors.white,
                                  ),
                                  errorStyle:
                                      TextStyle(color: Colors.redAccent),
                                  // Color del texto de error
                                  errorText: _colorPelajeError,
                                  suffixIcon: _colorPelajeError != null
                                      ? Icon(Icons.error,
                                          color: Colors.redAccent)
                                      : null,
                                ),
                                style: TextStyle(color: Colors.white),
                                onChanged: (value) {
                                  setState(() {
                                    _colorPelajeError =
                                        _validations.validateOnlyLetters(value);
                                  });
                                },
                                validator: (value) =>
                                    _validations.validateOnlyLetters(value),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                    color: Color.fromARGB(240, 22, 61, 96),
                                    width: 2),
                                color: const Color.fromARGB(61, 0, 0, 0),
                              ),
                              width: 400,
                              child: TextFormField(
                                controller: _tipo,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: 'Tipo de mascota',
                                  labelStyle: TextStyle(color: Colors.white),
                                  prefixIcon: Icon(
                                    Icons.pets,
                                    color: Colors.white,
                                  ),
                                  errorStyle:
                                      TextStyle(color: Colors.redAccent),
                                  // Color del texto de error
                                  errorText: _tipoMascotaError,
                                  suffixIcon: _tipoMascotaError != null
                                      ? Icon(Icons.error,
                                          color: Colors.redAccent)
                                      : null,
                                ),
                                style: TextStyle(color: Colors.white),
                                onChanged: (value) {
                                  setState(() {
                                    _tipoMascotaError =
                                        _validations.validateOnlyLetters(value);
                                  });
                                },
                                validator: (value) =>
                                    _validations.validateOnlyLetters(value),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                    color: Color.fromARGB(240, 22, 61, 96),
                                    width: 2),
                                color: const Color.fromARGB(61, 0, 0, 0),
                              ),
                              width: 400,
                              child: DropdownButtonFormField<String>(
                                value: privacidad,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    privacidad = newValue!;
                                  });
                                },
                                items: <String>[
                                  'Privado',
                                  'Público'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  );
                                }).toList(),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: 'Privacidad',
                                  labelStyle: TextStyle(color: Colors.white),
                                  prefixIcon: Icon(
                                    Icons.person,
                                    color: Colors.white,
                                  ),
                                ),
                                style: TextStyle(color: Colors.white),
                                dropdownColor: Colors
                                    .black, // Fondo negro para las opciones
                              ),
                            ),

                            // Container(
                            //   decoration: BoxDecoration(
                            //     borderRadius: BorderRadius.circular(30),
                            //     border: Border.all(
                            //         color: Color.fromARGB(240, 22, 61, 96),
                            //         width: 2),
                            //     color: const Color.fromARGB(61, 0, 0, 0),
                            //   ),
                            //   width: 400,
                            //   child: TextFormField(
                            //     controller: _privacidad,
                            //     decoration: InputDecoration(
                            //       border: InputBorder.none,
                            //       labelText: 'Privacidad',
                            //       labelStyle: TextStyle(color: Colors.white),
                            //       prefixIcon: Icon(
                            //         Icons.person,
                            //         color: Colors.white,
                            //       ),
                            //     ),
                            //     style: TextStyle(color: Colors.white),
                            //     keyboardType: TextInputType.name,
                            //   ),
                            // ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                    color: Color.fromARGB(240, 22, 61, 96),
                                    width: 2),
                                color: const Color.fromARGB(61, 0, 0, 0),
                              ),
                              width: 400,
                              child: TextFormField(
                                controller: _descripcion,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: 'Descripcion',
                                  labelStyle: TextStyle(color: Colors.white),
                                  prefixIcon: Icon(
                                    Icons.pets,
                                    color: Colors.white,
                                  ),
                                  errorStyle:
                                      TextStyle(color: Colors.redAccent),
                                  // Color del texto de error
                                  errorText: _descriptionError,
                                  suffixIcon: _descriptionError != null
                                      ? Icon(Icons.error,
                                          color: Colors.redAccent)
                                      : null,
                                ),
                                style: TextStyle(color: Colors.white),
                                onChanged: (value) {
                                  setState(() {
                                    _descriptionError =
                                        _validations.validateDescription(value);
                                  });
                                },
                                validator: (value) =>
                                    _validations.validateDescription(value),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 55, vertical: 10),

                                backgroundColor: Color.fromARGB(
                                    60, 23, 68, 165), // Color de fondo

                                shadowColor: const Color.fromARGB(
                                    61, 0, 0, 0), // Color de la sombra
                                elevation: 5, // Tamaño de la sombra
                                side: BorderSide(
                                  color: Color.fromARGB(
                                      239, 40, 125, 199), // Color del borde
                                  width: 2, // Ancho del borde
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      17), // Bordes redondeados
                                ),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  _showLoadingDialog(context);
                                  // Call _convertImageToBase64 and wait for it to complete

                                  // Insertar imágenes
                                  if (images[0] != null) {
                                    await _convertImageToBase64();
                                    await postImage(imageBase[0].toString(),
                                        _nombre_mas.text, privacidad);
                                  }
                                  if (images[1] != null) {
                                    //  await _convertImageToBase64();
                                    await postImage(imageBase[1].toString(),
                                        _nombre_mas.text, privacidad);
                                  }
                                  if (images[2] != null) {
                                    //  await _convertImageToBase64();
                                    await postImage(imageBase[2].toString(),
                                        _nombre_mas.text, privacidad);
                                  }

                                  String? username = await _getUsername();
                                  if (username != null) {
                                    await postMascota(
                                      _nombre_mas.text,
                                      _raza.text,
                                      sexoSeleccionado,
                                      _fecha_nac.text,
                                      _color.text,
                                      _tipo.text,
                                      privacidad,
                                      _descripcion.text,
                                      username,
                                    );
                                    setState(() {
                                      images = List.filled(3, null);
                                      imagePaths = List.filled(3, null);
                                      imageBase = List.filled(3, null);
                                      contador = 0; // Reset the counter
                                    });
                                    _hideLoadingDialog(context);
                                    Navigator.pop(context, true);
                                  } else {
                                    _showAlertDialog(
                                        "Error", "Username not found.");
                                  }
                                } else {
                                  _showAlertDialog(
                                      "Register invalid", "Form incompleted");
                                }
                              },
                              child: Text(
                                'Insertar',
                                style: TextStyle(
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    fontSize: 20),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
