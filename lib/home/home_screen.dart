import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebook/home/provider/internet_provider.dart';
import 'package:ebook/home/screen/no_internet_screen.dart';
import 'package:ebook/home/screen/popular_author_screen.dart';
import 'package:ebook/home/widget/continue_reading_widget.dart';
import 'package:ebook/home/widget/today_reading_widget.dart';
import 'package:ebook/utils/app_colors.dart';
import 'package:ebook/utils/app_images.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../firebase/firebase_collection.dart';
import '../shimmers/popular_author_shimmer.dart';
import '../widget/slider_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  // String bookName = '';
  //
  // getBookData() async{
  //   var querySnapshots = await FirebaseCollection().bookCollection.get();
  //   for (var snapshot in querySnapshots.docChanges) {
  //     setState((){
  //       bookName = snapshot.doc.get("bookTitle");
  //     });
  //   }
  // }

  @override
  void initState() {
    super.initState();
    Provider.of<InternetProvider>(context, listen: false).checkInternet().then((value) {});
  }

  @override
  Widget build(BuildContext context) {
    return  Consumer<InternetProvider>(builder: (context,internetSnapshot,_){
      internetSnapshot.checkInternet().then((value) {
      });
      //print(todayReadingSnapshot.checkTodayData());
      debugPrint("abcd ${internetSnapshot.isInternet}");
      return internetSnapshot.isInternet?
         Scaffold(
          backgroundColor: AppColor.whiteColor,
          appBar: AppBar(
            title: const Text('E-Library'),
            actions:  [
              StreamBuilder(
                  stream: FirebaseCollection().userCollection.doc(FirebaseCollection.currentUserId).snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Object?>> snapshot) {
                    if (!snapshot.hasData || !snapshot.data!.exists || snapshot.hasError) {
                    return Shimmer.fromColors(
                      highlightColor: Colors.white,
                      baseColor: Colors.grey.shade100,
                      child: ClipOval(
                        child: Image.asset(
                            AppImage.novel,
                            height: 50,
                            width: 40,
                            fit: BoxFit.fill),
                      ),
                    );
                    } else if(snapshot.requireData.exists){
                      Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                      return Padding(
                        padding: const EdgeInsets.only(right: 15,top: 8,bottom: 8),
                        child:
                        ClipOval(
                            child:
                            data['userImage'] == "" ? Container(
                              color: AppColor.darkGreen,
                              height: 50,width: 40,child: Center(
                              child: Text('${data['userName']?.substring(0,1).toUpperCase()}',
                                  style: const TextStyle(color: AppColor.whiteColor)),
                            ),) :
                            Image.network(
                                '${data['userImage']}',
                                height: 50,
                                width: 40,
                                fit: BoxFit.fill)
                        ),
                      );
                    } else{
                      return const CircularProgressIndicator();
                    }
                }
              )
            ],
          ),
          //drawer: const DrawerScreen(),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SliderWidget(),
                      const SizedBox(height: 20),
                      const TodayReadingWidget(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                  text: "Author",
                                  style: TextStyle(
                                      color: AppColor.darkGreen,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ))
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      StreamBuilder(
                          stream: FirebaseCollection().authorCollection.snapshots(),
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
                            if(snapshot.connectionState == ConnectionState.waiting){
                              return const PopularAuthorShimmers();
                            }else if (snapshot.hasError) {
                              return const Center(child: Text("Something went wrong"));
                            }
                            else if (!snapshot.hasData) {
                              return const Center(child: Text("No Data Found"));
                            } else if (snapshot.requireData.docChanges.isEmpty){
                              return const Center(child: Text("No Data Found"));
                            }
                            else{
                              return Container(
                                height: 100,
                                margin: const EdgeInsets.only(left: 10),
                                child: ListView.builder(
                                    itemCount: snapshot.data!.docs.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: (){
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=> PopularAuthorScreen(snapShotData: snapshot.data?.docs[index],)));
                                        },
                                        child: SizedBox(
                                          width: 80,
                                          height: 100,
                                          child: Column(
                                            children: [
                                              ClipOval(
                                                child: Image.network(snapshot.data?.docs[index]['authorImage'],
                                                  height: 60,width: 60,fit: BoxFit.fill,
                                                ),
                                              ),
                                              const SizedBox(height: 5,),
                                              Text(snapshot.data?.docs[index]['authorName'],
                                                style: const TextStyle(fontSize: 12),
                                                textAlign: TextAlign.center,maxLines: 2,overflow: TextOverflow.ellipsis,)
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                ),
                              );
                            }
                        }
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(text: "Continue ",
                                  style: TextStyle(color: AppColor.darkGreyColor,fontWeight: FontWeight.w500,fontSize: 18)
                              ),
                              TextSpan(
                                  text: "reading...",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColor.darkGreen
                                  ))
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const ContinueReadingWidget(),
                      const SizedBox(height: 10)
                    ],
              ),
            ),
          ),
        ) : noInternetDialog();
      }
    );
  }
}
