// IMPORTANT: ⚠️ only import annotations ⚠️
import 'package:pickled_cucumber/src/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mascotas/main.dart';

@StepDefinition()
class MascotasPageSteps {
  @Given('I am on the mascotas page')
  Future<void> iAmOnTheMascotasPage(WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    // Espera un tiempo para asegurar que la página esté completamente cargada
    await tester.pumpAndSettle(Duration(seconds: 5));
  }

  @Then('I should see the app bar and at least one pet item')
  Future<void> iShouldSeeTheAppBarAndAtLeastOnePetItem(WidgetTester tester) async {
    // Busca el AppBar por tipo
    final appBar = find.byType(AppBar);
    // Verifica que el AppBar está presente
    expect(appBar, findsOneWidget);

    // Busca la lista de mascotas por su Key
    final petList = find.byKey(const Key('petList'));
    expect(petList, findsOneWidget);

    // Espera hasta que se encuentren elementos en la lista
    await tester.pumpAndSettle(Duration(seconds: 5));
    final firstPetItem = find.descendant(
      of: petList,
      matching: find.byType(ListTile),
    );

    // Verifica que al menos un elemento esté presente
    expect(firstPetItem, findsWidgets);
  }
}
