import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:uuid/uuid.dart';
import 'package:lottie/lottie.dart';

class TeacherHomePage extends StatefulWidget {
  const TeacherHomePage({Key? key}) : super(key: key);

  @override
  _TeacherHomePageState createState() => _TeacherHomePageState();
}

class _TeacherHomePageState extends State<TeacherHomePage> {
  final List<Map<String, String>> groups = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9), // Dominant white background
      body: Column(
        children: [
          // Profile Section
          Container(
            height: 250,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFF9F9F9), // White
                  Color(0xFFBCBAB8), // Light gray as subtle gradient
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.asset(
                    'lib/images/profile2.png',
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Teacher',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF625757), // Accent dark gray
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
                    color: Color(0xFF625757), // Accent color
                  ),
                ),
                const SizedBox(height: 16),
                _buildHelpCard(
                  'Create and Manage Groups',
                  'Teachers can create groups and share the join link with students.',
                ),
              ],
            ),
          ),

          // Group Section
          Expanded(child: _buildGroupsSection()),
        ],
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        height: 75,
        decoration: BoxDecoration(
          color: const Color(0xFFF9F9F9), // White
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFBCBAB8).withOpacity(0.3), // Light gray shadow
              offset: const Offset(0, 20),
              blurRadius: 20,
            ),
          ],
        ),
        child: GNav(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          backgroundColor: const Color(0xFFF9F9F9), // White
          color: const Color(0xFF625757), // Dark gray icons
          activeColor: Colors.white,
          tabBackgroundColor: const Color(0xFF9D8F8F), // Warm gray for selected tab
          gap: 8,
          tabs: [
            GButton(
              icon: Icons.add,
              text: "Add Group",
              onPressed: _showAddGroupDialog,
            ),
            GButton(
              icon: Icons.link,
              text: "Generate Link",
              onPressed: _generateGroupLink,
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
      color: const Color(0xFFF9F9F9), // White
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
                      color: Color(0xFF625757),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF625757),
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

  Widget _buildGroupsSection() {
    return _buildGroupList('Your Groups', groups.isEmpty);
  }

  Widget _buildGroupList(String title, bool isEmpty) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: Color(0xFFF9F9F9), // White background
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF625757), // Accent dark gray
            ),
          ),
          const SizedBox(height: 16),
          if (isEmpty)
            const Center(
              child: Text(
                'No Groups Available',
                style: TextStyle(
                  color: Color(0xFF625757), // Accent dark gray
                  fontSize: 16,
                ),
              ),
            ),
          if (!isEmpty)
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: groups.length,
                itemBuilder: (context, index) {
                  final group = groups[index];
                  return _buildGroupCard(group);
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildGroupCard(Map<String, String> group) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: const Color(0xFFF9F9F9), // White card
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.group, size: 40, color: Color(0xFF625757)),
            const SizedBox(height: 10),
            Text(
              group['name']!,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF625757),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              group['description']!,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF625757),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddGroupDialog() {
    // Add group dialog implementation
  }

  void _generateGroupLink() {
    // Generate group link implementation
  }
}
