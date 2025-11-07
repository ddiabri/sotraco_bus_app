import 'dart:io';

class AdHelper {
  // IMPORTANT: Set to false when building for Play Store release
  // Set to true for development/testing
  static const bool useTestAds = false;

  static String get bannerAdUnitId {
    if (useTestAds) {
      // Test AdMob IDs - These always work and show test ads
      if (Platform.isAndroid) {
        return 'ca-app-pub-3940256099942544/6300978111'; // Test banner ID
      } else if (Platform.isIOS) {
        return 'ca-app-pub-3940256099942544/2934735716'; // Test banner ID
      } else {
        throw UnsupportedError('Unsupported platform');
      }
    } else {
      // Production AdMob IDs
      if (Platform.isAndroid) {
        return 'ca-app-pub-4878336509068044/5000887720';
      } else if (Platform.isIOS) {
        return 'ca-app-pub-4878336509068044/5000887720'; // Use same ID or create separate iOS unit
      } else {
        throw UnsupportedError('Unsupported platform');
      }
    }
  }
}
