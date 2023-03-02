import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebook/home/screen/continue_reading.dart';
import 'package:ebook/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../firebase/firebase_collection.dart';
import '../../shimmers/book_list_shimmers.dart';

class ContinueReadingWidget extends StatelessWidget {
  const ContinueReadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseCollection().bookCollection.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const BookListShimmers();
          }else if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          } else if (!snapshot.hasData) {
            return const BookListShimmers();
          } else if (snapshot.requireData.docChanges.isEmpty){
            return const Center(child: Text("No Data Found"));
          }
          else{
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>ContinueReadingScreen(snapshotData: snapshot.data?.docs[index],)));
                    },
                    child: Container(
                      margin: const EdgeInsets.only(left: 15,right: 10),
                      child: Card(
                        elevation: 5,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(topRight: Radius.circular(20),bottomRight: Radius.circular(20)),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(topRight: Radius.circular(20),bottomRight: Radius.circular(20)),
                              border: Border.all(width: 0.3,color: AppColor.darkGreen)
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ClipRRect(
                                child: Image.network(snapshot.data?.docs[index]['bookImage'],
                                    height: 100,width: 90,fit: BoxFit.contain
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 20,top: 10,left: 10),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children:  [
                                          Text(snapshot.data?.docs[index]['bookTitle'],
                                              style: const TextStyle(color: AppColor.darkGreen,fontSize: 16),maxLines: 1,overflow: TextOverflow.ellipsis),
                                          const SizedBox(height: 5),
                                          Text(snapshot.data?.docs[index]['bookDescription'],
                                              style: const TextStyle(color: AppColor.blackColor,fontSize: 10),maxLines: 2,
                                              overflow: TextOverflow.ellipsis,textAlign: TextAlign.start),
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
                                          )
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(top: 10,left: 10),
                                          child: Text('Book Type',
                                              style: TextStyle(color: AppColor.blackColor,fontSize: 10),
                                              maxLines: 1,overflow: TextOverflow.ellipsis,textAlign: TextAlign.start),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(right: 20,top: 5,left: 10),
                                            child: Text(snapshot.data?.docs[index]['bookType'],
                                                style: const TextStyle(color: AppColor.darkGreen,fontSize: 12,fontWeight: FontWeight.w600),
                                                maxLines: 1,overflow: TextOverflow.ellipsis,textAlign: TextAlign.start),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }
            );
          }
        }
    );
  }
}
