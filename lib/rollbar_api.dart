import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_rollbar/rollbar_types.dart';
import 'package:requests/requests.dart';

class RollbarApi {
  Future sendReport({
    @required String accessToken, 
    @required String message, 
    @required List<RollbarTelemetry> telemetry, 
    Map clientData, 
    RollbarPerson person, 
    String environment
  }) async {
    var response = await Requests.post(
      'https://api.rollbar.com/api/1/item/',
      body: {
        'access_token': accessToken,
        'data': {
          'environment': environment,
          'platform': Platform.isAndroid ? 'android' : 'ios',
          'framework': 'flutter',
          'language': 'dart',
          'body': {
            'message': {
              'body': message,
            },
            'telemetry': telemetry.map((item) => item.toJson()).toList(),
          },
          'person': person?.toJson(),
          'client': clientData,
          'notifier': {
            'name': 'flutter_rollbar',
            'version': '0.0.3',
          }
        }
      },
      bodyEncoding: RequestBodyEncoding.JSON
    );
    response.throwForStatus();
  }
}
