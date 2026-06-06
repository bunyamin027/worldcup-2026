import 'package:intl/intl.dart';

String formatMatchTime(String? isoDateString) {
  if (isoDateString == null || isoDateString.isEmpty) return '--:--';
  try {
    final DateTime dateTime = DateTime.parse(isoDateString).toLocal();
    return DateFormat('HH:mm').format(dateTime);
  } catch (e) {
    return '--:--';
  }
}
