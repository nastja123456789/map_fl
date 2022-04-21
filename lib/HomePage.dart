import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as myLat;
import 'package:location/location.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  MapController controller;
  Set<Marker> mark = new Set();

  updateMarkers() {
    markers.clear();
    firestore
        .collection("location")
        .get()
        .then((QuerySnapshot q) {
      q.docs.forEach((el) {
        initMarker(el["latitude"], el["longitude"]);
      });
    });
  }

  Marker _marker;
  Timer _timer;
  int _markerIndex = 0;
  Location location = Location();
  List<Marker> markers;

  @override
  void initState() {

    markers = <Marker>[];
    updateMarkers();
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        location.getLocation().then((p) {
          _marker = Marker(
            point: myLat.LatLng(p.latitude, p.longitude),
            builder: (ctx) => Container(
                child: Center(
                  child: Column(
                    children: [
                      // RaisedButton(
                      //   child: Text("$res and nothing",style: TextStyle(fontSize: 40),),
                      //     onPressed: _distanceInMeters
                      // ),
                      Icon(Icons.location_on, size: 40,),
                    ],
                  ),
                )

            ),
          );
        });
      });
    });

  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  void initMarker(lat, long) async{
    myLat.LatLng latLng = myLat.LatLng(lat, long);
    Marker marker = Marker(
      point: latLng,
      builder: (context) => new Container(
        child: IconButton(
          icon: Icon(Icons.location_on),
          color: Colors.red,
          iconSize: 45.0,
          onPressed: () {
            print('Marker');
          },
        ),
      ),
    );
    setState(() {
      markers.add(marker);
      print(marker.point);
    });
  }


  Widget build(BuildContext context) {
    if (_marker == null) {
      return new Container();
    }
    return Scaffold(
        appBar: new AppBar(title: new Text("Карта")),
        body : FlutterMap(
          mapController: controller,
          children: <Widget>[
            Container(
              child: RaisedButton(
                child: Text("Рассчитать"),
              ),
            )
          ],
          options: MapOptions(
            center: _marker.point,
            zoom: 15.0,
            onMapCreated: (MapController controller) {

            }
          ),
          layers: [
            TileLayerOptions(
                urlTemplate: "https://api.mapbox.com/styles/v1/aleshina/cl235m6jv000414o3ps4ulujl/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiYWxlc2hpbmEiLCJhIjoiY2wyMzVkOWJiMDNvcTNjbzAzbmt2OGFnMCJ9.ZfGMndD5jOX91MgRzI3nXA",
                additionalOptions: {
                  'accessToken' : 'pk.eyJ1IjoiYWxlc2hpbmEiLCJhIjoiY2wyMzVkOWJiMDNvcTNjbzAzbmt2OGFnMCJ9.ZfGMndD5jOX91MgRzI3nXA',
                }
            ),
            MarkerLayerOptions(
                markers: markers,
            ),
          ],
        )
    );
  }


}

