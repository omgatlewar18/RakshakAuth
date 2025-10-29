import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/Loginpage1.dart';
import 'package:untitled/SidebarWidget.dart';
import 'Screen_management.dart';
import 'WidgetProviders.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  bool isUserEnabled = false;

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

  void logout(BuildContext context) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  void ShowDialogBox(bool isEditable) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: isEditable ? Text('Edit User') : Text('Add User'),
        content: AdminCrudTableWidget(),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Provider.of<AppBarProvider>(context, listen: false).buildAppBar(context),
      drawer: buildSidebarMenu(context, 'AdminPage'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/Background.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
          userTableWidget(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ShowDialogBox(false);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class userTableWidget extends StatefulWidget {
  const userTableWidget({Key? key}) : super(key: key);

  @override
  _userTableWidgetState createState() => _userTableWidgetState();
}

class _userTableWidgetState extends State<userTableWidget> {
  List<User> users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  void fetchUsers() async {
    DatabaseReference dbRef = FirebaseDatabase.instance.ref().child("users");

    dbRef.once().then((DatabaseEvent event) {
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.exists) {
        List<User> tempUsers = [];
        Map<dynamic, dynamic> usersData = snapshot.value as Map<dynamic, dynamic>;

        usersData.forEach((key, value) {
          if (value is Map) {
            String username = value["username"] ?? "Unknown";
            String email = value["email"] ?? "No email";

            if (username == "Unknown" && value.containsKey("username") && value["username"] is String) {
              username = value["username"];
            }

            tempUsers.add(User(
              id: key,
              Users: username,
              email: email,
            ));
          }
        });

        setState(() {
          users = tempUsers;
          _isLoading = false;
        });
      }
    }).catchError((error) {
      print("Error fetching users: $error");
      setState(() {
        _isLoading = false;
      });
    });
  }

  void ShowDialogBox(bool isEditable) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: isEditable ? Text('Edit User') : Text('Add User'),
        content: CrudTableWidget(),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }


  void confirmdeletebox(BuildContext context, String userId, String username) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Confirm Delete '),
        content: Text('Are you sure you want to delete user "$username"?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => {deleteUser(context, userId, username)},
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  void deleteUser(BuildContext context, String userKey, String username) {
    DatabaseReference userRef = FirebaseDatabase.instance.ref().child("users").child(userKey);
    userRef.remove().then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User "$username" deleted successfully')),
      );
      Navigator.pop(context, 'OK');
      setState(() {
        _isLoading = true;
      });
      fetchUsers();
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete user: $error')),
      );
      Navigator.pop(context, 'OK');
    });
  }

  void logout(BuildContext context) {
    Navigator.pop(context, 'OK');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AdminDashboard()),
    );
  }


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 600,
      width: 1500,
      child: _isLoading
          ? Center(child: CircularProgressIndicator())
          : users.isEmpty
          ? Center(child: Text("No users found"))
          : DataTable(
        columnSpacing: 20,
        columns: const [
          DataColumn(label: Text('Users')),
          DataColumn(label: Text('Emails')),
          DataColumn(label: Text('Update')),
          DataColumn(label: Text('Delete')),
        ],
        rows: users.map((user) {
          return DataRow(cells: [
            DataCell(Text(user.Users)),
            DataCell(Text(user.email)),
            DataCell(
              IconButton(
                icon: Icon(Icons.edit),
                color: Colors.grey,
                onPressed: () {
                  ShowDialogBox(true);
                },
              ),
            ),
            DataCell(
              IconButton(
                icon: Icon(Icons.delete),
                color: Colors.red,
                onPressed: () {
                  confirmdeletebox(context, user.id, user.Users);
                },
              ),
            ),
          ]);
        }).toList(),
      ),
    );
  }
}


class User {
  final String id;
  final String Users;
  final String email;
  bool create;
  bool read;
  bool update;
  bool delete;
  bool isEnabled;
  String screenName;

  User({
    required this.id,
    required this.Users,
    required this.email,
    this.create = false,
    this.read = false,
    this.update = false,
    this.delete = false,
    this.isEnabled = false,
    this.screenName = '',
  });
}

class AdminCrudTableWidget extends StatefulWidget {
  final String? email;
  const AdminCrudTableWidget({Key? key, this.email}) : super(key: key);

  @override
  _AdminCrudTableWidgetState createState() => _AdminCrudTableWidgetState();
}

class _AdminCrudTableWidgetState extends State<AdminCrudTableWidget> {
  bool isEmailEnabled = false;
  final TextEditingController emailController = TextEditingController();
  String? emailError;

  final List<User> users = [
    User(id: "1", Users: "HomeScreen", email: "john@example.com"),
    User(id: "2", Users: "LandingPage", email: "jane@example.com"),
    User(id: "3", Users: "AdminPage", email: "alice@example.com"),
    User(id: "4", Users: "User Permissions", email: "john@example.com"),
  ];

  void validateEmail(String value) {
    bool emailExists = users.any((user) => user.email.toLowerCase() == value.toLowerCase());
    setState(() {
      emailError = emailExists ? null : "Email Not Found";
      isEmailEnabled = emailExists;
    });
  }

  void addUser() {
    String newEmail = emailController.text.trim();
    bool emailExists = users.any((user) => user.email.toLowerCase() == newEmail.toLowerCase());

    if (newEmail.isNotEmpty && !emailExists) {
      setState(() {
        users.add(User(
          id: DateTime.now().toString(),
          Users: "NewScreen",
          email: newEmail,
        ));
        isEmailEnabled = true;
        emailError = null;
        emailController.clear();
      });
    } else {
      setState(() {
        emailError = " Email Already Exists";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Enter Email",
                    errorText: emailError,
                    border: OutlineInputBorder(),
                  ),
                  onChanged: validateEmail,
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: addUser,
                child: const Text("Add User"),
              ),
              const SizedBox(width: 10),
              Switch(
                value: isEmailEnabled,
                onChanged: (value) {
                  if (isEmailEnabled) {
                    setState(() {
                      isEmailEnabled = value;
                    });
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Screens')),
                  DataColumn(label: Text('Create')),
                  DataColumn(label: Text('Read')),
                  DataColumn(label: Text('Update')),
                  DataColumn(label: Text('Delete')),
                ],
                rows: users.map((user) {
                  return DataRow(cells: [
                    DataCell(Text(user.screenName)),
                    DataCell(Checkbox(
                      value: user.create,
                      onChanged: isEmailEnabled
                          ? (bool? value) {
                        setState(() {
                          user.create = value ?? false;
                        });
                      }
                          : null,
                    )),
                    DataCell(Checkbox(
                      value: user.read,
                      onChanged: isEmailEnabled
                          ? (bool? value) {
                        setState(() {
                          user.read = value ?? false;
                        });
                      }
                          : null,
                    )),
                    DataCell(Checkbox(
                      value: user.update,
                      onChanged: isEmailEnabled
                          ? (bool? value) {
                        setState(() {
                          user.update = value ?? false;
                        });
                      }
                          : null,
                    )),
                    DataCell(Checkbox(
                      value: user.delete,
                      onChanged: isEmailEnabled
                          ? (bool? value) {
                        setState(() {
                          user.delete = value ?? false;
                        });
                      }
                          : null,
                    )),
                  ]);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}