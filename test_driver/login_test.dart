import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('LoginPage Tests', () {
    FlutterDriver? driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        driver!.close();
      }
    });

    test('should show error dialog on invalid login', () async {
      // Encuentra los widgets por key
      final usernameField = find.byValueKey('username_field');
      final passwordField = find.byValueKey('password_field');
      final loginButton = find.byValueKey('login_button');
      final alertDialog = find.byType('AlertDialog');

      // Ingresa el nombre de usuario y la contraseña incorrectos
      await driver!.tap(usernameField);
      await driver!.enterText('wronguser');
      await driver!.tap(passwordField);
      await driver!.enterText('wrongpassword');

      // Presiona el botón de inicio de sesión
      await driver!.tap(loginButton);

      // Espera un momento para ver si se muestra el AlertDialog
      bool isAlertDialogPresent = false;
      try {
        await driver!.waitFor(alertDialog, timeout: Duration(seconds: 5));
        isAlertDialogPresent = true;
      } catch (e) {
        isAlertDialogPresent = false;
      }

      // Verifica que el AlertDialog esté presente
      expect(isAlertDialogPresent, true);
    });
  });
}