import 'package:ebook/login/firebaseauth/phone_sign_in_auth.dart';
import 'package:ebook/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import '../../utils/app_images.dart';
//ignore: must_be_immutable
class OtpScreen extends StatefulWidget {
  String verificationId;
  String phoneNumber;
  OtpScreen({Key? key,required this.verificationId,required this.phoneNumber}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 20,right: 20),
              child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(child: Image.asset(AppImage.otp,
                          height: MediaQuery.of(context).size.height/4,
                          width: double.infinity)),
                      const SizedBox(height: 30),
                      const Text('Enter your OTP',style: TextStyle(fontSize: 20)),
                      const SizedBox(height: 10),
                      const Text('Please enter the 6 digit verification code sent to'),
                      const SizedBox(height: 20),
                      Pinput(
                        onCompleted: (pin) {
                          debugPrint(pin);
                        },
                        controller: otpController,
                        length: 6,
                        pinAnimationType: PinAnimationType.slide,
                        defaultPinTheme: PinTheme(
                          width: 56,
                          height: 56,
                          textStyle: TextStyle(fontSize: 20, color: AppColor.blackColor.withOpacity(0.6)),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColor.greyColor.withOpacity(0.3)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Container(
                        width: double.infinity,
                        height: 55,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)
                        ),
                        child:  ElevatedButton(
                            onPressed: () async {
                              debugPrint('verification => ${widget.verificationId}');
                              await MobileAuthProvider().userPhoneVerify(context, otpController.text.toString(),widget.verificationId,widget.phoneNumber);
                            },
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(AppColor.darkGreen),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    )
                                )
                            ),
                            child: const Text('Continue')
                        )
                      )
                    ],
              ),
            ),
          ),
        )
    );
  }
}
