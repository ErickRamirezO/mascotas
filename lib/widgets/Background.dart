import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: DecoratedBox(
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
      ),
    );
  }
}
