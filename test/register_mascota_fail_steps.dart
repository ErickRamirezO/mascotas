import 'package:flutter_test/flutter_test.dart';
import 'package:pickled_cucumber/pickled_cucumber.dart';
import 'package:flutter/material.dart';
import 'package:mascotas/main.dart';

@StepDefinition()
class RegisterMascotaFailSteps {
  @Given('I am on the register mascota page')
  Future<void> iAmOnTheRegisterMascotaPage(WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
  }

  @When('I fill the registration form with incorrect data')
  Future<void> iFillTheRegistrationFormWithIncorrectData(WidgetTester tester) async {
    await tester.enterText(find.byKey(Key('nameField')), '');
    await tester.enterText(find.byKey(Key('razaField')), '');
    await tester.enterText(find.byKey(Key('sexoField')), '');
    await tester.enterText(find.byKey(Key('fechaNacField')), '');
    await tester.enterText(find.byKey(Key('colorField')), '');
    await tester.enterText(find.byKey(Key('tipoField')), '');
    await tester.enterText(find.byKey(Key('privacidadField')), '');
    await tester.enterText(find.byKey(Key('descripcionField')), '');
  }

  @And('I submit the registration form')
  Future<void> iSubmitTheRegistrationForm(WidgetTester tester) async {
    await tester.tap(find.byKey(Key('submitButton')));
    await tester.pumpAndSettle();
  }

  @Then('I should see an error message')
  Future<void> iShouldSeeAnErrorMessage(WidgetTester tester) async {
    expect(find.text('Error en el registro'), findsOneWidget);
  }
}