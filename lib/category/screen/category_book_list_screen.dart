import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebook/firebase/firebase_collection.dart';
import 'package:ebook/home/screen/continue_reading.dart';
import 'package:ebook/home/screen/no_internet_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import '../../home/provider/internet_provider.dart';
import '../../utils/app_colors.dart';
//ignore: must_be_immutable
class CategoryBookListScreen extends StatefulWidget {

  String genreName;
  CategoryBookListScreen({Key? key,required this.genreName}) : super(key: key);

  @override
  State<CategoryBookListScreen> createState() => _CategoryBookListScreenState();
}

class _CategoryBookListScreenState extends State<CategoryBookListScreen> {
  @override
  Widget build(BuildContext context) {
    debugPrint(widget.genreName);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.genreName),
      ),
      body: Consumer<InternetProvider>(builder: (context,internetSnapshot,_){
        internetSnapshot.checkInternet().then((value) {
        });
        return internetSnapshot.isInternet?
           StreamBuilder(
             stream: FirebaseCollection().bookCollection.where('bookType',isEqualTo: widget.genreName).snapshots(),
             builder: (context,AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
               if(snapshot.connectionState == ConnectionState.waiting){
                 return const Center(child: CircularProgressIndicator());
               }else if (snapshot.hasError) {
                 return const Center(child: Text("Something went wrong"));
               }
               else if (!snapshot.hasData) {
                 return  const Center(child: Text("No Book Available"));
               } else if (snapshot.requireData.docChanges.isEmpty){
                 return  const Center(child: Text("No Book Available"));
               }
               else if(snapshot.hasData){
                 return ListView.builder(
                   itemCount: snapshot.data?.docs.length,
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
                                   height: 90,width: 90,fit: BoxFit.fill,),
                               ),
                               Expanded(
                                 child: Padding(
                                   padding: const EdgeInsets.only(right: 20,top: 10,left: 10),
                                   child: Column(
                                     mainAxisAlignment: MainAxisAlignment.start,
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children:  [
                                       Text(snapshot.data?.docs[index]['bookTitle'],
                                           style: const TextStyle(color: AppColor.darkGreen,fontSize: 16),maxLines: 1,overflow: TextOverflow.ellipsis),
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
                                       const SizedBox(height: 5),
                                       Text(snapshot.data?.docs[index]['bookDescription'],
                                         style: const TextStyle(color: AppColor.blackColor,fontSize: 12),maxLines: 2,overflow: TextOverflow.ellipsis,textAlign: TextAlign.start,),
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
               }
               else{
                 return const CircularProgressIndicator();
               }
             }
           ) : noInternetDialog();
        }
      ),
    );
  }
}
