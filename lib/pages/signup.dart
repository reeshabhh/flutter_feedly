import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feedly/pages/login.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  bool _loggingIn = false;

  _signup() async {
    setState(() {
      _loggingIn = true;
    });

    if (_passwordController.text.trim() !=
        _passwordConfirmController.text.trim()) {
      // _scaffoldKey.currentState!
      //     .showSnackBar(SnackBar(content: Text('Password do not match')));
      debugPrint(_passwordController.text.trim());
      debugPrint(_passwordConfirmController.text.trim());
      debugPrint('***********************************');
      return;
    }
    try {
      UserCredential _user = await _firebaseAuth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim());
      _scaffoldKey.currentState!.removeCurrentSnackBar();
      _scaffoldKey.currentState!
          .showSnackBar(SnackBar(content: Text('Logging you in')));
      // CircularProgressIndicator();

      await _firebaseAuth.currentUser!
          .updateDisplayName(_nameController.text.trim());

      // _scaffoldKey.currentState!.showSnackBar(SnackBar(
      //     content: Text('Your account has been created successfully.')));
    } catch (e) {
      _scaffoldKey.currentState?.showSnackBar(
        SnackBar(
          content: Text((e as PlatformException).message!),
        ),
      );
    } finally {
      setState(() {
        _loggingIn = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange,
      body: Form(
        child: ListView(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 72.0, bottom: 36.0),
              child: Icon(
                Icons.rss_feed,
                size: 60.0,
                color: Colors.white,
              ),
            ),
            InputFieldLoginSignup(
              icon: Icons.person,
              hintText: 'Enter your Name',
              controller: _nameController,
              obscureText: false,
            ),
            InputFieldLoginSignup(
              icon: Icons.alternate_email,
              hintText: 'Enter your email',
              controller: _emailController,
              obscureText: false,
            ),
            InputFieldLoginSignup(
              icon: Icons.lock_open,
              hintText: 'Enter your password',
              controller: _passwordController,
              obscureText: true,
            ),
            InputFieldLoginSignup(
              icon: Icons.lock_open,
              hintText: 'Re-enter your password',
              controller: _passwordConfirmController,
              obscureText: true,
            ),
            Container(
              margin: const EdgeInsets.only(top: 20.0),
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      onPressed: _loggingIn == true
                          ? null
                          : () {
                              _signup();
                            },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.0),
                              child: Text(
                                'SIGN UP',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.deepOrange),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20.0),
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (BuildContext ctx) {
                        //       return LoginPage();
                        //     },
                        //   ),
                        // );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.0),
                              child: Text(
                                'Already have an account? Login here.',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
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
}
