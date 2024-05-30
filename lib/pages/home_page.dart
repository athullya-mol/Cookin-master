import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookin/apis/recipe_apis.dart';
import 'package:cookin/apis/recipe_reps.dart';
import 'package:cookin/utils/colors.dart';
import 'package:cookin/widget/modal.dart';
import 'package:cookin/widget/searchbar.dart';
import 'package:cookin/widget/widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../utils/recipe.dart';
import '../widget/category.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Recipe> _recipes;
  bool _isLoading = true;
  String username='';
  String photoUrl = '';


  @override
  void initState() {
    super.initState();
    getRecipes();
    getUserData();
  }

  
  void getUserData() async{
   DocumentSnapshot snap = await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get();
   print(snap.data());
   setState(() {
     var data = snap.data() as Map<String, dynamic>;
      username = data['username'];
      photoUrl = data['photoUrl'];
   });
  }

  Future<void> getRecipes() async {
    _recipes = await RecipeApi.getRecipe();
    // _user = await User.get();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 2,
                      ),
                       ProfileInfo(username: username, photoUrl: photoUrl),
                      const SizedBox(height: 40),
                      Row(
                        children: [
                          const Flexible(
                            flex: 5,
                            child: SearchBarFood(
                              hintText: ' Search for food....',
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.02,
                          ),
                          const Flexible(
                            flex: 1,
                            child: FilterModal(),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Categories2(),
                      const SizedBox(
                        height: 7,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: _recipes.map((recipe) {
                            return OverflowCard(
                              repository: RecipesRepository(),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      const MyText(
                        text: 'New Recipes',
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      SizedBox(
                        height: 220,
                        child: OverflowCard2(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
    
  }
}

class ProfileInfo extends StatelessWidget {
  final String? username;
  final String? photoUrl;
  
  const ProfileInfo({
    super.key, this.username, this.photoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
         Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             MyText(
              color: AppColors.textColor,
              fontSize: 28,
              fontWeight: FontWeight.w900,
              text: 'Hello ${username ?? 'Guest'}👋',
            ),
            const MyText(
              text: 'What are you cooking today?',
              color: AppColors.textColor,
              fontWeight: FontWeight.w400,
              fontSize: 15,
            ),
          ],
        ),
        const Spacer(), // Responsive space
       Container(
  height: 45,
  width: 45,
  decoration: BoxDecoration(
    shape: BoxShape.circle,
    image: DecorationImage(
      image: photoUrl != null && photoUrl!.isNotEmpty
          ? NetworkImage(photoUrl!)
          : const AssetImage('images/profile.png') as ImageProvider,
      fit: BoxFit.cover,
    ),
  ),
)


      ],
    );
  }
}
