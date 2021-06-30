part of 'sleep_model.dart';

ResponseData _$ResponseDataFromJson(Map<String, dynamic> json) {
  return ResponseData(
    data: (json['data'] as List<dynamic>?)
        ?.map((e) => SleepData.fromJson(e as Map<String, dynamic>))
        .toList(),
    result: json['result'] as String?,
  );
}

Map<String, dynamic> _$ResponseDataToJson(ResponseData instance) =>
    <String, dynamic>{
      'data': instance.data,
      'result': instance.result,
    };

SleepData _$SleepDataFromJson(Map<String, dynamic> json) {
  DateTime date = DateTime.parse(json['date']);
  return SleepData(
    date: DateTime.utc(date.year, date.month, date.day),
    value: json['value'] == null || json['value'] == 0 
    ? null 
    : SleepValue.fromJson(json['value'] as Map<String, dynamic>)
  );
}

Map<String, dynamic> _$SleepDataToJson(SleepData instance) => <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'value': instance.value,
    };

SleepValue _$SleepValueFromJson(Map<String, dynamic> json) {
  return SleepValue(
    sleepList: (json['sleep'] as List<dynamic>?)
        ?.map((e) => SleepSession.fromJson(e as Map<String, dynamic>))
        .toList(),
    sleepSummaryOverall: SleepSummaryOverall.fromJson(
        json['summary'] as Map<String, dynamic>),
  );

  
}

Map<String, dynamic> _$SleepValueToJson(SleepValue instance) =>
    <String, dynamic>{
      'sleep': instance.sleepList,
      'summary': instance.sleepSummaryOverall,
    };

