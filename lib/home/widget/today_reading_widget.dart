import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../firebase/firebase_collection.dart';
import '../../shimmers/reading_shimmers.dart';
import '../../utils/app_colors.dart';
import '../provider/home_provider.dart';
import '../screen/continue_reading.dart';

class TodayReadingWidget extends StatelessWidget {
  const TodayReadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
        builder: (context,todayReadingSnapshot,_){
        return FutureBuilder(
            future: todayReadingSnapshot.checkTodayData(),
            builder: (context,futureSnapshot){
              return Visibility(
                visible: todayReadingSnapshot.checkTodayReading,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(text: "What are you \nreading ",
                                style: TextStyle(color: AppColor.blackColor)
                            ),
                            TextSpan(
                                text: "today?",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.darkGreen,fontSize: 20
                                ))
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    StreamBuilder(
                        stream: FirebaseCollection().todayReadingCollection.
                        where('currentUserMobile',isEqualTo: FirebaseAuth.instance.currentUser?.phoneNumber).
                        where('currentDate',isEqualTo: DateTime.now().toString().substring(0,10))
                            .snapshots(),
                        builder: (context,AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
                          if (snapshot.hasError) {
                            return const Text('Something went wrong');
                          }else if (!snapshot.hasData) {
                            return const ReadingShimmers();
                          }
                          else if(snapshot.hasData){
                            return SizedBox(
                              height: 290,
                              child: ListView.builder(
                                  itemCount: snapshot.data?.docs.length,
                                  shrinkWrap: true,
                                  primary: true,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin: const EdgeInsets.only(left: 10),
                                      width: 200,
                                      child: Card(
                                        elevation: 5,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomRight: Radius.circular(30)),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            ClipRRect(
                                              borderRadius: const BorderRadius.only(topLeft: Radius.circular(20)),
                                              child: Image.network(snapshot.data?.docs[index]['bookImage'],
                                                  height: 180,width: double.infinity,fit: BoxFit.fill),
                                            ),
                                            const SizedBox(height: 10),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 10,right: 10),
                                              child: Text(snapshot.data?.docs[index]['bookTitle'],maxLines: 1,overflow: TextOverflow.ellipsis,
                                                  style: const TextStyle(color: AppColor.darkGreen,fontSize: 16)),
                                            ),
                                            Container(
                                              height: 38,
                                              padding: const EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
                                              child: Text(snapshot.data?.docs[index]['bookDescription'],
                                                style: const TextStyle(color: AppColor.blackColor,fontSize: 12),maxLines: 2,overflow: TextOverflow.ellipsis,),
                                            ),
                                            SizedBox(
                                              width: double.infinity,
                                              height: 35,
                                              child: ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ContinueReadingScreen(snapshotData: snapshot.data!.docs[index])));
                                                  },
                                                  style: ButtonStyle(
                                                      backgroundColor: MaterialStateProperty.all<Color>(AppColor.darkGreen),
                                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                          const RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomRight: Radius.circular(30)),
                                                          )
                                                      )
                                                  ),
                                                  child: const Text('Read')
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                              ),
                            );
                          }
                          else{
                            return const CircularProgressIndicator();
                          }
                        }
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              );
            });
      }
    );
  }
}
