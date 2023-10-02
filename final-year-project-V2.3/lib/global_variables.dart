import 'dart:async';

class GlobalVariables {
  static String userRole = "";
  static String name = "";
  static String id = "";
  static String department = "";
  static String email = "";
  static String specialization = "";
  static String userId = "";
static bool deviceConnection=false;
  static var totalDuration;


static StreamController<bool> _deviceConnectionStreamController = StreamController<bool>.broadcast();

  static Stream<bool> get deviceConnectionStream => _deviceConnectionStreamController.stream;

  static void updateDeviceConnection(bool newValue) {
    deviceConnection = newValue;
    _deviceConnectionStreamController.add(newValue);
  }





}
