import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:twitter_login/twitter_login.dart';
import '../services/auth_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String _password = '';
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

      try {
        UserCredential? userCredential = await _authService.signUp(
          fullName: _fullName,
          email: _email,
          password: _password,
        );

        if (userCredential != null && userCredential.user != null) {
          // Create Firestore record
          await _createUserRecord(uid: userCredential.user!.uid);
          
          // Navigate to onboarding or home page
          Navigator.pushReplacementNamed(context, '/onboarding');
        } else {
          throw Exception('User creation failed');
        }
      } catch (e) {
        print('Error during sign up: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign Up Failed. Please try again.')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _createUserRecord({required String uid, String? email, String? fullName}) async {
    final signupReward = int.tryParse(dotenv.env['SIGNUP_REWARD'] ?? '') ?? 100;
    
    try {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      
      if (!userDoc.exists) {
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'fullName': fullName ?? _fullName,
          'email': email ?? _email,
          'pointsBalance': signupReward,
          'createdAt': FieldValue.serverTimestamp(),
        });
      } else {
        // Optionally update existing user data
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'lastSignIn': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('Error creating/updating user record: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating user profile. Please try again.')),
      );
    }
  }

  Future<void> _handleGoogleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        // Save user data to Firestore
        await _createUserRecord(uid: user.uid, email: user.email, fullName: user.displayName);

        // Navigate to onboarding or home page
        Navigator.pushReplacementNamed(context, '/createorimportwalletpage');
      } else {
        throw Exception('User is null after Google Sign In');
      }
    } catch (e) {
      print('Error during Google sign in: $e');
      if (e is PlatformException) {
        print('Error code: ${e.code}');
        print('Error message: ${e.message}');
        print('Error details: ${e.details}');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google Sign In Failed. Please try again.')),
      );
    }
  }

  Future<void> _handleTwitterSignIn() async {
    final twitterLogin = TwitterLogin(
      apiKey: dotenv.env['TWITTER_API_KEY']!,
      apiSecretKey: dotenv.env['TWITTER_API_SECRET_KEY']!,
      redirectURI: 'solgate://',
    );

    try {
      final authResult = await twitterLogin.login();
      switch (authResult.status) {
        case TwitterLoginStatus.loggedIn:
          final credential = TwitterAuthProvider.credential(
            accessToken: authResult.authToken!,
            secret: authResult.authTokenSecret!,
          );
          await _signInWithCredential(credential);
          break;
        case TwitterLoginStatus.cancelledByUser:
          // User cancelled the login flow
          break;
        case TwitterLoginStatus.error:
          throw Exception(authResult.errorMessage);
        default:
          throw Exception('Unknown error');
      }
    } catch (e) {
      print('Error during Twitter sign in: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Twitter Sign In Failed. Please try again.')),
      );
    }
  }

  Future<void> _signInWithCredential(AuthCredential credential) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      if (userCredential.user != null) {
        await _createUserRecord(uid: userCredential.user!.uid);
        Navigator.pushReplacementNamed(context, '/onboarding');
      } else {
        throw Exception('User creation failed');
      }
    } catch (e) {
      print('Error during sign in: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign In Failed. Please try again.')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
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
                key: _formKey,
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
                      'Welcome to Solgate 🙂',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 32),
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
                        Text(
                          'Already have an account? ',
                          style: TextStyle(color: Colors.white70),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                          child: ShaderMask(
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
                            child: Text(
                              'Log In',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
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
      onTap: () {
        if (assetName.contains('google')) {
          _handleGoogleSignIn();
        } else if (assetName.contains('x')) {
          _handleTwitterSignIn();
        }
      },
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
