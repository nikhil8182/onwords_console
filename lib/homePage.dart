import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shared_preferences/shared_preferences.dart';






FirebaseAuth auth = FirebaseAuth.instance;
final databaseReference = FirebaseDatabase.instance.reference().child('staff');

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
  String todaysDate = " ";
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
  List from = [];
  List to = [];
  List workDoneContent = [];
  List workDonePercentage = [];
  var data;
  var dataJson;
  var email;
  String name = " ";
  var workDoneDates;
  var rootKeyForData;
  var workManagerKey;
  var timeSheetKey;





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


  readData() async {
    todaysDate = currentDate.toString().split(' ')[0];
    //print("im at before atlast of firedata");
    setState(() {
      to.clear();
      from.clear();
      workDoneContent.clear();
      workDonePercentage.clear();
    });
    databaseReference.once().then((value) async {
      dataJson = value.snapshot.value;
        for (var element in value.snapshot.children) {
          email = element.value;
          if( email['email'] == auth.currentUser?.email){
            setState(() {
              name = email['name'];
            });
            for (var ele in element.children) {
              for (var el in ele.children) {
                for (var e in el.children) {
                  if(e.key == todaysDate){
                    for (var val in e.children) {
                      data = val.value;
                      setState(() {
                        to.add(data['to']);
                        from.add(data['from']);
                        workDoneContent.add(data['workDone']);
                        workDonePercentage.add(data['workPercentage']);
                      });
                    }
                  }
                }
              }
            }
          }
        }
    });
  }



  uploadData(String fromTime, String toTime,String date,Map totalData){

    databaseReference.once().then((value) async {
      dataJson = value.snapshot.value;
      for (var element in value.snapshot.children) {
        email = element.value;
        if( email['email'] == auth.currentUser?.email){
          rootKeyForData = element.key;
          setState(() {
            name = email['name'];
          });
          for (var ele in element.children) {
            if (ele.key == 'workManager') {
              workManagerKey = ele.key;
              for (var el in ele.children) {
                timeSheetKey = el.key;
                for (var e in el.children) {
                  databaseReference.child(rootKeyForData).child(workManagerKey).child(timeSheetKey).child(date).child('$fromTime to $toTime').set(totalData);
                }
              }
            }
          }
        }
      }
      readData();
    });
  }





  @override
  void initState() {
    todaysDate = currentDate.toString().split(' ')[0];
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
                  margin: const EdgeInsets.symmetric(horizontal: 20.0),
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
                          // hintText: "    %",
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
                        setState(() {
                          workDone.text.isEmpty ? workDoneValidate = true : workDoneValidate = false;
                          percentage.text.isEmpty ? workPercentValidate = true : workPercentValidate = false;
                          if (workDoneValidate)
                          {
                            showSimpleNotification(
                              const Text(
                                "please enter the workDone",
                                style: TextStyle(color: Colors.white),
                              ),
                              background: Colors.red,
                            );
                          } else if((workDoneValidate == false) && (workPercentValidate == false)){

                            if((startTime != " ")  && (endTime != " ")){

                              var dateFormat = DateFormat('h:ma');
                              DateTime durationStart = dateFormat.parse(uiStartTime.format(context).toString().replaceAll(" ", ""));
                              DateTime durationEnd = dateFormat.parse(uiEndTime.format(context).toString().replaceAll(" ", ""));
                              var differenceInHours = durationEnd.difference(durationStart).toString().split('.')[0];

                              var da = {
                                'from': startTime,
                                "to" : endTime,
                                "name": name,
                                "time_in_hours": differenceInHours,
                                "workDone": workDone.text,
                                "workPercentage": "${percentage.text}%",
                              };
                              uploadData(startTime.toString(),endTime.toString(),todaysDate,da);

                              showSimpleNotification(
                                const Text(
                                  "Work Submitted successfully",
                                  style: TextStyle(color: Colors.white),
                                ),
                                background: Colors.green,
                              );
                              workDone.clear();
                              percentage.clear();
                              uiStartTime = TimeOfDay.now();
                              uiEndTime = TimeOfDay.now();
                              // print(da);
                            }else{
                              showSimpleNotification(
                                const Text(
                                  "please choose time",
                                  style: TextStyle(color: Colors.white),
                                ),
                                background: Colors.red,
                              );
                            }
                          } else {
                            showSimpleNotification(
                              const Text(
                                "please percentage",
                                style: TextStyle(color: Colors.white),
                              ),
                              background: Colors.red,
                            );
                          }
                        });
                      }, child: const Text(" Done ",style: TextStyle(color: Colors.orange),)),
                ),
                from.isNotEmpty? ListView.builder(
                  shrinkWrap: true,
                itemCount: from.length,
                itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                    onTap: () {
                      // turnOffTheHueLight(lightId[index], !lightState[index]);
                    },
                    child: Container(
                        margin: const EdgeInsets.all(10.0),
                        padding: const EdgeInsets.symmetric(horizontal: 13.0,vertical: 18.0),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(25.0),
                          // border: Border.all(color: Colors.red)
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("From :  ${from[index]}",textAlign: TextAlign.left,),
                              Text("To      :  ${to[index]}",textAlign: TextAlign.left,),
                              Text("Work :   ${workDoneContent[index]}",textAlign: TextAlign.left,),
                              Text("Percentage : ${workDonePercentage[index]}",textAlign: TextAlign.left,),
                            ],
                          ),
                        )
                    )
                );
                  },
                ):const Center(
                  child: Text("No work Entry Registered")
                )
              ]
          ),
        ),
      ),
    );
  }
}
