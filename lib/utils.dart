import 'package:intl/intl.dart';

String formatDate(String dateStr) {
  DateTime dateTime = DateTime.parse(dateStr);
  DateFormat formatter = DateFormat('hh:mm a MMM dd,yyyy');
  return formatter.format(dateTime);
}
