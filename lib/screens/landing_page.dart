import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uniguard/screens/report_page.dart';

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
            }, child: Text('Report'))
          ],
        ),
      ),
    );
  }
}
