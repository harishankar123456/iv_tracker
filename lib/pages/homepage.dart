import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class IVTrackingHome extends StatefulWidget {
  @override
  _IVTrackingHomeState createState() => _IVTrackingHomeState();
}

class _IVTrackingHomeState extends State<IVTrackingHome> {
  String? userRole;
  bool isSliderVisible = false;
  GoogleMapController? mapController;

  // TODO: Add these variables for geofencing
  // double geofenceRadius = 100.0; // in meters
  // Set<Circle> geofenceCircles = {};
  // Set<Marker> markers = {};
  // LatLng? selectedLocation;

  // Define the initial position of the camera
  static const CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(37.7749, -122.4194),
    zoom: 14.0,
  );

  @override
  void initState() {
    super.initState();
    _fetchUserRole();
    // TODO: Initialize geofence service
    // _initializeGeofencing();
    // TODO: Load existing geofences from Firebase
    // _loadGeofencesFromFirebase();
  }

  // TODO: Add method to handle geofence creation
  // Future<void> _createGeofence(LatLng center, double radius) async {
  //   // 1. Create geofence in Google Maps
  //   // 2. Save geofence data to Firebase
  //   // 3. Start monitoring the geofence
  // }

  // TODO: Add method to monitor geofence
  // void _startGeofenceMonitoring() {
  //   // 1. Set up geofence triggers
  //   // 2. Handle enter/exit events
  //   // 3. Update Firebase with status
  // }

  // TODO: Add method to save geofence to Firebase
  // Future<void> _saveGeofenceToFirebase(Map<String, dynamic> geofenceData) async {
  //   // Save geofence details including:
  //   // - Center coordinates
  //   // - Radius
  //   // - Group ID
  //   // - Created by (teacher ID)
  // }

  Future<void> _fetchUserRole() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      setState(() {
        userRole = userData.get('role');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.white),
          onPressed: () {},
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: initialCameraPosition,
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
            // TODO: Add these properties for geofencing
            // circles: geofenceCircles,
            // markers: markers,
            // onTap: userRole == 'teacher' ? _handleMapTap : null,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: true,
            mapType: MapType.normal,
            compassEnabled: true,
            // Position controls to the left instead of right
            zoomGesturesEnabled: false,
            rotateGesturesEnabled: false,
          ),

          // Bottom Navigation Bar
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: Icon(Icons.map, size: 30, color: Colors.blue),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.group, size: 30, color: Colors.blue),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.person, size: 30, color: Colors.blue),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),

          // Teacher-specific Edit Button
          if (userRole == 'teacher')
            Positioned(
              bottom: 120,
              left: 20,
              child: FloatingActionButton(
                backgroundColor: Colors.white.withOpacity(0.9),
                elevation: 5,
                child: Icon(Icons.edit, color: Colors.blue),
                onPressed: () {
                  setState(() {
                    isSliderVisible = !isSliderVisible;
                  });
                  // TODO: When slider value changes
                  // 1. Update circle radius on map
                  // 2. Update geofence radius
                  // 3. Save changes to Firebase
                },
              ),
            ),

          // Slider for geofence radius
          if (userRole == 'teacher' && isSliderVisible)
            Positioned(
              bottom: 180,
              left: 20,
              child: Container(
                width: 200,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Edit radius'),
                    Slider(
                      value: 0.5,
                      onChanged: (value) {
                        // TODO: Implement radius change
                        // 1. Update circle radius on map
                        // 2. Update geofence radius in Firebase
                        // 3. Trigger geofence update
                      },
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  // TODO: Add method to handle map taps (for teachers)
  // void _handleMapTap(LatLng tappedPoint) {
  //   // 1. Create/Update marker
  //   // 2. Create/Update geofence circle
  //   // 3. Save location for geofence creation
  // }

  // TODO: Add method to monitor student location
  // void _monitorStudentLocation() {
  //   // 1. Get real-time location updates
  //   // 2. Check against active geofences
  //   // 3. Update status in Firebase
  // }

  @override
  void dispose() {
    // TODO: Clean up geofence monitoring
    // _disposeGeofencing();
    mapController?.dispose();
    super.dispose();
  }
}
