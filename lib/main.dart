import 'dart:io';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
FirebaseFirestore db = FirebaseFirestore.instance;




void initialize_fb()  async{
      await Firebase.initializeApp
(
options: DefaultFirebaseOptions.currentPlatform,
);}

void main() {
  initialize_fb();
  runApp(
    MaterialApp(
      home:MyApp()
    )
  );



}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme:ThemeData(
            useMaterial3: true,
            colorSchemeSeed: Colors.green,
            brightness: Brightness.dark
        ),

      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class Player extends StatelessWidget {
  Player(this.cat,this.country);
  String country,cat;
  @override



  Widget build(BuildContext context) {

    YoutubePlayerController cont = YoutubePlayerController(
      initialVideoId: 'iLnmTe5Q2Qw',
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: true,
      ),
    );

    return Card(


        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(cat),
            Text(country),

            YoutubePlayer(
            controller: cont,
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.amber,
            progressColors: const ProgressBarColors(
              playedColor: Colors.amber,
              handleColor: Colors.amberAccent,
            ),

                  ),
          ],
        ),
    );

  }
}

class _MyHomePageState extends State<MyHomePage> {
  var dooc;

  List<List<String>> content_list=[];
  void show() async{
    content_list = [];
    await db.collection("links").get().then((event) {
      for (var doc in event.docs) {
        content_list.add([doc.data()['CATEGORY'],doc.data()['COUNTRY'],doc.data()['LINK']]);
       setState(() {

       });
      }
    });

  }

  void add(String country, String cat, String link){
    content_list = [];
    final user = <String, dynamic>{
      "COUNTRY": country,
      "CATEGORY": cat,
      "LINK": link
    };

    db.collection("links").add(user).then((DocumentReference doc) =>
        //print('DocumentSnapshot added with ID: ${doc.id}'));
        print("")

    );
    show();
  }

  List<String> rowdetail = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Column(
            children: [
              ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(shape: StadiumBorder()),
                  icon: const Icon(Icons.admin_panel_settings),
                  label: Text("Admin"),
                  onPressed: (){add("ITALY", "ART", "https://www.youtube.com/watch?v=BmHTQsxxkPk");}
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(shape: StadiumBorder()),
                icon: const Icon(Icons.supervised_user_circle),
                label: Text("Users"),
                  onPressed: (){show(); print(dooc);},
              ),
            ],
          ),

          Column(
            children: [
              SizedBox(
                 height: 400,
                 width: 400,
                 child: ListWheelScrollView(
                   children: content_list.map((e) => Player(e[0],e[1])).toList(),
                   itemExtent:300 ),
               )
            ]
          ),
        ],
      )
    );
  }
}
