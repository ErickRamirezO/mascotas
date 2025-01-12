import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  late FlutterDriver driver;

  setUpAll(() async {
    driver = await FlutterDriver.connect();
  });

  tearDownAll(() async {
    if (driver != null) {
      await driver.close();
    }
  });

  test('Mostrar ActionSheet con opciones de imagen y seleccionar una opción', () async {
    // Encuentra el botón que muestra el ActionSheet
    final showActionSheetButton = find.byValueKey('showActionSheetButton');
    
    // Toca el botón para mostrar el ActionSheet
    await driver.tap(showActionSheetButton);
    
    // Espera que el AlertDialog aparezca
    final alertDialogFinder = find.byType('AlertDialog');
    await driver.waitFor(alertDialogFinder);

    // Verifica que las opciones en el AlertDialog están presentes
    final cameraOption = find.text('Abrir cámara');
    final galleryOption = find.text('Abrir galería');
    expect(await driver.getText(cameraOption), 'Abrir cámara');
    expect(await driver.getText(galleryOption), 'Abrir galería');

    // Toca la opción 'Abrir cámara'
    await driver.tap(cameraOption);
    
    // Verifica que el AlertDialog se cierra (opcional, depende de la lógica de la aplicación)
    await driver.waitForAbsent(alertDialogFinder);
  });
}
