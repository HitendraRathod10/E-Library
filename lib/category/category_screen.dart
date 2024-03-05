import 'package:ebook/category/screen/category_book_list_screen.dart';
import 'package:ebook/home/screen/no_internet_screen.dart';
import 'package:ebook/utils/app_images.dart';
import 'package:ebook/widget/provider/ads_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../home/provider/internet_provider.dart';
import '../utils/app_colors.dart';

class CategoryListModel{
  String bookType,bookImage;
  Color gridColor;

  CategoryListModel({
    required this.gridColor,required this.bookType,required this.bookImage,
  });
}

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    List<CategoryListModel> bookType = <CategoryListModel> [
      CategoryListModel(gridColor: Colors.amberAccent, bookType: 'History', bookImage: AppImage.history),
      CategoryListModel(gridColor: Colors.orange, bookType: 'Horror Fiction', bookImage: AppImage.horror),
      CategoryListModel(gridColor: Colors.greenAccent, bookType: 'Novel', bookImage: AppImage.novel),
      CategoryListModel(gridColor: Colors.lightGreen, bookType: 'Action', bookImage: AppImage.action),
      CategoryListModel(gridColor: Colors.lightBlue, bookType: 'Mystery', bookImage: AppImage.mystery),
      CategoryListModel(gridColor: Colors.cyan, bookType: 'Western', bookImage: AppImage.western),
      CategoryListModel(gridColor: Colors.deepPurpleAccent, bookType: 'Science',bookImage: AppImage.science),
      CategoryListModel(gridColor: Colors.redAccent, bookType: 'Children',bookImage: AppImage.children),
      CategoryListModel(gridColor: Colors.amberAccent, bookType: 'Magical',bookImage: AppImage.magical),
      CategoryListModel(gridColor: Colors.purple, bookType: 'Drama',bookImage: AppImage.drama),
      CategoryListModel(gridColor: Colors.purpleAccent, bookType: 'Crime',bookImage: AppImage.crime),
      CategoryListModel(gridColor: Colors.cyanAccent, bookType: 'Poetry',bookImage: AppImage.poetry),
      CategoryListModel(gridColor: Colors.indigoAccent, bookType: 'Comic',bookImage: AppImage.comic),
      CategoryListModel(gridColor: Colors.deepOrangeAccent, bookType: 'Romance',bookImage: AppImage.romance),
      CategoryListModel(gridColor: Colors.deepPurpleAccent, bookType: 'Historical',bookImage: AppImage.historical),
    ];

    return  Consumer2<InternetProvider,AdsProvider>(builder: (context,internetSnapshot,adsProvider,_){
      internetSnapshot.checkInternet().then((value) {
        adsProvider.createInterstitialAd();
      });
      return internetSnapshot.isInternet?
         SafeArea(
          child: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
                    child: Text('Book Category',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500)),
                  ),
                  GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1.1,
                      mainAxisExtent: 170
                    ),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: bookType.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: (){
                          adsProvider.showInterstitialAd();
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>CategoryBookListScreen(genreName: bookType[index].bookType,)));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5.0,right: 5),
                          child: Card(
                            elevation: 5,
                            shape:  RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10)),
                                  child: Image.asset(bookType[index].bookImage,
                                  height: 120,width: double.infinity,fit: BoxFit.cover),
                                ),
                                const SizedBox(height: 5),
                                Expanded(
                                  child: Center(
                                    child: Text(bookType[index].bookType,maxLines: 2,overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(color: AppColor.blackColor),textAlign:TextAlign.center),
                                  ),
                                ),
                                const SizedBox(height: 5)
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20,)
                ],
              ),
            ),
          ),
        ) : noInternetDialog();
      }
    );
  }
}
