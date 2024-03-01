import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-9134781771825641/9086399324';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-9134781771825641/9086399324';
    } else {
      throw new UnsupportedError('Unsupported platform');
    }
  }
}