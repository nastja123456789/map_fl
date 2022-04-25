import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoder/geocoder.dart';
//import 'package:geocoding/geocoding.dart' as cod;
import 'package:latlong2/latlong.dart' as myLat;
import 'package:location/location.dart' as loc;
import 'package:geolocator/geolocator.dart' as geo;

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  MapController controller;
  String searchAddr;
  Set<Marker> mark = new Set();
  var filterdist;
  List<double> mass=[];
  List<double> v=[];
  List<double> k=[];

  updateMarkers() {
    markers.clear();
    firestore
        .collection("location")
        .get()
        .then((QuerySnapshot q) {
      q.docs.forEach((el) {
        initMarker(el["latitude"], el["longitude"]);
        v.add(el["longitude"]);
        k.add(el["latitude"]);
      });
    });
  }


  Marker _marker;
  Timer _timer;
  int _markerIndex = 0;
  loc.Location location = loc.Location();
  //List<cod.Location> locations = [];
  List<Marker> markers;
  var CalDist;
  geo.Geolocator _geolocator = geo.Geolocator();
  geo.Position userLocation;

  // setMarkers() {
  //   markers.add(new Marker(
  //           point: myLat.LatLng(55.808 , 37.430),
  //           builder: (context) => new Container(
  //             child: IconButton(
  //               icon: Icon(Icons.location_on),
  //               color: Colors.red,
  //               iconSize: 45.0,
  //               onPressed: () {
  //                 print('Marker');
  //               },
  //             ),
  //           ),
  //         )
  //   );
  //   print(markers);
  //   return markers;
  // }

  //List<cod.Location> locations = [];//cod.locationFromAddress("Gronausestraat 710, Enschede") as List<cod.Location>;

  @override
  void initState() {
    markers = <Marker>[];
    updateMarkers();
    super.initState();
    //_timer = Timer.periodic(Duration(seconds: 1), (_) {
    //  setState(() {
    //    location.getLocation().then((p) {
          _marker = Marker(
            point: myLat.LatLng(55.808 , 37.430),
            builder: (ctx) =>
                Container(
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
      //});
    //});
  //});
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

  addToList(query) async{
    //final query = "Tallinskaya Ulitsa, 34, Moscow, 123592";
    var addresses = await Geocoder.local.findAddressesFromQuery(query);
    var first = addresses.first;
    setState(() {
      markers.add(new Marker(
        point: myLat.LatLng(first.coordinates.latitude, first.coordinates.longitude),
        builder: (context) => new Container(
          child: IconButton(
            icon: Icon(Icons.location_on),
            color: Colors.red,
            iconSize: 45.0,
            onPressed: () {
              print(first.featureName);
            },
          ),
        ),
      )
      );
    });

      print(markers);
  }

  Future addMarker() async{
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Enter Address'),
            contentPadding: EdgeInsets.all(10.0),
            content: TextField(
              decoration: InputDecoration(
                hintText: 'Enter Address',

                border: InputBorder.none,
              ),
              onChanged: (val) {
                setState(() {
                  searchAddr = val;
                });
              },
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  addToList(searchAddr);
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
                textColor: Colors.blue,
              )
            ],
          );
        }
    );
  }


  Widget build(BuildContext context) {
    if (_marker == null) {
      return new Container();
    }
    return Scaffold(
        appBar: new AppBar(
            title: new Text("Карта"),
          leading: new IconButton(
              onPressed: addMarker,
              icon: Icon(Icons.add)
          ),
          actions: <Widget>[
            Row(
              children: [
                IconButton(
                  onPressed: getDistance,
                  icon: Icon(Icons.filter_list),
                ),
                // IconButton(
                //   onPressed: getAddress,
                //   icon: Icon(Icons.filter_list_alt),
                // ),
              ],
            )
          ],
        ),
        body : FlutterMap(
          options: MapOptions(
            center: _marker.point,
            zoom: 15.0,
          ),
          layers: [
            TileLayerOptions(
                urlTemplate: "https://api.mapbox.com/styles/v1/aleshina/cl235m6jv000414o3ps4ulujl/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiYWxlc2hpbmEiLCJhIjoiY2wyMzVkOWJiMDNvcTNjbzAzbmt2OGFnMCJ9.ZfGMndD5jOX91MgRzI3nXA",
                additionalOptions: {
                  'accessToken' : 'pk.eyJ1IjoiYWxlc2hpbmEiLCJhIjoiY2wyMzVkOWJiMDNvcTNjbzAzbmt2OGFnMCJ9.ZfGMndD5jOX91MgRzI3nXA',
                },
            ),
            MarkerLayerOptions(
                markers: markers,
            ),
          ],
        )
    );
  }

  // searchandNavigate(searchAddr) async {
  //   locations = await cod.locationFromAddress(searchAddr);
  //   cod.Location l = locations.first;
  //   myLat.LatLng latLng = myLat.LatLng(l.latitude,l.longitude);
  //   _marker = Marker(
  //     point: latLng,
  //     builder: (context) => new Container(
  //       child: IconButton(
  //         icon: Icon(Icons.location_on),
  //         color: Colors.red,
  //         iconSize: 45.0,
  //         onPressed: () {
  //           print('Marker');
  //         },
  //       ),
  //     ),
  //   );
  // }

  Future<bool> getDistance() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Enter Distance in meters'),
            contentPadding: EdgeInsets.all(10.0),
            content: TextField(
              decoration: InputDecoration(hintText: 'Enter distance'),
              onChanged: (val) {
                setState(() {
                  filterdist = val;
                });
              },
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  filterMarkers(filterdist);
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
                textColor: Colors.blue,
              )
            ],
          );
        }
    );
  }

  // Future<bool> getAddress() {
  //
  //   return showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           title: Text('Enter Distance in meters'),
  //           contentPadding: EdgeInsets.all(10.0),
  //           content: TextField(
  //       decoration: InputDecoration(
  //       hintText: 'Enter Address',
  //
  //       border: InputBorder.none,
  //       ),
  //       onChanged: (val) {
  //       setState(() {
  //       searchAddr = val;
  //       });
  //       },
  //   ),
  //           actions: <Widget>[
  //             FlatButton(
  //               onPressed: () {
  //                 //searchandNavigate(searchAddr);
  //                 Navigator.of(context).pop();
  //               },
  //               child: Text("OK"),
  //               textColor: Colors.blue,
  //             )
  //           ],
  //         );
  //       }
  //   );
  // }

  filterMarkers(dist) {
    markers.clear();
    for(int i=0;i<k.length;++i) {
      CalDist = geo.Geolocator.distanceBetween(
          55.677,
          37.761,
          k[i],
          v[i]);
      print(CalDist.floorToDouble());
      print(double.parse(dist));
      //CalDist=1000;
      if (CalDist < double.parse(dist)) {
        placeFilterMarker(k[i], v[i], CalDist/1000);
      }
    }
  }

  placeFilterMarker(lat, long, distance) {
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

  }
