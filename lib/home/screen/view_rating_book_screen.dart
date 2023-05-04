import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebook/shimmers/book_list_shimmers.dart';
import 'package:ebook/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../firebase/firebase_collection.dart';
//ignore: must_be_immutable
class ViewRatingBookScreen extends StatefulWidget {
  dynamic ratingSnapshotData;
  ViewRatingBookScreen({Key? key,required this.ratingSnapshotData}) : super(key: key);

  @override
  State<ViewRatingBookScreen> createState() => _ViewRatingBookScreenState();
}

class _ViewRatingBookScreenState extends State<ViewRatingBookScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(widget.ratingSnapshotData['bookTitle']),
      ),
      body:  StreamBuilder(
          stream: FirebaseCollection().userRatingCollection.
          where('bookTitle',isEqualTo: widget.ratingSnapshotData['bookTitle'])
              .snapshots(),
          builder: (context,AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
            if(snapshot.hasError) {
              return const Text('Something went wrong');
            } else if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator());
            }
            else if(snapshot.requireData.docChanges.isEmpty){
               return const Center(child: Text('No review'));
             } else if(!snapshot.hasData) {
              return const Center(child: BookListShimmers());
            } else if(snapshot.hasData){
              return ListView.builder(
                  itemCount: snapshot.data?.docChanges.length,
                  itemBuilder: (context,index){
                    return Container(
                      padding: const EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ClipOval(
                              //   child: Container(
                              //     color: AppColor.darkGreen,
                              //     height: 50,width: 50,child: Center(
                              //     child: Text('${snapshot.data?.docs[index]['userName'].substring(0,1).toUpperCase()}',
                              //         style: const TextStyle(color: AppColor.whiteColor)),
                              //   ),)
                              // ),
                              ClipOval(
                                  child:
                                  snapshot.data!.docs[index]['userImage'] == "" ? Container(
                                    color: AppColor.darkGreen,
                                    height: 50,width: 50,child: Center(
                                    child: Text('${snapshot.data?.docs[index]['userName'].substring(0,1).toUpperCase()}',
                                        style: const TextStyle(color: AppColor.whiteColor)),
                                  ),) :
                                  Image.network(
                                      '${snapshot.data?.docs[index]['userImage']}',
                                      height: 50,
                                      width: 50,
                                      fit: BoxFit.fill)
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(snapshot.data?.docs[index]['userName']),
                                  const SizedBox(height: 5,),
                                  RatingBar.builder(
                                    initialRating: snapshot.data?.docs[index]['bookRating'],
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    ignoreGestures : true,
                                    itemSize: 15,
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
                             // Text(snapshot.data?.docs[index]['currentDate']),
                            ],
                          )
                        ],
                      ),
                    );
                  }
              );
            }else{
              return const Center(child: CircularProgressIndicator());
            }
        }
      ),
    );
  }
}
