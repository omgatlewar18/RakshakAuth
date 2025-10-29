import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/landingpage.dart';
import 'package:untitled/loginprovider.dart';
import 'package:untitled/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:untitled/Admin_Dashboard.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool showLoginCard = false;

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
        title: const Text('RakshakAuth LoginPage'),
        actions: [
          IconButton(
            icon: Icon(Icons.login),
            onPressed: () {
              setState(() {
                showLoginCard = true;
              });
            },
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                showLoginCard = true;
              });
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text('Login', style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ),
          IconButton(
            icon: Icon(Icons.add_box_outlined),
            onPressed: () {
              setState(() {
                showLoginCard = !showLoginCard;
              });
            },
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                showLoginCard = !showLoginCard;
              });
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text('Signup', style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/RA_background.png',
              fit: BoxFit.cover,
            ),
          ),
          if (showLoginCard)
            Center(
              child: Logincard(
                onClose: () {
                  setState(() {
                    showLoginCard = false;
                  });
                },
              ),
            ),
        ],
      ),
    );
  }
}

class Logincard extends StatelessWidget {
  final VoidCallback onClose;
  final DatabaseService db = DatabaseService();
  bool isLogin = false;
  Logincard({Key? key, required this.onClose}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController usernameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return SizedBox(
      width: 800,
      height: 600,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 60.0, vertical: 100.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(9.0),
        ),
        elevation: 8,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: onClose,
                  ),
                ),
                Image.asset('assets/images/RA.png',
                  height: 40,
                  width: 40,
                ),
                Text(isLogin?'  Rakshakauth Login  ' :' RakshakAuth Signup  ',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8 , width: 8),
                TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                      labelText: 'Username', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 8 , width: 8),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                      labelText: 'Password', border: OutlineInputBorder()),
                ),

                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    String username = usernameController.text;
                    String password = passwordController.text;

                    if (username == "admin" && password == "admin") {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => const AdminDashboard()),
                      );
                      return;
                    }

                    var userData = await db.read(username);

                    if (userData != null && userData['password'] == password) {
                      await db.update(username, {"last_login": DateTime.now().toString()});
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const LandingPage()),
                      );
                    } else {showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Login Failed"),
                        content: const Text("Invalid Username or Password"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Close"),
                          ),
                        ],
                      ),
                    );

                    }
                  },
                  child: const Text("Login"),
                ),
                const SizedBox(height: 40 , width: 80),
                Consumer<LoginProvider>(
                  builder: (context, loginprov, child) {
                    return ElevatedButton.icon(
                      icon: Image.asset('assets/images/Google.png', height: 20 , width: 40,),
                      label: const Text('Sign in with Google'),
                      onPressed: () async {
                        bool success = await loginprov.signInWithGoogle(context);

                        if (success) {
                          firebase_auth.User? user = firebase_auth.FirebaseAuth.instance.currentUser;

                          db.create(user!.uid, {
                            "username": user.displayName ?? "Updated Name",
                            "email": user.email ?? "Unknown"
                          });
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const LandingPage()),
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text("Login Failed"),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                  },
                                  child: const Text("Close"),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    await db.delete(usernameController.text);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("User deleted successfully")),
                    );
                  },
                  child: const Text("Delete Account"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}