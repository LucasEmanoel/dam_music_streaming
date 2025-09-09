import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dam_music_streaming/ui/core/ui/confirm_dialog.dart';

void main() {
  group('ConfirmationDialog Widget', () {
    testWidgets('deve renderizar o dialogo de confirmacao', (WidgetTester tester) async {
      // Arrange
      bool onConfirmCalled = false;
      const title = 'Confirm Action';
      const content = 'Are you sure you want to proceed?';
      const buttonText = 'Confirm';
      const buttonColor = Colors.red;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ConfirmationDialog(
              title: title,
              content: content,
              txtBtn: buttonText,
              corBtn: buttonColor,
              onConfirm: () {
                onConfirmCalled = true;
              },
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(ConfirmationDialog), findsOneWidget);
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text(title), findsOneWidget);
      expect(find.text(content), findsOneWidget);
      expect(find.text(buttonText), findsOneWidget);
      expect(find.text('Cancelar'), findsOneWidget);
    });

    testWidgets('deve chamar onConfirm quando o botao de confirmacao for pressionado', (WidgetTester tester) async {
      // Arrange
      bool onConfirmCalled = false;
      const title = 'Delete Item';
      const content = 'This action cannot be undone.';
      const buttonText = 'Delete';
      const buttonColor = Colors.red;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ConfirmationDialog(
              title: title,
              content: content,
              txtBtn: buttonText,
              corBtn: buttonColor,
              onConfirm: () {
                onConfirmCalled = true;
              },
            ),
          ),
        ),
      );

      // Find and tap the confirm button
      final confirmButton = find.text(buttonText);
      expect(confirmButton, findsOneWidget);
      
      await tester.tap(confirmButton);
      await tester.pumpAndSettle();

      // Assert
      expect(onConfirmCalled, isTrue);
    });

  });
}
