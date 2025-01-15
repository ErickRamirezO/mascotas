import 'package:flutter_test/flutter_test.dart';
import 'package:pickled_cucumber/pickled_cucumber.dart';
import 'package:flutter/material.dart';
import 'package:mascotas/main.dart';

@StepDefinition()
class RegisterMascotaSteps {
  @Given('I am on the register mascota page')
  Future<void> iAmOnTheRegisterMascotaPage(WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
  }

  @When('I fill the registration form with correct data')
  Future<void> iFillTheRegistrationFormWithCorrectData(WidgetTester tester) async {
    await tester.enterText(find.byKey(Key('nameField')), 'Fido');
    await tester.enterText(find.byKey(Key('razaField')), 'Labrador');
    await tester.enterText(find.byKey(Key('sexoField')), 'Macho');
    await tester.enterText(find.byKey(Key('fechaNacField')), '2020-01-01');
    await tester.enterText(find.byKey(Key('colorField')), 'Negro');
    await tester.enterText(find.byKey(Key('tipoField')), 'Perro');
    await tester.enterText(find.byKey(Key('privacidadField')), 'Privado');
    await tester.enterText(find.byKey(Key('descripcionField')), 'Un perro muy amigable');
  }

  @And('I submit the registration form')
  Future<void> iSubmitTheRegistrationForm(WidgetTester tester) async {
    await tester.tap(find.byKey(Key('submitButton')));
    await tester.pumpAndSettle();
  }

  @Then('I should see the success message')
  Future<void> iShouldSeeTheSuccessMessage(WidgetTester tester) async {
    expect(find.text('Registro exitoso'), findsOneWidget);
  }
}