// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'dart:collection';

import 'package:table_calendar/table_calendar.dart';
import 'dart:math';


/// Example event class.
class Event {
  final String title;

  const Event(this.title);

  @override
  String toString() => title;
}

/// Example events.
///
/// Using a [LinkedHashMap] is highly recommended if you decide to use a map.
final kEvents = LinkedHashMap<DateTime, List<Event>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(_kEventSource);

final _kEventSource = Map.fromIterable(List.generate(50, (index) => index),
    key: (item) => DateTime.utc(2020, 10, item * 5),
    value: (item) => List.generate(
        item % 4 + 1, (index) => Event('Event $item | ${index + 1}')))
  ..addAll({
    DateTime.now(): [
      Event('Today\'s Event 1'),
      Event('Today\'s Event 2'),
    ],
  });

final kEvents2 = LinkedHashMap<DateTime, List<Event>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(_kEventSource2);

final _kEventSource2 = Map.fromIterable(List.generate(20, (index) => index),
    key: (item) => DateTime.utc(2021, 06, item),
    value: (item) => List.generate(
        item % 2 + 1, (index) => Event('Sleep | ${index + 1}')));


// final kSleeps2 = LinkedHashMap<DateTime, int>(
//   hashCode: getHashCode,
// )..addAll({DateTime.utc(2021, 06, 17): 200, DateTime.utc(2021, 06, 18): 250, DateTime.utc(2021, 06, 19): 370, DateTime.utc(2021, 06, 20): 480});

Random rnd = new Random();

final kSleeps2 = LinkedHashMap<DateTime, int>(
  hashCode: getHashCode,
)..addAll(_kSleepSource2);


final _kSleepSource2 = Map.fromIterable(List.generate(20, (index) => index),
    key: (item) => DateTime.utc(2021, 06, item),
    value: (item) => 0 + rnd.nextInt(720 - 0));

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

// final kNow = DateTime.parse('2021-01-17');
final kNow = DateTime.now();
final kFirstDay = DateTime(kNow.year, kNow.month - 1, kNow.day);
final kLastDay = DateTime(kNow.year, kNow.month + 1, kNow.day);

DateTime beginingOfDay(date) => DateTime(date.year,date.month,date.day,0,0,0);

DateTime endOfDay(date) => DateTime(date.year,date.month,date.day,23,59,59);

DateTime lastDayOfMonth(DateTime month) {
    var beginningNextMonth = (month.month < 12)
        ? new DateTime(month.year, month.month + 1, 1)
        : new DateTime(month.year + 1, 1, 1);
    return beginningNextMonth.subtract(new Duration(days: 1));
  }