
import 'package:intl/intl.dart';

String formateMoney(value,format) {
  double angka = double.parse(value);
  String hasil = NumberFormat.currency(locale: format, symbol: '').format(angka);
  return hasil;
}

String formateDate(value,format) {
  int milliseconds = int.parse(value);
  DateTime utcDateTime = DateTime.fromMillisecondsSinceEpoch(milliseconds, isUtc: true);
  DateTime jakartaTime = utcDateTime.toLocal();
  String formattedDate = DateFormat(format).format(jakartaTime);
  return formattedDate;
}