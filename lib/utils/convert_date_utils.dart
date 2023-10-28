import 'package:intl/intl.dart';

class ConvertDateUtils {
  static String convertIntToDateTime(int time) {

    final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(time);

    return DateFormat('dd/MM/yy HH:mm').format(dateTime);
  }
}