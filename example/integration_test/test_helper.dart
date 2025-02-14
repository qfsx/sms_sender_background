import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void setUpTestPlugin() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('com.marketing_gateway/sms');
  
  channel.setMockMethodCallHandler((MethodCall methodCall) async {
    switch (methodCall.method) {
      case 'checkSmsPermission':
        return true;
      case 'requestSmsPermission':
        return true;
      case 'sendSms':
        final phoneNumber = methodCall.arguments['phoneNumber'] as String;
        final message = methodCall.arguments['message'] as String;
        
        if (phoneNumber.isEmpty || message.isEmpty) {
          throw PlatformException(
            code: 'INVALID_ARGUMENT',
            message: 'Phone number and message are required',
          );
        }
        return true;
      default:
        throw PlatformException(
          code: 'UNSUPPORTED_METHOD',
          message: '${methodCall.method} is not supported',
        );
    }
  });
}
