import 'package:ebook/login/firebaseauth/phone_sign_in_auth.dart';
import 'package:ebook/mixin/textfield_mixin.dart';
import 'package:ebook/utils/app_colors.dart';
import 'package:ebook/utils/app_images.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController phoneNumberController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.only(left: 20,right: 20),
              child: LayoutBuilder(
                builder: (BuildContext ctx, BoxConstraints constraints) {
                  if(constraints.maxWidth >=480){
                    return SizedBox(
                      width: 400,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(child: Image.asset(AppImage.loginAuthentication,
                              height: MediaQuery.of(context).size.height/4,
                              width: double.infinity)),
                          const SizedBox(height: 30),
                          const Text('Enter your phone number',style: TextStyle(fontSize: 20)),
                          const SizedBox(height: 10),
                          const Text('You will receive a 6 digit code for phone number verification'),
                          const SizedBox(height: 20),
                          TextFieldMixin().textFieldWidget(
                            labelText: 'Mobile Number',
                            labelStyle: TextStyle(color: AppColor.blackColor.withOpacity(0.5)),
                            border: InputBorder.none,
                            counterText: "",
                            prefixText: '+91',
                            maxLength: 10,
                            validator: (value){
                              if(value!.isEmpty){
                                return 'please enter mobile number';
                              }
                              else if(value.length != 10){
                                return 'please enter 10 digit of number';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.phone,
                            controller: phoneNumberController,
                          ),
                          const SizedBox(height: 30),
                          Container(
                            width: double.infinity,
                            height: 55,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20)
                            ),
                            child: ElevatedButton(
                                onPressed: () {
                                  if(_formKey.currentState!.validate()){
                                    MobileAuthProvider().userPhoneLogin(context, phoneNumberController.text,phoneNumberController.text);
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
                      ),
                    );
                  } else{
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(child: Image.asset(AppImage.loginAuthentication,
                            height: MediaQuery.of(context).size.height/4,
                            width: double.infinity)),
                        const SizedBox(height: 30),
                        const Text('Enter your phone number',style: TextStyle(fontSize: 20)),
                        const SizedBox(height: 10),
                        const Text('You will receive a 6 digit code for phone number verification'),
                        const SizedBox(height: 20),
                        TextFieldMixin().textFieldWidget(
                          labelText: 'Mobile Number',
                          labelStyle: TextStyle(color: AppColor.blackColor.withOpacity(0.5)),
                          border: InputBorder.none,
                          counterText: "",
                          prefixText: '+91',
                          maxLength: 10,
                          validator: (value){
                            if(value!.isEmpty){
                              return 'please enter mobile number';
                            }
                            else if(value.length != 10){
                              return 'please enter 10 digit of number';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.phone,
                          controller: phoneNumberController,
                        ),
                        const SizedBox(height: 30),
                        Container(
                          width: double.infinity,
                          height: 55,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)
                          ),
                          child: ElevatedButton(
                              onPressed: () {
                                if(_formKey.currentState!.validate()){
                                  MobileAuthProvider().userPhoneLogin(context, phoneNumberController.text,phoneNumberController.text);
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
                }
              ),
            ),
          ),
        ),
      )
    );
  }
}
