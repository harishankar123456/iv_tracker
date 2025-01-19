import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:animate_do/animate_do.dart'; // Add animations for aesthetic effects

import '../pages/login_page.dart';

class StudentTeacherPage extends StatelessWidget {
  const StudentTeacherPage({super.key});

  void _navigateToLogin(BuildContext context, String role) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => LoginPage(role: role),
        transitionDuration: const Duration(milliseconds: 800),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9), // Dominant white background
      body: Stack(
        children: [
          // Decorative background gradient
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFF9F9F9), Color(0xFFBCBAB8)], // White to light gray gradient
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),

          // Decorative glowing element
          Positioned(
            top: -100,
            left: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.blueAccent.withOpacity(0.2),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  const Text(
                    "Login as",
                    style: TextStyle(
                      color: Color(0xFF625757), // Accent dark gray
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Teacher Card
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _navigateToLogin(context, 'teacher'),
                      child: ZoomIn(
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F5), // Light gray background
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              // Lottie animation for teacher
                              Expanded(
                                child: Lottie.asset(
                                  'assets/animations/teacher_animation.json', // Replace with your file
                                  height: 180,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text(
                                      "Teacher",
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF625757), // Dark gray color
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Icon(
                                      Icons.arrow_forward,
                                      color: Color(0xFF625757), // Dark gray color
                                      size: 28,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Student Card
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _navigateToLogin(context, 'student'),
                      child: ZoomIn(
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF8E9EAB), // Soft gray-blue background
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              // Lottie animation for student
                              Expanded(
                                child: Lottie.asset(
                                  'assets/animations/student_animation.json', // Replace with your file
                                  height: 180,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text(
                                      "Student",
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Icon(
                                      Icons.arrow_forward,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
