import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/Loginpage1.dart';
import 'package:untitled/SidebarWidget.dart';

import 'WidgetProviders.dart';

class ScreenManagement extends StatefulWidget {
  const ScreenManagement({Key? key});

  @override
  State<ScreenManagement> createState() => _ScreenManagement();
}

class _ScreenManagement extends State<ScreenManagement> {
  void confirmbox(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Logout'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              logout(context);
              Navigator.pop(context);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  void logout(BuildContext context) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Provider.of<AppBarProvider>(context, listen: false).buildAppBar(context),
      drawer: buildSidebarMenu(context, 'Screen_Management'),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/Background.png',
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CrudTableWidget(),
                  ],
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }
}


class User {
  final String id;
  final String screenName;
  final String email;
  bool create;
  bool read;
  bool update;
  bool delete;
  bool isEnabled;

  User({
    required this.id,
    required this.screenName,
    required this.email,
    this.create = false,
    this.read = false,
    this.update = false,
    this.delete = false,
    this.isEnabled = false,
  });
}


class CrudTableWidget extends StatefulWidget {
  final String? email;
  const CrudTableWidget({Key? key, this.email}) : super(key: key);

  @override
  _CrudTableWidgetState createState() => _CrudTableWidgetState();
}

class _CrudTableWidgetState extends State<CrudTableWidget> {
  bool isEmailEnabled = false;
  final TextEditingController emailController = TextEditingController();
  String? emailError;

  final List<User> users = [
    User(id: "1", screenName: "HomeScreen", email: "john@example.com"),
    User(id: "2", screenName: "LandingPage", email: "jane@example.com"),
    User(id: "3", screenName: "AdminPage", email: "alice@example.com"),
    User(id: "4", screenName: "User Permissions", email: "john@example.com"),
  ];

  void validateEmail(String value) {
    bool emailExists = users.any((user) => user.email.toLowerCase() == value.toLowerCase());
    setState(() {
      emailError = emailExists ? null : "Email not found!";
      isEmailEnabled = emailExists;
    });
  }

  void addUser() {
    String newEmail = emailController.text.trim();
    bool emailExists = users.any((user) => user.email.toLowerCase() == newEmail.toLowerCase());

    if (newEmail.isNotEmpty && !emailExists) {
      setState(() {
        users.add(User(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          screenName: "Screen for \${newEmail.split('@')[0]}",
          email: newEmail,
        ));
        isEmailEnabled = true;
        emailError = null;
        emailController.clear();
      });
    } else {
      setState(() {
        emailError = "User with this email already exists!";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height - 100,
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(16),
        color: Colors.white.withOpacity(0.95),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Enter User Email to Set Permissions',
                        errorText: emailError,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      onSubmitted: (_) => addUser(),
                    ),
                  ),
                  SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: addUser,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text("Update"),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    isEmailEnabled ? "Permissions Enabled" : "Permissions Disabled",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 12),
                  Switch(
                    value: isEmailEnabled,
                    onChanged: (value) {
                      setState(() {
                        isEmailEnabled = value;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width - 64),
                    child: DataTable(
                      columnSpacing: 32,
                      headingRowHeight: 56,
                      dataRowHeight: 64,
                      columns: const [
                        DataColumn(label: Text('Screens')),
                        DataColumn(label: Text('Create')),
                        DataColumn(label: Text('Read')),
                        DataColumn(label: Text('Update')),
                        DataColumn(label: Text('Delete')),
                        DataColumn(label: Text('Enable/Disable')),
                      ],
                      rows: users.map((user) {
                        return DataRow(cells: [
                          DataCell(Text(user.screenName)),
                          DataCell(Checkbox(
                            value: user.create,
                            onChanged: isEmailEnabled
                                ? (val) => setState(() => user.create = val ?? false)
                                : null,
                          )),
                          DataCell(Checkbox(
                            value: user.read,
                            onChanged: isEmailEnabled
                                ? (val) => setState(() => user.read = val ?? false)
                                : null,
                          )),
                          DataCell(Checkbox(
                            value: user.update,
                            onChanged: isEmailEnabled
                                ? (val) => setState(() => user.update = val ?? false)
                                : null,
                          )),
                          DataCell(Checkbox(
                            value: user.delete,
                            onChanged: isEmailEnabled
                                ? (val) => setState(() => user.delete = val ?? false)
                                : null,
                          )),
                          DataCell(
                            Switch(
                              value: user.isEnabled,
                              onChanged: isEmailEnabled
                                  ? (val) => setState(() => user.isEnabled = val)
                                  : null,
                            ),
                          ),
                        ]);
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}