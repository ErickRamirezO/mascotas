// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: TestCodeBuilder
// **************************************************************************

import 'package:flutter_test/flutter_test.dart';

import 'login_steps.dart';

runFeatures() {
  final steps = LoginSteps();
  group(
    'Login',
    () {
      testWidgets(
        'User tries to login with invalid credentials',
        (WidgetTester widgetTester) async {
          await steps.iAmOnTheLoginPage(widgetTester);
          await steps.iEnterInvalidCredentials(widgetTester);
          await steps.iPressTheLoginButton(widgetTester);
          await steps.iShouldSeeAnErrorDialog(widgetTester);
        },
      );
    },
  );
}
