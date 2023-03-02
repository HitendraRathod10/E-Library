import 'package:ebook/login/screen/otp_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../firebase/firebase_collection.dart';
import '../../utils/app_preference_key.dart';
import '../../utils/app_utils.dart';
import '../../widget/bottom_navigation_bar.dart';
import '../../widget/provider/loading-provider.dart';
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
            debugPrint(exception.message);
            if (exception.code == 'invalid-phone-number') {
              Provider.of<LoadingProvider>(context,listen: false).stopLoading();
              AppUtils.instance.showToast(toastMessage: "Phone number is not valid.");
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
      //Provider.of<LoadingProvider>(context,listen: false).stopLoading();
      debugPrint("catch block");
      notifyListeners();
    }
    notifyListeners();
  }

  userPhoneVerify(BuildContext context,value,verification,phoneNumber)async{
    Provider.of<LoadingProvider>(context,listen: false).startLoading();
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verification, smsCode: value.toString());
    await auth.signInWithCredential(credential).then((value) async {
       getCurrentUserAuthId();
       //userDetailsData();
      debugPrint("logged successfully");
      //setValue();
       Provider.of<LoadingProvider>(context,listen: false).stopLoading();

       var querySnapshots = await FirebaseCollection().userCollection.get();
       print("querySnapshots ${querySnapshots.docs.length}");
       print("querySnapshots ${querySnapshots.docs.isEmpty}");
       if(querySnapshots.docs.isEmpty){
         print("querySnapshots.docs.isEmpty");
         Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => RegisterScreen(phoneNumber: phoneNumber)));
         notifyListeners();
       }else {
         for (var snapshot in querySnapshots.docChanges) {
           print("for loop querySnapshots");
           // debugPrint('Collection length ${querySnapshots.docs.length}');
           if (querySnapshots.docs.isEmpty) {
             print("querySnapshots.docs.isEmpty");
             Navigator.of(context).pushReplacement(MaterialPageRoute(
                 builder: (context) =>
                     RegisterScreen(phoneNumber: phoneNumber)));
             notifyListeners();
           } else {
             if (snapshot.doc.get('userMobile') == phoneNumber) {
               print("else if querySnapshots.docs.isEmpty");
               //print('If Inside =>>>>${snapshot.doc.get('userMobile')} == $phoneNumber');
               AppUtils.instance.setPref(
                   PreferenceKey.boolKey, PreferenceKey.prefLogin, true);
               AppUtils.instance.setPref(
                   PreferenceKey.stringKey, PreferenceKey.prefPhone, userPhone);
               getSharedPreferenceData(userPhone);
               Navigator.of(context).pushAndRemoveUntil(
                   MaterialPageRoute(
                       builder: (BuildContext context) =>
                       const BottomNavBarScreen()),
                       (Route<dynamic> route) => false);
               //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const BottomNavBarScreen()));
               notifyListeners();
               break;
             } else {
               print("else else querySnapshots.docs.isEmpty");
               //print('Else Inside =======> ${snapshot.doc.get('userMobile')} == $phoneNumber');
               Navigator.of(context).pushReplacement(MaterialPageRoute(
                   builder: (context) =>
                       RegisterScreen(phoneNumber: phoneNumber)));
               notifyListeners();
             }
           }
           print("abcxyz");
           print("userPhone $userPhone");
           //print('OutSide ========>>>>>>>${snapshot.doc.get('userMobile')} == $phoneNumber');
           // debugPrint('userPhone $userPhone');
         }
       }
    }).catchError((error) {
      print("error $error");
      Provider.of<LoadingProvider>(context,listen: false).stopLoading();
      notifyListeners();
      AppUtils.instance.showToast(toastMessage: "Invalid OTP!");
      // debugPrint("error $error");
    });
  }
}