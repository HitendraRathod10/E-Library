import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../firebase/firebase_collection.dart';

class HomeProvider extends ChangeNotifier{

  bool checkTodayReading = false;

  Future checkTodayData() async {
    var querySnapshots = await FirebaseCollection().todayReadingCollection.
    where('currentUserMobile',isEqualTo: FirebaseAuth.instance.currentUser?.phoneNumber).
    where('currentDate',isEqualTo: DateTime.now().toString().substring(0,10)).get();
    if(querySnapshots.docs.isEmpty){
      checkTodayReading = false;
      notifyListeners();
    } else{
      checkTodayReading = true;
      notifyListeners();
    }
  }

}