import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:map_fl/start.dart';

import 'HomePage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MetalHunt',
      theme: ThemeData(
          primarySwatch: Colors.blue
      ),
      home: HomePage(),
    );
  }
}


// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:latlong2/latlong.dart' as myLatLong;
// import 'package:location/location.dart';
//
// void main() => runApp(MyApp());
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         home: Scaffold(
//             body: FireMap()
//         )
//     );
//   }
// }
//
// class FireMap extends StatefulWidget {
//   @override
//   State createState() => FireMapState();
// }
//
//
// class FireMapState extends State<FireMap> {
//   GoogleMapController mapController;
//   Location location = new Location();
//   var currentLocation;
//   bool mapToggle = false;
//   var clients = [];
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     GeolocatorPlatform.instance.getCurrentPosition().then((currloc) {
//        setState(() {
//          currentLocation = currloc;
//          mapToggle = true;
//          populateClients();
//        });
//     });
//   }
//
//   populateClients() {
//     clients=[];
//     FirebaseFirestore.instance
//         .collection("location")
//         .get().then(
//             (v) {
//              if (v.docs.isNotEmpty) {
//               for (int i=0;i<v.docs.length;++i) {
//                 clients.add(v.docs[i].data);
//                 initMarket(v.docs[i].data);
//               }
//              }
//             });
//   }
//
//   initMarket(client) {
//     mapController.takeSnapshot().then((value) => mapController.)
//   }
//
//   @override
//   build(context) {
//     return Scaffold(
//       body: Column(
//         children: <Widget>[
//           Container(
//             child: mapToggle ?
//             GoogleMap(
//                 initialCameraPosition: CameraPosition(
//                   target: LatLng(currentLocation.latitude, currentLocation.longitude),
//                   zoom: 10.0
//                 ),
//                 onMapCreated: onMapCreated,
//
//             ):
//             Center(
//               child: Text("Loading"),
//             ),
//           )
//         ],
//       ),
//     );
//   }
//
//   onMapCreated(controller) {
//     setState(() {
//       mapController = controller;
//     });
//   }
//
//}