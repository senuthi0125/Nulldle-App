import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nulldle/main.dart';
void main() {
  
  // Test 1: Verify HomeScreen UI Elements 
  // This test works because HomeScreen is a simple StatelessWidget without async dependencies.
  testWidgets('HomeScreen UI elements are present and consistent', (WidgetTester tester) async {
    // 1. Pump the entire application (which starts at HomeScreen)
    await tester.pumpWidget(const WordleApp());
    await tester.pumpAndSettle();

    // Verify Title
    expect(find.text('Nulldle'), findsOneWidget);

    // Verify Instruction text (substring match)
    expect(
      find.textContaining('Guess the hidden five-letter word'),
      findsOneWidget,
    );
    
    // Verify Play Game button exists
    expect(find.widgetWithText(ElevatedButton, 'Play Game'), findsOneWidget);

    // Verify Image exists
    expect(find.byType(Image), findsOneWidget);
  });
}
