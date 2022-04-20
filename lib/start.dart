import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:map_fl/HomePage.dart';
import 'package:sort/sort.dart';

class StartPage extends StatefulWidget {
  const StartPage({Key key}) : super(key: key);

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {

  List<QueryDocumentSnapshot> res;

  double _distanceInMeters1 = Geolocator.distanceBetween(
        55.677,
        37.762,
        55.659,
        37.749
    );

  double _distanceInMeters2 = Geolocator.distanceBetween(
      55.651,
      37.743,
      55.659,
      37.749
  );

  List<double> sorted = [
    Geolocator.distanceBetween(
      55.677,
      37.762,
      55.659,
      37.749
  ),
  Geolocator.distanceBetween(
  55.651,
  37.743,
  55.659,
  37.749
  ),
    Geolocator.distanceBetween(
        55.677,
        37.762,
        55.659,
        37.749
    )
  ].simpleSort();

  bool isF=false;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Future<void> loc() async {
  //   var l = await FirebaseFirestore
  //       .instance
  //       .collection('location');
  //   QuerySnapshot querySnapshot = await l.get();
  //
  //   querySnapshot.docs.map((e) => res.add(e.data()));
  //
  // }

  _add() {
    firestore.collection("location").add({
      "longitude" : 55.6770248,
      "latitude" : 37.7619781,
      "name": "м.Люблино"
    }).then((value) {
      print(value.id);
    });
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text('Start Page'),
  //     ),
  //     body: Center(
  //       child: Column(
  //           children: [
  //             RaisedButton(
  //                 onPressed: _get,
  //               child: Text('Добавить'),
  //             ),
  //             ElevatedButton(
  //         onPressed: () {
  //           Navigator.push(
  //             context,
  //             MaterialPageRoute(builder: (context) => HomePage()),
  //           );
  //         },
  //         child: Text('Open Map'),
  //       ),
  //             SizedBox(height: 16),
  //             Text(""),
  //             res != null ?
  //             Expanded(
  //                child: ListView.builder(
  //                     padding: const EdgeInsets.all(8),
  //                     itemCount: sorted.length,
  //                     itemBuilder: (_, int index) =>
  //                         Text("${sorted[index]}")
  //
  //                 )
  //             )
  //                 : Container(child: Text("Text"),)
  //         ],
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
        .collection("location")
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (!streamSnapshot.hasData) return Text("No positions");
          return ListView(
            children: getLocation(streamSnapshot),
          );
        },
      ),
    );
  }

  getLocation(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.docs.map((e) =>  ListTile(
      title: Text(e["name"]),
      subtitle: Text(e["latitude"].toString() + ", " + e["longitude"].toString()),
    )).toList();
  }

}
