import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:onwords_console/homePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data_page.dart';
import 'login_page.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({Key? key}) : super(key: key);

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> with TickerProviderStateMixin{
  bool isLoggedIn = false;
    late AnimationController _controller;


    initial() async {
      SharedPreferences loginData = await SharedPreferences.getInstance();
      setState(() {
        isLoggedIn = loginData.getBool('login') ?? true;
      });
    }

  @override
  void initState() {
    super.initState();
    initial();
    // Timer(Duration(seconds: 5), () {
    //   _navigateUser();
    // });
    _controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
  }

  _navigateUser() async {
    if(!isLoggedIn){
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
    }else{
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor:  const Color.fromRGBO(247,249,252,1.0),
        body: Container(
          height: height*1.0,
          width: width*1.0,
            child:
            // Image(image: AssetImage("assets/splashscreen.png")),
            // SpinKitThreeBounce(
            //   color: Colors.orange,
            //   size: 50.0,
            // )),
        Center(
          child: Lottie.asset(
          'images/splash1.json',
          controller: _controller,
          height: MediaQuery.of(context).size.height * 1.0,
          width: width*1.0,
          animate: true,
          onLoaded: (composition) {
            _controller..duration = composition.duration..forward().whenComplete((){
              _navigateUser();
            });
          },
          ),
        ),
        ),
    );
  }
}