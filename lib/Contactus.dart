import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/Loginpage1.dart';
import 'package:untitled/SidebarWidget.dart';
import 'WidgetProviders.dart';


class ContactPage extends StatefulWidget {
  const ContactPage({Key? key});

  @override
  State<ContactPage> createState() => _ContactPage();
}

class _ContactPage extends State<ContactPage> {

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
      drawer: buildSidebarMenu(context, 'ContactUs'),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/Background.png',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left Side Contact Info
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Contact Us',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Get in touch with RakshakAuth ',
                        style: TextStyle(fontSize: 18, color: Colors.white70),
                      ),
                      const SizedBox(height: 40),

                      ContactInfoRow(icon: Icons.location_on, text: 'India'),
                      const SizedBox(height: 20),
                      ContactInfoRow(
                        icon: Icons.email,
                        text: 'ingaleprachi133@gmail.com',
                      ),
                      const SizedBox(height: 20),
                      ContactInfoRow(
                        icon: Icons.phone,
                        text: '(+91) 9370932686',
                      ),
                    ],
                  ),

                  // Right Side Contact Form
                  Container(
                    width: 400, // Adjust card width
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 12,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      // Shrinks card to fit content
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Contact Us',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Name Field
                        const Text(
                          'Name',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        const SizedBox(height: 5),
                        CustomTextField(hintText: 'Enter your full name'),

                        // Email Field
                        const SizedBox(height: 15),
                        const Text(
                          'Email',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        const SizedBox(height: 5),
                        CustomTextField(hintText: 'example@gmail.com'),

                        // Details Field
                        const SizedBox(height: 15),
                        const Text(
                          'Details',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        const SizedBox(height: 5),
                        CustomTextField(
                          hintText: 'Enter your problem details',
                          maxLines: 3,
                        ),

                        // Send Button
                        const SizedBox(height: 25),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF60A5FA),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30,
                                vertical: 12,
                              ),
                            ),
                            child: const Text(
                              'Send Message',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
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
}

// Widget for text fields
class CustomTextField extends StatelessWidget {
  final String hintText;
  final int maxLines;

  const CustomTextField({required this.hintText, this.maxLines = 1, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.blue),
        ),
      ),
    );
  }
}

// Widget for left-side contact info
class ContactInfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const ContactInfoRow({required this.icon, required this.text, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 22),
        const SizedBox(width: 10),
        Text(text, style: const TextStyle(fontSize: 16, color: Colors.white70)),
      ],
    );
  }
}