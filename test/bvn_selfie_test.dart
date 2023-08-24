// import 'package:flutter_test/flutter_test.dart';
// import 'package:bvn_selfie/bvn_selfie_platform_interface.dart';
// import 'package:bvn_selfie/bvn_selfie_method_channel.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';

// class MockBvnSelfiePlatform
//     with MockPlatformInterfaceMixin
//     implements BvnSelfiePlatform {
//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
// }

// void main() {
//   final BvnSelfiePlatform initialPlatform = BvnSelfiePlatform.instance;

//   test('$MethodChannelBvnSelfie is the default instance', () {
//     expect(initialPlatform, isInstanceOf<MethodChannelBvnSelfie>());
//   });

//   test('getPlatformVersion', () async {
//     BvnSelfie bvnSelfiePlugin = BvnSelfie();
//     MockBvnSelfiePlatform fakePlatform = MockBvnSelfiePlatform();
//     BvnSelfiePlatform.instance = fakePlatform;

//     expect(await bvnSelfiePlugin.getPlatformVersion(), '42');
//   });
// }
