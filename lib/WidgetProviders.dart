import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:untitled/Loginpage1.dart';
import 'package:untitled/landingpage.dart';
import 'Contactus.dart';
import 'loginprovider.dart';
import 'Profilepage.dart';

class AppBarProvider extends ChangeNotifier {
  int tokenTTL = 3599;
  Timer? _timer;

  AppBarProvider() {
    startCountdown();
  }

  PreferredSizeWidget buildAppBar(BuildContext context) {
    final loginprov = Provider.of<LoginProvider>(context, listen: false);

    return AppBar(
      backgroundColor: Colors.blueGrey,
      foregroundColor: Colors.white,
      title: Row(
        children: [
          Text('${loginprov.currentuser?.username ?? "Admin"} Login  |  '),
          SizedBox(width: 11),
          Container(
            decoration: BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              children: [
                Text(
                  'SAML ',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(width: 4),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    backgroundColor: tokenTTL > 0 ? Colors.green : Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 2,
                  ),
                  onPressed: () {},
                  child: Text(
                    tokenTTL > 0 ? 'Active' : 'Expired',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.account_circle_outlined),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen()),
            );
          },
        ),
        Text(' Profile     '),
        IconButton(
          icon: Icon(Icons.add_ic_call_outlined),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ContactPage()),
            );
          },
        ),
        Text('   Contact Us   '),
        IconButton(
          icon: Icon(Icons.home),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LandingPage()),
            );
          },
        ),
        Text('   Home    '),
        IconButton(
          icon: Icon(Icons.logout),
          onPressed: () {
            confirmbox(context);
          },
        ),
        Text('   Logout    '),
      ],
    );
  }

  void startCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (tokenTTL > 0) {
        tokenTTL--;
      } else {
        _timer?.cancel();
      }
      notifyListeners();
    });
  }

  void confirmbox(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Logout'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => {logout(context)},
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  void logout(BuildContext context) async {
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);

    try {
      await FirebaseAuth.instance.signOut();

      final googleSignIn = GoogleSignIn();
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
      }

      loginProvider.currentuser = null;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
            (route) => false,
      );
    } catch (e) {
      print("Logout error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Logout failed: ${e.toString()}")),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

class SidebarProvider extends ChangeNotifier {
  List<Screens> screens = [
    Screens(name: "HomeScreen", create: true, read: true, update: true, delete: true),
    Screens(name: "Admin_Dashboard", create: true, read: true, update: true, delete: true),
    Screens(name: "Screen_management", create: true, read: true, update: true, delete: true),
    Screens(name: "Contactus", create: true, read: true, update: true, delete: true),
    Screens(name: "Profilepage", create: true, read: true, update: true, delete: true),
  ];
}

/*
  class SidebarMenu extends StatefulWidget {
  const SidebarMenu({Key? key});

  @override
  State<SidebarMenu> createState() => _SidebarMenu();
}

class _SidebarMenu extends State<SidebarMenu> {

  void confirmbox(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
        title: Text('Logout'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => { logout(context)
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  void logout(BuildContext context){
    Navigator.pop(context, 'OK');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blueGrey),
            child: Column(
              children: [
                Image.asset('assets/images/RA.png', width: 80),
                SizedBox(height: 10),
                Text(
                  'Menu',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ],
            ),
          ),
          Opacity(
            opacity: 0.6,
            child: Container(
              color: Colors.blueGrey.withOpacity(0.1),
              child: ListTile(
                title: const Text('Profile'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()),
                  );
                },
              ),
            ),
          ),
          Opacity(
            opacity: 1.0,
            child: Container(
              color: Colors.blueGrey.withOpacity(0.3),
              child: ListTile(
                title: const Text('HomePage'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LandingPage()),
                  );
                },
              ),
            ),
          ),
          Opacity(
            opacity: 0.6,
            child: Container(
              color: Colors.blueGrey.withOpacity(0.1),
              child: ListTile(
                title: const Text('Screen Management'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ScreenManagement()),
                  );
                },
              ),
            ),
          ),
          Opacity(
            opacity: 0.6,
            child: Container(
              color: Colors.blueGrey.withOpacity(0.1),
              child: ListTile(
                title: const Text('Contact Us'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ContactPage()),
                  );
                },
              ),
            ),
          ),
          Opacity(
            opacity: 0.6,
            child: Container(
              color: Colors.blueGrey.withOpacity(0.1),
              child: ListTile(
                title: const Text('Logout'),
                onTap: () {
                  confirmbox(context);

                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

*/


/*


  APPBAR CLASS

  appBar: AppBar(
            backgroundColor: Colors.blueGrey,
            foregroundColor: Colors.white,
            title: Text('${loginprov.user?.username ?? "Admin"} Login'),
            leading: Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
            ),
            actions: [
              IconButton(icon: Icon(Icons.account_circle_outlined), onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()),
                );
              }),
              Text(' Profile     '),
              IconButton(
                icon: Icon(Icons.add_ic_call_outlined),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ContactPage()),
                  );
                },
              ),

              Text('   Contact Us   '),
              IconButton(icon: Icon(Icons.home), onPressed: () {

              }),
              Text('   Home    '),
              IconButton(
                icon: Icon(Icons.logout),
                onPressed: () {
                  Provider.of<LoginProvider>(context, listen: false).signOut();
                  confirmbox(context);
                },
              ),
              Text('   Logout    '),
            ],
          ),
   */