import 'package:flutter_test/flutter_test.dart';
import 'package:pickled_cucumber/pickled_cucumber.dart';
import 'package:flutter/material.dart';
import 'package:mascotas/main.dart';

@StepDefinition()
class RegisterPageFailSteps {
  @Given('I am on the register page')
  Future<void> iAmOnTheRegisterPage(WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
  }

  @When('I fill the registration form')
  Future<void> iFillTheRegistrationForm(WidgetTester tester) async {
    await tester.enterText(find.byKey(Key('nameField')), 'John');
    await tester.enterText(find.byKey(Key('lastNameField')), 'Doe');
    await tester.enterText(find.byKey(Key('phoneNumberField')), '1234567890');
    await tester.enterText(find.byKey(Key('emailField')), 'john.doe@example.com');
    await tester.enterText(find.byKey(Key('dateField')), '2000-01-01');
    await tester.enterText(find.byKey(Key('usernameField')), 'johndoe');
    await tester.enterText(find.byKey(Key('passwordField')), 'password123');
    await tester.enterText(find.byKey(Key('confirmPasswordField')), 'password123');
  }

  @And('I submit the registration form')
  Future<void> iSubmitTheRegistrationForm(WidgetTester tester) async {
    await tester.tap(find.byKey(Key('submitButton')));
    await tester.pumpAndSettle();
  }

  @Then('I should see the success message')
  Future<void> iShouldSeeTheSuccessMessage(WidgetTester tester) async {
    // Introduce una condición que no se cumpla para que el test falle.
    expect(find.text('Error en el registro'), findsOneWidget);
  }
}