import 'package:flutter_rollbar/rollbar_log_level.dart';
import 'package:meta/meta.dart';



class RollbarTelemetryType {
  final String name;

  const RollbarTelemetryType(this.name);

  @override
  String toString() => name;

  static const RollbarTelemetryType LOG = RollbarTelemetryType('log');
  static const RollbarTelemetryType ERROR = RollbarTelemetryType('error');
}

class RollbarTelemetry {
  final RollbarLogLevel level;
  final RollbarTelemetryType type;
  final String source;
  final int timestamp;
  final String message;
  final String stack;

  RollbarTelemetry({@required this.level, @required this.type, this.source = 'client', int timestamp, @required this.message, this.stack})
      : this.timestamp = timestamp ?? DateTime.now().millisecondsSinceEpoch;

  Map toJson() => {
    'level': level.name,
    'type': type.name,
    'source': source,
    'timestamp_ms': timestamp,
    'body': {
      'message': message,
      'stack': stack,
    },
  };
}

