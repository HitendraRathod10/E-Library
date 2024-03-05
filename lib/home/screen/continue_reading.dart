import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebook/addbook/firebaseauth/add_book_auth.dart';
import 'package:ebook/home/screen/no_internet_screen.dart';
import 'package:ebook/home/screen/readpdf/read_pdf_screen.dart';
import 'package:ebook/home/screen/view_rating_book_screen.dart';
import 'package:ebook/utils/app_colors.dart';
import 'package:ebook/utils/app_images.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import '../../firebase/firebase_collection.dart';
import '../../widget/provider/ads_provider.dart';
import '../firebaseauthprovider/home_firebase_auth.dart';
import '../provider/internet_provider.dart';
//ignore: must_be_immutable
class ContinueReadingScreen extends StatefulWidget {

  dynamic snapshotData;
  ContinueReadingScreen({Key? key,required this.snapshotData}) : super(key: key);

  @override
  State<ContinueReadingScreen> createState() => _ContinueReadingScreenState();
}

class _ContinueReadingScreenState extends State<ContinueReadingScreen> {

  double userRating = 0;
  double rating = 0;
  int userLength = 0;
  double sum = 0.0;

  late String bookTitle,bookSubTitle,
  authorName,publisher,publishDate,bookDescription,
  country,bookType,bookPrice,bookImage,
  currentUserMobile,bookPdf,userName;
  List ratingList = [];

