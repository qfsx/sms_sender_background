import 'package:flutter_test/flutter_test.dart';
import 'package:sms_sender_background/sms_sender.dart';
import 'package:sms_sender_background/sms_sender_platform_interface.dart';
import 'package:sms_sender_background/sms_sender_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockSmsSenderPlatform
    with MockPlatformInterfaceMixin
    implements SmsSenderPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final SmsSenderPlatform initialPlatform = SmsSenderPlatform.instance;

  test('$MethodChannelSmsSender is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelSmsSender>());
  });

  test('getPlatformVersion', () async {
    SmsSender smsSenderPlugin = SmsSender();
    MockSmsSenderPlatform fakePlatform = MockSmsSenderPlatform();
    SmsSenderPlatform.instance = fakePlatform;

    expect(await smsSenderPlugin.getPlatformVersion(), '42');
  });
}
