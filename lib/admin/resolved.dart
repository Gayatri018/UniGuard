import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../screens/report_details.dart';

class Resolved extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Text(
              "Resolved Reports",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('reports')
                  .where('status', isEqualTo: 'resolved')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text("No resolved reports found."));
                }
            
                return ListView(
                  padding: EdgeInsets.all(20),
                  children: snapshot.data!.docs.map((doc) => _buildReportItem(doc, context)).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Builds each report item
  Widget _buildReportItem(QueryDocumentSnapshot doc, BuildContext context) {
    var report = doc.data() as Map<String, dynamic>;
    return Column(
      children: [
        ListTile(
          title: Text(report['title']),
          subtitle: Text("Status: ${report['status']}"),
          trailing: Icon(Icons.arrow_forward),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReportDetails(reportId: doc.id, reportData: report),
            ),
          ),
        ),
        Divider(color: Color(0xFF8D0E02), thickness: 0.5),
      ],
    );
  }
}
