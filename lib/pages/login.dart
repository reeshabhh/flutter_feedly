import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feedly/pages/feed.dart';
import 'package:flutter_feedly/pages/signup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? _email;
  String? _password;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // ScaffoldMessengerState _scaffoldMessengerState = ScaffoldMessengerState.of(context);

  GlobalKey<ScaffoldMessengerState> _scaffoldMessengerStateKey =
      GlobalKey<ScaffoldMessengerState>();

  bool _loggingIn = false;

  _login() async {
    setState(() {
      _loggingIn = true;
    });
    try {
      UserCredential _user = await _firebaseAuth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // _scaffoldKey.currentState!.removeCurrentSnackBar();
      // _scaffoldKey.currentState!
      //     .showSnackBar(SnackBar(content: Text('Logging you in')));
      // CircularProgressIndicator();

      print('************************************************');
      print(_emailController.text);
      print(_passwordController.text);
      print('Login Successful');
      print('************************************************');

      // _scaffoldMessengerStateKey.currentState!
      //     .showSnackBar(SnackBar(content: Text('Login Successful')));
      // _scaffoldKey.currentState!
      //     .showSnackBar(SnackBar(content: Text('Login Successful')));
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext ctx) {
        return FeedPage();
      }));
    } catch (e) {
      print('************************************************');
      print(_emailController.text.trim());
      print(_passwordController.text.trim());
      print('Error');
      print('************************************************');

      // print('************************************************');
      // print(_emailController.text);

      // print(_passwordController.text);
      // print(e);
      // // print((e as PlatformException).message!);
      // print('************************************************');

      _scaffoldMessengerStateKey.currentState
          ?.showSnackBar(SnackBar(content: Text((e.toString()))));

      // _scaffoldMessengerStateKey.currentState?.showSnackBar(
      //     SnackBar(content: Text((e as FirebaseAuthException).message!)));

      // _scaffoldKey.currentState?.showSnackBar(
      //   SnackBar(
      //     content: Text((e as FirebaseAuthException).message!),
      //   ),
      // );
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
                size: 180,
                color: Colors.white,
              ),
            ),
            Container(
              margin:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white.withOpacity(0.5),
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    child: Icon(
                      Icons.alternate_email,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    height: 30.0,
                    width: 1.0,
                    color: Colors.white.withOpacity(0.5),
                    margin: const EdgeInsets.only(right: 10.0),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _emailController,
                      // obscureText: true,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter your email',
                        hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white.withOpacity(0.5),
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    child: Icon(
                      Icons.lock_open,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    height: 30.0,
                    width: 1.0,
                    color: Colors.white.withOpacity(0.5),
                    margin: const EdgeInsets.only(right: 10.0),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter your password',
                        hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // InputFieldLoginSignup(
            //   icon: Icons.alternate_email,
            //   hintText: 'Enter your email',
            //   controller: _emailController,
            // ),
            // InputFieldLoginSignup(
            //   icon: Icons.lock_open,
            //   hintText: 'Enter your password',
            //   controller: _passwordController,
            // ),
            Container(
              margin: const EdgeInsets.only(top: 20.0),
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        // TODO: make the login button opacity 50 percent if the value is null
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      onPressed: _loggingIn == true
                          ? null
                          : () {
                              _login();
                            },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.0),
                              child: Text(
                                'LOGIN',
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
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext ctx) {
                              return SignupPage();
                            },
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.0),
                              child: Text(
                                'Don\'t have an account? Create one',
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

class InputFieldLoginSignup extends StatelessWidget {
  // const InputFieldLoginSignup({
  //   Key? key,
  // }) : super(key: key);

  IconData? icon;
  String? hintText;
  TextEditingController? controller;
  bool? obscureText;
  InputFieldLoginSignup({
    @required this.icon,
    @required this.hintText,
    @required this.controller,
    @required this.obscureText,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white.withOpacity(0.5),
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Icon(
              icon,
              color: Colors.white,
            ),
          ),
          Container(
            height: 30.0,
            width: 1.0,
            color: Colors.white.withOpacity(0.5),
            margin: const EdgeInsets.only(right: 10.0),
          ),
          Expanded(
            child: TextFormField(
              controller: controller,
              obscureText: obscureText!,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
