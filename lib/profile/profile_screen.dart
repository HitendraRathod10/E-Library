import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebook/home/screen/no_internet_screen.dart';
import 'package:ebook/utils/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../firebase/firebase_collection.dart';
import '../home/provider/internet_provider.dart';
import '../login/screen/login_screen.dart';
import '../mixin/textfield_mixin.dart';
import '../utils/app_utils.dart';
import 'edit_profile_screen.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController mobileController = TextEditingController();
    return  Consumer<InternetProvider>(builder: (context,internetSnapshot,_){
      internetSnapshot.checkInternet().then((value) {
      });
      return internetSnapshot.isInternet?
         SafeArea(
          child: Scaffold(
            body: StreamBuilder(
                stream: FirebaseCollection().userCollection.doc(FirebaseCollection.currentUserId).snapshots(),
                builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Object?>> snapshot) {
                  if (snapshot.hasError) {
                    return const Text("Something went wrong");
                  }
                  else if (!snapshot.hasData || !snapshot.data!.exists) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  else if(snapshot.requireData.exists) {
                    Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                    return Column(
                      children: [
                        Stack(
                          children: [
                            Container(height: 150,color: AppColor.darkGreen,width: double.infinity,),
                            Positioned(
                              left: 0,right: 0,
                              child: Column(
                                children: [
                                  const SizedBox(height: 30,),
                                  Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 2,
                                          color: AppColor.whiteColor,
                                        ),
                                      borderRadius: BorderRadius.circular(100)
                                    ),
                                    child: ClipOval(
                                        child:
                                        data['userImage'] == "" ? Container(
                                          color: AppColor.whiteColor,
                                          height: 80,width: 80,child: Center(
                                          child: Text('${data['userName']?.substring(0,1).toUpperCase()}',
                                              style: const TextStyle(color: AppColor.darkGreen,fontSize: 30)),
                                        ),) :
                                        Image.network(
                                            '${data['userImage']}',
                                            height: 80,
                                            width: 80,
                                            fit: BoxFit.fill)
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                                right: 5,
                                child: GestureDetector(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const EditProfileScreen()));
                                  },
                                  child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: AppColor.whiteColor.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: Icon(Icons.edit,color: AppColor.whiteColor.withOpacity(0.7),)),
                                )
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20,right: 20,top: 40),
                          child: Column(
                            children: [
                              TextFieldMixin().textFieldWidget(
                                hintText: 'Name',
                                prefixIcon: const Icon(Icons.person,color: AppColor.darkGreen,),
                                labelStyle: TextStyle(color: AppColor.blackColor.withOpacity(0.5)),
                                border: InputBorder.none,
                                keyboardType: TextInputType.text,
                                readOnly: true,
                                controller: nameController..text = data['userName']
                              ),
                              const SizedBox(height: 20,),
                              TextFieldMixin().textFieldWidget(
                                hintText: 'Email',
                                  readOnly: true,
                                  prefixIcon: const Icon(Icons.email,color: AppColor.darkGreen,),
                                labelStyle: TextStyle(color: AppColor.blackColor.withOpacity(0.5)),
                                border: InputBorder.none,
                                keyboardType: TextInputType.emailAddress,
                                  controller: emailController..text = data['userEmail']
                              ),
                              const SizedBox(height: 20,),
                              TextFieldMixin().textFieldWidget(
                                hintText: 'Mobile',
                                  readOnly: true,
                                  prefixIcon: const Icon(Icons.phone_iphone,color: AppColor.darkGreen,),
                                labelStyle: TextStyle(color: AppColor.blackColor.withOpacity(0.5)),
                                border: InputBorder.none,
                                keyboardType: TextInputType.phone,
                                  controller: mobileController..text = data['userMobile']
                              ),

                              const SizedBox(height: 50),
                              Container(
                                width: 120,
                                height: 40,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20)
                                ),
                                child: ElevatedButton(
                                    onPressed: () {
                                      FirebaseAuth.instance.signOut();
                                      AppUtils.instance.clearPref().then((value) => Navigator.pushReplacement(context,
                                          MaterialPageRoute(builder: (context) =>  const LoginScreen())));
                                    },
                                    style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all<Color>(AppColor.darkGreen),
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10.0),
                                            )
                                        )
                                    ),
                                    child: const Text('Logout',)
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    );
                  }
                  else{
                    return const Center(child: CircularProgressIndicator());
                  }
              }
            ),
          ),
        ) : noInternetDialog();
      }
    );
  }
}
