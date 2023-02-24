import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebook/firebase/firebase_collection.dart';
import 'package:ebook/home/screen/continue_reading.dart';
import 'package:ebook/home/screen/no_internet_screen.dart';
import 'package:ebook/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/internet_provider.dart';

class PopularAuthorScreen extends StatefulWidget {

  var snapShotData;
  PopularAuthorScreen({Key? key,required this.snapShotData}) : super(key: key);

  @override
  State<PopularAuthorScreen> createState() => _PopularAuthorScreenState();
}

class _PopularAuthorScreenState extends State<PopularAuthorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Author Details'),
      ),
      body: Consumer<InternetProvider>(builder: (context,internetSnapshot,_){
        internetSnapshot.checkInternet().then((value) {
        });
        return internetSnapshot.isInternet?
           SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 20,right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Stack(
                    children: [
                      Container(
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(10)
                        ),
                      ),
                      Positioned(
                        top: 30,
                          left: 50,
                          child: Row(
                            children: [
                              ClipOval(
                                  child: Image.network(widget.snapShotData['authorImage'],height: 80,width: 80,fit: BoxFit.fill,)),
                              const SizedBox(width: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:  [
                                  Text(widget.snapShotData['authorName'],style: const TextStyle(color: AppColor.appColor,fontSize: 18,)),
                                  const SizedBox(height: 5),
                                  Text(widget.snapShotData['authorDesignation'])
                                ],
                              ),
                            ],
                          )),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text('About',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: AppColor.greyColor)),
                  const SizedBox(height: 5),
                  Text(widget.snapShotData['authorAbout'],
                      style: const TextStyle(fontSize: 12)),
                  const SizedBox(height: 20),
                  const Text('Publish Books',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: AppColor.greyColor)),
                  const SizedBox(height: 5),
                  StreamBuilder(
                      stream: FirebaseCollection().bookCollection.where('authorName',isEqualTo: widget.snapShotData['authorName']).snapshots(),
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
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>ContinueReadingScreen(snapshotData: snapshot.data?.docs[index],)));
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
                                                    style: const TextStyle(color: AppColor.blackColor,fontSize: 10,overflow: TextOverflow.ellipsis),textAlign:TextAlign.center,maxLines: 2,)),
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
                ],
              ),
            ),
          ) : noInternetDialog();
        }
      ),
    );
  }
}