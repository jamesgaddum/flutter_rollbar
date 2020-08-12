import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_rollbar/rollbar_log_level.dart';
import 'package:flutter_rollbar/rollbar_person.dart';
import 'package:requests/requests.dart';

class RollbarApi {

  Future sendMessage({
    @required String accessToken, 
    @required dynamic data,
    @required RollbarLogLevel level,
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
            'message': data,
          },
          'level': level.name,
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
