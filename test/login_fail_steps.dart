// IMPORTANT: ⚠️ only import annotations ⚠️
import 'package:pickled_cucumber/src/annotations.dart';
import 'package:flutter/material.dart';
import 'package:mascotas/main.dart';
import 'package:mascotas/presentation/screens/home_screen.dart';
import 'package:flutter_test/flutter_test.dart';

@StepDefinition()
class LoginFailSteps {
  @Given('I am on the login page')
  Future<void> iAmOnTheLoginPage(WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
  }

  @When('I enter an invalid credentials')
  Future<void> iEnterAnInvalidCredentials(WidgetTester tester) async {
    // Busca los campos de entrada por sus Keys.
    final usernameField = find.byKey(const Key('username_field'));
    final passwordField = find.byKey(const Key('password_field'));

    // Interactúa con los campos de texto.
    await tester.tap(usernameField);
    await tester.enterText(usernameField, 'wronguser');
    await tester.tap(passwordField);
    await tester.enterText(passwordField, 'wrongpassword');
  }

  @And('I press the login button')
  Future<void> iPressTheLoginButton(WidgetTester tester) async {
    // Busca el botón de login por su Key.
    final loginButton = find.byKey(const Key('login_button'));

    // Interactúa con el botón.
    await tester.tap(loginButton);
    await tester.pumpAndSettle(); // Espera a que las animaciones terminen.
  }

  @Then('I should see the home page')
  Future<void> iShouldSeeTheHomePage(WidgetTester tester) async {
    // Verifica que no se muestre la página de inicio.
    expect(find.byType(HomeScreen), findsNothing);

    // Verifica que se muestre un cuadro de diálogo de error.
    final alertDialog = find.byType(AlertDialog);
    expect(alertDialog, findsOneWidget);
  }
}