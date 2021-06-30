import 'package:intl/intl.dart';


part 'sleep_model.g.dart';


class ResponseData {
  List<SleepData>? data;
  String? result;

  ResponseData({this.data, this.result});

  factory ResponseData.fromJson(Map<String, dynamic> parsedJson) => _$ResponseDataFromJson(parsedJson);

  Map<String, dynamic> toJson() => _$ResponseDataToJson(this);
}

class SleepData {
  DateTime date;
  SleepValue? value;

  SleepData({
   required this.date, this.value
  });

  factory SleepData.fromJson(Map<String, dynamic> parsedJson) => _$SleepDataFromJson(parsedJson);

  Map<String, dynamic> toJson() => _$SleepDataToJson(this);
}

class SleepValue {
  List<SleepSession>? sleepList;
  SleepSummaryOverall? sleepSummaryOverall;

  SleepValue({
  this.sleepList, this.sleepSummaryOverall
  });

  factory SleepValue.fromJson(Map<String, dynamic> parsedJson) => _$SleepValueFromJson(parsedJson);

  Map<String, dynamic> toJson() => _$SleepValueToJson(this);
}


class SleepSession { 
  DateTime? dateOfSleep;
  int? duration;
  int? efficiency;
  DateTime? endTime;
  int? infoCode;
  bool? isMainSleep;
  int? logId;
  int? minutesAfterWakeup;
  int? minutesAsleep;
  int? minutesAwake;
  int? minutesToFallAsleep;
  DateTime? startTime;
  int? timeInBed;
  String? type;
  SleepLevel? levels;
  
  SleepSession({this.dateOfSleep, this.duration, this.efficiency, this.endTime, this.infoCode, this.isMainSleep, 
    required this.logId, required this.minutesAfterWakeup, required this.minutesAsleep, required this.minutesAwake, this.minutesToFallAsleep, this.startTime, 
    this.timeInBed, this.type, this.levels});

  factory SleepSession.fromJson(Map<String, dynamic> parsedJson) => _$SleepSessionFromJson(parsedJson);

  Map<String, dynamic> toJson() => _$SleepSessionToJson(this);
}

class SleepLevel {
  List<SleepIntradayData>? sleepIntradayData;
  SleepIntradaySummary? sleepIntradaySummary;
    
    
    SleepLevel({this.sleepIntradayData, this.sleepIntradaySummary});

    factory SleepLevel.fromJson(Map<String, dynamic> parsedJson) => _$SleepLevelFromJson(parsedJson);

    Map<String, dynamic> toJson() => _$SleepLevelToJson(this);
  }
  
class SleepIntradayData {

  DateTime? dateTime;
  String? level;
  int? seconds;

  SleepIntradayData({this.dateTime, this.level, this.seconds});

  factory SleepIntradayData.fromJson(Map<String, dynamic> parsedJson) => _$SleepIntradayDataFromJson(parsedJson);

  Map<String, dynamic> toJson() => _$SleepIntradayDataToJson(this);

}



class SleepSummaryOverall {
  int? totalMinutesAsleep;
  int? totalSleepRecords;
  int? totalTimeInBed;
  SleepStageSummaryOverall? sleepStageSummary;
  
  SleepSummaryOverall({
      this.totalMinutesAsleep, this.totalSleepRecords, this.totalTimeInBed, this.sleepStageSummary  
  });

  factory SleepSummaryOverall.fromJson(Map<String, dynamic> parsedJson) => _$SleepSummaryOverallFromJson(parsedJson);

  Map<String, dynamic> toJson() => _$SleepSummaryOverallToJson(this);
  }
  
class SleepStageSummaryOverall {
  int? deep;
  int? light;
  int? rem;
  int? wake;

  SleepStageSummaryOverall({this.deep, this.light, this.rem, this.wake});

  factory SleepStageSummaryOverall.fromJson(Map<String, dynamic> parsedJson) => _$SleepStageSummaryOverallFromJson(parsedJson);

  Map<String, dynamic> toJson() => _$SleepStageSummaryOverallToJson(this);
}

