// import 'dart:async';
//
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
//
// FirebaseAuth auth = FirebaseAuth.instance;
// final databaseReference = FirebaseDatabase.instance.reference();
//
// class SchedulePage extends StatefulWidget {
//   const SchedulePage({Key key}) : super(key: key);
//
//   @override
//   _SchedulePageState createState() => _SchedulePageState();
// }
//
// class _SchedulePageState extends State<SchedulePage> {
//
//   var scenesData;
//   List scheduleName = [];
//   List selectedRoutine =[];
//   Timer timer;
//   int id = 0;
//   bool validate = false;
//   bool loader = false;
//   SharedPreferences loginData;
//   String authKey = " ";
//   var personalDataJson;
//   bool vibrate = false;
//
//
//   initial() async
//   {
//     loginData = await SharedPreferences.getInstance();
//     setState(() {
//       vibrate = loginData.get('vibrationStatus')??false;
//       authKey = loginData.getString('ownerId')??" ";
//     });
//   }
//
//
//   getData() async {
//     await databaseReference.child(authKey).once().then((value) {
//       scheduleName.clear();
//       var dataJson;
//
//       setState(() {
//         loader = true;
//         dataJson = value.snapshot.value;
//         scenesData = value.snapshot.value;
//       });
//
//       // Map<dynamic, dynamic> values = value.value['SmartHome']['scenes'];
//       Map<dynamic, dynamic> values = dataJson['SmartHome']['schedule'];
//       values.forEach((key, values) {
//         scheduleName.add(values);
//       });
//
//
//     });
//   }
//
//   @override
//   void initState() {
//     initial();
//     timer = Timer.periodic(Duration(seconds: 3), (Timer t) {
//       getData();
//       //   // getName();
//     });
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     timer?.cancel();
//     // TODO: implement dispose
//     super.dispose();
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;
//     return Scaffold(
//       backgroundColor: Theme.of(context).backgroundColor,
//       appBar: AppBar(
//         title: Text("Schedule Page" ,style: Theme.of(context).textTheme.headline5,),
//       ),
//       body: Container(
//         padding: EdgeInsets.fromLTRB(10.0, 70.0, 10.0, 20.0),
//         child: loader ? GridView.builder(
//           scrollDirection: Axis.vertical,
//           itemCount: scheduleName.length, //scenesData.length?? scenesName.length
//           itemBuilder: (BuildContext context, int index) {
//             return GestureDetector(
//               onLongPress: ()async{
//                 showAnotherAlertDialog(context, index);
//               },
//               child: Container(
//                 margin: EdgeInsets.all(10.0),
//                 padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 15.0),
//                 // height: height * 0.15,
//                 // width: width * 0.30,
//                 decoration: BoxDecoration(
//                   //color: Color.fromRGBO(54, 54, 54, 1.0),
//                     color: Theme.of(context).canvasColor,
//                     borderRadius: BorderRadius.circular(25.0)),
//                 child: SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(
//                         height: height * 0.020,
//                       ),
//                       Text('''Name : ${scheduleName[index]['ScheduleName']}''',
//                           style: Theme.of(context).textTheme.bodyText2,
//                           textAlign: TextAlign.left),
//                       SizedBox(
//                         height: height * 0.010,
//                       ),
//                       Text('''Date : ${scheduleName[index]['date']}''',
//                           style: Theme.of(context).textTheme.bodyText2,
//                           textAlign: TextAlign.left),
//                       SizedBox(
//                         height: height * 0.010,
//                       ),
//                       Text('''Time : ${scheduleName[index]['time']}hrs''',
//                           style: Theme.of(context).textTheme.bodyText2,
//                           textAlign: TextAlign.left),
//                       SizedBox(
//                         height: height * 0.010,
//                       ),
//                       Text('''Routines :  ${scheduleName[index]['selectedRoutines'].toString()
//                           .replaceAll(RegExp("[\\p{Ps}\\p{Pe}]", unicode: true), "")}''',
//                           style: Theme.of(context).textTheme.bodyText2,
//                           textAlign: TextAlign.left,),
//
//                       Text('''Time : ${scheduleName[index]['status'] == true?"Completed":"Yet to Happen"}''',
//                           style: Theme.of(context).textTheme.bodyText2,
//                           textAlign: TextAlign.left),
//
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2,
//           ),
//         ): Center(
//           child: CircularProgressIndicator(
//             backgroundColor: Colors.black,
//             valueColor:
//             new AlwaysStoppedAnimation<Color>(
//                 Colors.white),
//           ),
//         )
//       ),
//     );
//   }
//   showAnotherAlertDialog(BuildContext context,index) {
//     // Create button
//     Widget cancelButton = TextButton(
//       child: Text("cancel"),
//       onPressed: (){
//         Navigator.pop(context, false);
//       },
//     );
//     Widget okButton = TextButton(
//       child: Text("ok"),
//       onPressed: (){
//         databaseReference.child(authKey).child('SmartHome')
//             .child('schedule').child(scheduleName[index]['ScheduleName']).remove();
//         Navigator.pop(context, true);
//       },
//     );
//     // Create AlertDialog
//     AlertDialog alert = AlertDialog(
//       backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
//       content: Text("Do you really want to delete this schedule ? ",style: Theme.of(context).dialogTheme.contentTextStyle,),
//       actions: [
//         cancelButton,
//         okButton,
//       ],
//     );
//
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return alert ;
//       },
//     );
//   }
// }
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shared_preferences/shared_preferences.dart';






