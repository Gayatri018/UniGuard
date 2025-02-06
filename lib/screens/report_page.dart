import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gm;
import 'package:uniguard/services/database_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReportForm extends StatefulWidget {

  final String token;

  ReportForm({super.key, required this.token});

  @override
  _ReportFormState createState() => _ReportFormState();

}

class _ReportFormState extends State<ReportForm> {



  final _dbservice = Database();
  gm.LatLng? selectedLocation;
  final GlobalKey<FormState> _FormGlobalKey = GlobalKey<FormState>();
  final TextEditingController _title = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _landmark = TextEditingController();
  final TextEditingController _priority = TextEditingController();
  final TextEditingController _cords = TextEditingController();

  void _onMapTapped(gm.LatLng position) {
    setState(() {
      selectedLocation = position;
    });
  }


  // location pending

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Report Form"), centerTitle: true),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Form(
              key: _FormGlobalKey,
              child: Column(
                children: [
                  TextField(
                    controller: _title,
                    decoration: const InputDecoration(
                        label: Text("Report Title"),
                        border: OutlineInputBorder()),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _description,
                    decoration: const InputDecoration(
                        label: Text("Report Description"),
                        border: OutlineInputBorder()),
                  ),
                  SizedBox(height: 20),
                  gm.GoogleMap(
                    initialCameraPosition: const gm.CameraPosition(
                      target: gm.LatLng(28.7041, 77.1025), // Default to New Delhi
                      zoom: 12,
                    ),
                    onTap: _onMapTapped,
                    markers: selectedLocation != null
                        ? {gm.Marker(markerId: const gm.MarkerId("selected"), position: selectedLocation!)}
                        : {},
                  ),
                  TextField(
                    controller: _landmark,
                    decoration: const InputDecoration(
                        label: Text("Landmark"), border: OutlineInputBorder()),
                  ),
                  SizedBox(height: 20),

                  FilledButton(onPressed: () {
                    final report = Report(unique_token: widget.token, title: _title.text, description: _description.text, landmark: _landmark.text, priority: _priority.text, cords: _cords.text);
                    _dbservice.report_submit(report);
                  },
                      child: Text("Submit")),
                ],
              )),
        ));
  }
}

class Report {

  final String unique_token;
  final String title;
  final String description;
  final String landmark;
  final String priority;
  final String cords;

  Report({required this.unique_token, required this.title, required this.description, required this.landmark, required this.priority, required this.cords});

  Map<String, dynamic> ReportToMap() => {
    "unique_token": unique_token,
    "title": title,
    "description": description,
    "landmark": landmark,
    "priority": priority,
    "cords": cords
  };
}


