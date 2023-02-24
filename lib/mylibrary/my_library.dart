import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebook/firebase/firebase_collection.dart';
import 'package:ebook/home/provider/internet_provider.dart';
import 'package:ebook/home/screen/no_internet_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../home/screen/continue_reading.dart';
import '../shimmers/book_list_shimmers.dart';
import '../utils/app_colors.dart';

class MyLibrary extends StatelessWidget {
  const MyLibrary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Consumer<InternetProvider>(builder: (context,internetSnapshot,_){
      internetSnapshot.checkInternet().then((value) {
      });
      return internetSnapshot.isInternet?
         Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: const Text('My Library'),
          ),
          body:  StreamBuilder(
            stream: FirebaseCollection().bookCollection.where('currentUserMobile',isEqualTo: FirebaseAuth.instance.currentUser?.phoneNumber).snapshots(),
            builder: (context,AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting){
                return const BookListShimmers();
              }else if (snapshot.hasError) {
                return const Center(child: Text("Something went wrong"));
              } else if (!snapshot.hasData) {
                return  const Center(child: Text("No Book Available"));
              } else if (snapshot.requireData.docChanges.isEmpty){
                return  const Center(child: Text("No Book Available"));
              } else if(snapshot.hasData){
                return ListView.builder(
                    itemCount: snapshot.data?.docs.length,
                    shrinkWrap: true,
                    itemBuilder: (context,index){
                      return GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>ContinueReadingScreen(snapshotData: snapshot.data?.docs[index])));
                        },
                        child: Container(
                          margin: const EdgeInsets.only(left: 10,right: 10,top: 15),
                          decoration: BoxDecoration(
                              border: Border.all(width: 0.1),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child:  Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ClipRRect(
                                child: Image.network(snapshot.data?.docs[index]['bookImage'],
                                  height: 100,width: 90,fit: BoxFit.fill,),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 20,top: 10,left: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children:  [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(snapshot.data?.docs[index]['bookTitle'],
                                                style : const TextStyle(color: AppColor.darkGreen,fontSize: 16),maxLines: 1,overflow: TextOverflow.ellipsis),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
                                            decoration: BoxDecoration(
                                                color: AppColor.darkGreen,
                                                borderRadius: BorderRadius.circular(10)
                                            ),
                                            child: Text('\$ ${snapshot.data?.docs[index]['bookPrice']}',
                                                style: const TextStyle(color: AppColor.whiteColor,fontSize: 12),maxLines: 1,overflow: TextOverflow.ellipsis),
                                          ),
                                        ],
                                      ),

                                      // Text(snapshot.data?.docs[index]['bookSubTitle'],
                                      //   style: const TextStyle(color: AppColor.blackColor,fontSize: 12),maxLines: 2,overflow: TextOverflow.ellipsis,textAlign: TextAlign.start,),
                                      const SizedBox(height: 5),
                                      Text(snapshot.data?.docs[index]['bookDescription'],
                                        style: const TextStyle(color: AppColor.darkGreyColor,fontSize: 10),maxLines: 2,overflow: TextOverflow.ellipsis,textAlign: TextAlign.start,),
                                      const SizedBox(height: 5),
                                      RatingBar.builder(
                                        initialRating: double.parse("${snapshot.data?.docs[index]['bookRating']}"),
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        ignoreGestures : true,
                                        itemSize: 10,
                                        itemBuilder: (context, _) => const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        onRatingUpdate: (rating) {
                                          debugPrint('$rating');
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }
          )
        ) : noInternetDialog();
      }
    );
  }
}