FirebaseAuth auth = FirebaseAuth.instance;
final databaseReference = FirebaseDatabase.instance.reference();

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  TextEditingController workDone = TextEditingController();
  TextEditingController percentage = TextEditingController();
  late String newTaskTitle;
  bool workDoneValidate = false;
  bool workPercentValidate = false;
  late SharedPreferences loginData;
  TimeOfDay selectedTime = TimeOfDay.now();
  var uiStartTime = TimeOfDay.now();
  var uiEndTime = TimeOfDay.now();
  var currentDate = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd');
  String formattedDate = " ";
  int day = 0;
  int month = 0;
  int year = 0;
  String combination = " ";
  String startTime = " ";
  String endTime = " ";
  FocusNode f1 = FocusNode();
  FocusNode f2 = FocusNode();
  bool everyDay = false;
  String authKey = " ";
  bool vibrate = false;
  late Timer timer;
  bool scheduleStatus= true;
  List existingScheduleName = [];
  var dataJson;
  var email;
  String name = " ";




  ///date and time
  // Future<void> _selectDate() async {
  //   formattedDate = formatter.format(currentDate);
  //   final DateTime pickedDate = await showDatePicker(
  //       context: context,
  //       builder: (BuildContext context, Widget child) {
  //         return Theme(
  //           data: ThemeData(
  //             colorScheme: ColorScheme.light(
  //               primary: Colors.blue,
  //               onPrimary: Colors.white,
  //               surface: Colors.white,
  //               onSurface: Colors.blue,
  //             ),
  //             dialogBackgroundColor: Colors.white,
  //           ),
  //           child: child ??Text(""),
  //         );
  //       },
  //       initialDate: currentDate,
  //       firstDate: DateTime(2020),
  //       lastDate: DateTime(2050));
  //   if (pickedDate != null && pickedDate != currentDate) {
  //     setState(() {
  //       currentDate = pickedDate;
  //       day = pickedDate.day;
  //       month = pickedDate.month;
  //       year = pickedDate.year;
  //       combination = "$day/$month/$year";
  //     });
  //   }
  // }
  // // time() {
  // //   selectedTime = TimeOfDay.now();
  // // }
  //
  _startTime() async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != selectedTime) {
      setState(() {
        uiStartTime = timeOfDay;
        startTime = uiStartTime.toString().substring(10, 15);
        combination = currentDate.toString().split(' ')[0];
      });
    }
  }

  _endTime() async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != selectedTime) {
      setState(() {
        uiEndTime = timeOfDay;
        endTime = uiEndTime.toString().substring(10, 15);
      });
    }
  }



  initialData() async
  {
    loginData = await SharedPreferences.getInstance();
    setState(() {
      // vibrate = loginData.get('vibrationStatus')??false;
      // authKey = loginData.getString('ownerId')??" ";
      readData();
    });
  }


  fireData() async {
    //print("im at before atlast of firedata");
    databaseReference.once().then((value) async {
      dataJson = value.snapshot.value;
        for (var element in value.snapshot.children) {
          for (var ele in element.children) {
            email = ele.value;
            if( email['email'] == auth.currentUser?.email){
              setState(() {
                name = email['name'];
              });
              for (var el in ele.children) {
                for (var e in el.children) {
                  print(e.value);
                }
              }
            }
          }
        }
      // Map<dynamic, dynamic> values = value.snapshot.value as Map;
      // values.forEach((key,values) {
      //   // print(key);
      //   // print(".............>>>>>");
      //   // print(values);
      //   // print(values["workManager"]);
      //   // list.add(values['name']);
      //   setState(() {
      //     if(values['name'] != null){
      //       staffName.add(values['name']);
      //     }
      //     workManager.add(values["workManager"]);
      //   });
      // });
      ///
      // print(workManager);
      // print(workManager);
      // print(staffName);

      //   var xx = jsonEncode(dataJson);
      //   var _dataJson = jsonDecode(xx);
      //   print(_dataJson.length);
      // // final userdata = new Map<String, dynamic>.from(_dataJson['staff']);
      // // print(userdata.keys.length);
      // setState(() {
      //   nik = _dataJson['staff']['x'].toString();
      // });
      // for (var x in _dataJson['staff']['x']){
      //   print(x);
      // }
      // final json = value.snapshot.value as Map<dynamic, dynamic>;
      // final message = Message.fromJson(json);


      // final json = dataJson['staff'] as Map<dynamic, dynamic>;
      // print(json);
      // final message = Data.fromJson(json);
      //
      // print("message $message");
      // for(int i =0; i<userdata.keys.length;i++)
      //   {
      //     print(userdata);
      //   }


      // Map<dynamic, dynamic> res = _dataJson;
      // var x =[];
      // x.add(res);
      //
      // print(x.length);
      // for(var x in res){
      //   print(x);
      // }
      // list.add(res.keys);
      // print(list);

      // for(int i =0;i<dataJson['staff'].length;i++){
      //   print(i);
      //   // print(dataJson[]);
      // }
    });



  }



  readData(){
    databaseReference.child(authKey).child('SmartHome').child('schedule').once().then((value){
      value.snapshot.children.forEach((element) {
        setState(() {
          existingScheduleName.add(element.key);
        });
      });
    });
  }

  @override
  void initState() {
    initialData();
    // time();
    // timer = Timer.periodic(const Duration(seconds: 1), (timer) {
    //
    // });
    workDone = TextEditingController();
    percentage = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(247,249,252,1.0),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: SingleChildScrollView(
          child: Column(
              children: [
                SizedBox(
                  height: height*0.037,
                ),
                Row(
                  children: [
                    IconButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.clear)
                    ),
                  ],
                ),
                SizedBox(
                  height: height*0.037,
                ),
                //headline2: TextStyle(color: Colors.grey,fontWeight: FontWeight.w800,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("    Set Time",style: TextStyle(color: Colors.black,fontSize: height*0.020),),
                    SizedBox(
                      height: height*0.017,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            Text(" From",style: TextStyle(color: Colors.black,fontSize: height*0.015),),
                            GestureDetector(
                              onTap: (){
                                _startTime();
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 10.0),
                                padding: EdgeInsets.all(6.0),
                                width: width * 0.30,
                                height: height*0.060,
                                decoration: BoxDecoration(
                                  //color: Color.fromRGBO(54, 54, 54, 1.0),
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(10.0)),
                                child:  Center(
                                  child: Text(
                                      // selectedTime.format(context),
                                      uiStartTime.format(context),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: height*0.020,)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(" To ",style: TextStyle(color: Colors.black,fontSize: height*0.015),),
                            GestureDetector(
                              onTap: (){
                               _endTime();
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 10.0),
                                padding: EdgeInsets.all(6.0),
                                width: width * 0.30,
                                height: height*0.060,
                                decoration: BoxDecoration(
                                  //color: Color.fromRGBO(54, 54, 54, 1.0),
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(10.0)),
                                child:  Center(
                                  child: Text(
                                    // selectedTime.format(context),
                                      uiEndTime.format(context),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: height*0.020,)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: height*0.037,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.0),
                  padding: const EdgeInsets.all(8.0),
                  width: width * 0.90,
                  height: height*0.18,
                  decoration: BoxDecoration(
                    //color: Color.fromRGBO(54, 54, 54, 1.0),
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(15.0)),
                  child: TextFormField(
                    onEditingComplete: (){
                      f1.unfocus();
                    },
                    focusNode: f1,
                    autofocus: false,
                    controller: workDone,
                    style: Theme.of(context).textTheme.bodyText2,
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 8,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintText: '  Enter your work here ',
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      errorText: workDoneValidate ? ' enter your work' : null,
                    ),
                  ),
                ),
                SizedBox(
                  height: height*0.017,
                ),
                Row(
                  children: [
                    Text("     Percentage",style: TextStyle(color: Colors.black,fontSize: height*0.015),),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20.0),
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      width: width * 0.160,
                      height: height*0.060,
                      decoration: BoxDecoration(
                        //color: Color.fromRGBO(54, 54, 54, 1.0),
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(15.0)),
                      child: TextFormField(
                        onEditingComplete: (){
                          f2.unfocus();
                        },
                        focusNode: f2,
                        autofocus: false,
                        controller: percentage,
                        style: Theme.of(context).textTheme.bodyText2,
                        keyboardType: TextInputType.number,
                        minLines: 1,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          suffix: const Text("%"),
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorText: workPercentValidate ? 'percent' : null,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: height*0.017,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 40.0,vertical: 10.0),
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Theme.of(context).canvasColor)
                      ),
                      onPressed: (){

                        fireData();
                        // setState(() {
                        //   workDone.text.isEmpty ? workDoneValidate = true : workDoneValidate = false;
                        //   percentage.text.isEmpty ? workPercentValidate = true : workPercentValidate = false;
                        //   if (workDoneValidate)
                        //   {
                        //     showSimpleNotification(
                        //       const Text(
                        //         "please enter the workDone",
                        //         style: TextStyle(color: Colors.white),
                        //       ),
                        //       background: Colors.red,
                        //     );
                        //   } else if((workDoneValidate == false) && (workPercentValidate == false)){
                        //
                        //     if((startTime != " ")  && (endTime != " ")){
                        //
                        //       var dateFormat = DateFormat('h:ma');
                        //       DateTime durationStart = dateFormat.parse(uiStartTime.format(context).toString().replaceAll(" ", ""));
                        //       DateTime durationEnd = dateFormat.parse(uiEndTime.format(context).toString().replaceAll(" ", ""));
                        //       var differenceInHours = durationEnd.difference(durationStart).toString().split('.')[0];
                        //       print(differenceInHours);
                        //       print(endTime);
                        //       print(startTime);
                        //
                        //       var da = {
                        //         'from': startTime,
                        //         "to" : endTime,
                        //         "name": name,
                        //         "time_in_hours": differenceInHours,
                        //         "workDone": workDone.text,
                        //         "workPercentage": percentage.text,
                        //       };
                        //       // print(da);
                        //     }else{
                        //       showSimpleNotification(
                        //         const Text(
                        //           "please choose time",
                        //           style: TextStyle(color: Colors.white),
                        //         ),
                        //         background: Colors.red,
                        //       );
                        //     }
                        //
                        //
                        //   } else {
                        //     showSimpleNotification(
                        //       const Text(
                        //         "please percentage",
                        //         style: TextStyle(color: Colors.white),
                        //       ),
                        //       background: Colors.red,
                        //     );
                        //   }
                        // });
                      }, child: const Text(" Done ",style: TextStyle(color: Colors.orange),)),
                )
              ]
          ),
        ),
      ),
    );
  }
}
