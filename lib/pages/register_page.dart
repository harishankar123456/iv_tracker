import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../components/my_button.dart';
import '../components/my_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatefulWidget {
  // Converted to StatefulWidget
  RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Text editing controllers
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Selected Role (Default: Student)
  String selectedRole = 'Student';

  // Method to show a pop-up dialog
  void showPopup(BuildContext context, String message, bool isSuccess) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            isSuccess ? 'Success' : 'Error',
            style: TextStyle(
              color: isSuccess ? Color(0xFF90D8F8) : Color(0xFF625757),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            message,
            style: const TextStyle(color: Colors.black),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Register user method
  void registerUser(BuildContext context) async {
    if (passwordController.text != confirmPasswordController.text) {
      showPopup(context, 'Passwords do not match', false);
      return;
    }

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      await createUserWithEmailAndPassword(context);

      // Close the loading dialog
      Navigator.of(context).pop();

      // Show success popup
      showPopup(context,
          'Registration successful! Please verify your email to log in.', true);
    } catch (e) {
      // Close the loading dialog
      Navigator.of(context).pop();

      // Show error popup
      showPopup(context, 'Registration failed: ${e.toString()}', false);
    }
  }

  Future<void> createUserWithEmailAndPassword(BuildContext context) async {
    try {
      // Create the user with email and password
      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Update the displayName with the username
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.updateProfile(displayName: usernameController.text.trim());
        await user.reload();
        user = FirebaseAuth.instance.currentUser;
      }

      // Send email verification
      await userCredential.user?.sendEmailVerification();
      print("Verification email sent to ${userCredential.user?.email}");

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'username': usernameController.text.trim(),
        'email': emailController.text.trim(),
        'role': selectedRole, // 🚀 **Modified: Added role to Firestore**
        'createdAt': Timestamp.now(),
      });
    } catch (e) {
      throw Exception('Failed to register user: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFFFFFF), // Pure White
              Color(0xFFF5F5F5), // Light Gray
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),

                  // Lottie animation above the title
                  SizedBox(
                    height: 200,
                    width: 200,
                    child: Lottie.asset(
                      'assets/animations/register_page.json',
                      fit: BoxFit.cover,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Welcome text
                  const Text(
                    'Create Your Account',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Text fields
                  MyTextField(
                    controller: usernameController,
                    hintText: 'Username',
                    obscureText: false,
                    backgroundColor: const Color(0xFFF9F9F9),
                    textColor: Colors.black,
                    borderColor: Color(0xFFBCBAB8),
                    borderRadius: 25,
                  ),
                  const SizedBox(height: 15),
                  MyTextField(
                    controller: emailController,
                    hintText: 'Email',
                    obscureText: false,
                    backgroundColor: const Color(0xFFF9F9F9),
                    textColor: Colors.black,
                    borderColor: Color(0xFFBCBAB8),
                    borderRadius: 25,
                  ),
                  const SizedBox(height: 15),
                  MyTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                    backgroundColor: const Color(0xFFF9F9F9),
                    textColor: Colors.black,
                    borderColor: Color(0xFFBCBAB8),
                    borderRadius: 25,
                  ),
                  const SizedBox(height: 15),
                  MyTextField(
                    controller: confirmPasswordController,
                    hintText: 'Confirm Password',
                    obscureText: true,
                    backgroundColor: const Color(0xFFF9F9F9),
                    textColor: Colors.black,
                    borderColor: Color(0xFFBCBAB8),
                    borderRadius: 25,
                  ),

                  const SizedBox(height: 20),

                  // Role Selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ChoiceChip(
                        label: const Text('Student'),
                        selected: selectedRole == 'student',
                        onSelected: (isSelected) {
                          setState(() {
                            selectedRole = 'student';
                          });
                        },
                      ),
                      const SizedBox(width: 10),
                      ChoiceChip(
                        label: const Text('Teacher'),
                        selected: selectedRole == 'teacher',
                        onSelected: (isSelected) {
                          setState(() {
                            selectedRole = 'teacher';
                          });
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // Register button
                  MyButton(
                    onTap: () => registerUser(context),
                    text: 'Register',
                    backgroundColor: const Color(0xFF9D8F8F),
                    textColor: Colors.white,
                    borderRadius: 25,
                    shadowColor: Colors.black.withOpacity(0.1),
                  ),

                  const SizedBox(height: 40),

                  // Already have an account?
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account?',
                        style: TextStyle(color: Colors.black54),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Login now',
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
    );
  }
}
