import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebook/firebase/firebase_collection.dart';
import 'package:ebook/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SliderWidget extends StatelessWidget {
  const SliderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return StreamBuilder(
      stream: FirebaseCollection().bookCollection.
      orderBy('timeStamp',descending: true).snapshots(),
      builder: (context,AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
        if(snapshot.hasError){
          return const CircularProgressIndicator();
        } else if(!snapshot.hasData){
          return Container(
            padding: const EdgeInsets.only(left: 20,right: 20),
            child: Shimmer.fromColors(
              highlightColor: Colors.white,
              baseColor: Colors.grey.shade100,
              child: Container(
                padding: const EdgeInsets.only(left: 20,right: 20),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height/3,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    )
                ),
                child: const SizedBox(),
              ),
            ),
          );
        }
        else if(snapshot.hasData){
          return Visibility(
            visible: snapshot.data!.docChanges.length >=3 ? true : false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(text: "Recently ",
                            style: TextStyle(color: AppColor.darkGreyColor,fontWeight: FontWeight.w500,fontSize: 20)
                        ),
                        TextSpan(
                            text: "Added",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColor.darkGreen,
                            ))
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                Center(
                    child: CarouselSlider.builder(
                      options: CarouselOptions(
                        autoPlay: true,
                        reverse: false,
                        viewportFraction: 1,
                        autoPlayInterval: const Duration(seconds: 3),
                      ),
                      itemCount:  3,
                      itemBuilder: (context, index, int realIndex) {
                        return Container(
                          padding: const EdgeInsets.only(left: 20,right: 20),
                          child: Stack(
                            children: [
                              ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    topLeft: Radius.circular(20),
                                  ),
                                  child: Image.network(snapshot.data?.docs[index]['bookImage'],
                                    height: MediaQuery.of(context).size.height/3,
                                    width: MediaQuery.of(context).size.width,fit: BoxFit.fill,)),
                              Positioned(
                                  top : 150,
                                  child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: const BoxDecoration(
                                          color: AppColor.newSummerColor,
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(10),
                                            bottomRight: Radius.circular(10),
                                          )
                                      ),
                                      child: Text(snapshot.data?.docs[index]['bookTitle'],
                                        style: const TextStyle(color: AppColor.whiteColor),))
                              )
                            ],
                          ),
                        );
                      },
                    )),
              ],
            ),
          );
        } else{
          return const CircularProgressIndicator();
        }
      }
    );
  }
}