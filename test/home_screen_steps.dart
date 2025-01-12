// IMPORTANT: ⚠️ only import annotations ⚠️ 
import 'package:pickled_cucumber/src/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mascotas/main.dart';

@StepDefinition()
class HomeScreenSteps {
  @Given('I am on the home screen')
  Future<void> iAmOnTheHomeScreen(WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
  }

  @When('I press the refresh button {int} times')
  Future<void> iPressTheRefreshButtonNTimes(WidgetTester tester, int times) async {
    // Busca el botón por su Key.
    final refreshButton = find.byKey(const Key('refresh_button'));

    for (int i = 0; i < times; i++) {
      // Interactúa con el botón.
      await tester.tap(refreshButton);
      await tester.pumpAndSettle(); // Espera a que las animaciones terminen.
      
      // Espera adicional para garantizar que la aplicación tenga tiempo de actualizar completamente.
      await Future.delayed(Duration(seconds: 3));
    }
  }

  @Then('The images should refresh')
  Future<void> theImagesShouldRefresh(WidgetTester tester) async {
    // Busca el widget de las imágenes.
    final imageWidget = find.byType(Image);

    // Verifica que al menos un widget de tipo Image esté presente.
    expect(imageWidget, findsWidgets);
  }
}
