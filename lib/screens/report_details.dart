// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gm;

class ReportDetails extends StatefulWidget {
  final String reportId;
  final Map<String, dynamic> reportData;

  ReportDetails({required this.reportId, required this.reportData});

  @override
  _ReportDetailsState createState() => _ReportDetailsState();
}

class _ReportDetailsState extends State<ReportDetails> {
  late String _status;
  late gm.LatLng _reportLocation;

  @override
  void initState() {
    super.initState();
    _status = widget.reportData['status'];
    _reportLocation = gm.LatLng(
      widget.reportData['cords']['latitude'],
      widget.reportData['cords']['longitude'],
    );
  }

  // void _updateStatus(String newStatus) async {
  //   await FirebaseFirestore.instance.collection('reports').doc(widget.reportId).update({
  //     'status': newStatus,
  //     'updated_time': FieldValue.serverTimestamp(),
  //   });
  //
  //   setState(() {
  //     _status = newStatus;
  //   });
  //
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text("Status updated successfully")),
  //   );
  // }
  //
  // void _navigateToLocation() {
  //   // Open Google Maps with the location
  //   final String googleMapsUrl =
  //       "https://www.google.com/maps/search/?api=1&query=${_reportLocation.latitude},${_reportLocation.longitude}";
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Report Details"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Title: ${widget.reportData['title']}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("Description: ${widget.reportData['description']}"),
            SizedBox(height: 10),
            Text("Landmark: ${widget.reportData['landmark']}"),
            SizedBox(height: 10),
            Text("Priority: ${widget.reportData['priority']}"),
            SizedBox(height: 10),
            Text("Status: $_status", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Container(
              height: 300,
              child: gm.GoogleMap(
                initialCameraPosition: gm.CameraPosition(target: _reportLocation, zoom: 14),
                markers: {
                  gm.Marker(markerId: gm.MarkerId("reportLocation"), position: _reportLocation),
                },
              ),
            ),
            // SizedBox(height: 10),
            // ElevatedButton(
            //   onPressed: _navigateToLocation,
            //   child: Text("Navigate to Location"),
            // ),
            // SizedBox(height: 10),
            // DropdownButton<String>(
            //   value: _status,
            //   items: ["pending", "resolved"].map((String status) {
            //     return DropdownMenuItem<String>(
            //       value: status,
            //       child: Text(status.toUpperCase()),
            //     );
            //   }).toList(),
            //   onChanged: (String? newValue) {
            //     if (newValue != null) {
            //       _updateStatus(newValue);
            //     }
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
