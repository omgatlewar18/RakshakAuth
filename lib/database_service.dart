import 'package:firebase_database/firebase_database.dart';

class DatabaseService {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  Future<void> create(String userId, Map<String, dynamic> userData) async {
    try {
      await _db.child("users/$userId").set(userData);
      print("User created successfully!");
    } catch (error) {
      print("Error creating user: $error");
    }
  }
  Future<Map<String, dynamic>?> read(String userId) async {
    try {
      DatabaseEvent event = await _db.child("users/$userId").once();
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.value != null) {
        print("User Data: ${snapshot.value}");

      } else {
        print("No data found!");
      }
    } catch (error) {
      print("Error reading user: $error");
    }
  }

  // UPDATE: Modify user data
  Future<void> update(String userId, Map<String, dynamic> updates) async {
    try {
      await _db.child("users/$userId").update(updates);
      print("User updated successfully!");
    } catch (error) {
      print("Error updating user: $error");
    }
  }

  // DELETE: Remove user data
  Future<void> delete(String userId) async {
    try {
      await _db.child("users/$userId").remove();
      print("User deleted successfully!");
    } catch (error) {
      print("Error deleting user: $error");
    }
  }
}