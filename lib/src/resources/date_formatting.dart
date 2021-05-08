import 'package:intl/intl.dart';

String getFormattedDate(String iso8601) {
  var dateFormat = DateFormat.yMMMd();
  return dateFormat.format(DateTime.parse(iso8601));
}

String getFormattedTime(String iso8601) {
  var timeFormat = DateFormat.jm();
  return timeFormat.format(DateTime.parse(iso8601));
}

String getActiveConversationDate(String iso8601) {
  DateTime date = DateTime.parse(iso8601);
  if (calculateDifference(date) == 0) {
    return getFormattedTime(iso8601);
  }
  return getFormattedDate(iso8601);
}

int calculateDifference(DateTime date) {
  DateTime now = DateTime.now();
  return DateTime(date.year, date.month, date.day)
      .difference(DateTime(now.year, now.month, now.day))
      .inDays;
}
