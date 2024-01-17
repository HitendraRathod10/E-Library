import 'package:ebook/login/screen/otp_screen.dart';
import 'package:ebook/utils/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../firebase/firebase_collection.dart';
import '../../main.dart';
import '../../utils/app_preference_key.dart';
import '../../utils/app_utils.dart';
import '../../widget/bottom_navigation_bar.dart';
import '../../widget/provider/loading_provider.dart';
import '../screen/register_screen.dart';

class MobileAuthProvider extends ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;
  String verificationId = "";
  String currentUserId = "";
  String userPhone = "";
  String? phoneNumber;

  getSharedPreferenceData(String? phone) {
    userPhone=phone!;
    notifyListeners();
  }

  getCurrentUserAuthId(){
    final user = auth.currentUser;
    currentUserId = user!.uid;
  }

  userPhoneLogin(BuildContext context,userPhone,phoneNumber) async{
    //Provider.of<LoadingProvider>(context,listen: false).startLoading();
    String number = "+91$userPhone";
    // final prefs = await SharedPreferences.getInstance();
    // prefs.setString("phoneNumber", userPhone);
    try {
      FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: number,
          verificationCompleted: (PhoneAuthCredential credential) async {
            await auth.signInWithCredential(credential).then((value) {
              debugPrint("You are logged successfully");
              Provider.of<LoadingProvider>(context,listen: false).stopLoading();
              notifyListeners();
            });
          },
          verificationFailed: (FirebaseAuthException exception) {
            debugPrint("Failed>>> ${exception.message} : Code >>> ${exception.code} ");
            if (exception.code == 'invalid-phone-number') {
              Provider.of<LoadingProvider>(context,listen: false).stopLoading();
              AppUtils.instance.showToast(toastMessage: "Phone number is not valid.");
              notifyListeners();
            } if (exception.code == '17010' || exception.message == "We have blocked all requests from this device due to unusual activity.") {
              Provider.of<LoadingProvider>(context,listen: false).stopLoading();
              AppUtils.instance.showToast(toastMessage: "SMS verification code request failed\nTry again later");
              notifyListeners();
            }
          },
          codeSent: (String verificationID, int? resendToken) {
            verificationId = verificationID;
            Provider.of<LoadingProvider>(context,listen: false).stopLoading();
            notifyListeners();
            Navigator.push(context, MaterialPageRoute(builder: (context)=>  OtpScreen(verificationId: verificationID,phoneNumber: phoneNumber)));
          },
          timeout: const Duration(seconds: 90),
          codeAutoRetrievalTimeout: (String verificationID) {});
    } catch (e) {
      AppUtils.instance.showToast(toastMessage: "SMS verification code request failed\nTry again later");
      debugPrint("catch block");
      notifyListeners();
    }
    notifyListeners();
  }

  userPhoneVerify(BuildContext context,value,verification,phoneNumber)async{
    Provider.of<LoadingProvider>(context,listen: false).startLoading();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verification, smsCode: value.toString());
    await auth.signInWithCredential(credential).then((value) async {
       getCurrentUserAuthId();
       //userDetailsData();
      debugPrint("logged successfully");
      //setValue();
       Provider.of<LoadingProvider>(context,listen: false).stopLoading();

       var querySnapshots = await FirebaseCollection().userCollection.get();
       debugPrint("querySnapshots ${querySnapshots.docs.length}");
       debugPrint("querySnapshots ${querySnapshots.docs.isEmpty}");
       if(querySnapshots.docs.isEmpty){
         debugPrint("querySnapshots.docs.isEmpty");
         navigatorKey.currentState!.pushReplacement(MaterialPageRoute(builder: (context) => RegisterScreen(phoneNumber: phoneNumber)));
         
         notifyListeners();
       }else {
         for (var snapshot in querySnapshots.docChanges) {
           debugPrint("for loop querySnapshots");
           // debugPrint('Collection length ${querySnapshots.docs.length}');
           if (querySnapshots.docs.isEmpty) {
             debugPrint("querySnapshots.docs.isEmpty");
             navigatorKey.currentState!.pushReplacement(MaterialPageRoute(builder: (context) => RegisterScreen(phoneNumber: phoneNumber)));
             notifyListeners();
           } else {
             if (snapshot.doc.get('userMobile') == phoneNumber) {
               debugPrint("else if querySnapshots.docs.isEmpty");
               //print('If Inside =>>>>${snapshot.doc.get('userMobile')} == $phoneNumber');
               AppUtils.instance.setPref(PreferenceKey.boolKey, PreferenceKey.prefLogin, true);
               AppUtils.instance.setPref(PreferenceKey.stringKey, PreferenceKey.prefPhone, userPhone);
               getSharedPreferenceData(userPhone);
               navigatorKey.currentState!.pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => const BottomNavBarScreen()), (Route<dynamic> route) => false);

               //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const BottomNavBarScreen()));
               notifyListeners();
               break;
             } else {
               debugPrint("else else querySnapshots.docs.isEmpty");
               //print('Else Inside =======> ${snapshot.doc.get('userMobile')} == $phoneNumber');
               navigatorKey.currentState!.pushReplacement(MaterialPageRoute(builder: (context) => RegisterScreen(phoneNumber: phoneNumber)));
               notifyListeners();
             }
           }
           debugPrint("abc xyz");
           debugPrint("userPhone $userPhone");
           //print('OutSide ========>>>>>>>${snapshot.doc.get('userMobile')} == $phoneNumber');
           // debugPrint('userPhone $userPhone');
         }
       }
    }).catchError((error) {
      debugPrint("error $error");
      Provider.of<LoadingProvider>(context,listen: false).stopLoading();
      notifyListeners();
      AppUtils.instance.showToast(toastMessage: "Invalid OTP!");
      // debugPrint("error $error");
    });
  }
}