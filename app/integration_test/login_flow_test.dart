import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'package:dam_music_streaming/ui/login/login_inicio.dart';
import 'package:dam_music_streaming/ui/core/user/view_model/user_view_model.dart';

void main() {

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  group('Login Flow Integration Tests', () {

    Future<void> pumpLoginScreen(WidgetTester tester, Directory docsDir) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => UserViewModel(docsDir)),
          ],
          child: MaterialApp(
            home: LoginInicio(docsDir: docsDir),
          ),
        ),
      );
    }

    testWidgets('deve renderizar a tela de login', (WidgetTester tester) async {
      final Directory docsDir = await getApplicationDocumentsDirectory();
      await pumpLoginScreen(tester, docsDir);
      await tester.pumpAndSettle();

      expect(find.text('Bem-vindo ao Harmony!'), findsOneWidget);
    });

    testWidgets('deve navegar para a tela principal após login real com sucesso', (WidgetTester tester) async {
      final Directory docsDir = await getApplicationDocumentsDirectory();
      await pumpLoginScreen(tester, docsDir);
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).first, 'juan@email.com');
      await tester.enterText(find.byType(TextField).last, 'admin');              

      await tester.tap(find.widgetWithText(FilledButton, 'Entrar'));
      
      await tester.pumpAndSettle(const Duration(seconds: 5)); 

      expect(find.text('Bem-vindo ao Harmony!'), findsNothing);
      
      expect(find.text('Harmony'), findsOneWidget);
      expect(find.text('Músicas'), findsOneWidget);
    });
  });
}