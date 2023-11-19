import 'package:date_format/date_format.dart';
import 'package:intl/intl.dart';

class TimeManager {
  static String timeWithColon(DateTime dateTime) {
    String formattedTime = DateFormat('HH:mm:ss').format(dateTime);
    return formattedTime;
  }

  static String dateWithDash(DateTime dateTime) {
    print("This is date Time now : $dateTime");
    String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
    return formattedDate;
  }

  static String dateWithSlash(String dateString) {
    DateTime dateTime = new DateFormat("yyyy-MM-dd").parse(dateString);
    String format = formatDate(dateTime, [dd, '/', mm, '/', yyyy]);
    return format;
  }

  static String dateInspection(String dateString) {
    DateTime dateTime = new DateFormat("dd-MM-yyyy HH:mm:ss").parse(dateString);
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  static String todayWithSlash(DateTime dateTime) {
    String format = formatDate(dateTime, [dd, '/', mm, '/', yyyy]);
    return format;
  }

  static String countDaysRestan(String date) {
    DateTime tempDate = new DateFormat("yyyy-MM-dd").parse(date);
    final restanDate = tempDate;
    final date2 = DateTime.now();
    final difference = date2.difference(restanDate).inDays.abs();
    return difference.toString();
  }
}
