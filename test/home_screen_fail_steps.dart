// IMPORTANT: ⚠️ only import annotations ⚠️ 
import 'package:pickled_cucumber/src/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mascotas/main.dart';

@StepDefinition()
class HomeScreenFailSteps {
  @Given('I am on the home screen')
  Future<void> iAmOnTheHomeScreen(WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
  }

  @When('I wait for seven seconds')
  Future<void> iWaitForSevenSeconds(WidgetTester tester) async {
    // Espera el tiempo especificado.
    await Future.delayed(Duration(seconds: 7));
  }

  @Then('The images should not refresh')
  Future<void> theImagesShouldNotRefresh(WidgetTester tester) async {
    // Busca el widget de las imágenes.
    final imageWidget = find.byType(Image);

    // Verifica que no haya ningún widget de tipo Image presente.
    expect(imageWidget, findsNothing);
  }
}