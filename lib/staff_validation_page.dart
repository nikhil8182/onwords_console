import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:onwords_console/data_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'homePage.dart';
import 'login_page.dart';


FirebaseAuth auth = FirebaseAuth.instance;

class StaffValidationPage extends StatefulWidget {
  const StaffValidationPage({Key? key}) : super(key: key);

  @override
  State<StaffValidationPage> createState() => _StaffValidationPageState();
}

class _StaffValidationPageState extends State<StaffValidationPage> {

  late SharedPreferences loginData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(247,249,252,1.0),
      body: Column(
        children: [
          SizedBox(
            height: height*0.10,
          ),
          Text("Choose Destination",style: TextStyle(fontSize: height*0.020),),
          SizedBox(
            height: height*0.050,
          ),
          Container(
            height: height*0.10,
            width: width*0.80,
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            margin: const EdgeInsets.symmetric(horizontal: 50.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25.0)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
               Image(image: const AssetImage("images/task1.png"),height: height*0.070,),
                SizedBox(
                  width: width*0.070,
                ),
                Text("Task Manager",style: TextStyle(fontSize: height*0.020),),
              ],
            ),
          ),
          SizedBox(
            height: height*0.020,
          ),
          auth.currentUser?.email == "ceo@onwords.in"?Container():GestureDetector(
            onTap: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                      const HomePage()));
            },
            child: Container(
              height: height*0.10,
              width: width*0.80,
              margin: const EdgeInsets.symmetric(horizontal: 50.0),
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25.0)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(image: const AssetImage("images/work1.png"),height: height*0.070,),
                  SizedBox(
                    width: width*0.040,
                  ),
                  Text("Work Manager",style: TextStyle(fontSize: height*0.020),),
                ],
              ),
            ),
          ),
          SizedBox(
            height: height*0.020,
          ),
          auth.currentUser?.email == "ceo@onwords.in" ?GestureDetector(
            onTap: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                      const MyApp()));
            },
            child: Container(
              height: height*0.10,
              width: width*0.80,
              margin: const EdgeInsets.symmetric(horizontal: 50.0),
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25.0)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(image: const AssetImage("images/add.png"),height: height*0.070,),
                  SizedBox(
                    width: width*0.040,
                  ),
                 Text("WorkDone Data",style: TextStyle(fontSize: height*0.020),),
                ],
              ),
            ),
          ):Container(),
          SizedBox(
            height: height*0.030,
          ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.orange)
            ),
            onPressed: () async {
                loginData = await SharedPreferences.getInstance();
                setState(() {
                  loginData.setBool('login', true);
                  auth.signOut();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                });
          }, child: Text(" Logout ",style: TextStyle(fontSize: height*0.020),),)
        ],
      ),
    );
  }
}
