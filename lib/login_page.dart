import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/svg.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:onwords_console/homePage.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'data_page.dart';



FirebaseAuth auth = FirebaseAuth.instance;
final databaseReference = FirebaseDatabase.instance.reference().child('staff');



class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  late String loginState;
  late SharedPreferences loginData;
  bool newUser = false;
  bool _isHidden = true;
  bool hasInternet = false;
  ConnectivityResult result = ConnectivityResult.none;
  List userId = [];
  List userToken = [];
  String mToken = " ";
  late AndroidNotificationChannel channel;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;






  ///get token from firestore
  // void getTokenFromFirestore(String collName) async {
  //
  //   QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection(collName).get();
  //
  //   querySnapshot.docs.asMap().forEach((key, value) {
  //     // print(value.id);
  //   });
  //   for (int i = 0; i < querySnapshot.docs.length; i++) {
  //     var a = querySnapshot.docs[i];
  //
  //     //print("helllo ${a.id}");
  //     userId.add(a.id);
  //
  //     final data = await FirebaseFirestore.instance.collection(collName).doc(a.id).get();
  //
  //     data.data()?.forEach((key, value) {
  //       userToken.add(value);
  //     });
  //
  //
  //
  //   }
  // }


  ///sendpush notification
  // void sendPushMessage(String token, String title, String body) async {
  //   try {
  //     await http.post(
  //       Uri.parse('https://fcm.googleapis.com/fcm/send'),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json',
  //         'Authorization': 'key=AAAAyfCaNws:APA91bEo187K7j-Xc7o0tAoaU0rYIKS2n3oR0tZB6TBv0eGZLXjQURLc9AJZ7au6pQSevaw-UGLhw_ashDHdQJ8ZuKQqFVRqtj7GjFajI6uYg4CWCeroZOkj6I3XgqQS2BgWjEmdOEzB',
  //       },
  //       body: jsonEncode(
  //         <String, dynamic>{
  //           'notification': <String, dynamic>{
  //             'body': body,
  //             'title': title
  //           },
  //           'priority': 'high',
  //           'data': <String, dynamic>{
  //             'click_action': 'FLUTTER_NOTIFICATION_CLICK',
  //             'id': '1',
  //             'status': 'done'
  //           },
  //           "to": token,
  //         },
  //       ),
  //     );
  //   } catch (e) {
  //     print("error push notification");
  //   }
  // }

  void saveToken(String token,String saveEmail) async {

    await FirebaseFirestore.instance.collection(auth.currentUser!.uid).doc(auth.currentUser?.uid).set({
      'token' : token,
      'email' : saveEmail,
    });

  }

  void getToken(String saveEmail) async {
    await FirebaseMessaging.instance.getToken().then(
            (token) {
          setState(() {
            mToken = token!;
          });

          saveToken(token!,saveEmail);
        }
    );
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  void listenFCM() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              // TODO add a proper drawable resource to android, for now using
              //      one that already exists in example app.
              icon: 'launch_background',
            ),
          ),
        );
      }
    });
  }

  void loadFCM() async {
    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        importance: Importance.high,
        enableVibration: true,
      );

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      /// Create an Android Notification Channel.
      ///
      /// We use this channel in the `AndroidManifest.xml` file to override the
      /// default FCM channel to enable heads up notifications.
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      /// Update the iOS foreground notification presentation options to allow
      /// heads up notifications.
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  register(String saveEmail){

    // getTokenFromFirestore(famName);

    requestPermission();

    loadFCM();

    listenFCM();

    getToken(saveEmail);

  }

  Future<void> internet() async {

    Connectivity().onConnectivityChanged.listen((result) {
      setState(() {
        this.result = result;
      });
    });

    InternetConnectionChecker().onStatusChange.listen((status) async {
      final hasInternet = status == InternetConnectionStatus.connected;
      setState(() {
        this.hasInternet = hasInternet;
      });
    });
    hasInternet = await InternetConnectionChecker().hasConnection;
    result = await Connectivity().checkConnectivity();
  }


  @override
  void initState() {

    // Timer.periodic(Duration(seconds: 1), (Timer t) => getTime());
    //check_if_already_login();

    email = TextEditingController();
    pass = TextEditingController();


    super.initState();
  }


  void check_if_already_login() async {
    loginData = await SharedPreferences.getInstance();
    newUser = (loginData.getBool('login') ?? true);
    // print(newUser);
    if (newUser == false) {
      // Navigator.pushReplacement(
      //     context, new MaterialPageRoute(builder: (context) => HomePage()));
    }
  }


  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  @override
  void dispose() {
    email.dispose();
    pass.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(247,249,252,1.0),
      body: SingleChildScrollView(
        child: Container(
          height: height * 1.0,
          width: width * 1.0,
          color: const Color.fromRGBO(247,249,252,1.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: height * 0.10,
                ),
                SvgPicture.asset(
                  'images/logo.svg',height: height*0.08,
                ),
                Column(
                  children:  [
                    Text("Hey Welcome Back !",
                      style:TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: height*0.032),
                    ),
                    SizedBox(
                      height: height * 0.0126,
                    ),
                    Text("Sign in to continue to the admin console",
                      style:TextStyle(color: Colors.black26,fontSize: height*0.014),
                    ),
                  ],
                ),
                SizedBox(
                  height: height * 0.020,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0,vertical: 05.0),
                  child: SvgPicture.asset(
                    'images/login.svg',
                  ),
                ),
                Container(
                  height: height*0.44,
                  width: width * 1.0,
                  margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(255, 255, 255,1.0),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: height * 0.020,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Email-address", style:TextStyle(color: Colors.black26,fontSize: height*0.014),),
                          SizedBox(
                            height: height * 0.010,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 1.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black,width: 1.0),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: TextField(
                              controller: email,
                              cursorColor: Colors.orange,
                              style: Theme.of(context).textTheme.bodyText2,
                              keyboardType: TextInputType.emailAddress,
                              maxLines: null,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(5.0),
                                icon: const Icon(Icons.mail_outline,color: Colors.black,),
                                border: InputBorder.none,
                                enabledBorder : Theme.of(context).inputDecorationTheme.enabledBorder,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                filled: true,
                                fillColor: Colors.transparent,
                                hintText: "Yourname@onwords.in",
                                hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
                                focusedBorder: Theme.of(context).inputDecorationTheme.focusedBorder,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * 0.034,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Password", style:TextStyle(color: Colors.black26,fontSize: height*0.014),),
                          SizedBox(
                            height: height * 0.010,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 1.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black,width: 1.0),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: TextField(
                              controller: pass,
                              obscureText: _isHidden,
                              cursorColor: Colors.orange,
                              style: Theme.of(context).textTheme.bodyText2,
                              decoration: InputDecoration(
                                icon: const Icon(Icons.lock_open,color: Colors.black,),
                                suffix: InkWell(
                                  onTap: _togglePasswordView,
                                  child: Icon(
                                    _isHidden
                                        ? Icons.visibility
                                        : Icons.visibility_off, color: Colors.grey,
                                  ),
                                ),
                                errorBorder: InputBorder.none,
                                disabledBorder : InputBorder.none,
                                enabledBorder : Theme.of(context).inputDecorationTheme.enabledBorder,
                                border: InputBorder.none ,
                                filled: true,
                                fillColor: Colors.transparent,
                                hintText: "Password",
                                hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
                                focusedBorder: Theme.of(context).inputDecorationTheme.focusedBorder,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * 0.030,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                              onTap: () async {
                                hasInternet = await InternetConnectionChecker().hasConnection;
                                result = await Connectivity().checkConnectivity();

                                if(hasInternet) {
                                  try {
                                    await auth.signInWithEmailAndPassword(email: email.text.replaceAll(' ', ''),password: pass.text.replaceAll(' ', ''));
                                    register(email.text.replaceAll(' ', ''));
                                    loginData = await SharedPreferences.getInstance();
                                    await loginData.clear();
                                    setState(() {
                                      loginData.setBool('login', false);
                                      loginData.setString('username', email.text);
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const HomePage()));
                                    });
                                  } catch (e) {
                                    setState(() {
                                      loginState = "Incorrect Password or Email";
                                      final snackBar = SnackBar(
                                        content: Text(loginState),
                                        backgroundColor: Colors.red,
                                      );
                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                    });
                                  }
                                }
                                else{
                                  showSimpleNotification(
                                    const Text("No Network",
                                      style: TextStyle(color: Colors.white),),
                                    background: Colors.red,
                                  );
                                }
                              },
                              child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 145.0,vertical: 10.0),
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(77, 50, 187, 1.0),
                                      border: Border.all(color: Colors.black,width: 1.0),
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    child: const Center(
                                      child: Text("Sign In",
                                        style:TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * 0.030,
                      ),
                      GestureDetector(
                        onTap: (){
                          // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SignUpPage()));
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 70.0,vertical: 10.0),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(255,255,255, 1.0),
                            border: Border.all(color: Colors.black,width: 1.0),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: const [
                              Image(image: AssetImage('images/Google.png'),height: 20,),
                              Text("Continue with google",
                                style:TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: height * 0.020,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
