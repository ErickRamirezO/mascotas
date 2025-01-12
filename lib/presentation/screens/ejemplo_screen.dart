import 'package:flutter/material.dart';
import 'package:mascotas/widgets/Background.dart';

class EjemploScreen extends StatefulWidget {
  const EjemploScreen({super.key});

  @override
  State<EjemploScreen> createState() => _EjemploScreenState();
}

class _EjemploScreenState extends State<EjemploScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Stack(
              //  llamar la clase Background
              children: [
            Background(),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: ListView(
                scrollDirection: Axis.vertical,
                children: [
                  Row(
                    children: [Text("Ejmplo Screen")],
                  )
                ],
              ),
            )
          ])),
    );
  }
}
