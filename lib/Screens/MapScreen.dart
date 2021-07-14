import 'dart:async';
import 'package:location_tracker/Utilities/DatabaseManagement.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:rxdart/rxdart.dart';
import 'package:location/location.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;
FirebaseAuth _auth = FirebaseAuth.instance;
Geoflutterfire geo = Geoflutterfire();
Location _location = Location();

class MapScreen extends StatefulWidget {
  static const String id = 'MapScreen';
  final String GID;
  MapScreen({required this.GID});
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late User loggedInUser;

  late GoogleMapController myController;

  BehaviorSubject<double> radius = BehaviorSubject();
  Set<Marker> markerList = {};
  late Stream<dynamic> query;
  late StreamSubscription subscription;

  void _onMapCreated(GoogleMapController controller) {
    _location.onLocationChanged.listen((position) {
      GeoFirePoint pos = geo.point(
          latitude: position.latitude!, longitude: position.longitude!);
      updateLocationInGroup(widget.GID, loggedInUser.email!, pos);
    });
    setState(() {
      myController = controller;
    });
  }

  void getUser() {
    loggedInUser = _auth.currentUser!;
  }

  @override
  void initState() {
    super.initState();
    radius.add(100.0);
    getUser();
    _startQuery();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Maps',
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back),
          ),
        ),
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            GoogleMap(
              onMapCreated: _onMapCreated,
              // myLocationEnabled: true,
              initialCameraPosition:
                  CameraPosition(target: LatLng(19.25, 73.25), zoom: 10.0),
              markers: markerList,
            ),
            Positioned(
              bottom: 50.0,
              left: 10.0,
              child: Slider(
                min: 100.0,
                max: 500.0,
                divisions: 5,
                label: 'Radius ${radius.value.toInt()}km',
                value: radius.value,
                onChanged: _updateQuery,
              ),
            )
          ],
        ),
      ),
    );
  }

  void _updateMarkers(List<DocumentSnapshot> documentList) {
    markerList = {};
    documentList.forEach((document) {
      GeoPoint pos = document['Location']['geopoint'];
      // double distance = document.data['distance'];
      Marker marker = Marker(
        alpha: 0.75,
        markerId: MarkerId(document['MID']),
        position: LatLng(pos.latitude, pos.longitude),
        infoWindow:
            InfoWindow(title: document['Name'], snippet: document['Email']),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      );
      setState(() {
        markerList.add(marker);
      });
    });
  }

  void _startQuery() async {
    var pos = await _location.getLocation();
    double lat = pos.latitude!;
    double lng = pos.longitude!;

    var ref = _firestore
        .collection('Groups')
        .doc(widget.GID)
        .collection('MembersList');
    GeoFirePoint center = geo.point(latitude: lat, longitude: lng);

    // subscribe to query
    subscription = radius.switchMap((rad) {
      return geo.collection(collectionRef: ref).within(
          center: center, radius: rad, field: 'Location', strictMode: true);
    }).listen(_updateMarkers);
  }

  void _updateQuery(value) {
    setState(() {
      radius.add(value);
    });
    final zoomMap = {
      100.0: 12.0,
      180.0: 10.0,
      260.0: 7.0,
      340.0: 6.0,
      420.0: 5.0,
      500.0: 4.0,
    };
    final zoom = zoomMap[value];
    myController.moveCamera(CameraUpdate.zoomTo(zoom!));
  }

  @override
  void dispose() {
    radius.close();
    subscription.cancel();
    myController.dispose();
    super.dispose();
  }
}
