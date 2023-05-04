import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';

import '../../firebase/firebase_collection.dart';

class LoginProvider extends ChangeNotifier{

  String? selectUserType;
  File? file;
  List<dynamic> userData = [];

  List<String> selectUserTypeList = ['User','Author'];

  get getUserType {
    notifyListeners();
    return selectUserTypeList;
  }

  //Compress Image File
  Future<File> imageSizeCompress(
      {required File image, quality = 100, percentage = 70}) async {
    var path = await FlutterNativeImage.compressImage(image.absolute.path,quality: 100,percentage: 70);
    return path;
  }

  //Pick Image File
  void selectImage(BuildContext context) async{
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.image
    );
    if(result == null) return;
    final filePath = result.files.single.path;
    File compressImage = await imageSizeCompress(image: File(filePath!));
    file = compressImage;
    notifyListeners();
  }

  Future<void> addEmployee(
      {required String userName,
        required String userEmail,
        required String userMobile,
        required String userType,
        required String userImage,
        required Timestamp timestamp
      }
      ) async {
    DocumentReference documentReferencer =
    FirebaseCollection().userCollection.doc(userMobile);

    Map<String, dynamic> data = <String, dynamic>{
      "userEmail": userEmail.toString(),
      "userName": userName.toString(),
      "userMobile": userMobile.toString(),
      "userType": userType.toString(),
      "userImage": userImage.toString(),
      "timeStamp" : timestamp
    };
    debugPrint('user data=> $data');

    FirebaseCollection().userCollection.get().then((querySnapshot) {
      for (var result in querySnapshot.docs) {
        debugPrint("${result.data()}");
        userData.add(result.data());
      }
    });
    await documentReferencer
        .set(data)
        .whenComplete(() => debugPrint("Added user Details"))
        .catchError((e) => debugPrint(e));
  }

}