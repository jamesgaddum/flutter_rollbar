library flutter_rollbar;

import 'dart:async';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_rollbar/rollbar_api.dart';
import 'package:flutter_rollbar/rollbar_log_level.dart';
import 'package:flutter_rollbar/rollbar_person.dart';
import 'package:flutter_rollbar/rollbar_telemetry.dart';
import 'package:package_info/package_info.dart';

export './rollbar_telemetry.dart';
export './rollbar_person.dart';
export './rollbar_log_level.dart';

class Rollbar {
  static var _instance = Rollbar._internal();

  factory Rollbar() => _instance;

  static void reset() async {
    _instance = Rollbar._internal();
    await _instance._getClientData();
  }

  final _api = RollbarApi();

  List<RollbarTelemetry> _telemetry = [];
  List<RollbarTelemetry> get telemetry => _telemetry;

  RollbarPerson person;
  String environment;
  String accessToken;
  Map<String, dynamic> _clientData;

  Rollbar._internal();

  Future initialise() async {
    await _getClientData();
  }
    
  void addTelemetry(RollbarTelemetry telemetry) {
    _telemetry.add(telemetry);
  }

  Future log({
    @required String message, 
    @required RollbarLogLevel level,
    dynamic data,
  }) async {
    if (data != null) data['body'] = message;
    else data = {
      'body': message
    };
    return _api.sendMessage(
      accessToken: accessToken, 
      data: data,
      level: level,
      clientData: _clientData, 
      person: person, 
      environment: environment
    );
  }

  Future info({
    @required String message, 
    dynamic data,
  }) async {
    await log(
      message: message,
      level: RollbarLogLevel.INFO,
      data: data
    );
  }

  Future error({
    @required String message, 
    dynamic data,
  }) async {
    await log(
      message: message,
      level: RollbarLogLevel.ERROR,
      data: data
    );
  }

  Future _getClientData() async {
    var packageInfo = await PackageInfo.fromPlatform();
    
    _clientData = <String, dynamic>{
      'version_code': packageInfo.buildNumber,
      'version_name': packageInfo.version,
    };

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      _clientData['android'] = {
        'phone_model': androidInfo.model,
        'android_version': androidInfo.version.release,
      };
    }

    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      _clientData['ios'] = {
        'ios_version': iosInfo.systemVersion,
        'device_code': iosInfo.utsname.machine,
      };
    }
  }
}
