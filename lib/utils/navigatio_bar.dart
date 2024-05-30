import 'package:cookin/pages/home_page.dart';
import 'package:cookin/pages/profile_page.dart';
import 'package:cookin/pages/saved_recipes.dart';
import 'package:cookin/utils/utils.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class BottonNavBar extends StatefulWidget {
  const BottonNavBar({super.key});

  @override
  State<BottonNavBar> createState() => _BottonNavBarState();
}

class _BottonNavBarState extends State<BottonNavBar> {
  int selectedIndex = 0;

  final List<Widget> pages = [
    const HomePage(),
     SavedPage(userId: FirebaseAuth.instance.currentUser!.uid,),
    // const CreateRecipeScreen(recipeNameImage: null,),
    const ProfilePage(),
  ];
  @override
  void initState() {
    pages;
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: pages[selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        height: 55,
        color: AppColors.primaryColor,
        backgroundColor: AppColors.primaryColor.withOpacity(0.5),
        animationDuration: const Duration(milliseconds: 500),
        index: selectedIndex,
        onTap: (int index) {
          setState(() {
            selectedIndex = index;
          });
        },
        items: const [
          Icon(Icons.home_outlined,
          size: 30,
          ),
          Icon(Icons.bookmark_border_outlined,
          size: 30,
          ),
          // Icon(Icons.auto_awesome,
          // size: 30,
          // ),
          Icon(Icons.person,
          size: 30,
          ),
        ],
      )
    );
  }
}