SleepSession _$SleepSessionFromJson(Map<String, dynamic> json) {
  return SleepSession(
    dateOfSleep: json['dateOfSleep'] == null
        ? null
        : DateTime.parse(json['dateOfSleep'] as String),
    duration: json['duration'] as int?,
    efficiency: json['efficiency'] as int?,
    endTime: json['endTime'] == null
        ? null
        : DateTime.parse(json['endTime'] as String),
    infoCode: json['infoCode'] as int?,
    isMainSleep: json['isMainSleep'] as bool?,
    logId: json['logId'] as int?,
    minutesAfterWakeup: json['minutesAfterWakeup'] as int?,
    minutesAsleep: json['minutesAsleep'] as int?,
    minutesAwake: json['minutesAwake'] as int?,
    minutesToFallAsleep: json['minutesToFallAsleep'] as int?,
    startTime: json['startTime'] == null
        ? null
        : DateTime.parse(json['startTime'] as String),
    timeInBed: json['timeInBed'] as int?,
    type: json['type'] as String?,
    levels: json['levels'] == null
        ? null
        : SleepLevel.fromJson(json['levels'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$SleepSessionToJson(SleepSession instance) =>
    <String, dynamic>{
      'dateOfSleep': instance.dateOfSleep?.toIso8601String(),
      'duration': instance.duration,
      'efficiency': instance.efficiency,
      'endTime': instance.endTime?.toIso8601String(),
      'infoCode': instance.infoCode,
      'isMainSleep': instance.isMainSleep,
      'logId': instance.logId,
      'minutesAfterWakeup': instance.minutesAfterWakeup,
      'minutesAsleep': instance.minutesAsleep,
      'minutesAwake': instance.minutesAwake,
      'minutesToFallAsleep': instance.minutesToFallAsleep,
      'startTime': instance.startTime?.toIso8601String(),
      'timeInBed': instance.timeInBed,
      'type': instance.type,
      'levels': instance.levels,
    };

SleepLevel _$SleepLevelFromJson(Map<String, dynamic> json) {
  return SleepLevel(
    sleepIntradayData: (json['data'] as List<dynamic>?)
        ?.map((e) => SleepIntradayData.fromJson(e as Map<String, dynamic>))
        .toList(),
    sleepIntradaySummary: json['summary'] == null
        ? null
        : SleepIntradaySummary.fromJson(
            json['summary'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$SleepLevelToJson(SleepLevel instance) =>
    <String, dynamic>{
      'data': instance.sleepIntradayData,
      'summary': instance.sleepIntradaySummary,
    };

SleepIntradayData _$SleepIntradayDataFromJson(Map<String, dynamic> json) {
  return SleepIntradayData(
    dateTime: json['dateTime'] == null
        ? null
        : DateTime.parse(json['dateTime'] as String),
    level: json['level'] as String?,
    seconds: json['seconds'] as int?,
  );
}

Map<String, dynamic> _$SleepIntradayDataToJson(SleepIntradayData instance) =>
    <String, dynamic>{
      'dateTime': instance.dateTime?.toIso8601String(),
      'level': instance.level,
      'seconds': instance.seconds,
    };

SleepSummaryOverall _$SleepSummaryOverallFromJson(Map<String, dynamic> json) {
  return SleepSummaryOverall(
    totalMinutesAsleep: json['totalMinutesAsleep'] == null ? null : json['totalMinutesAsleep'] as int,
    totalSleepRecords: json['totalSleepRecords'] == null ? null : json['totalSleepRecords'] as int,
    totalTimeInBed: json['totalTimeInBed'] == null ? null : json['totalTimeInBed'] as int,
    sleepStageSummary: json['stages'] == null
        ? null
        : SleepStageSummaryOverall.fromJson(
            json['stages'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$SleepSummaryOverallToJson(
        SleepSummaryOverall instance) =>
    <String, dynamic>{
      'totalMinutesAsleep': instance.totalMinutesAsleep,
      'totalSleepRecords': instance.totalSleepRecords,
      'totalTimeInBed': instance.totalTimeInBed,
      'stages': instance.sleepStageSummary,
    };

SleepStageSummaryOverall _$SleepStageSummaryOverallFromJson(
    Map<String, dynamic> json) {
  return SleepStageSummaryOverall(
    deep: json['deep'] as int?,
    light: json['light'] as int?,
    rem: json['rem'] as int?,
    wake: json['wake'] as int?,
  );
}

Map<String, dynamic> _$SleepStageSummaryOverallToJson(
        SleepStageSummaryOverall instance) =>
    <String, dynamic>{
      'deep': instance.deep,
      'light': instance.light,
      'rem': instance.rem,
      'wake': instance.wake,
    };

SleepIntradaySummary _$SleepIntradaySummaryFromJson(Map<String, dynamic> json) {
  return SleepIntradaySummary(
    deepIntradayMinutes:
        json['deep']?['minutes'],
    lightIntradayMinutes:
        json['light']?['minutes'],
    remIntradayMinutes:
        json['rem']?['minutes'],
    wakeIntradayMinutes:
        json['wake']?['minutes'],
    deepIntradayCount:
        json['wake']?['minutes'],
    lightIntradayCount:
        json['wake']?['minutes'],
    remIntradayCount:
        json['wake']?['minutes'],
    wakeIntradayCount:
        json['wake']?['minutes'],
    deepIntradayMonthAvgMins: json['wake']?['minutes'],
    lightIntradayMonthAvgMins: json['wake']?['minutes'],
    remIntradayMonthAvgMins: json['wake']?['minutes'],
    wakeIntradayMonthAvgMins: json['wake']?['minutes'],
  );
}

Map<String, dynamic> _$SleepIntradaySummaryToJson(
        SleepIntradaySummary instance) =>
    <String, dynamic>{
      'deepIntradayMinutes': instance.deepIntradayMinutes,
      'lightIntradayMinutes': instance.lightIntradayMinutes,
      'remIntradayMinutes': instance.remIntradayMinutes,
      'wakeIntradayMinutes': instance.wakeIntradayMinutes,
      'deepIntradayCount': instance.deepIntradayCount,
      'lightIntradayCount': instance.lightIntradayCount,
      'remIntradayCount': instance.remIntradayCount,
      'wakeIntradayCount': instance.wakeIntradayCount,
      'deepIntradayMonthAvgMins': instance.deepIntradayMonthAvgMins,
      'lightIntradayMonthAvgMins': instance.lightIntradayMonthAvgMins,
      'remIntradayMonthAvgMins': instance.remIntradayMonthAvgMins,
      'wakeIntradayMonthAvgMins': instance.wakeIntradayMonthAvgMins,
    };

SleepIntradayDeepSummary _$SleepIntradayDeepSummaryFromJson(
    Map<String, dynamic> json) {
  return SleepIntradayDeepSummary(
    count: json['count'] as int?,
    minutes: json['minutes'] as int?,
    thirtyDayAvgMinutes: json['thirtyDayAvgMinutes'] as int?,
  );
}

Map<String, dynamic> _$SleepIntradayDeepSummaryToJson(
        SleepIntradayDeepSummary instance) =>
    <String, dynamic>{
      'count': instance.count,
      'minutes': instance.minutes,
      'thirtyDayAvgMinutes': instance.thirtyDayAvgMinutes,
    };

SleepIntradayLightSummary _$SleepIntradayLightSummaryFromJson(
    Map<String, dynamic> json) {
  return SleepIntradayLightSummary(
    count: json['count'] as int?,
    minutes: json['minutes'] as int?,
    thirtyDayAvgMinutes: json['thirtyDayAvgMinutes'] as int?,
  );
}

Map<String, dynamic> _$SleepIntradayLightSummaryToJson(
        SleepIntradayLightSummary instance) =>
    <String, dynamic>{
      'count': instance.count,
      'minutes': instance.minutes,
      'thirtyDayAvgMinutes': instance.thirtyDayAvgMinutes,
    };

SleepIntradayRemSummary _$SleepIntradayRemSummaryFromJson(
    Map<String, dynamic> json) {
  return SleepIntradayRemSummary(
    count: json['count'] as int?,
    minutes: json['minutes'] as int?,
    thirtyDayAvgMinutes: json['thirtyDayAvgMinutes'] as int?,
  );
}

Map<String, dynamic> _$SleepIntradayRemSummaryToJson(
        SleepIntradayRemSummary instance) =>
    <String, dynamic>{
      'count': instance.count,
      'minutes': instance.minutes,
      'thirtyDayAvgMinutes': instance.thirtyDayAvgMinutes,
    };

SleepIntradayWakeSummary _$SleepIntradayWakeSummaryFromJson(
    Map<String, dynamic> json) {
  return SleepIntradayWakeSummary(
    count: json['count'] as int?,
    minutes: json['minutes'] as int?,
    thirtyDayAvgMinutes: json['thirtyDayAvgMinutes'] as int?,
  );
}

Map<String, dynamic> _$SleepIntradayWakeSummaryToJson(
        SleepIntradayWakeSummary instance) =>
    <String, dynamic>{
      'count': instance.count,
      'minutes': instance.minutes,
      'thirtyDayAvgMinutes': instance.thirtyDayAvgMinutes,
    };
