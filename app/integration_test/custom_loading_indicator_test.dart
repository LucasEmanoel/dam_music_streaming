import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dam_music_streaming/ui/core/ui/loading.dart';

void main() {
  group('CustomLoadingIndicator Widget', () {
    testWidgets('deve renderizar o indicador de carregamento', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CustomLoadingIndicator(),
          ),
        ),
      );

      expect(find.byType(CustomLoadingIndicator), findsOneWidget);
      expect(find.byType(Center), findsOneWidget);
    });

  });
}
