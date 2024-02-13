import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:ebook/addbook/firebaseauth/add_book_auth.dart';
import 'package:ebook/firebase/firebase_collection.dart';
import 'package:ebook/home/screen/no_internet_screen.dart';
import 'package:ebook/login/provider/login_provider.dart';
import 'package:ebook/mixin/textfield_mixin.dart';
import 'package:ebook/utils/app_colors.dart';
import 'package:ebook/utils/app_utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../home/provider/internet_provider.dart';
import '../widget/bottom_navigation_bar.dart';
import '../widget/provider/loading_provider.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({Key? key}) : super(key: key);

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  File? file, pdfFile, authorImageFile;
  String bookFileName = '';
  String bookImageName = '';
  String authorImageName = '';
  var url = '';
  TextEditingController bookTitleController = TextEditingController();
  TextEditingController bookSubTitleController = TextEditingController();
  TextEditingController authorNameController = TextEditingController();
  TextEditingController authorDesignationController = TextEditingController();
  TextEditingController authorAboutController = TextEditingController();
  TextEditingController publisherController = TextEditingController();
  TextEditingController publishDateController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool checkBoxValue = false;
  late AddBookProvider addBookProvider;

  void selectImage(context) async {
    //Pick Image File
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowMultiple: false, type: FileType.image);
    if (result == null) return;
    final filePath = result.files.single.path;
    File compressImage =
        await Provider.of<LoginProvider>(context, listen: false)
            .imageSizeCompress(image: File(filePath!));
    setState(() {
      file = compressImage;
      bookImageName = result.files.first.name;
    });
  }

  void selectAuthorImage(context) async {
    //Pick Image File
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowMultiple: false, type: FileType.image);
    if (result == null) return;
    final filePath = result.files.single.path;
    File compressImage =
        await Provider.of<LoginProvider>(context, listen: false)
            .imageSizeCompress(image: File(filePath!));
    setState(() {
      authorImageFile = compressImage;
      authorImageName = result.files.first.name;
    });
  }

  void selectBookPdf(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['pdf']);
    if (result == null) return;
    final filePath = result.files.single.path;
    setState(() {
      pdfFile = File(filePath!);
      bookFileName = result.files.first.name;
    });
  }

  void uploadFile(context) async {
    FocusScope.of(context).unfocus();
    Provider.of<LoadingProvider>(context, listen: false).startLoading();
    if (file == null && pdfFile == null) return;
    final imageDestination = 'images/$bookImageName';
    final bookDestination = 'book/$bookFileName';
    try {
      final ref1 = FirebaseStorage.instance.ref().child(imageDestination);
      final ref2 = FirebaseStorage.instance.ref().child(bookDestination);
      UploadTask imageUploadsTask = ref1.putFile(file!);
      UploadTask bookUploadsTask = ref2.putFile(pdfFile!);
      final snapshot1 = await imageUploadsTask.whenComplete(() {});
      final snapshot2 = await bookUploadsTask.whenComplete(() {});
      final imageUrl = await snapshot1.ref.getDownloadURL().whenComplete(() {});
      final bookUrl = await snapshot2.ref.getDownloadURL().whenComplete(() {});

      checkBoxValue == true ? await authorUploadFile(imageUrl) : '';

      var querySnapShot = await FirebaseCollection()
          .userCollection
          .where('userMobile', isEqualTo: FirebaseCollection.currentUserId)
          .get();

      for (var snapshotData in querySnapShot.docChanges) {
        AddBookProvider().createBook(
            bookTitle: bookTitleController.text,
            bookSubTitle: bookSubTitleController.text,
            authorName: authorNameController.text.trim(),
            publisher: publisherController.text,
            publishDate: publishDateController.text,
            bookDescription: descriptionController.text,
            country: Provider.of<AddBookProvider>(context, listen: false)
                .selectCountry
                .toString(),
            bookType: Provider.of<AddBookProvider>(context, listen: false)
                .selectBookGenre
                .toString(),
            bookPrice: priceController.text,
            bookImage: imageUrl,
            bookPdf: bookUrl,
            timestamp: Timestamp.now(),
            currentUserMobile:
                FirebaseAuth.instance.currentUser!.phoneNumber.toString(),
            bookRating: 0.1,
            userName: snapshotData.doc.get('userName'));
        AppUtils.instance.showToast(toastMessage: 'Added Book');
        Provider.of<LoadingProvider>(context, listen: false).stopLoading();
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const BottomNavBarScreen()));
      }
      debugPrint("Image URL = $imageUrl");
      debugPrint("Pdf URL = $bookUrl");
    } catch (e) {
      debugPrint('Failed to upload image');
    }
  }

  Future<void> authorUploadFile(String imageUrl) async {
    if (authorImageFile == null) return;
    final authorImageDestination = 'author/$authorImageName';
    try {
      final authorImageRef =
          FirebaseStorage.instance.ref().child(authorImageDestination);
      UploadTask authorUploadsTask = authorImageRef.putFile(authorImageFile!);
      final snapshot3 = await authorUploadsTask.whenComplete(() {});
      final authorUrl =
          await snapshot3.ref.getDownloadURL().whenComplete(() {});

      checkBoxValue == true
          ? AddBookProvider().addAuthorDetails(
              authorName: authorNameController.text.trim(),
              authorImage: authorUrl,
              authorDesignation: authorDesignationController.text,
              authorAbout: authorAboutController.text,
              authorBookImage: imageUrl,
              authorBookName: bookTitleController.text,
              authorBookDescription: descriptionController.text,
              timestamp: Timestamp.now())
          : '';

      debugPrint("Author URL = $authorUrl");
    } catch (e) {
      debugPrint('Failed to upload image');
    }
  }
