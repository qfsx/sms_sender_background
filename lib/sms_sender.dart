// You have generated a new plugin project without specifying the `--platforms`
// flag. A plugin project with no platform support was generated. To add a
// platform, run `flutter create -t plugin --platforms <platforms> .` under the
// same directory. You can also find a detailed instruction on how to add
// platforms in the `pubspec.yaml` at
// https://flutter.dev/to/pubsec-plugin-platforms.

import 'dart:async';
import 'package:flutter/services.dart';

/// A Flutter plugin for sending SMS messages.
class SmsSender {
  static const MethodChannel _channel = MethodChannel('com.marketing_gateway.sms_sender');
  
  /// Sends an SMS message to the specified phone number.
  /// 
  /// Parameters:
  /// - [phoneNumber]: The recipient's phone number in international format (e.g., '+1234567890')
  /// - [message]: The text message to send
  /// - [simSlot]: (Optional) The SIM card slot to use for dual-SIM devices (0 or 1). Defaults to 0
  /// 
  /// Returns:
  /// - [Future<bool>]: true if the message was sent successfully, false otherwise
  /// 
  /// Throws:
  /// - [PlatformException] if there's an error sending the message or if SMS permission is not granted
  Future<bool> sendSms({
    required String phoneNumber,
    required String message,
    int simSlot = 0,
  }) async {
    try {
      final bool? result = await _channel.invokeMethod('sendSms', {
        'phoneNumber': phoneNumber,
        'message': message,
        'simSlot': simSlot,
      });
      return result ?? false;
    } on PlatformException catch (e) {
      throw PlatformException(
        code: e.code,
        message: 'Failed to send SMS: ${e.message}',
        details: e.details,
      );
    }
  }

  /// Checks if the app has permission to send SMS messages.
  /// 
  /// Returns:
  /// - [Future<bool>]: true if SMS permission is granted, false otherwise
  Future<bool> checkSmsPermission() async {
    try {
      final bool? result = await _channel.invokeMethod('checkSmsPermission');
      return result ?? false;
    } on PlatformException catch (e) {
      throw PlatformException(
        code: e.code,
        message: 'Failed to check SMS permission: ${e.message}',
        details: e.details,
      );
    }
  }

  /// Requests SMS permission from the user.
  /// 
  /// Returns:
  /// - [Future<bool>]: true if permission was granted, false if denied
  Future<bool> requestSmsPermission() async {
    try {
      final bool? result = await _channel.invokeMethod('requestSmsPermission');
      return result ?? false;
    } on PlatformException catch (e) {
      throw PlatformException(
        code: e.code,
        message: 'Failed to request SMS permission: ${e.message}',
        details: e.details,
      );
    }
  }
}
