// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'dart:collection';
import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'package:table_calendar_example/models/patient_data.dart';
import 'package:table_calendar_example/models/sleep_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar_example/widgets/square_container.dart';

import '../utils.dart';

class TableEventsExample extends StatefulWidget {
  @override
  _TableEventsExampleState createState() => _TableEventsExampleState();
}

class _TableEventsExampleState extends State<TableEventsExample> {
  ValueNotifier<List<SleepEvent>>? _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  late DateTime _focusedDay;
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  late LinkedHashMap<DateTime, int?> kSleeps;
  late LinkedHashMap<DateTime, List<SleepEvent>> kEvents;

  late DateTime today;
  late DateTime firstDate;
  late DateTime lastDate;

  late DateTime? lastSyncDate;
  late ResponseData sleepData;

  final _storage = FlutterSecureStorage();

  Future? future;
  double _sizeOfSquare = 52;
  String token =
      '''eyJhbGciOiJIUzUxMiIsImlhdCI6MTYyNDk2MTQ4NiwiZXhwIjoxNjI1NTY2Mjg2fQ.eyJpZCI6NTQsInVzZXJfdHlwZSI6IkNsaW5pY2lhbiIsImNsaW5pY19pZCI6MTV9.4CVCWWGF-o8uBuXXWPYbOQVmQmi3Ap9WLkafQscEBCrRuWUYD49_-1QnDS_NptwgiFxbJzxi5qx3JTbY4_rLRg''';
  String patientFitbitId = "9FM937";
  String patientId = '67';

  CalendarStyle _calendarStyle = new CalendarStyle(
    markersOffset: const PositionedOffset(end: 0, bottom: 2),
    markersMaxCount: 1,
    markerDecoration: BoxDecoration(
      color: Color(0xff0f2a61),
      shape: BoxShape.rectangle,
    ),
    markersAutoAligned: false,
    markersAlignment: Alignment.bottomRight,
    cellMargin: EdgeInsets.all(2.0),
    outsideDaysVisible: false,
    isTodayHighlighted: false,
    selectedDecoration: BoxDecoration(
      color: Color(0xff1a47a2),
      shape: BoxShape.circle,
    ),
  );

  @override
  void initState() {
    super.initState();

    future = fetchData();
  }

  @override
  void dispose() {
    _selectedEvents?.dispose();
    super.dispose();
  }

