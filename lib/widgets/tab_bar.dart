import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:mascotas/Login/LoginPage.dart';
import 'package:mascotas/mascotas/MascotasPage.dart';
import 'package:mascotas/mascotas/registrar_mascota.dart';
import 'package:mascotas/presentation/screens/ejemplo_screen.dart';
import 'package:mascotas/presentation/screens/home_screen.dart'; // Asegúrate de importar la página de inicio de sesión

class TabBarCustom extends StatefulWidget {
  const TabBarCustom({super.key});

  @override
  State<TabBarCustom> createState() => _TabBarCustomState();
}

class _TabBarCustomState extends State<TabBarCustom> {
  int _page = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  Color colorIcon = const Color.fromARGB(255, 0, 217, 255);
  Color colorShadowIcon = Color.fromARGB(148, 0, 217, 255);

  // Lista de estados de selección para los íconos
  List<bool> isSelected = [true, false, false, false];

  // Screen para navegación
  final List<Widget> _screens = [
    const HomeScreen(),
    //const EjemploScreen(),
    MascotasPage(),
    const EjemploScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: 0,
        items: <Widget>[
          _buildIcon(Icons.home, isSelected[0]),
          //_buildIcon(Icons.person, isSelected[1]),
          _buildIcon(Icons.favorite_border, isSelected[1]),
          _buildIcon(Icons.logout_outlined, isSelected[2]),
        ],
        color: const Color.fromARGB(30, 255, 255, 255),
        buttonBackgroundColor: const Color.fromARGB(255, 25, 23, 61),
        height: 55,
        backgroundColor: const Color.fromARGB(255, 25, 23, 61),
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 600),
        onTap: (index) async {
          if (index == _screens.length - 1) {
            // Muestra un diálogo de confirmación
            bool? shouldExit = await _showExitConfirmationDialog(context);
            if (shouldExit == true) {
              // Si el usuario confirma, redirige a la página de inicio de sesión
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            }
          } else {
            setState(() {
              _page = index;
              // Actualiza el estado de selección de los íconos
              for (int i = 0; i < isSelected.length; i++) {
                isSelected[i] = (i == index);
              }
            });
          }
        },
        letIndexChange: (index) => true,
      ),
      body: Container(
        color: Color.fromARGB(255, 25, 23, 61),
        child: Center(
          child: _screens[
              _page], // Muestra la pantalla correspondiente al índice seleccionado
        ),
      ),
    );
  }

  // Widget icons
  Widget _buildIcon(IconData icon, bool isSelected) {
    Color iconColor = isSelected ? colorIcon : Colors.grey; // Color del ícono
    List<BoxShadow> iconShadow = isSelected
        ? [
            BoxShadow(color: colorShadowIcon, blurRadius: 20)
          ] // Sombra del ícono cuando está seleccionado
        : []; // Sin sombra cuando no está seleccionado

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: iconShadow,
      ),
      child: Icon(icon, size: 30, color: iconColor),
    );
  }

  Future<bool?> _showExitConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(240, 22, 61, 96),
          title: Text('Confirmar salida', style: TextStyle(color: Colors.white),),
          content: Text('¿Estás seguro de que deseas salir?', style: TextStyle(color: Colors.white)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // No salir
              },
              child: Text('Cancelar', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Salir
              },
              child: Text('Aceptar', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
