import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uniguard/screens/report_page.dart';
import 'package:uniguard/admin/community.dart';

import '../admin/report_details.dart';
import '../admin/view_reports.dart';
import 'my_community.dart';

class LandingPage extends StatelessWidget {

  final String token;

  LandingPage({required this.token});  


  @override
  Widget build(BuildContext context) {
        
    return Scaffold(
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
              token,  
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: token));  // Copy to clipboard
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Token copied to clipboard!')),
                );
              },
              child: Text('Copy to Clipboard'),
            ),
            SizedBox(height: 20,),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ReportForm(token: token)),
                  );
            }, child: Text('Report')),
            SizedBox(height: 20,),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ViewReports()),
                  );
                }, child: Text('myreports')),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SpeakerDetailsScreen()),
                  );
                }, child: Text('community')),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ViewReports()),
                  );
                }, child: Text('View')),
          ],
        ),
      ),
    );
  }
}
