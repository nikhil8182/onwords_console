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
  var nik="";
  var wrkManage;
  String formattedDate = " ";
  var formatter = DateFormat('yyyy-MM-dd');
  int day = 0;
  int month = 0;
  int year = 0;
  String combination = " ";
  String dumTime = " ";
  var data;
  bool loader = false;
  String loading = "No Data....";


  Future<void> _selectDate(BuildContext context) async {
    formattedDate = formatter.format(currentDate);
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        builder: (context,child){
          return Theme(data: ThemeData(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              surface: Colors.blue,
              onSurface: Colors.black12,
            ),
            dialogBackgroundColor: Colors.white,
          ),child: child ?? const Text(""));
        },
        initialDate: currentDate,
        firstDate: DateTime(2020,1,1),
        lastDate: DateTime(2050,1,1));
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
      if(DateTime.now().isBefore(currentDate))
      {
        setState(() {
          loading = "Please select a proper date";
        });
      }else{
        for (var element in value.snapshot.children) {
          for (var ele in element.children) {
            if (ele.key == "workManager") {
              for (var el in ele.children) {
                for (var e in el.children) {
                  if (e.key == combination.split(' ')[0]) {
                    for (var val in e.children) {
                      data = val.value;
                      setState(() {
                        loader = true;
                        staffName.add(data['name']);
                        to.add(data['to']);
                        from.add(data['from']);
                        time_in_hours.add(data['time_in_hours']);
                        workDone.add(data['workDone']);
                        workPrecentage.add(data['workPercentage']);
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
    });



  }


  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.orange,
            title: combination.split(' ')[0] != " " ?Text("Date : ${combination.split(' ')[0]}"):const Text("WorkDone Data"),
            actions: [
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.orange)
                  ),
                  onPressed: (){
                    combination = " ";
                    _selectDate(context);
                    // fireData();
                    // testData();
                  }, child: const Text(" Get ",style: TextStyle(fontSize: 12),)),

            ],
          ),
          // body: Column(
          //   children: [
          //     Text(combination.split(' ')[0]),
          //     Text(combination.split(' ')[0]),
          //   ],
          // ),
          //   body: StreamBuilder(
          //       stream: databaseReference.orderByKey().onValue,
          //       builder: (context,  AsyncSnapshot<dynamic> snapshot){
          //         final listTile = <Container>[];//ListTile
          //         if(snapshot.hasData){
          //
          //           final staffDetails = (snapshot.data! as DatabaseEvent).snapshot.value as Map<Object?,dynamic>;
          //               staffDetails.forEach((key, value) {
          //             final nextOrder  = Map<String,dynamic>.from(value);
          //             // print(nextOrder.keys);
          //
          //            if(nextOrder['workManager'] != null)
          //            {
          //              nextOrder['workManager'].forEach((key, value) {
          //                final work = Map<String,dynamic>.from(value);
          //                if((work.values) != null){
          //                  work.forEach((key, value) {
          //                    final timeSheet = Map<String, dynamic>.from(value);
          //                    timeSheet.forEach((key, value) {
          //                         wrkManage =  Map<String, dynamic>.from(value);
          //                    });
          //                  });
          //                }
          //              });
          //            }
          //             final orderTile = Container(
          //                           margin: EdgeInsets.all(10.0),
          //                           padding: EdgeInsets.all(18.0),
          //                           decoration: BoxDecoration(
          //                             color: Colors.green,
          //                               borderRadius: BorderRadius.circular(25.0),
          //                               // border: Border.all(color: Colors.red)
          //                           ),
          //                             child: Column(
          //                               crossAxisAlignment: CrossAxisAlignment.start,
          //                               children: [
          //                                 Row(
          //                                   children: [
          //                                     Text(nextOrder['name'],textDirection: TextDirection.ltr,),
          //                                     // Text(workManager[index]??" ")
          //                                   ],
          //                                 ),
          //                                 Text(wrkManage['workPercentage'],textDirection: TextDirection.ltr,),
          //                                 Text(wrkManage['workDone'],textDirection: TextDirection.ltr,),
          //                               ],
          //                             ));
          //             listTile.add(orderTile);
          //           });
          //         }
          //           return  GridView(gridDelegate:
          //             const SliverGridDelegateWithFixedCrossAxisCount(
          //                   crossAxisCount: 2,
          //                   crossAxisSpacing: 4.0,
          //                   mainAxisSpacing: 4.0),
          //           children: listTile);
          // }
          body: loader ? GridView.builder(
            itemCount: staffName.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 1.0,
                mainAxisSpacing: 1.0),
            itemBuilder: (BuildContext context, int index) {
              return Container(
                  margin: const EdgeInsets.all(5.0),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(staffName[index],textAlign: TextAlign.left,style: const TextStyle(fontWeight: FontWeight.bold),),
                            Text(workPrecentage[index]??" ")
                          ],
                        ),
                        SizedBox(
                          height: height*0.010,
                        ),
                        Text("From : ${from[index]}",textAlign: TextAlign.left,),
                        Text("To : ${to[index]}",textAlign: TextAlign.left,),
                        Text("Time_in_hours : ${time_in_hours[index]}",textAlign: TextAlign.left,),
                        Text("WorkDone : ${workDone[index]}",textAlign: TextAlign.left,),
                      ],
                    ),
                  ));
            },
          ):Center(child: Text(loading),)
      ),
    );
  }
}

