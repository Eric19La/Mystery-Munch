import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class SignInScreen extends StatefulWidget {
  // Creating a screen that allows the user to sign in or sign up
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  // Controller for the email and password fields
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Instance of the AuthService
  final AuthService _authService = AuthService();

  // Holds the current user
  User? _currentUser;

  @override
  void initState() {
    super.initState();

    // Check if the user is already signed in
    _currentUser = FirebaseAuth.instance.currentUser;
  }

  // Helper function to show an alert dialog
  void _showAlert(String title, String message) {
    // Shows a popup with a title and message for the user
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("OK"),
              ),
            ],
          ),
    );
  }

  // Functions for signing in
  void _signIn() async {
    final result = await _authService.signIn(
      emailController.text.trim(),
      passwordController.text.trim(),
    );

    if (result.user != null) {
      setState(() {
        _currentUser = result.user;
      });
      _showAlert("Signed In", "Welcome back, ${result.user!.email}!");
    } else {
      _showAlert(
        "Sign In Failed",
        result.error ?? "Invalid credentials. Try again.",
      );
    }
  }

  // Functions for signing up (Similar to signing in)
  void _signUp() async {
    final result = await _authService.signUp(
      emailController.text.trim(),
      passwordController.text.trim(),
    );

    if (result.user != null) {
      setState(() {
        _currentUser = result.user;
      });
      _showAlert("Account Created", "Welcome, ${result.user!.email}!");
    } else {
      _showAlert(
        "Sign Up Failed",
        result.error ?? "Something went wrong. Try again.",
      );
    }
  }

  // Function for signing out
  void _signOut() async {
    // Uses the AuthService to sign out the user
    await FirebaseAuth.instance.signOut();

    // Clear the text fields
    emailController.clear();
    passwordController.clear();

    // Update the UI back to the sign in/up screen
    setState(() {
      _currentUser = null;
    });
    _showAlert("Logged Out", "You have been signed out.");
  }

  // UI for the login screen
  Widget _buildLoginForm() {
    return Column(
      children: [
        // Text fields for email and password
        TextField(
          controller: emailController,
          decoration: InputDecoration(
            labelText: "Email",
            helperText: "Example: bronDaGoat@gmail.com",
          ),
        ),
        TextField(
          controller: passwordController,
          decoration: InputDecoration(
            labelText: "Password",
            helperText:
                "Example: seeyuh\n*Password has to be at least 6 characters",
          ),
          obscureText: true,
        ),

        // Sign in/up buttons
        SizedBox(height: 20),
        ElevatedButton(onPressed: _signIn, child: Text("Sign In")),
        ElevatedButton(onPressed: _signUp, child: Text("Sign Up")),
      ],
    );
  }

  // UI for the logout screen
  Widget _buildLogoutUI() {
    return Center(
      child: ElevatedButton(onPressed: _signOut, child: Text("Log Out")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _currentUser != null ? "Welcome" : "Sign In",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _currentUser != null ? _buildLogoutUI() : _buildLoginForm(),
      ),
    );
  }
} // end _SignInScreenState
