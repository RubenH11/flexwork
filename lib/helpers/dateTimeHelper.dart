import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tuple/tuple.dart';
import 'package:timezone/data/latest.dart' as tz;
import "package:timezone/timezone.dart" as tz;

class DateTimeHelper {
  static bool _initialized = false;

  static void initializeTimeZones() {
    if (!_initialized) {
      tz.initializeTimeZones();
      _initialized = true;
    }
  }

  static bool rangeOverlapsDay(
      Tuple2<DateTime, DateTime>? range, DateTime? day) {
    if (range == null || day == null) {
      return false;
    }

    final startOfDay = extractOnlyDay(day);
    final endOfDay = startOfDay
        .add(const Duration(days: 1))
        .subtract(const Duration(seconds: 1));
    return dateRangesOverlap(range, Tuple2(startOfDay, endOfDay));
  }

  static DateTime extractOnlyDay(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  static Tuple2<DateTime, DateTime> getFullDayRange(DateTime day) {
    return Tuple2(extractOnlyDay(day),
        extractOnlyDay(day).add(Duration(days: 1, milliseconds: -1)));
  }

  static bool dateRangesOverlap(
      Tuple2<DateTime, DateTime> range1, Tuple2<DateTime, DateTime> range2) {
    if (range1.item1.isBefore(range2.item1) &&
            range1.item2.isBefore(range2.item1) ||
        range1.item2.isAtSameMomentAs(range2.item1)) {
      return false;
    }
    if (range1.item1.isAfter(range2.item2) ||
        range1.item1.isAtSameMomentAs(range2.item2) &&
            range1.item2.isAfter(range2.item2)) {
      return false;
    }
    return true;
  }

  static List<Tuple2<DateTime, DateTime>> getOverlappingDateRangesOverDay(
      List<Tuple2<DateTime, DateTime>> ranges, DateTime comparisonDay) {
    return ranges
        .where((range) => rangeOverlapsDay(range, comparisonDay))
        .toList();
  }

  static Set<Tuple2<String, DateTime>> sortSetOfRanges(
      Set<Tuple2<String, DateTime>> setOfRanges) {
    final listVersion = setOfRanges.toList();
    listVersion.sort((a, b) => a.item2.compareTo(b.item2));
    return listVersion.toSet();
  }

  // static toDateTime(Timestamp timestamp) {
  //   DateTime localDateTime = timestamp.toDate();
  //   //might have to add an hour
  //   DateTime utcDateTime = localDateTime.toUtc();

  //   String dateTimeString = utcDateTime.toIso8601String().substring(0,utcDateTime.toIso8601String().length - 1);

  //   return DateTime.parse(dateTimeString);
  // }
}
