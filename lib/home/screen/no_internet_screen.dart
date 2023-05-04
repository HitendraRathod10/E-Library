import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
class Background extends StatelessWidget {

  final Widget child;
  const Background({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(child: child),
        IgnorePointer(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.center,
                colors: [
                  AppColor.checkBoxColor.withOpacity(0.2),
                  AppColor.whiteColor.withOpacity(0),
                ],
                //stops: [0, 1],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Widget noInternetDialog({Function? onTap}) {
Widget noInternetDialog() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: const [
      Icon(
        Icons.wifi_off,
        color: AppColor.darkGreen,
        size: 60,
      ),
      Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          "There is no Internet connection Please check Your Internet connection",
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColor.appBlackColor, fontSize: 14),
        ),
      ),

    ],
  );
}

// class NoInternetScreen extends StatefulWidget {
//   final Widget? child;
//   NoInternetScreen({Key? key, this.child}) : super(key: key);
//
//   @override
//   State<NoInternetScreen> createState() => _NoInternetScreenState();
// }
//
// class _NoInternetScreenState extends State<NoInternetScreen> {
//   Widget noInternetDialog(InternetCommonProvider obj) {
//     return Container(
//       decoration: BoxDecoration(
//           color: AppColor.white, borderRadius: BorderRadius.circular(10)),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Image.asset(
//             AppImage.noInternet,
//           ),
//           const Text(
//             "Oops!",
//             textAlign: TextAlign.center,
//             style: const TextStyle(
//                 color: AppColor.black,
//                 fontSize: 30,
//                 fontWeight: FontWeight.bold),
//           ),
//           const Padding(
//             padding: EdgeInsets.all(20),
//             child: Text(
//               "There is no Internet connection Please check Your Internet connection",
//               textAlign: TextAlign.center,
//               style: TextStyle(color: AppColor.black, fontSize: 16),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(20),
//             child: GestureDetector(
//               onTap: () {
//                 print("Try Again Pressed....");
//                 Provider.of<InternetCommonProvider>(context, listen: false)
//                     .initializeInternet(context);
//                 if (Provider.of<InternetCommonProvider>(context, listen: false)
//                     .isInterNetAvailable) {
//                 } else {
//                   toast(
//                       textColor: AppColor.white,
//                       toastMessage: "You are still offline",
//                       backgroundColor: AppColor.cp_blue_bg);
//                 }
//                 // updateApi(context);
//               },
//               child: Container(
//                 decoration: const BoxDecoration(
//                   color: AppColor.cp_blue_bg,
//                 ),
//                 child: const Padding(
//                   padding: EdgeInsets.all(20),
//                   child: Text(
//                     "Try Again",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(color: AppColor.black, fontSize: 16),
//                   ),
//                 ),
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<InternetCommonProvider>(
//       builder: (context, data, _) {
//         return Scaffold(
//             body: Center(
//           child: Stack(
//             fit: StackFit.expand,
//             children: <Widget>[
//               IgnorePointer(
//                   ignoring: !data.isInterNetAvailable, child: widget.child!),
//               if (!data.isInterNetAvailable) noInternetDialog(data)
//             ],
//           ),
//         ));
//       },
//     );
//   }
//
//   updateApi(context) {
//     print("Update Api called!");
//     Provider.of<NewUpdateApiProvider>(context, listen: false)
//         .checkAppUpdate(context)
//         .then((model) async {
//       PackageInfo packageInfo = await PackageInfo.fromPlatform();
//       if (model!.status == 200) {
//         print("CURRENT APP INFO -- ${packageInfo.version}");
//         print("API APP INFO -- ${model.data!.versionCode!}");
//         var apiCode = model.data!.versionCode!.split(".");
//         var packageCode = packageInfo.version.split(".");
//         if (int.parse(apiCode[0]) > int.parse(packageCode[0]) ||
//             int.parse(apiCode[1]) > int.parse(packageCode[1]) ||
//             int.parse(apiCode[2]) > int.parse(packageCode[2])) {
//           Get.off(const NewUpdateScreen());
//         }
//       } else {}
//     });
//   }
// }
