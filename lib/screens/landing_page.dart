import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:uniguard/chatbot/chatbot.dart';
import 'package:uniguard/screens/read_blog.dart';
import 'package:uniguard/screens/report_page.dart';
// import 'package:uniguard/admin/community.dart';
// import '../admin/report_details.dart';
import 'package:uniguard/screens/my_reports.dart';
// import 'package:uniguard/screens/signup_page.dart';
import 'package:uniguard/utils/token_manager.dart';
import 'login_page.dart';
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

  void _logout(BuildContext context) async {
    bool? confirmLogout = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text("Logout", style: TextStyle(color: Color(0xFF8D0E02)),),
          content: const Text("Are you sure you want to logout?", style: TextStyle(color: Color(0xFF8D0E02)),),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false), // Cancel
              child: const Text("Cancel", style: TextStyle(color: Color(0xFF8D0E02)),),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true), // Confirm
              child: const Text("Logout", style: TextStyle(color: Color(0xFF8D0E02)),),
            ),
          ],
        );
      },
    );

    if (confirmLogout == true) {
      await TokenManager.clearToken();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginPage()), // replace with actual LoginPage widget
            (Route<dynamic> route) => false,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logged out successfully!')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFBF4F4),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF8D0E02),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF8D0E02),
        child: Icon(Icons.chat, color: Colors.white,),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Chatbot(),
            ),
          );
        },
      ),
      appBar: AppBar(
        backgroundColor: Color(0xFF8D0E02),
        elevation: 0.5,
        toolbarHeight: 90,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
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
                        widget.token.length > 20 // Limit length before truncating
                            ? "${widget.token.substring(0, 20)}..." // Show first 10 chars + "..."
                            : widget.token, // Show full token if it's short,
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
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                _logout(context); // Call your logout function
              },
              color: Colors.white,
              iconSize: 30,
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
  HomeScreen({Key? key, required this.token}) : super(key: key);

  final List<Map<String, String>> blogs = [
    {
      'image': 'assets/images/Blog1.png', // Replace with real image
      'title': 'Understanding Depression',
      'content': 'Depression is more than just feeling sad. It’s a condition that affects...',
      'full_content': 'Depression is a mental health disorder that involves a persistent feeling of sadness and loss of interest. It affects how one feels, thinks, and handles daily activities... It can also lead to various physical symptoms like insomnia, fatigue, and more.',
    },
    {
      'image': 'assets/images/Blog2.png', // Replace with real image
      'title': 'The Impact of Anxiety Disorders',
      'content': 'Anxiety disorders are the most common mental health disorders. These affect millions of people...',
      'full_content': 'Anxiety disorders include generalized anxiety disorder, panic disorder, and social anxiety disorder. They are characterized by feelings of excessive fear or worry that interfere with daily life. These disorders can cause physical symptoms like increased heart rate, sweating, and shaking...',
    },
    {
      'image': 'assets/images/Blog3.png', // Replace with real image
      'title': 'The Dangers of Drug Abuse',
      'content': 'Drug abuse is a serious issue affecting millions worldwide. It has devastating impacts on the body and mind...',
      'full_content': 'Drug abuse refers to the habitual use of illegal substances or the misuse of prescription medications. It can lead to addiction, health problems, legal issues, and affect relationships. The physical effects may include liver damage, heart disease, and neurological problems...',
    },
    {
      'image': 'assets/images/Blog4.png', // Replace with real image
      'title': 'Mental Health Stigma and Its Consequences',
      'content': 'Mental health stigma prevents individuals from seeking the help they need...',
      'full_content': 'Mental health stigma is the negative perception or discrimination associated with mental health disorders. This stigma often prevents individuals from seeking help, leading to untreated conditions and worsening symptoms. Stigma can also affect employment, relationships, and social interactions...',
    },
  ];


  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: blogs.length,
      itemBuilder: (context, index) {
        final blog = blogs[index];
        return Card(
          margin: EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(width: double.infinity, height: 180,child: Image.asset(blog['image']!, width: 80, height: 80, fit: BoxFit.cover),),
              ListTile(
                title: Text(blog['title']!),
                subtitle: Text(blog['content']!),
                trailing: TextButton(
                  onPressed: () {
                    // Navigate to ReadBlogPage
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReadBlogPage(blog: blog),
                      ),
                    );
                  },
                  child: Text('Read More', style: TextStyle(color: Color(0xFF8D0E02)),),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Widget _buildSection() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 16.0),
  //     child: Row(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Container(
  //           width: 150,
  //           height: 150,
  //           color: Color(0xFF8D0E02), // Placeholder for Image
  //         ),
  //         const SizedBox(width: 16),
  //         Expanded(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                   "Blog Title",
  //                   style: TextStyle(
  //                     fontSize: 18,
  //                     fontWeight: FontWeight.bold,
  //                     color: Color(0xFF8D0E02),
  //                   ),
  //               ),
  //               SizedBox(height: 10,),
  //               Text(
  //                 "This is a sample paragraph that describes the content in this section. It provides some textual information and can span multiple lines to ensure proper readability and structure in the layout.",
  //                 style: TextStyle(color: Colors.black, fontSize: 14),
  //                 softWrap: true, // Ensures text wraps properly
  //                 overflow: TextOverflow.visible, // Ensures text isn't clipped
  //               )
  //             ]
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
