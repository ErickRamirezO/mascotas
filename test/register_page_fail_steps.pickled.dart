// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: TestCodeBuilder
// **************************************************************************

import 'package:flutter_test/flutter_test.dart';

import 'register_page_fail_steps.dart';

runFeatures() {
  final steps = RegisterPageFailSteps();
  group(
    'Register Page Success',
    () {
      testWidgets(
        'User registers successfully',
        (WidgetTester widgetTester) async {
          await steps.iAmOnTheRegisterPage(widgetTester);
          await steps.iFillTheRegistrationForm(widgetTester);
          await steps.iSubmitTheRegistrationForm(widgetTester);
          await steps.iShouldSeeTheSuccessMessage(widgetTester);
        },
      );
    },
  );
  group(
    'Register Page Fail',
    () {
      testWidgets(
        'User registration failed',
        (WidgetTester widgetTester) async {
          await steps.iAmOnTheRegisterPage(widgetTester);
          await steps.iFillTheRegistrationForm(widgetTester);
          await steps.iSubmitTheRegistrationForm(widgetTester);
          await steps.iShouldSeeTheSuccessMessage(widgetTester);
        },
      );
    },
  );
}
