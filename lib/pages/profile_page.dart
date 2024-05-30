import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookin/models/user_model.dart';
import 'package:cookin/pages/login_page.dart';
import 'package:cookin/utils/colors.dart';
import 'package:cookin/utils/navigatio_bar.dart';
import 'package:cookin/utils/pickimage.dart';
import 'package:cookin/services/storage_services.dart';
import 'package:cookin/widget/text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:solar_icons/solar_icons.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserModel? userModel;
  Uint8List? _image;
  final StorageServices _storageServices = StorageServices();

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() async {
    try {
      DocumentSnapshot snap = await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
       print("Fetched user data: ${snap.data()}"); // Print fetched user data
    if (snap.exists) {
      setState(() {
        userModel = UserModel.fromSnap(snap);
      });
    }
  } catch (error) {
    print('Error fetching user data: $error');
    // Handle error gracefully
  }
}


  void selectImage() async {
    Uint8List? imagePicked = await pickImage(ImageSource.gallery);
    setState(() {
      _image = imagePicked!;
    });
  }

  Future<void> _deleteAccount() async {
    try {
      // Delete user document from Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .delete();

      // Delete user account from Firebase Authentication
      await FirebaseAuth.instance.currentUser!.delete();

      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ));
    } catch (error) {
      print('Error deleting account: $error');
      // Display error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error deleting account')));
    }
  }

  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ));
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          'Logged out Successfully',
          style: TextStyle(
            fontSize: 16,
            letterSpacing: 1,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.success,
      ));
    } catch (error) {
      print('Error logging out: $error');
      // Display error message to the user
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Error logging out')));
    }
  }

  Future<void> _updateProfile() async {
    try {
      if (_image != null) {
        // Upload image to Firebase Storage
        String photoUrl = await _storageServices.uploadImageToStorage(
            "user_profile_images", _image!, false);

        // Update user data in Firestore with the new image URL
        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({'photoUrl': photoUrl});

        setState(() {
          userModel = userModel?.copyWith(photoUrl: photoUrl);
        });
      }
      // Display success message to the user
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          'Profile Updated Successfully',
          style: TextStyle(
            fontSize: 16,
            letterSpacing: 1,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.success,
      ));
    } catch (error) {
      print('Error updating profile: $error');
      // Display error message to the user
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error updating profile $error'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'User Profile',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textColor,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            size: 30,
            color: AppColors.textColor,
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const BottonNavBar(),));
          },
        ),
        actions: [
          TextButton(
            onPressed: (){
              setState(() {
               _updateProfile();
    });
            },
            child: const Text('Save',
            style: TextStyle(
              color: AppColors.primaryColor
            )
            )
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 5),
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: Column(children: [
                  Stack(children: [
                    CircleAvatar(
                      radius: 68,
                      backgroundImage: _image != null
                          ? MemoryImage(_image!)
                          : userModel?.photoUrl != null &&
                                  userModel!.photoUrl.isNotEmpty
                              ? NetworkImage(userModel!.photoUrl)
                              : const AssetImage('images/profile.png')
                                  as ImageProvider,
                    ),
                    Positioned(
                        bottom: -2,
                        right: -2,
                        child: IconButton(
                          onPressed: () {
                            selectImage();
                          },
                          style: const ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(
                            AppColors.primaryColor,
                          )),
                          icon: const Icon(
                            Icons.add_a_photo,
                            size: 20,
                          ),
                        ))
                  ]),
                  const SizedBox(
                    height: 10,
                  ),
                  MyText(
                      text: userModel?.username ?? 'Username',
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryColor,
                    ),
                  Container(
                    alignment: AlignmentDirectional.center,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 3, vertical: 5),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(32, 56, 56, 56),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        MyText(
                          text: 'About',
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        MyText(
                          text: 'I am a chef lolz  ',
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      child: Row(
                        children: [
                          Icon(SolarIconsOutline.questionCircle,
                              color: Colors.black54),
                          SizedBox(
                            width: 15,
                          ),
                          MyText(
                            text: 'Help & Support',
                            fontSize: 18,
                          )
                        ],
                      ),
                    ),
                    Divider(
                      color: Colors.black12,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      child: Row(
                        children: [
                          Icon(SolarIconsOutline.chatSquareCall,
                              color: Colors.black54),
                          SizedBox(
                            width: 15,
                          ),
                          MyText(
                            text: 'Feedback',
                            fontSize: 18,
                          )
                        ],
                      ),
                    ),
                    Divider(
                      color: Colors.black12,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      child: Row(
                        children: [
                          Icon(SolarIconsOutline.shieldUser,
                              color: Colors.black54),
                          SizedBox(
                            width: 15,
                          ),
                          MyText(
                            text: 'Legal',
                            fontSize: 18,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () => _logout(),
                              icon: const Icon(SolarIconsOutline.logout_2,
                                  color: Colors.red)),
                          const SizedBox(
                            width: 15,
                          ),
                          const MyText(
                            text: 'Logout',
                            fontSize: 18,
                          )
                        ],
                      ),
                    ),
                    const Divider(
                      color: Colors.black12,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Row(
                        children: [
                          IconButton(
                              icon: const Icon(SolarIconsOutline.trashBinTrash,
                                  color: Colors.red),
                              onPressed: () {
                                QuickAlert.show(
                                  context: context,
                                  type: QuickAlertType.confirm,
                                  backgroundColor: Colors.black,
                                  barrierColor: Colors.black.withOpacity(0.41),
                                  barrierDismissible: false,
                                  text: 'Do you want to delete',
                                  textColor: Colors.white,
                                  titleColor: Colors.white,
                                  confirmBtnText: 'Delete',
                                  cancelBtnText: 'Cancel',
                                  confirmBtnColor: AppColors.primaryColor,
                                  customAsset: 'images/delete.gif',
                                  onConfirmBtnTap: () {
                                    _deleteAccount();

                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginPage(),
                                        ));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text(
                                        'Account Deleted!',
                                        style: TextStyle(
                                          fontSize: 16,
                                          letterSpacing: 1,
                                          color: Colors.white,
                                        ),
                                      ),
                                      backgroundColor: AppColors.success,
                                    ));
                                  },
                                );
                              }),
                          const SizedBox(
                            width: 15,
                          ),
                          const MyText(
                            text: 'Delete Account',
                            fontSize: 18,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget iconTexButton(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.red),
          const SizedBox(
            width: 15,
          ),
          MyText(
            text: text,
            fontSize: 18,
          )
        ],
      ),
    );
  }
}
