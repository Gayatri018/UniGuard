import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uniguard/screens/report_page.dart';
import 'package:uniguard/admin/community.dart';

import '../admin/report_details.dart';
import '../admin/view_reports.dart';
import 'my_community.dart';

class LandingPage extends StatefulWidget {
  final String token;

  LandingPage({required this.token});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.red[100],
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.messenger),
            icon: Icon(Icons.messenger_outline_rounded),
            label: 'Community',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.warning),
            icon:  Icon(Icons.warning_amber),
            label: 'Report',
          ),
          NavigationDestination(
              selectedIcon: Icon(Icons.person),
              icon: Icon(Icons.person_outlined),
              label: 'My Reports'
          ),
        ],
      ),
      appBar: AppBar(title: Text('Landing Page')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Your Unique Token:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            SelectableText(
              widget.token,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Clipboard.setData(
                    ClipboardData(text: widget.token)); // Copy to clipboard
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Token copied to clipboard!')),
                );
              },
              child: Text('Copy to Clipboard'),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ReportForm(token: widget.token)),
                  );
                },
                child: Text('Report')),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ViewReports()),
                  );
                },
                child: Text('myreports')),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SpeakerDetailsScreen()),
                  );
                },
                child: Text('community')),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ViewReports()),
                  );
                },
                child: Text('View')),
          ],
        ),
      ),
    );
  }
}