  late Timestamp timestamp;
  late Timer timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<AdsProvider>(context,listen: false).createInterstitialAd();
    Provider.of<AdsProvider>(context,listen: false).loadBannerAd();
    timer = Timer. periodic(const Duration(seconds: 55), (Timer t) => Provider.of<AdsProvider>(context,listen: false).loadBannerAd());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:
      Provider.of<AdsProvider>(context, listen: false).bannerAd == null
          ? const SizedBox.shrink()
          : SizedBox(
        height: Provider.of<AdsProvider>(context, listen: false)
            .bannerAd!
            .size
            .height
            .toDouble(),
        width: double.infinity,
        child: AdWidget(
            ad: Provider.of<AdsProvider>(context, listen: false)
                .bannerAd!),
      ),
      body: Consumer<InternetProvider>(builder: (context,internetSnapshot,_){
        internetSnapshot.checkInternet().then((value) {
        });
        return internetSnapshot.isInternet?
           SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(50),bottomRight: Radius.circular(50)),
                      child: Image.asset(AppImage.background,
                        width: double.infinity,height: 300,fit: BoxFit.fill),
                    ),
                    Positioned(
                        left: 30,right: 30,
                        top: 70,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(widget.snapshotData['bookTitle'],
                                    style: const TextStyle(fontSize: 18,color: Colors.black38),textAlign: TextAlign.start,),
                                  const SizedBox(height: 5),
                                  Text('by ${widget.snapshotData['authorName']}',
                                    style: const TextStyle(fontSize: 12,color: Colors.blueGrey),textAlign: TextAlign.start,
                                  ),
                                  const SizedBox(height: 5),
                                  RatingBar.builder(
                                    initialRating: double.parse("${widget.snapshotData['bookRating']}"),
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
                                  const SizedBox(height: 20),
                                  SizedBox(
                                    width: 120,
                                    height: 35,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
                                              ReadPdfScreen(url: widget.snapshotData['bookPdf'])));

                                          HomeFireAuth().todayReadingData(
                                              bookTitle: widget.snapshotData['bookTitle'],
                                              bookSubTitle: widget.snapshotData['bookSubTitle'],
                                              authorName: widget.snapshotData['authorName'],
                                              publisher: widget.snapshotData['publisher'],
                                              publishDate: widget.snapshotData['publishDate'],
                                              bookDescription: widget.snapshotData['bookDescription'],
                                              country: widget.snapshotData['country'],
                                              bookType: widget.snapshotData['bookType'],
                                              bookPrice: widget.snapshotData['bookPrice'],
                                              bookImage: widget.snapshotData['bookImage'],
                                              bookRating: widget.snapshotData['bookRating'],
                                              currentUserMobile: '${FirebaseAuth.instance.currentUser!.phoneNumber}',
                                              bookPdf: widget.snapshotData['bookPdf'],
                                              currentDate: DateTime.now().toString().substring(0,10),
                                              timestamp: Timestamp.now()).then((value) {
                                                  Provider.of<AdsProvider>(
                                                          context,
                                                          listen: false)
                                                      .showInterstitialAd();
                                                });
                                          },
                                        style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.all<Color>(AppColor.whiteColor),
                                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(20),
                                                )
                                            )
                                        ),
                                        child: const Text('Read',style: TextStyle(color: AppColor.darkGreen),)
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(width: 10,),
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20)
                              ),
                              child: Image.network(widget.snapshotData['bookImage'],
                                  width: 130,height: 150,fit: BoxFit.fill),
                            ),
                          ],
                        )
                    ),
                    /*Positioned(
                        right: 20,
                        bottom: -10,
                        child: Container(
                          margin: const EdgeInsets.only(right: 20,top: 10),
                          padding: const EdgeInsets.only(left: 20,right: 20,top: 5,bottom: 5),
                          decoration: BoxDecoration(
                              color: AppColor.newSummerColor,
                              borderRadius: BorderRadius.circular(20)
                          ),
                          child: Text('\$ ${widget.snapshotData['bookPrice']}',style: TextStyle(color: AppColor.whiteColor),),
                        ),)*/
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0,right: 20,top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('About this book',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: AppColor.greyColor)),
                      const SizedBox(height: 5),
                      Text(widget.snapshotData['bookDescription'],
                          style: const TextStyle(color: AppColor.darkGreyColor)),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('Book Type',
                                  style: TextStyle(fontWeight: FontWeight.w400)),
                              SizedBox(height: 5),
                              Text('Country',
                                  style: TextStyle(fontWeight: FontWeight.w400)),
                              SizedBox(height: 5),
                              Text('Publish Date',
                                  style: TextStyle(fontWeight: FontWeight.w400)),
                            ],
                          ),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.snapshotData['bookType'],
                                  style: const TextStyle(color: AppColor.darkGreen)),
                              const SizedBox(height: 5),
                              Text(widget.snapshotData['country'],
                                  style: const TextStyle(color: AppColor.darkGreen)),
                              const SizedBox(height: 5),
                              Text(widget.snapshotData['publishDate'],
                                  style: const TextStyle(color: AppColor.darkGreen)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20,),
                      Visibility(
                          visible: widget.snapshotData['currentUserMobile'] != FirebaseAuth.instance.currentUser?.phoneNumber ? true : false,
                          child: const Center(child: Text('Rated this Books',style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500,color: AppColor.darkGreyColor)))
                      ),
                      Visibility(
                        visible: widget.snapshotData['currentUserMobile'] != FirebaseAuth.instance.currentUser?.phoneNumber ? true : false,
                        child: Center(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              StreamBuilder(
                                stream:  FirebaseCollection().userRatingCollection.
                                where('bookTitle',isEqualTo: widget.snapshotData['bookTitle']).
                                where('currentUserMobile',isEqualTo: FirebaseAuth.instance.currentUser?.phoneNumber).snapshots(),
                                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
                                  if(!snapshot.hasData || snapshot.requireData.docChanges.isEmpty){
                                    return RatingBar.builder(
                                      initialRating: 0,
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemSize: 20,
                                      itemBuilder: (context, _) => const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      onRatingUpdate: (rating) {
                                        debugPrint('$rating');
                                        userRating = 0;
                                        ratingList.clear();
                                        userRating = rating;
                                        debugPrint('I am user Rating => $userRating');
                                      },
                                    );
                                  }
                                  else if(snapshot.hasData){
                                    return RatingBar.builder(
                                      // initialRating: 2,
                                      initialRating: snapshot.data?.docs[0]['bookRating'],
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemSize: 20,
                                      ignoreGestures: false,
                                      itemBuilder: (context, _) => const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      onRatingUpdate: (rating) async {
                                        debugPrint('$rating');
                                        userRating = 0;
                                        ratingList.clear();
                                        userRating = rating;
                                        debugPrint('I am user Rating => $userRating');
                                      },
                                    );
                                  }
                                  else {
                                    return const SizedBox();
                                  }
                                },
                              ),
                              const SizedBox(width: 5),
                              TextButton(
                                  onPressed: () async{
                                    ratingList.clear();
                                    var querySnapShot = await FirebaseCollection().userCollection.
                                    where('userMobile',isEqualTo: FirebaseCollection.currentUserId).get();

                                    var queryUserRatingSnapshots = await FirebaseCollection().userRatingCollection.
                                    where('bookTitle',isEqualTo: widget.snapshotData['bookTitle']).get();

                                    var queryBookSnapshots = await FirebaseCollection().bookCollection.
                                    where('bookTitle',isEqualTo: widget.snapshotData['bookTitle']).get();

                                    for (var snapshot in querySnapShot.docChanges) {
                                      HomeFireAuth().userRating(
                                          bookTitle: widget.snapshotData['bookTitle'],
                                          bookSubTitle: widget.snapshotData['bookSubTitle'],
                                          authorName: widget.snapshotData['authorName'],
                                          country: widget.snapshotData['country'],
                                          bookType: widget.snapshotData['bookType'],
                                          currentUserMobile: FirebaseAuth.instance.currentUser!.phoneNumber.toString(),
                                          currentDate: DateTime.now().toString().substring(0,10),
                                          userRating: userRating,
                                          timestamp: Timestamp.now(),
                                          userName: snapshot.doc.get('userName'),
                                          userImage: snapshot.doc.get('userImage')
                                      );
                                    }

                                for (var snapshot in queryUserRatingSnapshots.docChanges) {
                                  //debugPrint('Collection Length ${queryUserRatingSnapshots.docs.length}');
                                  //debugPrint('Collection Length1 ${snapshot.doc.get('bookRating')}');
                                 // double tot = 0.0;
                                 //  for(int i = 0;i<1;i++){
                                    userRating = snapshot.doc.get('bookRating');
                                    debugPrint('User Rating $userRating');
                                    ratingList.add(snapshot.doc.get('bookRating'));
                                    sum = ratingList.reduce((a, b) => a + b);
                                    debugPrint(' I am Rating List ==>>> $ratingList');
                                    userLength = queryUserRatingSnapshots.docs.length;
                                    rating = sum/userLength;
                                    debugPrint('User Rating => $sum = $userLength = $rating');
                                    break;
                                  // }
                                }
                                for(var bookSnapshot in queryBookSnapshots.docChanges){
                                    bookTitle = bookSnapshot.doc.get('bookTitle');
                                    bookSubTitle = bookSnapshot.doc.get('bookSubTitle');
                                    authorName = bookSnapshot.doc.get('authorName');
                                    publisher= bookSnapshot.doc.get('publisher');
                                    publishDate= bookSnapshot.doc.get('publishDate');
                                    bookDescription= bookSnapshot.doc.get('bookDescription');
                                    country= bookSnapshot.doc.get('country');
                                    bookType= bookSnapshot.doc.get('bookType');
                                    bookPrice= bookSnapshot.doc.get('bookPrice');
                                    bookImage= bookSnapshot.doc.get('bookImage');
                                    currentUserMobile= bookSnapshot.doc.get('currentUserMobile');
                                    bookPdf= bookSnapshot.doc.get('bookPdf');
                                    timestamp= bookSnapshot.doc.get('timeStamp');
                                    userName= bookSnapshot.doc.get('userName');
                                }
                                    //var sum = [1, 2, 3,4].reduce((a, b) => a + b);
                                    debugPrint('Sum => $sum');
                                    AddBookProvider().createBook(
                                        bookTitle: bookTitle,
                                        bookSubTitle: bookSubTitle,
                                        authorName: authorName,
                                        publisher: publisher,
                                        publishDate: publishDate,
                                        bookDescription: bookDescription,
                                        country: country,
                                        bookType: bookType,
                                        bookPrice: bookPrice,
                                        bookImage: bookImage,
                                        currentUserMobile: currentUserMobile,
                                        bookRating: rating,
                                        bookPdf: bookPdf,
                                        timestamp:timestamp,
                                        userName:userName
                                    );
                              }, child: const Text('Submit',style: TextStyle(color: AppColor.darkGreen,fontSize: 12))),
                              TextButton(
                                  onPressed: () async{
                                    Navigator.push(context, 
                                        MaterialPageRoute(builder: (context)=>ViewRatingBookScreen(ratingSnapshotData: widget.snapshotData,)));
                                  },
                                  child: const Text('View Rating',style: TextStyle(color: AppColor.darkGreen,fontSize: 12),)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text('Related Books',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: AppColor.greyColor)),
                      const SizedBox(height: 5,),
                      StreamBuilder(
                          stream: FirebaseCollection().bookCollection.
                          where('bookType',isEqualTo: widget.snapshotData['bookType'])
                          //.where('bookTitle',isNotEqualTo: widget.snapshotData['bookTitle'])
                              .snapshots(),
                          builder: (context,AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
                            if(snapshot.connectionState == ConnectionState.waiting){
                              return const Center(child: CircularProgressIndicator());
                            }else if (snapshot.hasError) {
                              return const Center(child: Text("Something went wrong"));
                            } else if (!snapshot.hasData) {
                              return  const Center(child: Text("No Book Available"));
                            } else if (snapshot.requireData.docChanges.isEmpty){
                              return  const Center(child: Text("No Book Available"));
                            } else if(snapshot.hasData){
                              return SizedBox(
                                height: 210,
                                child: ListView.builder(
                                    itemCount: snapshot.data?.docs.length,
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemBuilder: (context,index) {
                                      return GestureDetector(
                                        onTap: (){
                                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ContinueReadingScreen(snapshotData: snapshot.data?.docs[index],)));
                                        },
                                        child: Container(
                                          width: 150,
                                          height: 200,
                                          padding: const EdgeInsets.only(right: 5),
                                          child: Card(
                                            elevation: 5,
                                            shape:  RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Column(
                                              children: [
                                                ClipRRect(
                                                  borderRadius: const BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10)),
                                                  child: Image.network(snapshot.data!.docs[index]['bookImage'],
                                                      height: 120,width: double.infinity,fit: BoxFit.fill),
                                                ),
                                                const SizedBox(height: 5),
                                                Container(
                                                  padding: const EdgeInsets.only(left: 10,right: 10),
                                                  child: Center(
                                                      child: Text(snapshot.data!.docs[index]['bookTitle'],
                                                          style: const TextStyle(color: AppColor.darkGreen,fontSize: 16),textAlign:TextAlign.center,maxLines: 2,overflow: TextOverflow.ellipsis)),
                                                ),
                                                const SizedBox(height: 5),
                                                Container(
                                                  padding: const EdgeInsets.only(left: 10,right: 10,bottom: 10),
                                                  child: Center(
                                                      child: Text(snapshot.data!.docs[index]['bookDescription'],
                                                        style: const TextStyle(color: AppColor.blackColor,fontSize: 10,overflow: TextOverflow.ellipsis),textAlign:TextAlign.center,maxLines: 1,)),
                                                ),

                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                ),
                              );
                            } else{
                              return const CircularProgressIndicator();
                            }
                          }
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                )
              ],
            ),
          ) : noInternetDialog();
        },
      ),
    );
  }
}
