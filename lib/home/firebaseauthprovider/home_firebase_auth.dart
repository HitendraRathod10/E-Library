import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../firebase/firebase_collection.dart';

class HomeFireAuth{

  Future<void> todayReadingData(
      {
        required String bookTitle,
        required String bookSubTitle,
        required String authorName,
        required String publisher,
        required String publishDate,
        required String bookDescription,
        required String country,
        required String bookType,
        required double bookRating,
        required String bookPrice,
        required String bookImage,
        required String currentUserMobile,
        required String bookPdf,
        required String currentDate,
        required Timestamp timestamp
      }
      ) async {
    DocumentReference documentReferencer = FirebaseCollection().todayReadingCollection.
    doc('${FirebaseAuth.instance.currentUser?.phoneNumber}$currentDate$bookTitle');

    Map<String, dynamic> data = <String, dynamic>{
      "bookTitle": bookTitle.toString(),
      "bookSubTitle": bookSubTitle.toString(),
      "authorName": authorName.toString(),
      "publisher": publisher.toString(),
      "publishDate": publishDate.toString(),
      "bookDescription": bookDescription.toString(),
      "country": country.toString(),
      "currentUserMobile": currentUserMobile.toString(),
      "bookType": bookType.toString(),
      "bookImage": bookImage.toString(),
      "bookPdf": bookPdf.toString(),
      "bookRating": bookRating,
      "bookPrice": bookPrice.toString(),
      "currentDate": currentDate.toString(),
      "timeStamp" : timestamp
    };
    debugPrint('Today Reading data=> $data');

    await documentReferencer
        .set(data)
        .whenComplete(() => debugPrint("Added Data"))
        .catchError((e) => debugPrint(e));
  }

  Future<void> userRating(
      {required String bookTitle,
        required String bookSubTitle,
        required String authorName,
        required String country,
        required String bookType,
        required String currentUserMobile,
        required String currentDate,
        required double userRating,
        required String userName,
        required String userImage,
        required Timestamp timestamp
      }
      ) async {
    DocumentReference documentReferencer = FirebaseCollection().userRatingCollection.
    doc('${FirebaseAuth.instance.currentUser?.phoneNumber} $bookTitle');

    Map<String, dynamic> data = <String, dynamic>{
      "bookTitle": bookTitle.toString(),
      "bookSubTitle": bookSubTitle.toString(),
      "authorName": authorName.toString(),
      'bookRating' : userRating,
      "country": country.toString(),
      "currentUserMobile": currentUserMobile.toString(),
      "bookType": bookType.toString(),
      "currentDate": currentDate.toString(),
      "userName": userName.toString(),
      "userImage": userImage.toString(),
      "timeStamp" : timestamp
    };
    debugPrint('User Rating Data=> $data');

    await documentReferencer
        .set(data)
        .whenComplete(() => debugPrint("Added User Rating Data"))
        .catchError((e) => debugPrint(e));
  }
}