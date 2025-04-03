import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../screens/report_details.dart';

class DiscardedReports extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Discarded Reports")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('reports')
            .where('status', isEqualTo: 'discarded') // 🔹 Fetch only discarded reports
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No discarded reports found."));
          }

          return ListView(
            padding: EdgeInsets.all(20),
            children: snapshot.data!.docs.map((doc) => _buildReportItem(doc, context)).toList(),
          );
        },
      ),
    );
  }

  /// Builds each discarded report item
  Widget _buildReportItem(QueryDocumentSnapshot doc, BuildContext context) {
    var report = doc.data() as Map<String, dynamic>;
    return Column(
      children: [
        ListTile(
          title: Text(report['title']),
          subtitle: Text("Reason: ${report['discard_reason'] ?? 'No reason provided'}"),
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
