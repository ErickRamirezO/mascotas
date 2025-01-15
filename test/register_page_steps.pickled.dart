// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: TestCodeBuilder
// **************************************************************************

import 'package:flutter_test/flutter_test.dart';

import 'register_page_steps.dart';

runFeatures() {
  final steps = ActionSheetSteps();
  group(
    'Mostrar ActionSheet con opciones de imagen',
    () {
      testWidgets(
        'Mostrar ActionSheet y seleccionar una opción',
        (WidgetTester widgetTester) async {
          await steps.iAmOnThePageWithActionSheetButton(widgetTester);
          await steps.iTapTheShowActionSheetButton(widgetTester);
          await steps.iShouldSeeTheAlertDialogWithOptions(widgetTester);
          await steps.iTapTheCameraOption(widgetTester);
          await steps.theAlertDialogShouldDisappear(widgetTester);
        },
      );
    },
  );
}
