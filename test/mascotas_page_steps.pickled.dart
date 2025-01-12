// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: TestCodeBuilder
// **************************************************************************

import 'package:flutter_test/flutter_test.dart';

import 'mascotas_page_steps.dart';

runFeatures() {
  final steps = MascotasPageSteps();
  group(
    'MascotasPage',
    () {
      testWidgets(
        'Verify AppBar and pet list',
        (WidgetTester widgetTester) async {
          await steps.iAmOnTheMascotasPage(widgetTester);
          await steps.iShouldSeeTheAppBarAndAtLeastOnePetItem(widgetTester);
        },
      );
    },
  );
}
