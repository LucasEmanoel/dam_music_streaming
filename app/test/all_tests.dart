import 'package:flutter_test/flutter_test.dart';
import 'unit/song_data_test.dart' as song_data_tests;
import 'unit/duration_conversor_test.dart' as duration_conversor_tests;
import 'widget/custom_loading_indicator_test.dart' as loading_indicator_tests;
import 'widget/confirmation_dialog_test.dart' as confirmation_dialog_tests;
import '../integration_test/login_flow_test.dart' as login_flow_tests;
import '../integration_test/player_workflow_test.dart' as player_workflow_tests;

void main() {
  group('All Tests', () {
    group('Unit Tests', () {
      song_data_tests.main();
      duration_conversor_tests.main();
    });

    group('Widget Tests', () {
      loading_indicator_tests.main();
      confirmation_dialog_tests.main();
    });

    group('Integration Tests', () {
      login_flow_tests.main();
      player_workflow_tests.main();
    });
  });
}
