import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import '../components/student_teacher.dart'; // Import StudentTeacherPage

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    // Hide system UI
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    // Navigate to the student/teacher page after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(_createRoute());
    });
  }

  @override
  void dispose() {
    // Re-enable system overlays when splash screen is removed
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const StudentTeacherPage(),
      transitionDuration: const Duration(milliseconds: 1200), // Increased transition time
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final fadeAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut, // Smooth easing curve
        );

        return FadeTransition(
          opacity: fadeAnimation,
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color backgroundColor = Color(0xFFF9F9F9); // Light gray background
    const Color borderColor = Color(0xFFBCBAB8); // Subtle gray border color

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              backgroundColor, // Light background
              borderColor, // Soft light gray color
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Lottie.network(
            'https://lottie.host/31cd1a2c-a344-4f10-9a4f-c370ff821a8b/A32H02dQfv.json',
            width: 250,
            height: 250,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
