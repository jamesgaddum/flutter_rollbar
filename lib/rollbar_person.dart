import 'package:flutter/foundation.dart';

class RollbarPerson {
  final String id, email, username;

  RollbarPerson({
    @required this.id, 
    this.email, 
    this.username
  });

  Map toJson() => {
    'id': id,
    'email': email,
    'username': username,
  };
}