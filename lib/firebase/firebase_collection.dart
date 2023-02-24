import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseCollection {
  static const String userCollectionName = 'user';
  static const String bookCollectionName = 'book';
  static const String bookTypeCollectionName = 'bookType';
  static const String authorCollectionName = 'author';
  static const String todayReadingCollectionName = 'todayReading';
  static const String userRatingCollectionName = 'rating';
  static String currentUserId = FirebaseAuth.instance.currentUser!.phoneNumber.toString().substring(3,13);
  CollectionReference userCollection = FirebaseFirestore.instance.collection(userCollectionName);
  CollectionReference bookCollection = FirebaseFirestore.instance.collection(bookCollectionName);
  CollectionReference bookTypeCollection = FirebaseFirestore.instance.collection(bookTypeCollectionName);
  CollectionReference authorCollection = FirebaseFirestore.instance.collection(authorCollectionName);
  CollectionReference todayReadingCollection = FirebaseFirestore.instance.collection(todayReadingCollectionName);
  CollectionReference userRatingCollection = FirebaseFirestore.instance.collection(userRatingCollectionName);
}