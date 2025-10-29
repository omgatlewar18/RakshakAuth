import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/SidebarWidget.dart';
import 'WidgetProviders.dart';
import 'loginprovider.dart';
import 'package:url_launcher/url_launcher.dart';


class LandingPage extends StatefulWidget{
  const LandingPage({Key? key});


  @override
  State<LandingPage>  createState() => _LandingPage();
}

class _LandingPage extends State<LandingPage> {


  @override
  Widget build(BuildContext context) {
    return Consumer<LoginProvider>(
      builder: (context, loginprov, child) {
        return Scaffold(
          appBar: Provider.of<AppBarProvider>(context, listen: false).buildAppBar(context),
          drawer: buildSidebarMenu(context, 'HomePage', isAdmin: loginprov.isAdmin),
          body: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/images/Background.png',
                  fit: BoxFit.cover,
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [

                        _buildCard(context, 'assets/images/pinterest.png', 'Pinterest', 'https://in.pinterest.com/login/'),
                        _buildCard(context, 'assets/images/canva.jpeg', 'Canva', 'https://www.canva.com/en_in/'),
                        _buildCard(context, 'assets/images/zoom.png', 'Zoom', 'https://zoom.us/signin#/login'),


                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [

                        _buildCard(context, 'assets/images/linkedin.png', 'LinkedIn', 'https://www.linkedin.com/login'),
                        _buildCard(context, 'assets/images/miro.png', 'Miro', 'https://miro.com/login/'),
                        _buildCard(context, 'assets/images/coursera.png', 'Coursera', 'https://www.coursera.org/login'),

                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCard(BuildContext context, String imagePath, String title, String url){
    return GestureDetector(
      onTap: () => _launchURL(url),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          width: 250,
          height: 250,
          padding: EdgeInsets.all(12),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imagePath,
                width: 120,
                height: 120,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 10),
              Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

}


void _launchURL(String url) async {
  Uri uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, webOnlyWindowName: '_blank');
  } else {
    throw 'Could not launch $url';
  }
}