class SleepIntradaySummary {
  int? deepIntradayMinutes;
  int? lightIntradayMinutes;
  int? remIntradayMinutes;
  int? wakeIntradayMinutes;
  int? deepIntradayCount;
  int? lightIntradayCount;
  int? remIntradayCount;
  int? wakeIntradayCount;
  int? deepIntradayMonthAvgMins;
  int? lightIntradayMonthAvgMins;
  int? remIntradayMonthAvgMins;
  int? wakeIntradayMonthAvgMins;

  
  SleepIntradaySummary({this.deepIntradayMinutes, this.lightIntradayMinutes, this.remIntradayMinutes, 
  this.wakeIntradayMinutes, this.deepIntradayCount, this.lightIntradayCount, this.remIntradayCount, this.wakeIntradayCount, this.deepIntradayMonthAvgMins,
  this.lightIntradayMonthAvgMins, this.remIntradayMonthAvgMins, this.wakeIntradayMonthAvgMins});
  
  factory SleepIntradaySummary.fromJson(Map<String, dynamic> parsedJson) => _$SleepIntradaySummaryFromJson(parsedJson);

  Map<String, dynamic> toJson() => _$SleepIntradaySummaryToJson(this);

}


class SleepIntradayDeepSummary {
  int? count;
  int? minutes; 
  int? thirtyDayAvgMinutes;

  SleepIntradayDeepSummary({this.count, this.minutes, this.thirtyDayAvgMinutes});

  factory SleepIntradayDeepSummary.fromJson(Map<String, dynamic> parsedJson) => _$SleepIntradayDeepSummaryFromJson(parsedJson);

  Map<String, dynamic> toJson() => _$SleepIntradayDeepSummaryToJson(this);

}

class SleepIntradayLightSummary {
  int? count;
  int? minutes; 
  int? thirtyDayAvgMinutes;

  SleepIntradayLightSummary({this.count, this.minutes, this.thirtyDayAvgMinutes});

  factory SleepIntradayLightSummary.fromJson(Map<String, dynamic> parsedJson) => _$SleepIntradayLightSummaryFromJson(parsedJson);

  Map<String, dynamic> toJson() => _$SleepIntradayLightSummaryToJson(this);

}

class SleepIntradayRemSummary {
  int? count;
  int? minutes; 
  int? thirtyDayAvgMinutes;

  SleepIntradayRemSummary({this.count, this.minutes, this.thirtyDayAvgMinutes});

  factory SleepIntradayRemSummary.fromJson(Map<String, dynamic> parsedJson) => _$SleepIntradayRemSummaryFromJson(parsedJson);

  Map<String, dynamic> toJson() => _$SleepIntradayRemSummaryToJson(this);
}

class SleepIntradayWakeSummary {
  int? count;
  int? minutes; 
  int? thirtyDayAvgMinutes;

  SleepIntradayWakeSummary({this.count, this.minutes, this.thirtyDayAvgMinutes});

  factory SleepIntradayWakeSummary.fromJson(Map<String, dynamic> parsedJson) => _$SleepIntradayWakeSummaryFromJson(parsedJson);

  Map<String, dynamic> toJson() => _$SleepIntradayWakeSummaryToJson(this);
}
  

class SleepEvent {
  DateTime? startTime;
  DateTime? endTime;
  bool? isMainSleep;
  SleepSession? sleepSession;
  
  SleepEvent({this.startTime, this.endTime, this.isMainSleep, this.sleepSession});

  DateTime get start_time { 
   return startTime!; 
  } 

  DateTime get end_time { 
   return endTime!; 
  } 

  bool get is_main_sleep { 
   return isMainSleep!; 
  }

  String toString() {

    if (startTime == null || endTime == null) {
      return 'Start / End Time is NULL';
    }

    String sleepOrNap = is_main_sleep ? "Main Sleep" : "Nap";
    final dateFormatter = DateFormat.jm();
    final start = dateFormatter.format(startTime!);
    final end = dateFormatter.format(endTime!);
    return '$sleepOrNap - $start to $end';
  }
}
  