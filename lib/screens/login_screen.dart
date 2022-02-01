import 'package:admin_pannel_app/screens/homescreen.dart';
import 'package:admin_pannel_app/services/firebase_service.dart';
import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  final _formKey = GlobalKey<FormState>();
  FirebaseServices _services = FirebaseServices();
  String username = '';
  String password = '';
  @override
  Widget build(BuildContext context) {
    ArsProgressDialog progressDialog = ArsProgressDialog(
      context,
      blur: 2,
      backgroundColor: const Color(0xFF84c225),
      animationDuration: Duration(milliseconds: 500),
    );
    Future<void> _login() async {
      progressDialog.show();
      _services.getAdminCredentials().then((value) {
        value.docs.forEach((doc) async {
          if (doc.get('username') == username) {
            if (doc.get('password') == password) {
              UserCredential userCredential =
                  await FirebaseAuth.instance.signInAnonymously();
              progressDialog.dismiss();
              if (userCredential.user.uid != null) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => HomeScreen()));
                return;
              } else {
                _showDialog(
                  title: 'Login',
                  message: 'Login Failed',
                );
              }
            } else {
              progressDialog.dismiss();
              _showDialog(
                  title: 'Incorrect Password',
                  message: 'Password you entered is incorrect. ');
            }
          } else {
            progressDialog.dismiss();
            _showDialog(
                title: 'Invalid Username',
                message: ' Username you entered is not valid.');
          }
        });
      });
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          'Admin Panel',
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Connection failed'),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0xFF84c225), Colors.white],
                    stops: [1.0, 1.0],
                    begin: Alignment.topCenter,
                    end: Alignment(0.0, 0.0)),
              ),
              child: Center(
                // ignore: sized_box_for_whitespace
                child: Container(
                  width: 300,
                  height: 500,
                  child: Card(
                    elevation: 6,
                    shape: Border.all(color: Colors.green, width: 2),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            // ignore: avoid_unnecessary_containers
                            Container(
                              child: Column(
                                children: [
                                  Image.asset('images/logo.png'),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const Text(
                                    'Foodie Admin Panel',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 20),
                                  ),
                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                  TextFormField(
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Enter Username';
                                      }
                                      setState(() {
                                        username = value;
                                      });
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        prefixIcon: const Icon(Icons.person),
                                        labelText: 'User Name',
                                        contentPadding: const EdgeInsets.only(
                                            left: 20, right: 20),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                width: 2))),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  TextFormField(
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Enter Password';
                                      }
                                      if (value.length < 6) {
                                        return 'Minimum 6 Characters';
                                      }
                                      setState(() {
                                        password = value;
                                      });
                                      return null;
                                    },
                                    obscureText: true,
                                    decoration: InputDecoration(
                                        labelText: 'Minimum 6 Characters',
                                        prefixIcon:
                                            const Icon(Icons.vpn_key_sharp),
                                        hintText: 'Password',
                                        contentPadding: const EdgeInsets.only(
                                            left: 20, right: 20),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                width: 2))),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  // ignore: deprecated_member_use
                                  child: FlatButton(
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          _login();
                                        }
                                      },
                                      color: Theme.of(context).primaryColor,
                                      child: const Text(
                                        'Login',
                                        style: TextStyle(color: Colors.white),
                                      )),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Future<void> _showDialog({title, message}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
                Text('Please try again'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
