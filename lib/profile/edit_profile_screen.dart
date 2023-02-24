import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebook/home/screen/no_internet_screen.dart';
import 'package:ebook/utils/app_colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:provider/provider.dart';
import '../../mixin/textfield_mixin.dart';
import '../firebase/firebase_collection.dart';
import '../home/provider/internet_provider.dart';
import '../login/provider/login_provider.dart';
import '../utils/app_utils.dart';
import '../widget/provider/loading-provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreen();
}

class _EditProfileScreen extends State<EditProfileScreen> {

  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  File? file;
  var url = '';

  Future<File> imageSizeCompress(
      {required File image,
        quality = 100,
        percentage = 10}) async {
    var path = await FlutterNativeImage.compressImage(image.absolute.path,quality: 100,percentage: 60);
    return path;
  }

  void selectImage(BuildContext context) async{
    //Pick Image File
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.image
    );
    if(result == null) return;
    final filePath = result.files.single.path;
    File compressImage = await imageSizeCompress(image: File(filePath!));
    setState((){
      file = compressImage;
    });
  }

  void uploadFile() async {
    //_selectProfileImage(context);
    //Store Image in firebase database
    if (file == null) return;
    final fireauth = FirebaseAuth.instance.currentUser?.email;
    final destination = 'images/$fireauth';
    try {
      final ref = FirebaseStorage.instance.ref().child(destination);
      UploadTask uploadsTask =  ref.putFile(file!);
      final snapshot = await uploadsTask.whenComplete(() {});
      final imageUrl = await snapshot.ref.getDownloadURL().whenComplete(() {});

      AppUtils.instance.showToast(toastMessage: "Update Profile");
      Provider.of<LoginProvider>(context,listen: false).addEmployee(
          userEmail: emailController.text.trim(),
          userName: nameController.text.trim(),
          userMobile: mobileController.text.trim(),userType: 'User',
          timestamp: Timestamp.now(), userImage: imageUrl);
      Provider.of<LoadingProvider>(context,listen: false).stopLoading();
      Navigator.pop(context);
      debugPrint("Image URL = $imageUrl");
    } catch (e) {
      print('Failed to upload image');
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Consumer<InternetProvider>(builder: (context,internetSnapshot,_){
        internetSnapshot.checkInternet().then((value) {
        });
        return internetSnapshot.isInternet?
        SingleChildScrollView(
          child: Form(
            key: formKey,
            child: StreamBuilder(
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
                        const SizedBox(height: 30,),
                        Stack(
                            clipBehavior: Clip.none,
                            children : [
                              GestureDetector(
                                onTap: (){
                                  selectImage(context);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 2,
                                        color: AppColor.appColor,
                                      ),
                                      borderRadius: BorderRadius.circular(100)
                                  ),
                                  child: ClipOval(
                                    child: file == null ?
                                    data['userImage'] == "" ? Container(
                                      color: AppColor.appColor,
                                      height: 80,width: 80,child: Center(
                                      child: Text('${data['userName']?.substring(0,1).toUpperCase()}',
                                          style: const TextStyle(color: AppColor.whiteColor,fontSize: 30)),
                                    ),) :
                                    Image.network(
                                        '${data['userImage']}',
                                        height: 80,
                                        width: 80,
                                        fit: BoxFit.fill) :
                                    Image.file(
                                      file!,
                                      height: 80,width: 80,
                                      fit: BoxFit.fill,),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 60,
                                top: 50,
                                child: ClipOval(
                                    child: Container(
                                      height: 30,width: 30,
                                      color:Colors.white,child: const Icon(Icons.camera_alt,color: AppColor.appColor,size: 22,),)),
                              )
                            ]
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
                                controller: nameController..text = data['userName'],
                                validator: (value){
                                  if(value!.isEmpty){
                                    return 'Name is Required';
                                  }
                                },
                              ),
                              const SizedBox(height: 20,),
                              TextFieldMixin().textFieldWidget(
                                hintText: 'Email',
                                prefixIcon: const Icon(Icons.email,color: AppColor.darkGreen,),
                                labelStyle: TextStyle(color: AppColor.blackColor.withOpacity(0.5)),
                                border: InputBorder.none,
                                keyboardType: TextInputType.emailAddress,
                                controller: emailController..text = data['userEmail'],
                                validator: (value){
                                  if(value!.isEmpty){
                                    return 'Email is Required';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20,),
                              TextFieldMixin().textFieldWidget(
                                hintText: 'Mobile',
                                prefixIcon: const Icon(Icons.phone_iphone,color: AppColor.darkGreen,),
                                labelStyle: TextStyle(color: AppColor.blackColor.withOpacity(0.5)),
                                border: InputBorder.none,
                                keyboardType: TextInputType.phone,
                                controller: mobileController..text = data['userMobile'],
                                validator: (value){
                                  if(value!.isEmpty){
                                    return 'Mobile is Required';
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 50),
                              Container(
                                width: double.infinity,
                                height: 45,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20)
                                ),
                                child: ElevatedButton(
                                    onPressed: () {
                                      if(formKey.currentState!.validate() ) {
                                        Provider.of<LoadingProvider>(context,listen: false).startLoading();
                                        if(file != null){
                                          uploadFile();
                                        } else{
                                          AppUtils.instance.showToast(toastMessage: "Update Profile");
                                          Provider.of<LoginProvider>(context,listen: false).addEmployee(
                                              userEmail: emailController.text.trim(),
                                              userName: nameController.text.trim(),
                                              userMobile: mobileController.text.trim(),userType: data['userType'],
                                              timestamp: Timestamp.now(), userImage: data['userImage']);
                                          Provider.of<LoadingProvider>(context,listen: false).stopLoading();
                                          Navigator.pop(context);
                                        }
                                      }
                                    },
                                    style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all<Color>(AppColor.darkGreen),
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10.0),
                                            )
                                        )
                                    ),
                                    child: const Text('Update',)
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
      ),
    );
  }
}
