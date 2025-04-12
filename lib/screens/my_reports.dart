import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter/services.dart';
import 'package:uniguard/screens/report_details.dart';

import '../utils/token_manager.dart';

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
    String? token = await TokenManager.getToken();
    setState(() {
      userToken = token ?? 'No token found';
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Reports"), centerTitle: true, automaticallyImplyLeading: false,),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('reports').where('anonUserId', isEqualTo: userToken).snapshots(),
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
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Status: ${report['status']}"),
                            if (report['status'] == 'discarded' && report.containsKey('discard_reason'))
                              Text("Reason: ${report['discard_reason']}", style: TextStyle(color: Colors.red, fontStyle: FontStyle.italic)),
                          ],
                        ),
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
          ),
        ],
      ),
    );
  }
}
