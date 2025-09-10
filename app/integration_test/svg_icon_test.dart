import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dam_music_streaming/ui/core/ui/svg_icon.dart';

void main() {
  group('SvgIcon Widget', () {
    testWidgets('deve renderizar o icone', (WidgetTester tester) async {
      const assetName = 'assets/icons/test.svg';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SvgIcon(assetName: assetName),
          ),
        ),
      );

      expect(find.byType(SvgIcon), findsOneWidget);
      
      final svgIcon = tester.widget<SvgIcon>(find.byType(SvgIcon));
      expect(svgIcon.assetName, equals(assetName));
      expect(svgIcon.size, equals(24.0));
      expect(svgIcon.color, isNull);
    });

    testWidgets('deve customizar o tamanho do icone', (WidgetTester tester) async {
      const assetName = 'assets/icons/test.svg';
      const customSize = 48.0;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SvgIcon(
              assetName: assetName,
              size: customSize,
            ),
          ),
        ),
      );

      expect(find.byType(SvgIcon), findsOneWidget);
      
      final svgIcon = tester.widget<SvgIcon>(find.byType(SvgIcon));
      expect(svgIcon.assetName, equals(assetName));
      expect(svgIcon.size, equals(customSize));
    });

    testWidgets('deve renderizar o icone com tamanho e cor personalizados', (WidgetTester tester) async {

      const assetName = 'assets/icons/test.svg';
      const customSize = 32.0;
      const customColor = Colors.blue;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SvgIcon(
              assetName: assetName,
              size: customSize,
              color: customColor,
            ),
          ),
        ),
      );

      expect(find.byType(SvgIcon), findsOneWidget);
      
      final svgIcon = tester.widget<SvgIcon>(find.byType(SvgIcon));
      expect(svgIcon.assetName, equals(assetName));
      expect(svgIcon.size, equals(customSize));
      expect(svgIcon.color, equals(customColor));
    });

  
  });
}
