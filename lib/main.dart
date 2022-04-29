import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:onwords_console/login_page.dart';
import 'package:onwords_console/splashScreen.dart';
import 'package:overlay_support/overlay_support.dart';


FirebaseAuth auth = FirebaseAuth.instance;
final databaseReference = FirebaseDatabase.instance.reference().child('staff');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp( const Appis());
}

class Appis extends StatefulWidget {
  const Appis({Key? key}) : super(key: key);

  @override
  State<Appis> createState() => _AppisState();
}

class _AppisState extends State<Appis> {
  @override
  Widget build(BuildContext context) {
    return const OverlaySupport.global(
        child: MaterialApp(
         home: SplashScreenPage(),
          debugShowCheckedModeBanner: false,
        ),
    );
  }
}



