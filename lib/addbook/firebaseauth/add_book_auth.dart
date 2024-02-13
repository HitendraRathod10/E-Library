import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../firebase/firebase_collection.dart';

class AddBookProvider extends ChangeNotifier{

  String? selectCountry,selectBookGenre;
  List<dynamic> bookData = [];

  List<String> selectCountryList = ['India','USA','Russia','Australia','England'];
  List<String> selectBookGenreList = ['History','Horror Fiction','Novel','Action','Mystery',
  'Western','Science','Children','Magical','Drama','Crime','Poetry','Comic','Romance','Historical'];
  Icon getCountryIcon(){
    if(selectCountry== "India"){
      return const Icon(Icons.currency_rupee);
    }else if(selectCountry== "USA"){
      return const Icon(Icons.attach_money);
    }else if(selectCountry== "Russia"){
      return const Icon(Icons.currency_ruble);
    }else if(selectCountry== "Australia"){
      return const Icon(Icons.euro);
    }else if(selectCountry== "England"){
      return const Icon(Icons.currency_pound);
    }else{
      return const Icon(Icons.currency_rupee);
    }
  }

  get getCountry {
    notifyListeners();
    return selectCountryList;
  }
  get getBookGenre {
    notifyListeners();
    return selectBookGenreList;
  }

  Future<void> createBook(
      {required String bookTitle,
        required String bookSubTitle,
        required String authorName,
        required String publisher,
        required String publishDate,
        required String bookDescription,
        required String country,
        required String bookType,
        required String userName,
        required String bookPrice,
        required String bookImage,
        required String currentUserMobile,
        required double bookRating,
        required String bookPdf,
        required Timestamp timestamp
      }
      ) async {
    DocumentReference documentReferencer = FirebaseCollection().bookCollection.doc(bookTitle);

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
      "userName": userName.toString(),
      "bookImage": bookImage.toString(),
      "bookPdf": bookPdf.toString(),
      "bookRating": bookRating,
      "bookPrice": bookPrice.toString(),
      "timeStamp" : timestamp
    };
    debugPrint('added data=> $data');

    FirebaseCollection().bookCollection.get().then((querySnapshot) {
      for (var result in querySnapshot.docs) {
        debugPrint("${result.data()}");
        bookData.add(result.data());
      }
    });
    await documentReferencer
        .set(data)
        .whenComplete(() => debugPrint("Added book"))
        .catchError((e) => debugPrint(e));
  }

  Future<void> addAuthorDetails(
      {required String authorName,
        required String authorImage,
        required String authorDesignation,
        required String authorAbout,
        required String authorBookImage,
        required String authorBookName,
        required String authorBookDescription,
        required Timestamp timestamp
      }
      ) async {
    DocumentReference documentReferencer = FirebaseCollection().authorCollection.doc(authorName);

    Map<String, dynamic> data = <String, dynamic>{
      "authorName": authorName.toString(),
      "authorImage": authorImage.toString(),
      "authorDesignation": authorDesignation.toString(),
      "authorAbout": authorAbout.toString(),
      "authorBookImage": authorBookImage.toString(),
      "authorBookName": authorBookName.toString(),
      "authorBookDescription": authorBookDescription.toString(),
      "timeStamp" : timestamp
    };
    debugPrint('added data=> $data');

    // FirebaseCollection().authorCollection.get().then((querySnapshot) {
    //   for (var result in querySnapshot.docs) {
    //     print("${result.data()}");
    //     authorData.add(result.data());
    //   }
    // });
    await documentReferencer
        .set(data)
        .whenComplete(() => debugPrint("Added book"))
        .catchError((e) => debugPrint(e));
  }

}