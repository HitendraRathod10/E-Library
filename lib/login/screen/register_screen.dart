import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:ebook/login/firebaseauth/phone_sign_in_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../mixin/textfield_mixin.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_preference_key.dart';
import '../../utils/app_utils.dart';
import '../../widget/bottom_navigation_bar.dart';
import '../provider/login_provider.dart';
//ignore: must_be_immutable
class RegisterScreen extends StatefulWidget with TextFieldMixin {
  String phoneNumber;
  RegisterScreen({Key? key,required this.phoneNumber}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  var emailController = TextEditingController();
  var nameController = TextEditingController();
  var mobileController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void uploadFile(context) async {
    //_selectProfileImage(context);
    //Store Image in firebase database
    if (Provider.of<LoginProvider>(context,listen: false).file == null) return;
    final fireauth = FirebaseAuth.instance.currentUser?.email;
    final destination = 'images/$fireauth';
    try {
      final ref = FirebaseStorage.instance.ref().child(destination);
      UploadTask uploadsTask =  ref.putFile(Provider.of<LoginProvider>(context,listen: false).file!);
      final snapshot = await uploadsTask.whenComplete(() {});
      final imageUrl = await snapshot.ref.getDownloadURL().whenComplete(() {});
      //Provider.of<LoadingProvider>(context,listen: false).stopLoading();
      AppUtils.instance.showToast(toastMessage: "Register Successfully");
      Provider.of<LoginProvider>(context,listen: false).addEmployee(
          userName: nameController.text.toString(),
          userEmail: emailController.text.toString(),
          userMobile: mobileController.text.toString(),
          userType: Provider.of<LoginProvider>(context,listen: false).selectUserType.toString(),
          userImage: imageUrl.toString(), timestamp: Timestamp.now());
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) =>
              const BottomNavBarScreen()), (Route<dynamic> route) => false);
      Provider.of<MobileAuthProvider>(context,listen: false).getSharedPreferenceData(widget.phoneNumber);

      debugPrint("Image URL = $imageUrl");
    } catch (e) {
      debugPrint('Failed to upload image');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child:  Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.only(top: 70, left: 30, right: 30),
                child: Consumer<LoginProvider>(
                    builder: (BuildContext context, snapshot, Widget? child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Center(
                          child: Text(
                            "Create An Account",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Center(
                          child: Stack(
                              clipBehavior: Clip.none,
                              children : [
                                GestureDetector(
                                  onTap: (){
                                    snapshot.selectImage(context);
                                  },
                                  child: ClipOval(
                                    child: snapshot.file == null ?
                                    Container(
                                      color: AppColor.appColor,
                                      height: 80,width: 80,child: const Center(
                                      child: Icon(Icons.person,size: 40,color: AppColor.whiteColor,)
                                    ),) :
                                    Image.file(
                                      snapshot.file!,
                                      height: 80,width: 80,
                                      fit: BoxFit.fill),
                                  ),
                                ),
                                Positioned(
                                  left: 50,
                                  top: 50,
                                  child: GestureDetector(
                                    onTap: () => snapshot.selectImage(context),
                                    child: ClipOval(child: Container(
                                      height: 30,width: 30,
                                      color:AppColor.whiteColor,child: const Icon(Icons.camera_alt,color: AppColor.appColor,size: 22),)),
                                  ),
                                )
                              ]
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFieldMixin().textFieldWidget(
                          controller: nameController,
                          labelText: 'User Name',
                          border: InputBorder.none,
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.trim().isEmpty) {
                              return 'Please enter name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFieldMixin().textFieldWidget(
                          controller: emailController,
                          labelText: 'Email',
                          border: InputBorder.none,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value!.isEmpty ||
                                value.trim().isEmpty ||
                                !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@"
                                r"[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value)) {
                              return 'Enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFieldMixin().textFieldWidget(
                          controller: mobileController..text = widget.phoneNumber,
                          labelText: 'Mobile Number',
                          border: InputBorder.none,
                          readOnly: true,
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.trim().isEmpty) {
                              return 'Please enter mobile number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        DropdownButtonFormField2(
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(vertical: 20),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          buttonStyleData: const ButtonStyleData(
                            padding: EdgeInsets.only(right: 10),
                          ),
                          dropdownStyleData: DropdownStyleData(
                              padding: EdgeInsets.zero,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              maxHeight: 200,
                              useSafeArea: true,
                              isOverButton: false,
                              offset: const Offset(0, -20)
                          ),
                          iconStyleData: const IconStyleData(
                              icon: Icon(Icons.arrow_drop_down)),
                          barrierDismissible: false,
                          autofocus: true,
                          isExpanded: true,
                              value: snapshot.selectUserType,
                              validator: (value) {
                                if (value == null) {
                                  return 'User type is required';
                                }
                                return null;
                              },
                              hint: const Text('Select User Type'),
                              isDense: true,
                              style: const TextStyle(color: AppColor.appBlackColor, fontSize: 14),
                              onChanged: (String? newValue) {
                                snapshot.selectUserType = newValue!;
                                snapshot.getUserType;
                              },
                              items: snapshot.selectUserTypeList
                                  .map<DropdownMenuItem<String>>((String leaveName) {
                                return DropdownMenuItem<String>(
                                    value: leaveName,
                                    child: Row(
                                      children: [
                                        Text(leaveName)
                                      ],
                                    )
                                );
                              }).toList(),
                            ),
                        const SizedBox(height: 30),
                        Container(
                          width: double.infinity,
                          height: 55,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)
                          ),
                          child: ElevatedButton(
                              onPressed: () async {
                                if(_formKey.currentState!.validate()){
                                  //Provider.of<LoadingProvider>(context,listen: false).startLoading();
                                  if(snapshot.file !=null){
                                    uploadFile(context);
                                  } else{
                                   // Provider.of<LoadingProvider>(context,listen: false).stopLoading();
                                    AppUtils.instance.showToast(toastMessage: "Register Successfully");
                                    Provider.of<LoginProvider>(context,listen: false).addEmployee(
                                        userName: nameController.text.toString(),
                                        userEmail: emailController.text.toString(),
                                        userMobile: mobileController.text.toString(),
                                        userType: Provider.of<LoginProvider>(context,listen: false).selectUserType.toString(),
                                        userImage: '', timestamp: Timestamp.now()).then((value) {
                                      AppUtils.instance.setPref(PreferenceKey.boolKey, PreferenceKey.prefLogin, true);
                                    });
                                    Provider.of<MobileAuthProvider>(context,listen: false).getSharedPreferenceData(widget.phoneNumber);
                                    // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const BottomNavBarScreen()));
                                    Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                        builder: (context) => const BottomNavBarScreen(),
                                      ),
                                          (route) => false,
                                    );

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
                              child: const Text('Continue',)
                          ),
                        )
                      ],
                    );
                  }
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
