import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:uniguard/admin/report_details.dart';

class ViewReports extends StatefulWidget {
  @override
  _ViewReportsState createState() => _ViewReportsState();
}

class _ViewReportsState extends State<ViewReports> {
  String? userToken;

  @override
  void initState() {
    super.initState();
    _loadUserToken();
  }

  Future<void> _loadUserToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userToken = prefs.getString('user_token') ?? 'No token found';
    });
  }

  void _copyToClipboard() {
    if (userToken != null) {
      Clipboard.setData(ClipboardData(text: userToken!));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Token copied to clipboard")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Reports"), centerTitle: true),
      body: Column(
        children: [
          SizedBox(height: 20),
          CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage('assets/profile_icon.png'), // Ensure this image exists in assets folder
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                userToken ?? "Loading token...",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 10),
              IconButton(
                icon: Icon(Icons.copy),
                onPressed: _copyToClipboard,
              ),
            ],
          ),
          SizedBox(height: 20),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('reports').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text("No reports found."));
                }

                var reports = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: reports.length,
                  itemBuilder: (context, index) {
                    var report = reports[index].data() as Map<String, dynamic>;

                    return ListTile(
                      title: Text(report['title']),
                      subtitle: Text("Status: ${report['status']}"),
                      trailing: Icon(Icons.arrow_forward),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReportDetails(
                              reportId: reports[index].id,
                              reportData: report,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
