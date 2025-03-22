import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Backend {
  // Fetch the user role from Firebase
  static Future<String?> fetchUserRole() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        return userData.get('role');
      }
    } catch (e) {
      print('Error fetching user role: $e');
    }
    return null;
  }

  // Save geofence data to Firebase
  static Future<void> saveGeofenceToFirebase(
      LatLng center, double radius, String groupId) async {
    try {
      final geofenceData = {
        'center': {'lat': center.latitude, 'lng': center.longitude},
        'radius': radius,
        'groupId': groupId, // Store the group ID
        'createdBy': FirebaseAuth.instance.currentUser?.uid, // Store teacher ID
      };
      await FirebaseFirestore.instance
          .collection('geofences')
          .add(geofenceData);
    } catch (e) {
      print('Error saving geofence: $e');
    }
  }

  // Fetch geofences for a specific group
  static Future<List<Map<String, dynamic>>> fetchGeofencesForGroup(
      String groupId) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('geofences')
          .where('groupId', isEqualTo: groupId)
          .get();

      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error fetching geofences for group: $e');
      return [];
    }
  }
}
