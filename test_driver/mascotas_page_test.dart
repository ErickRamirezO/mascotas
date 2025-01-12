import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('MascotasPage Tests', () {
    FlutterDriver? driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        driver!.close();
      }
    });

    test('verify the AppBar and at least one pet item is displayed', () async {
      // Encuentra el AppBar y la lista de mascotas
      final appBar = find.byType('AppBar');
      final petList = find.byValueKey('petList');

      // Verifica que el AppBar esté presente
      await driver!.waitFor(appBar, timeout: Duration(seconds: 5));

      // Verifica que la lista de mascotas esté presente
      await driver!.waitFor(petList, timeout: Duration(seconds: 5));

      // Verifica que al menos un elemento en la lista esté presente
      final firstPetItem = find.descendant(
        of: petList,
        matching: find.byType('ListTile'),
      );
      await driver!.waitFor(firstPetItem, timeout: Duration(seconds: 5));
    });
  });
}
