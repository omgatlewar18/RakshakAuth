import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:untitled/landingpage.dart';
import 'Contactus.dart';
import 'Loginpage1.dart';
import 'SidebarWidget.dart';
import 'loginprovider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile Screen',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ProfileScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  final TextEditingController firstNameController = TextEditingController(text: 'Prachi');
  final TextEditingController lastNameController = TextEditingController(text: 'Ingale');
  final TextEditingController phoneController = TextEditingController(text: '+91');
  final TextEditingController emailController = TextEditingController(text: 'ingaleprachi@gmail.com');
  final TextEditingController cityController = TextEditingController(text: 'Nagpur');
  final TextEditingController stateController = TextEditingController(text: 'Maharashtra');
  final TextEditingController postcodeController = TextEditingController(text: '440024');
  final TextEditingController countryController = TextEditingController(text: 'India');

  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController!.index = 4;
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

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

  void logout(BuildContext context) async {
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);

    try {
      // Firebase sign out
      await FirebaseAuth.instance.signOut();

      // Google sign out (if applicable)
      final googleSignIn = GoogleSignIn();
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
      }

      // Clear user data
      loginProvider.currentuser = null;

      // Go to LoginPage and clear navigation stack
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
        title: Text(' RakshakAuth Profile'),
        leading: Builder(
          builder:
              (context) => IconButton(
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
          IconButton(icon: Icon(Icons.home), onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LandingPage()),
            );
          }
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
      ),
      drawer: buildSidebarMenu(context, 'ProfilePage'),
      body: Stack(
        children: [Positioned.fill(
          child: Image.asset(
            'assets/images/Background.png',
            fit: BoxFit.cover,
          ),
        ),
          Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: 160,
                    child: Image.asset(
                      'assets/images/Background.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    right: 16,
                    bottom: 16,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      icon: Icon(Icons.camera_alt),
                      label: Text('Change Cover'),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),

              // Main Content Area
              Expanded(
                child: Container(
                  color: Colors.grey[100],
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(220, 0, 16, 16), // Leave space for profile card
                    child: Card(
                      margin: EdgeInsets.only(top: 0),
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          // Tab Bar
                          Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Colors.grey[300]!, width: 1),
                              ),
                            ),
                            child: TabBar(
                              controller: _tabController,
                              labelColor: Colors.blue,
                              unselectedLabelColor: Colors.grey,
                              indicatorColor: Colors.blue,
                              indicatorWeight: 3,
                              tabs: [
                                Tab(text: 'Account Setting'),
                                Tab(text: 'Company Setting'),
                                Tab(text: 'Documents'),
                                Tab(text: 'Activity'),
                                Tab(text: 'Notifications'),
                              ],
                            ),
                          ),

                          // Form Content
                          Expanded(
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                _buildFormContent(),
                                Center(child: Text('Company Setting Content')),
                                Center(child: Text('Documents Content')),
                                Center(child: Text('Project Content')),
                                Center(child: Text('Notifications Content')),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Side Profile Card
          Positioned(
            top: 120,
            left: 16,
            child: Container(
              width: 190,
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 40), // Space for avatar
                      Text(
                        'Prachi Ingale',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Assisstant Manager',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      Divider(height: 24),
                      _buildStatRow('Active Projects', '7', Colors.green),
                      Divider(height: 16),
                      _buildStatRow('Allotted Projects', '12', Colors.amber),
                      Divider(height: 16),
                      _buildStatRow('Finished Projects', '4', Colors.blue),
                      SizedBox(height: 16),
                      OutlinedButton(
                        onPressed: () {},
                        child: Text('View public profile'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.black,
                          side: BorderSide(color: Colors.grey[300]!),
                          padding: EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      Container(
                        height: 36,
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                'https://app.ingaleprachi...',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.blue,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Icon(Icons.copy, size: 16),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Profile Avatar
          Positioned(
            top: 80,
            left: 16 + 95 - 45, // Centered on the card
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4),
              ),
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.purple[100],
                    child: Text(
                      "CG",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormContent() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // First row - First Name & Last Name
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildTextField(
                  'First Name',
                  firstNameController,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildTextField(
                  'Last Name',
                  lastNameController,
                ),
              ),
            ],
          ),
          SizedBox(height: 24),

          // Second row - Phone & Email
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildTextField(
                  'Phone Number',
                  phoneController,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildTextField(
                  'Email Address',
                  emailController,
                ),
              ),
            ],
          ),
          SizedBox(height: 24),

          // Third row - City & State/Country
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildDropdownField(
                  'City',
                  cityController,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildTextField(
                  'State/Country',
                  stateController,
                ),
              ),
            ],
          ),
          SizedBox(height: 24),

          // Fourth row - Postcode & Country
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildDropdownField(
                  'Postcode',
                  postcodeController,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildDropdownField(
                  'Country',
                  countryController,
                ),
              ),
            ],
          ),
          SizedBox(height: 32),

          // Update Button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              minimumSize: Size(120, 44),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            onPressed: () {},
            child: Text('Update'),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            suffixIcon: Icon(Icons.keyboard_arrow_down),
          ),
          readOnly: true,
        ),
      ],
    );
  }

  Widget _buildStatRow(String label, String value, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 12),
          ),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}