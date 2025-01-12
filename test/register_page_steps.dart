import 'package:pickled_cucumber/src/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mascotas/main.dart';

@StepDefinition()
class ActionSheetSteps {
  @Given('I am on the page with the action sheet button')
  Future<void> iAmOnThePageWithActionSheetButton(WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    // Espera que la página esté completamente cargada
    await tester.pumpAndSettle();
  }

  @When('I tap the show action sheet button')
  Future<void> iTapTheShowActionSheetButton(WidgetTester tester) async {
    // Encuentra el botón que muestra el ActionSheet
    final showActionSheetButton = find.byKey(const Key('showActionSheetButton'));
    // Toca el botón para mostrar el ActionSheet
    await tester.tap(showActionSheetButton);
    await tester.pumpAndSettle();
  }

  @And('I should see an alert dialog with options Abrir cámara and Abrir galería')
  Future<void> iShouldSeeTheAlertDialogWithOptions(WidgetTester tester) async {
    // Espera a que el AlertDialog aparezca
    final alertDialogFinder = find.byType(AlertDialog);
    await tester.pumpAndSettle();
    expect(alertDialogFinder, findsOneWidget);

    // Verifica que las opciones están presentes
    final cameraOption = find.text('Abrir cámara');
    final galleryOption = find.text('Abrir galería');
    expect(cameraOption, findsOneWidget);
    expect(galleryOption, findsOneWidget);
  }

  @And('I tap the Abrir cámara option')
  Future<void> iTapTheCameraOption(WidgetTester tester) async {
    // Toca la opción 'Abrir cámara'
    final cameraOption = find.text('Abrir cámara');
    await tester.tap(cameraOption);
    await tester.pumpAndSettle();
  }

  @Then('The alert dialog should disappear')
  Future<void> theAlertDialogShouldDisappear(WidgetTester tester) async {
    // Verifica que el AlertDialog se ha cerrado
    final alertDialogFinder = find.byType(AlertDialog);
    expect(alertDialogFinder, findsNothing);
  }
}
