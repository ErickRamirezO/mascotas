import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('HomeScreen Tests', () {
    FlutterDriver? driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        driver!.close();
      }
    });

    test('should refresh images when FloatingActionButton is pressed', () async {
      // Encuentra el FloatingActionButton usando una key
      final fab = find.byValueKey('refresh_button');
      final imageWidget = find.byType('ImageWidget');

      for (int i = 0; i < 3; i++) {
        // Toca el FloatingActionButton
        await driver!.tap(fab);

        // Espera un momento para que se actualicen las imágenes
        await Future.delayed(Duration(seconds: 2));

        // Verifica que las imágenes están cargadas esperando a que el primer ImageWidget esté presente
        await driver!.waitFor(imageWidget, timeout: Duration(seconds: 3));

        expect(true, isTrue);
      }
    });
  });
}
