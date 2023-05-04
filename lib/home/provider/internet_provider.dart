import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';

class InternetProvider extends ChangeNotifier {
  final Connectivity connectivity = Connectivity();
  bool isInternet = false;

  checkInternet() async {
    try{
      connectivity
          .onConnectivityChanged
          .listen((ConnectivityResult result,)
      async {
        if (result == ConnectivityResult.mobile ||
            result == ConnectivityResult.wifi) {
          isInternet = true;
          debugPrint('internet');
          notifyListeners();
        } else {
          isInternet = false;
          debugPrint('no internet');
          notifyListeners();
        }
      });
    }
    catch(e){
      debugPrint('Catch Block');
    }

  }
}