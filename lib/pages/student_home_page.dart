import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:lottie/lottie.dart';

class StudentHomePage extends StatelessWidget {
  final List<Map<String, String>> groups = []; // List of groups

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
                _joinGroup(context);
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
    return _buildGroupList('Join Groups', groups.isEmpty);
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
  void _joinGroup(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Join a Group",
            style: TextStyle(color: Color(0xFF625757))),
        content: TextField(
          decoration: const InputDecoration(
            hintText: "Enter group link",
            hintStyle: TextStyle(color: Colors.black54),
          ),
          onChanged: (value) {},
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:
                const Text("Join", style: TextStyle(color: Color(0xFF9D8F8F))),
          ),
        ],
      ),
    );
  }
}
