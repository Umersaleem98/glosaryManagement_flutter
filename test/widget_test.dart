import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glosary_management/main.dart';

void main() {
  testWidgets('Search, view details, add groceries and check them off', (
    tester,
  ) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(() {
      debugDefaultTargetPlatformOverride = null;
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const GroceryApp());
    expect(find.text('Pantry overview'), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);

    await tester.tap(find.text('Groceries'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pantry'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'honey');
    await tester.pumpAndSettle();
    expect(find.text('Basmati rice'), findsNothing);
    await tester.tap(find.text('Honey'));
    await tester.pumpAndSettle();
    expect(find.text('Grocery details'), findsOneWidget);

    await tester.tap(find.text('Add to shopping list'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Shopping list'));
    await tester.pumpAndSettle();
    expect(find.text('0 of 4 picked up'), findsOneWidget);
    await tester.tap(find.byType(Checkbox).last);
    await tester.pumpAndSettle();
    expect(find.text('1 of 4 picked up'), findsOneWidget);
  });
}
