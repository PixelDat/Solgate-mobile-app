import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String _password = '';
  String _reEnteredPassword = '';
  String _fullName = '';
  String _email = '';
  bool _isLoading = false;

  final AuthService _authService = AuthService();

  // Add a GlobalKey for the form
  final _formKey = GlobalKey<FormState>();

  void _signUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      UserCredential? userCredential = await _authService.signUp(
        fullName: _fullName,
        email: _email,
        password: _password,
      );

      setState(() {
        _isLoading = false;
      });

      if (userCredential != null) {
        // Navigate to onboarding or home page
        Navigator.pushReplacementNamed(context, '/onboarding');
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign Up Failed. Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main background color
          Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ),
          // Glow background
          Positioned.fill(
            child: Opacity(
              opacity: 0.6, // Adjust this value as needed (0.0 to 1.0)
              child: Image.asset(
                'assets/images/glow_background_1.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Top-left background image
          Positioned(
            top: -700,
            left: -900,
            child: Image.asset(
              'assets/images/background_top_left.png',
              width: 2200,
              height: 2200,
            ),
          ),
          // Bottom-right background image
          Positioned(
            top: -10,
            left: -30,
            child: Image.asset(
              'assets/images/background_bottom_right.png',
              width: 300,
              height: 300,
            ),
          ),
          // Main content
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.0),
              child: Form(
                key: _formKey, // Assign the form key
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 40),
                    Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Welcome to Solgate, sign up with Google or X, or you can fill out the fields below',
                      style: TextStyle(color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 30),
                    _buildTextField(
                      'Full Name*',
                      Icons.person,
                      onChanged: (value) => _fullName = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Full Name is required';
                        }
                        return null;
                      },
                    ),
                    _buildTextField(
                      'Email*',
                      Icons.email,
                      onChanged: (value) => _email = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email is required';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),
                    _buildPasswordField(
                      'Password*',
                      onChanged: (value) => _password = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        }
                        if (value.length < 8) {
                          return 'Password must be at least 8 characters';
                        }
                        // Add more validation if needed
                        return null;
                      },
                    ),
                    _buildPasswordField(
                      'Re-Enter Password',
                      onChanged: (value) => _reEnteredPassword = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please re-enter your password';
                        }
                        if (value != _password) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    _isLoading
                        ? CircularProgressIndicator()
                        : Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 185, 68, 235), // Purple
                                  Color(0xFF4EADFF), // Blue
                                  Color(0xFF5EEBC7), // Teal
                                ],
                                stops: [0.2, 0.7, 1.0],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: ElevatedButton(
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: _signUp,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding: EdgeInsets.symmetric(vertical: 16),
                                minimumSize: Size(double.infinity, 60),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
                          ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildSocialButton('assets/images/google_icon.png'),
                        SizedBox(width: 20),
                        _buildSocialButton('assets/images/x_icon.png'),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Already have an account?',
                            style: TextStyle(color: Colors.white70)),
                        ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return LinearGradient(
                              colors: [
                                Color.fromARGB(255, 185, 68, 235), // Purple
                                Color(0xFF4EADFF), // Blue
                                Color(0xFF5EEBC7), // Teal
                              ],
                              stops: [0.0, 0.5, 1.0],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ).createShader(bounds);
                          },
                          child: TextButton(
                            child: Text(
                              'Log In',
                              style: TextStyle(
                                color: Colors.white, // This color will be overridden by the gradient
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    IconData icon, {
    required ValueChanged<String> onChanged,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.white70),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.1),
          labelStyle: TextStyle(color: Colors.white70),
        ),
        style: TextStyle(color: Colors.white),
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }

  Widget _buildPasswordField(
    String label, {
    required ValueChanged<String> onChanged,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          obscureText: true,
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(Icons.lock, color: Colors.white70),
            suffixIcon: Icon(Icons.visibility_off, color: Colors.white70),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.white.withOpacity(0.1),
            labelStyle: TextStyle(color: Colors.white70),
          ),
          style: TextStyle(color: Colors.white),
          onChanged: onChanged,
          validator: validator,
        ),
        if (label == 'Password*') ...[
          SizedBox(height: 8),
          Text(
            '• Password must be at least 8 characters.',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          Text(
            '• Include an uppercase letter.',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          Text(
            r'• Include one symbol (!@%$*).',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          SizedBox(height: 11),
        ],
      ],
    );
  }

  Widget _buildSocialButton(String assetName) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Image.asset(assetName, height: 24, width: 24),
      ),
    );
  }
}