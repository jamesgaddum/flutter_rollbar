class RollbarLogLevel {
  final String name;

  const RollbarLogLevel(this.name);

  @override
  String toString() => name;

  static const RollbarLogLevel CRITICAL = RollbarLogLevel('critical');
  static const RollbarLogLevel ERROR = RollbarLogLevel('error');
  static const RollbarLogLevel WARNING = RollbarLogLevel('warning');
  static const RollbarLogLevel INFO = RollbarLogLevel('info');
  static const RollbarLogLevel DEBUG = RollbarLogLevel('debug');
}