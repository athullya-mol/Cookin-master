import 'package:cookin/firebase_options.dart';
import 'package:cookin/pages/start_screen.dart';
import 'package:cookin/services/shared_preferences.dart';
import 'package:cookin/utils/navigatio_bar.dart';
import 'package:cookin/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    await getSavedRecipesFromPrefs(currentUser.uid);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Cookin',
          theme: ThemeData.dark().copyWith(
            useMaterial3: true,
            textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green)
                .copyWith(background: AppColors.white),
          ),
          home: const ScaffoldMessenger(child: AutoLogin()),
        );
      },
    );
  }
}
class AutoLogin extends StatefulWidget {
  const AutoLogin({Key? key}) : super(key: key);

  @override
  _AutoLoginState createState() => _AutoLoginState();
}

class _AutoLoginState extends State<AutoLogin> {
  @override
  void initState() {
    super.initState();
    // Use post-frame callback to navigate after the initial frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkCurrentUser();
    });
  }

  Future<void> checkCurrentUser() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const BottonNavBar()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const startScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
