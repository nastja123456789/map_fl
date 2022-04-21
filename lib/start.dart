import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:map_fl/HomePage.dart';
import 'package:sort/sort.dart';
import 'package:latlong2/latlong.dart' as myLat;

class StartPage extends StatefulWidget {
  const StartPage({Key key}) : super(key: key);

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {

  List<QueryDocumentSnapshot> res;
  List<Marker> markers;
  Map<double, double> mapDouble;
  List<double> result = [];
  List<double> k = [];
  List<double> v = [];
  bool isF = false;
  List<double> r=[];

  @override
  void initState() {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore
        .collection("location")
        .get()
        .then((QuerySnapshot q) {
      q.docs.forEach((el) {
        initMarker(el["latitude"], el["longitude"]);
      });
    });
    isF = true;

    if (k.length > 1) {
      distance();
    }
  }

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


  // FirebaseFirestore firestore = FirebaseFirestore.instance;

  // loc() {
  //   firestore
  //       .collection("location")
  //       .get()
  //       .then((QuerySnapshot q) {
  //     q.docs.forEach((el) {
  //       initMarker(el["latitude"], el["longitude"]);
  //     });
  //   });
  //
  // }


  void initMarker(lat, long) {
    k.add(lat);
    v.add(long);
    print(k.last);
    print(v.last);
  }

  void distance() {
    setState(() {
      for (int i=0;i<k.length-1;i++) {
        r.add(Geolocator.distanceBetween(k[i], v[i], k[i+1], v[i+1]));
      }

      //r.add(Geolocator.distanceBetween(k[1], v[1], k[2], v[2]));
      for (int i=0;i<r.length;i++) {
        result.add((r[i].floorToDouble())/1000);
      }
      result.simpleSort();
    });

    print(result);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Start Page'),
      ),
      body: Center(
        child: Column(
          children: [
            RaisedButton(onPressed: distance, child: Text("Add"),),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
              child: Text('Open Map'),
            ),
            SizedBox(height: 16),
            Text("Sorted List koordinats"),
            isF != false ?
            Expanded(
                child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: result.length,
                    itemBuilder: (_, int index) =>
                        Text("${result[index]} kilometers")

                )
            )
                : Container(child: Text("Text"),)
          ],
        ),
      ),
    );
  }
}