  Future<String> fetchData() async {
    await _fetchLastSyncDate();
    await _fetchSleepRecords();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));

    return "Fetch Data Completed";
  }

  LinkedHashMap<DateTime, int?> _formSleepDurations(
      ResponseData sleepData) {
    final kSleepSource = {
      for (var x in sleepData.data!)
        x.date: x.value?.sleepSummaryOverall?.totalMinutesAsleep
    };

    this.kSleeps = LinkedHashMap<DateTime, int?>(
      hashCode: getHashCode,
    )..addAll(kSleepSource);

    return kSleeps;
  }

  LinkedHashMap<DateTime, List<SleepEvent>> _formSleepEvents(
      ResponseData sleepData) {
    final Map<DateTime, List<SleepEvent>> kEventSource = Map.fromIterable(
        sleepData.data!,
        key: (item) => item.date,
        value: (item) => List<SleepEvent>.generate(
                item.value?.sleepList.length == null
                    ? 0
                    : item.value?.sleepList.length, (int index) {
              return new SleepEvent(
                  startTime: item.value?.sleepList.elementAt(index).startTime,
                  endTime: item.value?.sleepList.elementAt(index).endTime,
                  isMainSleep:
                      item.value?.sleepList.elementAt(index).isMainSleep,
                  sleepSession: item.value?.sleepList.elementAt(index));
            }));

    this.kEvents = LinkedHashMap<DateTime, List<SleepEvent>>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(kEventSource);

    return kEvents;
  }

  Future<dynamic> _fetchSleepRecordsFromAPI(
      {DateTime? oldLastSyncDate, bool isSyncDateChanged = false}) async {
    if (isSyncDateChanged) {
      String startDate = DateFormat('yyyy-MM-dd').format((oldLastSyncDate!));
      //.add(new Duration(days: 1)));
      String endDate = DateFormat('yyyy-MM-dd').format((this.lastSyncDate!));

      print("Request Sent - isOldLastSyncDate - $startDate to $endDate");

      http.Response response = await http.get(
        Uri.parse('https://siha-staging.qcri.org/' +
            'siha-api/v1/fitbit/data/intraday/sleep/userid/' +
            this.patientFitbitId +
            '/start/$startDate/end/$endDate'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ' + this.token
        },
      );

      return response.body;
    } else {
      String startDate = DateFormat('yyyy-MM-dd')
          .format((this.lastSyncDate!).subtract(new Duration(days: 10)));
      String endDate = DateFormat('yyyy-MM-dd').format((this.lastSyncDate!));

      print("Request Sent - $startDate to $endDate");

      http.Response response = await http.get(
        Uri.parse('https://siha-staging.qcri.org/' +
            'siha-api/v1/fitbit/data/intraday/sleep/userid/' +
            this.patientFitbitId +
            '/start/$startDate/end/$endDate'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ' + this.token
        },
      );

      return response.body;
    }
  }

  Future<DateTime?> _fetchLastSyncDate() async {
    http.Response r = await http.get(
      Uri.parse('https://siha-staging.qcri.org/' +
          'siha-api/v1/patients/id/' +
          this.patientId),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + this.token
      },
    );

    final responseData = jsonDecode(r.body);

    PatientData pd = new PatientData.fromJson(responseData);
    if (r.statusCode == 200) {
      for (var i = 0; i < pd.devices!.length; i++) {
        if (pd.devices!.length > 0 &&
            pd.devices![i].name == "fitbit" &&
            pd.devices![i].latestData != null) {
          this.lastSyncDate = normalizeDate(
              DateFormat('EEE, d MMM yyyy HH:mm:ss vvv', 'en-US')
                  .parse(pd.devices![i].latestData!));
        }
      }
    }

    if (this.lastSyncDate == null) {
      print('lastSyncDate - NULL');
      this.lastSyncDate = DateTime.now();
    }

    this.firstDate = DateTime(
        lastSyncDate!.year, lastSyncDate!.month - 2, lastSyncDate!.day);
    this.lastDate = this.lastSyncDate!;
    // this.lastSyncDate = normalizeDate(DateTime(2021, 06, 12));
    this._focusedDay = this.lastSyncDate!;
    print('lastSyncDate $lastSyncDate');
    // await _storage.deleteAll();
    return lastSyncDate;
  }

  Future<ResponseData> _fetchSleepRecords() async {
    DateTime storedSyncDate;
    if (this.lastSyncDate != null) {
      if (await _storage.containsKey(key: 'lastSyncDate')) {
        String? storedDate = await _storage.read(key: 'lastSyncDate');
        storedSyncDate = DateTime.parse(storedDate!);
        print('storedSyncDate: $storedSyncDate');

        int diff = lastSyncDate!.difference(storedSyncDate).inDays;
        print('diff: $diff');

        if (diff == 0) {
          ///Same sync date, now check if sleep records exist uptil [lastSyncDate].
          if (await _storage.containsKey(key: 'sleepRecords-$lastSyncDate')) {
            String? sleepRecordsJson =
                await _storage.read(key: 'sleepRecords-$lastSyncDate');
            print("is this block going to run?");
            //Decoding and Deserializing.
            this.sleepData =
                new ResponseData.fromJson(json.decode(sleepRecordsJson!));

            // sleepData.data!.forEach((element) => print(element.date));

            _formSleepDurations(this.sleepData);
            _formSleepEvents(this.sleepData);

            return this.sleepData;
          } else {
            //Sleep Records do not exist
            String sleepRecords = await _fetchSleepRecordsFromAPI();

            await _storage.write(
                key: 'sleepRecords-$lastSyncDate', value: sleepRecords);

            this.sleepData =
                new ResponseData.fromJson(json.decode(sleepRecords));
            _formSleepDurations(this.sleepData);
            _formSleepEvents(this.sleepData);
            return this.sleepData;
          }
        } else {
          //Last Sync Date has Changed.
          ///Call API from [storedSyncDate] to New [lastSyncDate]
          ///Retrieve Sleep Records from storage uptil [storedSyncDate] 

          List<dynamic> sleepRecords = await Future.wait([
            _fetchSleepRecordsFromAPI(
                oldLastSyncDate: storedSyncDate, isSyncDateChanged: true),
            _storage.read(key: 'sleepRecords-$storedSyncDate')
          ]);

          ResponseData newSleepData =
              new ResponseData.fromJson(json.decode(sleepRecords[0]));

          this.sleepData = new ResponseData.fromJson(
              json.decode(sleepRecords[1])); 

          //Combine sleep records
          newSleepData.data
              ?.forEach((record) => this.sleepData.data?.add(record));

          //Serialize this.sleepData and write it to storage.
          await Future.wait([
            _storage.delete(key: 'sleepRecords-$storedSyncDate'),
            _storage.write(
                key: 'sleepRecords-$lastSyncDate',
                value: json.encode(this.sleepData)),
            _storage.write(key: 'lastSyncDate', value: '$lastSyncDate')
          ]);

          _formSleepDurations(this.sleepData);
          _formSleepEvents(this.sleepData);

          return this.sleepData;
        }
      } else {
        ///Sleep records do not exist at [lastSyncDate], so fetch from API and store.
        List<dynamic> sleepRecords = await Future.wait([
          _fetchSleepRecordsFromAPI(),
          _storage.write(key: 'lastSyncDate', value: '$lastSyncDate')
        ]);

        await _storage.write(
            key: 'sleepRecords-$lastSyncDate', value: sleepRecords[0]);

        this.sleepData =
            new ResponseData.fromJson(json.decode(sleepRecords[0]));

        _formSleepDurations(this.sleepData);
        _formSleepEvents(this.sleepData);

        return this.sleepData;
      }
    }
    return this.sleepData;
  }

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  bool isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) {
      return false;
    }

    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  List<SleepEvent> _getEventsForDay(DateTime day) {
    // print(this.kEvents[day]);
    return this.kEvents[day] ?? [];
  }

  int? _getSleepDurationForDay(DateTime day) {
    // print("Date");
    // print(DateTime.utc(day.year, day.month, day.day));
    // print(kSleeps2[DateTime.utc(day.year, day.month, day.day)]);
    // print("_getSleepDurationForDay");
    return kSleeps[day] ?? 0;
  }

  //When a new day is selected, then update the state and retrieve it's events.
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents?.value = _getEventsForDay(selectedDay);
    }
  }

  List<SleepEvent> _getEventsForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      _selectedEvents?.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents?.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents?.value = _getEventsForDay(end);
    }
  }

  Widget _buildSingleMarker(
      DateTime day, SleepEvent event, int eventListLength) {
    return Container(
      width: 12,
      height: 12,
      margin: EdgeInsets.symmetric(horizontal: 0.3),
      decoration: const BoxDecoration(
        color: const Color(0xFF263238),
        shape: BoxShape.rectangle,
      ),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          eventListLength.toString(),
          style: TextStyle(color: Color(0xFFFAFAFA), fontSize: 10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sleep History'),
        backgroundColor: Color(0xff1a47a2),
      ),
      body: Container(
          child: FutureBuilder(
              future: future,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        clipBehavior: Clip.antiAlias,
                        margin: const EdgeInsets.all(8.0),
                        child: TableCalendar<SleepEvent>(
                          calendarBuilders: CalendarBuilders(
                            defaultBuilder: (context, day, focusedDay) {
                              String text = '${day.day}';
                              int sleepDurationForDay =
                                  _getSleepDurationForDay(day)!;

                              int sleepThreshold =
                                  assignThreshold(sleepDurationForDay);
                              switch (sleepThreshold) {
                                case 1:
                                  {
                                    return SquareContainer(
                                        progress: sleepDurationForDay / 1000,
                                        size: _sizeOfSquare,
                                        backgroundColor:
                                            const Color(0xFFf1a2a6),
                                        progressColor: const Color(0xFFE3464E),
                                        text: text);
                                  }
                                case 2:
                                  {
                                    return SquareContainer(
                                        progress: sleepDurationForDay / 1000,
                                        size: _sizeOfSquare,
                                        backgroundColor:
                                            const Color(0xFFf1ca96),
                                        progressColor: const Color(0xFFE4962D),
                                        text: text);
                                  }
                                case 3:
                                  {
                                    return SquareContainer(
                                        progress: sleepDurationForDay / 1000,
                                        size: _sizeOfSquare,
                                        backgroundColor:
                                            const Color(0xFFf7d986),
                                        progressColor: const Color(0xFFEFB40D),
                                        text: text);
                                  }
                                case 4:
                                  {
                                    return SquareContainer(
                                        progress: sleepDurationForDay / 1000,
                                        size: _sizeOfSquare,
                                        backgroundColor:
                                            const Color(0xFF8fd198),
                                        progressColor: const Color(0xFF20a432),
                                        text: text);
                                  }
                                default:
                                  return null;
                              }
                            },
                            markerBuilder: (context, day, events) {
                              return PositionedDirectional(
                                top: null,
                                bottom: _calendarStyle.markersOffset.bottom,
                                start: null,
                                end: _calendarStyle.markersOffset.end,
                                child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: events
                                        .take(_calendarStyle.markersMaxCount)
                                        .map((event) => _buildSingleMarker(
                                            day, event, events.length))
                                        .toList()),
                              );
                            },
                          ),
                          firstDay: this.firstDate,
                          lastDay: this.lastDate,
                          focusedDay: _focusedDay,
                          selectedDayPredicate: (day) =>
                              isSameDay(_selectedDay, day),
                          rangeStartDay: _rangeStart,
                          rangeEndDay: _rangeEnd,
                          calendarFormat: _calendarFormat,
                          rangeSelectionMode: _rangeSelectionMode,
                          eventLoader: _getEventsForDay,
                          startingDayOfWeek: StartingDayOfWeek.sunday,
                          headerStyle: HeaderStyle(
                            formatButtonVisible: false,
                            formatButtonShowsNext: false,
                            decoration: BoxDecoration(
                              color: Color(0xff1a47a2),
                            ),
                            headerMargin: const EdgeInsets.only(bottom: 8.0),
                            titleTextStyle: TextStyle(
                              color: Colors.white,
                            ),
                            formatButtonDecoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            formatButtonTextStyle:
                                TextStyle(color: Colors.white),
                            leftChevronIcon: Icon(
                              Icons.chevron_left,
                              color: Colors.white,
                            ),
                            rightChevronIcon: Icon(
                              Icons.chevron_right,
                              color: Colors.white,
                            ),
                          ),
                          calendarStyle: _calendarStyle,
                          onDaySelected: _onDaySelected,
                          onRangeSelected: _onRangeSelected,
                          onFormatChanged: (format) {
                            if (_calendarFormat != format) {
                              setState(() {
                                _calendarFormat = format;
                              });
                            }
                          },
                          onPageChanged: (focusedDay) {
                            _focusedDay = focusedDay;
                          },
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Expanded(
                        child: ValueListenableBuilder<List<SleepEvent>>(
                          valueListenable: _selectedEvents!,
                          builder: (context, value, _) {
                            return ListView.builder(
                              itemCount: value.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 12.0,
                                    vertical: 4.0,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: ListTile(
                                    //Pass object of sleep session via -> value[index].sleepSession!
                                    onTap: () => print('${value[index]}'),
                                    title: Text('${value[index]}'),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  );
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 150.0,
                        child: Stack(
                          children: <Widget>[
                            Center(
                              child: Container(
                                width: 150,
                                height: 150,
                                child: new CircularProgressIndicator(
                                  color: Color(0xff5e7ebd),
                                  strokeWidth: 8,
                                  value: 1.0,
                                ),
                              ),
                            ),
                            Center(child: Text("Loading Sleep Data...")),
                          ],
                        ),
                      ),
                    ],
                  );
                }
              })),
    );
  }
}
