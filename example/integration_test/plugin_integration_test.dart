// This is a basic Flutter integration test.
//
// Since integration tests run in a full Flutter application, they can interact
// with the host side of a plugin implementation, unlike Dart unit tests.
//
// For more information about Flutter integration tests, please see
// https://flutter.dev/to/integration-testing


import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:sms_sender_background/sms_sender.dart';
import 'test_helper.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  setUpAll(() {
    setUpTestPlugin();
  });

  group('SMS Sender Plugin Tests', () {
    late SmsSender smsSender;

    setUp(() {
      smsSender = SmsSender();
    });

    testWidgets('Test SMS permission check', (WidgetTester tester) async {
      final hasPermission = await smsSender.checkSmsPermission();
      expect(hasPermission, isTrue);
    });

    testWidgets('Test SMS permission request', (WidgetTester tester) async {
      final granted = await smsSender.requestSmsPermission();
      expect(granted, isTrue);
    });

    testWidgets('Test SMS sending with valid data', (WidgetTester tester) async {
      final result = await smsSender.sendSms(
        phoneNumber: '+1234567890',
        message: 'Test message',
      );
      expect(result, isTrue);
    });

    testWidgets('Test SMS sending with empty phone number', (WidgetTester tester) async {
      expect(() => smsSender.sendSms(
        phoneNumber: '',
        message: 'Test message',
      ), throwsA(isA<PlatformException>()));
    });

    testWidgets('Test SMS sending with empty message', (WidgetTester tester) async {
      expect(() => smsSender.sendSms(
        phoneNumber: '+1234567890',
        message: '',
      ), throwsA(isA<PlatformException>()));
    });

    testWidgets('Test SMS sending with custom SIM slot', (WidgetTester tester) async {
      final result = await smsSender.sendSms(
        phoneNumber: '+1234567890',
        message: 'Test message',
        simSlot: 1,
      );
      expect(result, isTrue);
    });
  });
}
