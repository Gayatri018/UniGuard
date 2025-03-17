import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uniguard/screens/report_page.dart';
// import 'package:uniguard/admin/community.dart';
// import '../admin/report_details.dart';
import 'package:uniguard/screens/my_reports.dart';
import 'my_community.dart';

class LandingPage extends StatefulWidget {
  final String token;

  const LandingPage({Key? key, required this.token}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int _currentIndex = 0;

  // List of pages corresponding to bottom navigation items
  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages.addAll([
      HomeScreen(token: widget.token),
      SpeakerDetailsScreen(),
      ReportForm(token: widget.token),
      ViewReports(),
    ]);
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[50],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.red[400],
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home, color: Colors.white),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.messenger_outline_rounded),
            activeIcon: Icon(Icons.messenger, color: Colors.white),
            label: 'Community',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.warning_amber),
            activeIcon: Icon(Icons.warning, color: Colors.white),
            label: 'Report',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            activeIcon: Icon(Icons.person, color: Colors.white),
            label: 'My Reports',
          ),
        ],
      ),
      appBar: AppBar(
        backgroundColor: Colors.red[400],
        elevation: 0.5,
        toolbarHeight: 90,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Welcome",
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    SelectableText(
                      widget.token,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: widget.token));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Token copied to clipboard!')),
                        );
                      },
                      color: Colors.white,
                      iconSize: 16,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      body: _pages[_currentIndex],
    );
  }
}

// Placeholder HomeScreen to avoid errors, replace with actual implementation
class HomeScreen extends StatelessWidget {
  final String token;
  const HomeScreen({Key? key, required this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          _buildSection(),
          Divider(color: Colors.red),
          _buildSection(),
          Divider(color: Colors.red),
          _buildSection(),
          Divider(color: Colors.red),
          _buildSection(),
          Divider(color: Colors.red),
          _buildSection(),
        ],
      ),
    );
  }

  Widget _buildSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 150,
            height: 150,
            color: Colors.red, // Placeholder for Image
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    "Blog Title",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                ),
                SizedBox(height: 10,),
                Text(
                  "This is a sample paragraph that describes the content in this section. It provides some textual information and can span multiple lines to ensure proper readability and structure in the layout.",
                  style: TextStyle(color: Colors.black, fontSize: 14),
                  softWrap: true, // Ensures text wraps properly
                  overflow: TextOverflow.visible, // Ensures text isn't clipped
                )
              ]
            ),
          ),
        ],
      ),
    );
  }
}
