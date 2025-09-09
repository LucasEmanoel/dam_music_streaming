import 'package:flutter_test/flutter_test.dart';
import 'package:dam_music_streaming/utils/duration_conversor.dart';

void main() {
  group('Duration Converter', () {
    test('deve converter em horas, minutos e segundos', () {
      const iso8601String = 'PT2H30M45S';

      final duration = parseIso8601Duration(iso8601String);

      expect(duration, isNotNull);
      expect(duration!.inHours, equals(2));
      expect(duration.inMinutes, equals(150));
      expect(duration.inSeconds, equals(9045)); 
    });

    test('deve lidar com duracao zero', () {
      const iso8601String = 'PT0S';

      final duration = parseIso8601Duration(iso8601String);
      
      expect(duration, isNotNull);
      expect(duration!.inSeconds, equals(0));
    });

    test('deve lidar com string malformada', () {
      const malformedString = 'PT1X2M3S';

      final duration = parseIso8601Duration(malformedString);

      expect(duration, Duration.zero);
    });
  });
}
