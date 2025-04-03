import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DiscardReportPage extends StatefulWidget {
  final String reportId;

  DiscardReportPage({required this.reportId});

  @override
  _DiscardReportPageState createState() => _DiscardReportPageState();
}

class _DiscardReportPageState extends State<DiscardReportPage> {
  final List<String> _reasons = [
    "False Report",
    "Duplicate Report",
    "Insufficient Information",
    "Resolved by Other Means",
    "Not Relevant"
  ];

  String? _selectedReason;

  void _submitDiscard() {
    if (_selectedReason == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please select a reason")));
      return;
    }

    // Update Firestore with the discard reason
    FirebaseFirestore.instance.collection('reports').doc(widget.reportId).update({
      'status': 'discarded',
      'discard_reason': _selectedReason,
    }).then((_) {
      Navigator.pop(context); // Close Discard Page
      Navigator.pop(context); // Close Report Details Page
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Discard Report")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Select a reason for discarding this report:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),

            // List of Radio Buttons
            ..._reasons.map((reason) => RadioListTile<String>(
              title: Text(reason),
              value: reason,
              groupValue: _selectedReason,
              onChanged: (value) {
                setState(() => _selectedReason = value);
              },
            )),

            Spacer(),

            // Submit Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: _submitDiscard,
              child: Text("Confirm Discard"),
            ),
          ],
        ),
      ),
    );
  }
}
