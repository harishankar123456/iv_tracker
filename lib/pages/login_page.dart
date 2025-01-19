import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Firebase authentication package
import 'register_page.dart';
import '../components/my_button.dart';
import '../components/my_textfield.dart';
import '../components/square_tile.dart';

class LoginPage extends StatelessWidget {
  final String role;

  LoginPage({super.key, required this.role});

  // Text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Firebase authentication instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign user in method
  Future<void> signUserIn(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    try {
      // Firebase sign-in logic
      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user?.emailVerified ?? false) {
        // Email is verified, proceed to home page
        if (role == 'teacher') {
          Navigator.pushReplacementNamed(
              context, '/teacher_home'); // Teacher homepage route
        } else if (role == 'student') {
          Navigator.pushReplacementNamed(
              context, '/student_home'); // Student homepage route
        }
      } else {
        // Email is not verified
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Please verify your email before logging in.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      // Handle Firebase-specific errors
      String errorMessage = '';
      if (e.code == 'invalid-credential') {
        errorMessage = "Incorrect credentials, please try again.";
      } else if (e.code == 'invalid-email') {
        errorMessage = "Invalid email address, please try again.";
      } else if (e.code == 'missing-password') {
        errorMessage = "Password cannot be empty.";
      } else {
        errorMessage = "An error occurred. Please try again.";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      // Handle general errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("An unexpected error occurred: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9), // Dominant white background
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFF9F9F9), // White
              Color(0xFFBCBAB8), // Light Gray
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),

                    // Lottie animation
                    Lottie.asset(
                      'assets/animations/Animation - 1736879941396.json',
                      height: 120,
                      width: 120,
                      fit: BoxFit.cover,
                    ),

                    const SizedBox(height: 30),

                    // Welcome message
                    Text(
                      role == 'student'
                          ? 'Welcome back, dear Student!'
                          : 'Welcome back, respected Teacher!',
                      style: const TextStyle(
                        color: Color(0xFF625757), // Accent dark gray
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 20),

                    // Email textfield
                    MyTextField(
                      controller: emailController,
                      hintText: 'Email',
                      obscureText: false,
                      backgroundColor: const Color(0xFFF9F9F9), // White background
                      textColor: const Color(0xFF625757), // Dark gray
                      borderColor: const Color(0xFFBCBAB8), // Subtle gray border
                      borderRadius: 25,
                    ),

                    const SizedBox(height: 15),

                    // Password textfield
                    MyTextField(
                      controller: passwordController,
                      hintText: 'Password',
                      obscureText: true,
                      backgroundColor: const Color(0xFFF9F9F9),
                      textColor: const Color(0xFF625757),
                      borderColor: const Color(0xFFBCBAB8),
                      borderRadius: 25,
                    ),

                    const SizedBox(height: 10),

                    // Forgot password
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: const Color(0xFF9D8F8F),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // Sign in button
                    MyButton(
                      onTap: () => signUserIn(context),
                      text: 'Sign In',
                      backgroundColor: const Color(0xFF9D8F8F), // Accent color
                      textColor: Colors.white,
                      borderRadius: 25,
                      shadowColor: const Color(0xFF625757).withOpacity(0.2),
                    ),

                    const SizedBox(height: 40),

                    // Or continue with
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[700],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            'Or continue with',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // Google and Apple sign-in buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        SquareTile(imagePath: 'lib/images/google.png'),
                        SizedBox(width: 25),
                        SquareTile(imagePath: 'lib/images/apple.png'),
                      ],
                    ),

                    const SizedBox(height: 40),

                    // Register now
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Not a member?',
                          style: TextStyle(color: Color(0xFF625757)),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegisterPage(),
                              ),
                            );
                          },
                          child: const Text(
                            'Register now',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