@override
  void dispose() {
    addBookProvider.selectCountry= null;
    super.dispose();
  }

  @override
  void initState() {
    addBookProvider = Provider.of<AddBookProvider>(context, listen: false) ;
    super.initState();
  }

  // Icon countryIcon = getCountryIcon(country);

  @override
  Widget build(BuildContext context) {
    return Consumer<InternetProvider>(builder: (context, internetSnapshot, _) {
      internetSnapshot.checkInternet().then((value) {});
      return internetSnapshot.isInternet
          ? SafeArea(
              child: Scaffold(
                body: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Form(
                    key: _formKey,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 20.0, right: 20, top: 50),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Add Book',
                              style: TextStyle(fontSize: 20)),
                          const SizedBox(
                            height: 40,
                          ),
                          TextFieldMixin().textFieldWidget(
                            labelText: 'Book Title',
                            border: InputBorder.none,
                            controller: bookTitleController,
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.trim().isEmpty) {
                                return 'Please enter title';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFieldMixin().textFieldWidget(
                            labelText: 'Book SubTitle',
                            controller: bookSubTitleController,
                            border: InputBorder.none,
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.trim().isEmpty) {
                                return 'Please enter subtitle';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFieldMixin().textFieldWidget(
                            labelText: 'Author Name',
                            border: InputBorder.none,
                            controller: authorNameController,
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.trim().isEmpty) {
                                return 'Please enter author name';
                              }
                              return null;
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Text('Add author details'),
                              Checkbox(
                                checkColor: Colors.white,
                                value: checkBoxValue,
                                onChanged: (bool? value) {
                                  setState(() {
                                    checkBoxValue = value!;
                                  });
                                },
                              ),
                            ],
                          ),
                          Visibility(
                            visible: checkBoxValue,
                            child: TextFieldMixin().textFieldWidget(
                              labelText: 'Author Designation',
                              controller: authorDesignationController,
                              border: InputBorder.none,
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.trim().isEmpty) {
                                  return 'Please enter author designation';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                          Visibility(
                            visible: checkBoxValue,
                            child: TextFieldMixin().textFieldWidget(
                              labelText: 'About',
                              border: InputBorder.none,
                              maxLines: 3,
                              controller: authorAboutController,
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.trim().isEmpty) {
                                  return 'Please enter author description';
                                } else if (value.length < 100) {
                                  return 'Please enter maximum 100 latter';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: checkBoxValue == true ? 20 : 0),
                          TextFieldMixin().textFieldWidget(
                              labelText: 'Publisher',
                              controller: publisherController,
                              border: InputBorder.none,
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.trim().isEmpty) {
                                  return 'Please enter Publisher Name';
                                }
                                return null;
                              }),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFieldMixin().textFieldWidget(
                            labelText: 'Publish Date',
                            readOnly: true,
                            controller: publishDateController
                              ..text =
                                  DateTime.now().toString().substring(0, 10),
                            border: InputBorder.none,
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.trim().isEmpty) {
                                return 'Please enter publish date';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Consumer<AddBookProvider>(builder:
                              (BuildContext context, snapshot, Widget? child) {
                            return DropdownButtonFormField2<String>(
                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 20),
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
                                  offset: const Offset(0, -20)),
                              iconStyleData: const IconStyleData(
                                  icon: Icon(Icons.arrow_drop_down)),
                              barrierDismissible: true ,
                              autofocus: true,
                              isExpanded: true,
                              value: snapshot.selectCountry,
                              validator: (value) {
                                if (value == null) {
                                  return 'Country is required';
                                }
                                return null;
                              },
                              hint: const Text('Select Country'),
                              style: const TextStyle(
                                  color: AppColor.appBlackColor, fontSize: 14),
                              onChanged: (String? newValue) {
                                setState(() {
                                  if (mounted) {
                                    snapshot.selectCountry = newValue!;
                                    snapshot.getCountry;
                                  }
                                });
                                print(
                                    "Country ${snapshot.selectCountry} $newValue");
                              },
                              items: snapshot.selectCountryList
                                  .map((item) => DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(
                                          item,
                                        ),
                                      ))
                                  .toList(),
                            );
                          }),
                          const SizedBox(
                            height: 20,
                          ),
                          Consumer<AddBookProvider>(builder:
                              (BuildContext context, snapshot, Widget? child) {
                            return DropdownButtonFormField2(
                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 20),
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
                                  offset: const Offset(0, -20)),
                              iconStyleData: const IconStyleData(
                                  icon: Icon(Icons.arrow_drop_down)),
                              barrierDismissible: false,
                              autofocus: true,
                              isExpanded: true,
                              value: snapshot.selectBookGenre,
                              validator: (value) {
                                if (value == null) {
                                  return 'Genre is required';
                                }
                                return null;
                              },
                              hint: const Text('Select Genre'),
                              // isDense: true,
                              style: const TextStyle(
                                  color: AppColor.appBlackColor, fontSize: 14),
                              onChanged: (String? newValue) {
                                snapshot.selectBookGenre = newValue!;
                                snapshot.getBookGenre;
                              },
                              items: snapshot.selectBookGenreList
                                  .map<DropdownMenuItem<String>>(
                                      (String leaveName) {
                                return DropdownMenuItem<String>(
                                    value: leaveName, child: Text(leaveName));
                              }).toList(),
                            );
                          }),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFieldMixin().textFieldWidget(
                            labelText: 'Description',
                            border: InputBorder.none,
                            maxLines: 3,
                            controller: descriptionController,
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.trim().isEmpty) {
                                return 'Please enter short description';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFieldMixin().textFieldWidget(
                            hintText: "Price",
                            controller: priceController,
                            prefixIcon:addBookProvider.selectCountry== null?null:Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: addBookProvider.getCountryIcon(),
                            ),
                            contentPadding:addBookProvider.selectCountry== null?const EdgeInsets.symmetric(vertical: 10): const EdgeInsets.only(top: 15),
                            keyboardType: TextInputType.number,
                            border: InputBorder.none,
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.trim().isEmpty) {
                                return "Please enter price";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: GestureDetector(
                                    onTap: () {
                                      selectImage(context);
                                    },
                                    child: file == null
                                        ? Container(
                                            color: AppColor.darkGreyColor
                                                .withOpacity(0.3),
                                            height: 80,
                                            width: 120,
                                            child: const Center(
                                                child: Text('Select Image',
                                                    style: TextStyle(
                                                        color: AppColor
                                                            .whiteColor))))
                                        : Image.file(
                                            file!,
                                            height: 80,
                                            width: 120,
                                            fit: BoxFit.fill,
                                          )),
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: GestureDetector(
                                    onTap: () {
                                      selectBookPdf(context);
                                    },
                                    child: pdfFile == null
                                        ? Container(
                                            color: AppColor.darkGreyColor
                                                .withOpacity(0.3),
                                            height: 80,
                                            width: 120,
                                            child: const Center(
                                                child: Text('Select Book',
                                                    style: TextStyle(
                                                        color: AppColor
                                                            .whiteColor))))
                                        : Container(
                                            color: AppColor.darkGreyColor
                                                .withOpacity(0.3),
                                            height: 80,
                                            width: 120,
                                            child: Center(
                                                child: Text(bookFileName,
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                        color: AppColor
                                                            .darkGreen))))),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Visibility(
                            visible: checkBoxValue,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      selectAuthorImage(context);
                                    },
                                    child: authorImageFile == null
                                        ? Column(
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(15),
                                                decoration: BoxDecoration(
                                                    color: AppColor.darkGreen,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100)),
                                                child: const Icon(
                                                  Icons.person_add_alt_1_sharp,
                                                  size: 50,
                                                  color: AppColor.whiteColor,
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              const Text('Select Author')
                                            ],
                                          )
                                        : ClipOval(
                                            child: Image.file(
                                              authorImageFile!,
                                              height: 80,
                                              width: 80,
                                              fit: BoxFit.fill,
                                            ),
                                          )),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Container(
                            width: 150,
                            height: 45,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20)),
                            child: ElevatedButton(
                                onPressed: () {
                                  String toastMessage = '';

                                  if (_formKey.currentState!.validate() &&
                                      pdfFile != null &&
                                      file != null &&
                                      (checkBoxValue == true
                                          ? (authorImageFile != null &&
                                              authorImageFile!.path.isNotEmpty)
                                          : true)) {
                                    uploadFile(context);
                                    addBookProvider.selectCountry = '';
                                    setState(() {});
                                  } else {
                                    if (file == null && pdfFile == null) {
                                      toastMessage =
                                          "Select Image And Book To Proceed.";
                                    } else {
                                      if (pdfFile == null) {
                                        toastMessage += ' Select Book. ';
                                      }

                                      if (file == null) {
                                        toastMessage += ' Select Book Image. ';
                                      }

                                      if (checkBoxValue == true &&
                                          pdfFile != null &&
                                          file != null) {
                                        if (authorImageFile == null ||
                                            authorImageFile!.path.isEmpty) {
                                          toastMessage +=
                                              ' Select Author Image. ';
                                        }
                                      }
                                    }

                                    if (toastMessage.isNotEmpty) {
                                      AppUtils.instance.showToast(
                                        toastMessage: toastMessage,
                                      );
                                    }
                                  }
                                },
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            AppColor.darkGreen),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ))),
                                child: const Text(
                                  'Add Book',
                                )),
                          ),
                          const SizedBox(height: 50)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          : noInternetDialog();
    });
  }
}
