import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_fonts/google_fonts.dart';

import 'categorypage.dart';

class onbrdscrn extends StatefulWidget {
  const onbrdscrn({super.key});

  @override
  State<onbrdscrn> createState() => _onbrdscrnState();
}

class _onbrdscrnState extends State<onbrdscrn>
    with SingleTickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  late AnimationController _animationController;
  late Animation<double> _logoAnimation;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));

    _logoAnimation =
        CurvedAnimation(parent: _animationController, curve: Curves.elasticOut);

    _animationController.forward();
  }

  Future<User?> _signInWithEmailAndPassword() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message ?? "An error occurred";
      });
      return null;
    }
  }

  Future<User?> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null; // User canceled the sign-in
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  void _handleSignInWithEmail() async {
    User? user = await _signInWithEmailAndPassword();
    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const catgrypg()),
      );
    }
  }

  void _handleSignInWithGoogle() async {
    User? user = await _signInWithGoogle();
    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const catgrypg()),
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Colors.white, Colors.orangeAccent],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 100),
                ScaleTransition(
                  scale: _logoAnimation,
                  child: SizedBox(
                    height: 250,
                    width: 450,
                    child: Image.asset(
                      'assets/images/WALQ LOGO png.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  'WALQ FOOD INDUSTRIES LLC',
                  style: GoogleFonts.anton(fontSize: 35, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: TextField(
                    controller: _emailController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: const TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.orange.shade600,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: TextField(
                    controller: _passwordController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: const TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.orange.shade600,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                    ),
                    obscureText: true,
                  ),
                ),
                const SizedBox(height: 20),
                if (_errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Text(
                      _errorMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 50,
                  width: 250,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      backgroundColor: Colors.deepOrangeAccent,
                    ),
                    onPressed: _handleSignInWithEmail,
                    child: const Text(
            ///          "Sign In with Email",
                          "SIGN IN",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                ///      SizedBox(
                ///        height: 50,
                ///        width: 300,
                ///        child: ElevatedButton(
                ///          style: ElevatedButton.styleFrom(
                ///            elevation: 10,
                ///            shape: RoundedRectangleBorder(
                ///              borderRadius: BorderRadius.circular(15),
                ///            ),
                ///            backgroundColor: Colors.orange,
                ///          ),
                ///          onPressed: _handleSignInWithGoogle,
                ///          child: const Row(
                ///            mainAxisAlignment: MainAxisAlignment.center,
                ///            children: [
                ///              Text(
                ///                "Continue with Google",
                ///                style: TextStyle(fontSize: 20, color: Colors.white),
                ///              ),
                ///              SizedBox(width: 10),
                ///              Icon(Icons.login, color: Colors.white),
                ///            ],
                ///          ),
                ///        ),
                ///      ),
                ///      const SizedBox(height: 20),
                SizedBox(
                  height: 50,
                  width: 250,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      backgroundColor: Colors.deepOrangeAccent,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const catgrypg(),
                        ),
                      );
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Continue",
                          style: TextStyle(fontSize: 30, color: Colors.white),
                        ),
                        SizedBox(width: 10),
                        Icon(Icons.arrow_forward_ios, color: Colors.white),
                      ],
                    ),
                  ),
                ),
               /// const SizedBox(height: 40),
               /// const Padding(
               ///   padding: EdgeInsets.fromLTRB(350, 50, 1, 8),
               ///   child: Text(
               ///     'github.com/Aruncp47',
               ///     style: TextStyle(fontSize: 5, color: Colors.white38),
               ///   ),
               /// )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
