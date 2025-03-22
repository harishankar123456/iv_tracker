import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../backend.dart'; // Import the backend file

class IVTrackingHome extends StatefulWidget {
  @override
  _IVTrackingHomeState createState() => _IVTrackingHomeState();
}

class _IVTrackingHomeState extends State<IVTrackingHome> {
  String? userRole;
  bool isSliderVisible = false;
  GoogleMapController? mapController;

  // Variables for geofence creation
  double geofenceRadius = 100.0; // in meters
  LatLng? selectedLocation;
  Set<Circle> geofenceCircles = {};

  // Define the initial position of the camera
  static const CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(37.7749, -122.4194),
    zoom: 14.0,
  );

  @override
  void initState() {
    super.initState();
    _fetchUserRole(); // Fetch user role from backend
    _loadGeofencesForGroup("groupId123"); // Load geofences for the group
  }

  void _fetchUserRole() async {
    userRole = await Backend.fetchUserRole(); // Call backend function
    setState(() {});
  }

  void _loadGeofencesForGroup(String groupId) async {
    final geofences = await Backend.fetchGeofencesForGroup(groupId);
    setState(() {
      geofenceCircles = geofences.map((geofence) {
        final center = LatLng(
          geofence['center']['lat'],
          geofence['center']['lng'],
        );
        return Circle(
          circleId: CircleId(center.toString()),
          center: center,
          radius: geofence['radius'],
          fillColor: Colors.blue.withOpacity(0.5),
          strokeColor: Colors.blue,
          strokeWidth: 2,
        );
      }).toSet();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.menu, color: Colors.white),
                onPressed: () {
                  Scaffold.of(context).openDrawer(); // Open the drawer
                },
              ),
            ),
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Text(
                    'Menu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.map, color: Colors.blue),
                  title: Text('Map'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.group, color: Colors.blue),
                  title: Text('Groups'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.person, color: Colors.blue),
                  title: Text('Profile'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                if (userRole ==
                    'teacher') // Add "Create Geofence" option for teachers
                  ListTile(
                    leading: Icon(Icons.add_location_alt, color: Colors.blue),
                    title: Text('Create Geofence'),
                    onTap: () {
                      Navigator.pop(context); // Close the drawer
                      Future.delayed(Duration(milliseconds: 300), () {
                        _showGeofenceBottomSheet(
                            context); // Correctly invoke the function
                      });
                    },
                  ),
              ],
            ),
          ),
          body: Stack(
            children: [
              GoogleMap(
                initialCameraPosition: initialCameraPosition,
                onMapCreated: (GoogleMapController controller) {
                  mapController = controller;
                },
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                zoomControlsEnabled: false,
                mapType: MapType.normal,
                compassEnabled: true,
                zoomGesturesEnabled: true,
                rotateGesturesEnabled: true,
                scrollGesturesEnabled: true,
                tiltGesturesEnabled: true,
                circles: geofenceCircles, // Display geofences
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
      },
    );
  }

  void _showGeofenceBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.8,
              child: Column(
                children: [
                  Expanded(
                    child: GoogleMap(
                      initialCameraPosition: initialCameraPosition,
                      onMapCreated: (GoogleMapController controller) {
                        mapController = controller;
                      },
                      onTap: (LatLng tappedPoint) {
                        setState(() {
                          selectedLocation = tappedPoint;
                          geofenceCircles = {
                            Circle(
                              circleId: CircleId(tappedPoint.toString()),
                              center: tappedPoint,
                              radius: geofenceRadius,
                              fillColor: Colors.blue.withOpacity(0.5),
                              strokeColor: Colors.blue,
                              strokeWidth: 2,
                            ),
                          };
                        });
                      },
                      circles: geofenceCircles,
                      myLocationEnabled: true,
                      zoomGesturesEnabled: true,
                      scrollGesturesEnabled: true,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text('Adjust Geofence Radius'),
                        Slider(
                          value: geofenceRadius,
                          min: 50,
                          max: 500,
                          divisions: 9,
                          label: '${geofenceRadius.round()} meters',
                          onChanged: (value) {
                            setState(() {
                              geofenceRadius = value;
                              if (selectedLocation != null) {
                                geofenceCircles = {
                                  Circle(
                                    circleId:
                                        CircleId(selectedLocation.toString()),
                                    center: selectedLocation!,
                                    radius: geofenceRadius,
                                    fillColor: Colors.blue.withOpacity(0.5),
                                    strokeColor: Colors.blue,
                                    strokeWidth: 2,
                                  ),
                                };
                              }
                            });
                          },
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            if (selectedLocation != null) {
                              await Backend.saveGeofenceToFirebase(
                                  selectedLocation!,
                                  geofenceRadius,
                                  "groupId123"); // Replace with actual group ID
                              _loadGeofencesForGroup(
                                  "groupId123"); // Reload geofences after saving
                              Navigator.pop(context);
                            }
                          },
                          child: Text('Confirm Geofence'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
  }
}
