import 'package:ebook/addbook/add_book_screen.dart';
import 'package:ebook/mylibrary/my_library.dart';
import 'package:ebook/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import '../category/category_screen.dart';
import '../home/home_screen.dart';
import '../utils/app_colors.dart';

class BottomNavBarScreen extends StatefulWidget {
  const BottomNavBarScreen({Key? key}) : super(key: key);

  @override
  State<BottomNavBarScreen> createState() => _BottomNavBarScreenState();
}

class _BottomNavBarScreenState extends State<BottomNavBarScreen> {

  int _selectedIndex=0;
  String imageUrl="https://t4.ftcdn.net/jpg/03/64/21/11/360_F_364211147_1qgLVxv1Tcq0Ohz3FawUfrtONzz8nq3e.jpg";
  List<Widget> buildScreen(){
    return [
      const HomeScreen(),
      const MyLibrary(),
      const AddBookScreen(),
      const CategoryScreen(),
      const Profile()
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: buildScreen().elementAt(_selectedIndex),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        currentIndex: _selectedIndex,
        backgroundColor: AppColor.whiteColor,
        selectedLabelStyle: const TextStyle(color: AppColor.appColor),
        unselectedLabelStyle: const TextStyle(color: AppColor.appBlackColor,),
        selectedItemColor: AppColor.appColor,
        unselectedItemColor: AppColor.greyColor,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
              label: "Home",
              icon: Icon(Icons.home,size: 24,
              )),
          BottomNavigationBarItem(
              label: "My Library",
              icon: Icon(Icons.library_books_sharp,size: 24,
              )),
          BottomNavigationBarItem(
              label: "AddBook",
              icon: Icon(Icons.add_box_outlined,size: 24,
              )),
          BottomNavigationBarItem(
              label: "Category",
              icon: Icon(Icons.my_library_books_outlined,size: 24,
              )),
          BottomNavigationBarItem(
              label: "Profile",
              icon: Icon(Icons.person,size: 24,
              )),
        ],
      ),
    );
  }
}

