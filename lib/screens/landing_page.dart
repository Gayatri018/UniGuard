import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uniguard/chatbot/chatbot.dart';
import 'package:uniguard/screens/read_blog.dart';
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
