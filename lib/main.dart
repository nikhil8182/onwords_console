import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp( const MaterialApp(home: MyApp()));
}



FirebaseAuth auth = FirebaseAuth.instance;
final databaseReference = FirebaseDatabase.instance.reference().child('staff');
final staffDatabaseReference = FirebaseDatabase.instance.reference().child('staff');


class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var dataJson;
  List staffName = [];
  List workManager = [];
  var nik="";

   fireData() async {
    //print("im at before atlast of firedata");
    databaseReference.once().then((value) async {
      staffName.clear();
      workManager.clear();
      dataJson = value.snapshot.value;
      // print(dataJson[Key]);

      Map<dynamic, dynamic> values = value.snapshot.value as Map;
      values.forEach((key,values) {
        // print(key);
        // print(".............>>>>>");
        // print(values);
        // print(values["workManager"]);
        // list.add(values['name']);
        setState(() {
          if(values['name'] != null){
            staffName.add(values['name']);
          }
          workManager.add(values["workManager"]);
        });
      });
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

    staffDatabaseReference.onChildAdded.forEach((element) async{

      // workManager.clear();

      var val;
      // print(element.snapshot.value);
      // val = element.snapshot.key;

      // if(val['workManager'] != null){
      //   print("8888888888888888888888");
      //   print(val['workManager']['timeSheet']);
      // }

      // Map<dynamic, dynamic> valu = val as Map;
      // valu.forEach((key,values) {
      //   print("hello");
      //   if(valu["timeSheet"] != null){
      //     print(valu["timeSheet"]);
      //   }
      //   // workManager.add(values["workManager"]);
      // });


    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Data"),
        actions: [
          ElevatedButton(
              onPressed: (){
                fireData();
              }, child: const Text("data",style: TextStyle(fontSize: 12),)),
          
        ],
      ),
      body: GridView.builder(
        itemCount: staffName.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 4.0,
            mainAxisSpacing: 4.0),
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
              onTap: () {
                // turnOffTheHueLight(lightId[index], !lightState[index]);
              },
              child: Container(
                margin: EdgeInsets.all(10.0),
                padding: EdgeInsets.all(18.0),
                decoration: BoxDecoration(
                  color: Colors.green,
                    borderRadius: BorderRadius.circular(25.0),
                    // border: Border.all(color: Colors.red)
                ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(staffName[index],textDirection: TextDirection.ltr,),
                          // Text(workManager[index]??" ")
                        ],
                      ),
                    ],
                  )));
        },
      ),
    );
  }
}

class Message {
  final String text;
  final DateTime date;

  Message(this.text, this.date);
}