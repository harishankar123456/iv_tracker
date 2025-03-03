import 'package:flutter/material.dart';

import 'package:projects/components/splash_screen.dart';

import './components/student_teacher.dart';

import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'pages/teacher_home_page.dart'; // Import Teacher HomePage
import 'pages/student_home_page.dart';
import 'pages/homepage.dart'; // Add this import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/student_teacher': (context) => const StudentTeacherPage(),
        '/login': (context) => LoginPage(
              role: '',
            ),
        '/register': (context) => RegisterPage(),
        '/teacher_home': (context) =>
            TeacherHomePage(), // Add Teacher HomePage route
        '/student_home': (context) => StudentHomePage(),
        '/home': (context) => IVTrackingHome(), // Add this route
      },
    );
  }
}
