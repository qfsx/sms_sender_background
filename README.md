# SMS Sender Background

A Flutter plugin for sending SMS messages with support for dual SIM cards, permission handling, and multi-part messages.

## Features

- Send SMS messages from your Flutter app
- Support for dual SIM cards (specify SIM slot)
- Automatic permission handling (request and check SMS permissions)
- Support for long messages (automatically splits into multi-part messages)
- Error handling and status reporting

## Getting Started

### Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  sms_sender_background:
    git:
      url: https://github.com/qfsx/sms_sender_background.git
```

### Android Setup

Add the following permission to your Android Manifest (`android/app/src/main/AndroidManifest.xml`):

```xml
<uses-permission android:name="android.permission.SEND_SMS"/>
```

### Usage

```dart
import 'package:sms_sender_background/sms_sender.dart';

// Create an instance
final smsSender = SmsSender();

// Check SMS permission
bool hasPermission = await smsSender.checkSmsPermission();

// Request permission if needed
if (!hasPermission) {
  hasPermission = await smsSender.requestSmsPermission();
}

// Send SMS
if (hasPermission) {
  try {
    bool success = await smsSender.sendSms(
      phoneNumber: '+1234567890',
      message: 'Hello from Flutter!',
      simSlot: 0, // Optional: specify SIM slot (0 or 1)
    );
    print('SMS sent: $success');
  } catch (e) {
    print('Error sending SMS: $e');
  }
}
```

## Additional Features

### Dual SIM Support

To send an SMS using a specific SIM card:

```dart
await smsSender.sendSms(
  phoneNumber: '+1234567890',
  message: 'Hello!',
  simSlot: 1, // Use second SIM card
);
```

### Long Messages

The plugin automatically handles long messages by splitting them into multiple parts:

```dart
await smsSender.sendSms(
  phoneNumber: '+1234567890',
  message: 'A very long message that will be automatically split...',
);
```

## Error Handling

The plugin provides detailed error information through exceptions:

- `PlatformException` with code "PERMISSION_DENIED" when SMS permission is not granted
- `PlatformException` with code "INVALID_ARGUMENT" when phone number or message is empty
- `PlatformException` with code "SMS_SEND_ERROR" when SMS sending fails

## Contributing

Feel free to contribute to this project:

1. Fork it
2. Create your feature branch (`git checkout -b feature/my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin feature/my-new-feature`)
5. Create a new Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details
