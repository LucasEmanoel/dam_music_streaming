Duration? parseIso8601Duration(String isoString) {
  final regExp = RegExp(r'PT(?:(\d+)H)?(?:(\d+)M)?(?:(\d+)S)?');
  final match = regExp.firstMatch(isoString);

  if (match == null) {
    return null;
  }

  final hours = int.parse(match.group(1) ?? '0');
  final minutes = int.parse(match.group(2) ?? '0');
  final seconds = int.parse(match.group(3) ?? '0');

  return Duration(hours: hours, minutes: minutes, seconds: seconds);
}