import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebook/utils/app_images.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../firebase/firebase_collection.dart';
import '../login/screen/login_screen.dart';
import '../utils/app_colors.dart';
import '../utils/app_utils.dart';


class DrawerScreen extends StatelessWidget {
  const DrawerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(FirebaseAuth.instance.currentUser!.phoneNumber.toString().substring(3,13));
    return Drawer(
      backgroundColor: AppColor.whiteColor,
      child: ListView(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: AppColor.whiteColor,
            ),
            child: StreamBuilder(
                stream: FirebaseCollection().userCollection.doc(FirebaseCollection.currentUserId).snapshots(),
                builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Object?>?> snapshot) {
                  if(snapshot.connectionState == ConnectionState.none){
                    return const Text('Something went wrong');
                  }
                  else if(!snapshot.hasData){
                    return const Text('Unable to Find data');
                  } else{
                    Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipOval(
                            child: Image.asset(AppImage.appLogo, height: 70, width: 70, fit: BoxFit.fill),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:  [
                              const SizedBox(height: 5),
                              Text('${data['userName']}',style: const TextStyle(fontSize: 18)),
                              Text('${data['userEmail']}',style: TextStyle(color: AppColor.blackColor.withOpacity(0.3)),),
                            ],
                          )
                        ]);
                  }
              }
            )
          ),
          const Divider(height: 1,color: AppColor.darkGreyColor,),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              // Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pop(context);
            },
          ),

          const Divider(height: 1,color: AppColor.darkGreyColor,),

          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              FirebaseAuth.instance.signOut();
              AppUtils.instance.clearPref().then((value) => Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) =>  const LoginScreen())));
            },
          ),
        ],
      ),
    );
  }
}
