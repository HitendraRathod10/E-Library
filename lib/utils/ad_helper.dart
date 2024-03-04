import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-9134781771825641/9086399324';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-9134781771825641/9086399324';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-9134781771825641/1757793392';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-9134781771825641/1757793392';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}