import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Calculator {
// Datetime --> String

  static String dateTimeToString(DateTime dateTime) {
    String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
    return formattedDate;
  }

  // DateTime --> TimeStamp

  static Timestamp datetimeToTimestamp(DateTime dateTime) {
    return Timestamp.fromMillisecondsSinceEpoch(
        dateTime.millisecondsSinceEpoch);
  }

  // TimeStamp-->String

  static DateTime datetimeFromTimestamp(Timestamp timeStamp) {
    return DateTime.fromMillisecondsSinceEpoch(timeStamp.seconds * 1000);
  }
}
