import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

FirebaseAuth auth = FirebaseAuth.instance;
final databaseReference = FirebaseDatabase.instance.reference().child('staff');
// final staffDatabaseReference = FirebaseDatabase.instance.reference().child('staff');

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var dataJson;
  TimeOfDay selectedTime = TimeOfDay.now();
  var dummyTime = TimeOfDay.now();
  var currentDate = DateTime.now();
  List staffName = [];
  List from = [];
  List to = [];
  List time_in_hours = [];
  List workDone = [];
  List workPrecentage = [];
  var nik = "";
  var wrkManage;
  String formattedDate = " ";
  var formatter = DateFormat('yyyy-MM-dd');
  int day = 0;
  int month = 0;
  int year = 0;
  String combination = " ";
  String dumTime = " ";
  var data;
  var personalData;
  bool loader = false;
  String loading = "No Data....";
  List dummyData = [];
  List name = [];


  Future<void> _selectDate(BuildContext context) async {
    formattedDate = formatter.format(currentDate);
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        builder: (context, child) {
          return Theme(
              data: ThemeData(
                colorScheme: const ColorScheme.light(
                  primary: Colors.blue,
                  onPrimary: Colors.white,
                  surface: Colors.blue,
                  onSurface: Colors.black12,
                ),
                dialogBackgroundColor: Colors.white,
              ),
              child: child ?? const Text(""));
        },
        initialDate: currentDate,
        firstDate: DateTime(2020, 1, 1),
        lastDate: DateTime(2050, 1, 1));
    if (pickedDate != null && pickedDate != currentDate) {
      setState(() {
        currentDate = pickedDate;
        combination = currentDate.toString();
        fireData();
      });
    }
  }

  fireData() async {
    //print("im at before atlast of firedata");
    databaseReference.once().then((value) async {
      dummyData.clear();
      staffName.clear();
      from.clear();
      to.clear();
      time_in_hours.clear();
      workDone.clear();
      workPrecentage.clear();
      setState(() {
        loader = false;
      });
      dataJson = value.snapshot.value;
      if (DateTime.now().isBefore(currentDate)) {
        setState(() {
          loading = "Please select a proper date";
        });
      } else {
        for (var element in value.snapshot.children) {
          // print(element.key);
          personalData = element.value;
          // staffName.add(personalData['name']);

          for (var ele in element.children) {
            if (ele.key == "workManager") {
              for (var el in ele.children) {
                for (var e in el.children) {
                  if (e.key == combination.split(' ')[0]) {
                    // print(e.value);
                    // dummyData =
                    for (var val in e.children) {
                      data = val.value;
                      print(data);
                      print("----------------------------------------");
                      if(data['name'] == personalData['name'])
                      {
                        print(data);
                        dummyData.add(data);
                        // print(dummyData);
                      }
                      setState(() {
                        loader = true;
                        staffName.add(data['name']);
                        to.add(data['to']);
                        from.add(data['from']);
                        time_in_hours.add(data['time_in_hours']);
                        workDone.add(data['workDone']);
                        workPrecentage.add(data['workPercentage']);
                        // print(staffName.toSet().toList());
                        // Map<String, int> count = {};
                        // for (var i in staffName) {
                        //   count[i] = (count[i] ?? 0)+1;
                        // }
                        // print(count.toString());
                        // print(to);
                        // print(from);
                        // print(time_in_hours);
                        // print(workDone);
                        // print(workPrecentage);
                      });
                    }
                  }
                }
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

      setState((){
        name = staffName.toSet().toList();
        // print(name);
      });

      // Map<String, int> count = {};
      // for (var i in staffName) {
      //   count[i] = (count[i] ?? 0)+1;
      // }
      // // print(count.toString());
      //
      // countvalues = count;
    });
  }



  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.orange,
            title: combination.split(' ')[0] != " "
                ? Text("Date : ${combination.split(' ')[0]}")
                : const Text("WorkDone Data"),
            actions: [
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.orange)),
                  onPressed: () {
                    combination = " ";
                    _selectDate(context);
                    // fireData();
                    // testData();
                  },
                  child: const Text(
                    " Get ",
                    style: TextStyle(fontSize: 12),
                  )),
            ],
          ),
          body: loader ? ListView.builder(
                  // itemCount: staffName.toSet().toList().length,
                  itemCount: name.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                        margin: const EdgeInsets.all(5.0),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 13.0, vertical: 18.0),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(25.0),
                          // border: Border.all(color: Colors.red)
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(name[index],textAlign: TextAlign.left,
                                  style: const TextStyle(fontWeight: FontWeight.bold),),
                                  ],
                            ),
                            SizedBox(
                                            height: height*0.010,
                                          ),
                            ListView.builder(
                                shrinkWrap: true,
                                itemCount: dummyData.length,
                                itemBuilder: (BuildContext context, int ind) {
                              return dummyData[ind]['name'].contains(name[index])? Card(
                                color: Colors.white54,
                                child: ListTile(
                                  subtitle:Text("working hours: ${dummyData[ind]['time_in_hours']??" "}"),
                                       leading: Column(
                                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                         children: [
                                           Text("${dummyData[ind]['from']??" "}"),
                                           Text("To",style: TextStyle(fontSize: height*0.007),),
                                           Text("${dummyData[ind]['to']??" "}"),
                                         ],
                                       ) ,
                                       trailing: Text("${dummyData[ind]['workPercentage']??" "}"),
                                       title: Text("${dummyData[ind]['workDone']??" "}",textAlign: TextAlign.left,),
                                )
                              ):Container();
                            }),
                          ],
                        )
                    );
                  },
                )
              : Center(
                  child: Text(loading),
                )),
    );
  }
}


//
// GridView.builder(
//   itemCount: staffName.length,
//   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//       crossAxisCount: 2,
//       crossAxisSpacing: 1.0,
//       mainAxisSpacing: 1.0),
//   itemBuilder: (BuildContext context, int index) {
//     return Container(
//         margin: const EdgeInsets.all(5.0),
//         padding: const EdgeInsets.symmetric(horizontal: 13.0,vertical: 18.0),
//         decoration: BoxDecoration(
//           color: Colors.grey.shade300,
//           borderRadius: BorderRadius.circular(25.0),
//           // border: Border.all(color: Colors.red)
//         ),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(staffName[index],textAlign: TextAlign.left,style: const TextStyle(fontWeight: FontWeight.bold),),
//                   Text(workPrecentage[index]??" ")
//                 ],
//               ),
//               SizedBox(
//                 height: height*0.010,
//               ),
//               Text("From : ${from[index]}",textAlign: TextAlign.left,),
//               Text("To : ${to[index]}",textAlign: TextAlign.left,),
//               Text("Time_in_hours : ${time_in_hours[index]}",textAlign: TextAlign.left,),
//               Text("WorkDone : ${workDone[index]}",textAlign: TextAlign.left,),
//             ],
//           ),
//         ));
//   },
// )