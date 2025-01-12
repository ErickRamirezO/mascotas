// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: TestCodeBuilder
// **************************************************************************

import 'package:flutter_test/flutter_test.dart';

import 'home_screen_steps.dart';

runFeatures() {
  final steps = HomeScreenSteps();
  group(
    'HomeScreen',
    () {
      testWidgets(
        'Refresh images when FloatingActionButton is pressed',
        (WidgetTester widgetTester) async {
          await steps.iAmOnTheHomeScreen(widgetTester);
          await steps.iPressTheRefreshButtonNTimes(
            widgetTester,
            3,
          );
          await steps.theImagesShouldRefresh(widgetTester);
        },
      );
    },
  );
}
