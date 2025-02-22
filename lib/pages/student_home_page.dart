import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:lottie/lottie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StudentHomePage extends StatefulWidget {
  const StudentHomePage({Key? key}) : super(key: key);

  @override
  _StudentHomePageState createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _groupCodeController = TextEditingController();

  @override
  void dispose() {
    _groupCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9), // Lightest shade for background
      body: Column(
        children: [
          // Profile Section
          Container(
            height: 250,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF625757), // Darkest shade
                  const Color(0xFF9D8F8F), // Medium dark shade
                  const Color(0xFFBCBAB8), // Soft gray
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.asset(
                    'lib/images/profile.png',
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Student',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF9F9F9), // Lightest shade for contrast
                  ),
                ),
              ],
            ),
          ),

          // Guide Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Guide:',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF625757), // Darkest shade
                  ),
                ),
                const SizedBox(height: 16),
                _buildHelpCard(
                  'Join Groups with a Link',
                  'Students can join a group using a link provided by the teacher.',
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),

          // Group Section for Students
          Expanded(child: _buildGroupsSection()),
        ],
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        height: 75,
        decoration: BoxDecoration(
          color: const Color(0xFF625757), // Darkest shade
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: const Offset(0, 8),
              blurRadius: 10,
            ),
          ],
        ),
        child: GNav(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          backgroundColor: const Color(0xFF625757),
          color: const Color(0xFFF9F9F9), // Lightest shade for icons
          activeColor: const Color(0xFFF9F9F9), // Lightest shade when active
          tabBackgroundColor: const Color(0xFF9D8F8F), // Medium dark shade
          gap: 8,
          tabs: [
            GButton(
              icon: Icons.link,
              text: "Join Group",
              onPressed: () {
                _showJoinGroupDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Help Card Widget
  Widget _buildHelpCard(String title, String description) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: const Color(0xFFBCBAB8), // Soft gray background for card
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            SizedBox(
              width: 50,
              height: 50,
              child: Lottie.asset(
                'assets/animations/app_guide.json',
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF625757), // Darkest shade
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54, // Neutral text color
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Groups Section for Students
  Widget _buildGroupsSection() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('group_members')
          .where('userId', isEqualTo: _auth.currentUser?.uid)
          .snapshots(),
      builder: (context, membershipSnapshot) {
        if (membershipSnapshot.hasError) {
          return Center(child: Text('Error: ${membershipSnapshot.error}'));
        }

        if (membershipSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final memberships = membershipSnapshot.data?.docs ?? [];
        return _buildGroupList('Your Groups', memberships.isEmpty);
      },
    );
  }

  // Group List Builder
  Widget _buildGroupList(String title, bool isEmpty) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9), // Lightest background
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF625757), // Darkest shade
            ),
          ),
          const SizedBox(height: 16),
          if (isEmpty)
            const Center(
              child: Text(
                'No Groups Available',
                style: TextStyle(
                    color: Colors.black54, fontSize: 16), // Neutral text color
              ),
            ),
          if (!isEmpty)
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('group_members')
                    .where('userId', isEqualTo: _auth.currentUser?.uid)
                    .snapshots(),
                builder: (context, membershipSnapshot) {
                  if (!membershipSnapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: membershipSnapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final membership = membershipSnapshot.data!.docs[index];
                      final groupId = membership['groupId'];

                      return FutureBuilder<DocumentSnapshot>(
                        future:
                            _firestore.collection('groups').doc(groupId).get(),
                        builder: (context, groupSnapshot) {
                          if (!groupSnapshot.hasData) {
                            return const SizedBox();
                          }

                          final groupData = groupSnapshot.data!.data()
                              as Map<String, dynamic>;
                          return _buildGroupCard({
                            'name': groupData['name'] ?? '',
                            'description': groupData['description'] ?? '',
                          });
                        },
                      );
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  // Group Card for Students
  Widget _buildGroupCard(Map<String, String> group) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: const Color(0xFFBCBAB8), // Soft gray
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.group,
                size: 40, color: Color(0xFF625757)), // Darkest shade
            const SizedBox(height: 10),
            Text(
              group['name']!,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF625757), // Darkest shade
              ),
            ),
            const SizedBox(height: 5),
            Text(
              group['description']!,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54, // Neutral text color
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Join Group Dialog
  void _showJoinGroupDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Join a Group"),
        content: TextField(
          controller: _groupCodeController,
          decoration: const InputDecoration(
            labelText: 'Group Code',
            hintText: 'Enter the group code',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _joinGroup(_groupCodeController.text.trim());
              Navigator.pop(context);
              _groupCodeController.clear();
            },
            child: const Text('Join'),
          ),
        ],
      ),
    );
  }

  Future<void> _joinGroup(String groupId) async {
    try {
      // Check if group exists
      final groupDoc = await _firestore.collection('groups').doc(groupId).get();

      if (!groupDoc.exists) {
        throw 'Group not found';
      }

      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      // Check if already joined
      final existingMembership = await _firestore
          .collection('group_members')
          .where('groupId', isEqualTo: groupId)
          .where('userId', isEqualTo: userId)
          .get();

      if (existingMembership.docs.isNotEmpty) {
        throw 'You are already a member of this group';
      }

      // Join the group
      await _firestore.collection('group_members').add({
        'groupId': groupId,
        'userId': userId,
        'joinedAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successfully joined the group!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }
}
