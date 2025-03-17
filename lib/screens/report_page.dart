import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gm;
import 'package:uniguard/services/database_service.dart';

class ReportForm extends StatefulWidget {
  final String token;

  ReportForm({super.key, required this.token});

  @override
  _ReportFormState createState() => _ReportFormState();
}

enum Priority { low, medium, high }

enum Status { pending, resolved }

class _ReportFormState extends State<ReportForm> {
  final _dbservice = Database();
  gm.LatLng? selectedLocation;

  final GlobalKey<FormState> _FormGlobalKey = GlobalKey<FormState>();
  final TextEditingController _title = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _landmark = TextEditingController();

  Priority _priority = Priority.low; // default value of priority is low
  Status _status = Status.pending;

  void _onMapTapped(gm.LatLng position) {
    setState(() {
      selectedLocation = position;
    });
    log(selectedLocation.toString());
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
                  TextFormField(
                    controller: _title,
                    decoration: const InputDecoration(
                        label: Text("Report Title"),
                        border: OutlineInputBorder()),
                    validator: (value) =>
                        value!.isEmpty ? "Title cannot be empty" : null,
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _description,
                    decoration: const InputDecoration(
                        label: Text("Report Description"),
                        border: OutlineInputBorder()),
                    validator: (value) =>
                        value!.isEmpty ? "Description cannot be empty" : null,
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    height: 500,
                    width: 500,
                    child: gm.GoogleMap(
                      initialCameraPosition: const gm.CameraPosition(
                        target:
                            gm.LatLng(28.7041, 77.1025), // Default to New Delhi
                        zoom: 12,
                      ),
                      onTap: _onMapTapped,
                      markers: selectedLocation != null
                          ? {
                              gm.Marker(
                                  markerId: const gm.MarkerId("selected"),
                                  position: selectedLocation!)
                            }
                          : {},
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _landmark,
                    decoration: const InputDecoration(
                        label: Text("Landmark"), border: OutlineInputBorder()),
                    validator: (value) =>
                        value!.isEmpty ? "Landmark cannot be empty" : null,
                  ),
                  SizedBox(height: 20),

                  Text("Set Priority",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),

                  // ✅ Step 2: Toggle Buttons for Priority Selection
                  ToggleButtons(
                    isSelected: [
                      _priority == Priority.low,
                      _priority == Priority.medium,
                      _priority == Priority.high,
                    ],
                    onPressed: (int index) {
                      setState(() {
                        _priority = Priority.values[index];
                        // print("Priority set to: $_priority");
                      });
                    },
                    children: [
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text("Low")),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text("Medium")),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text("High")),
                    ],
                  ),

                  SizedBox(height: 20),

                  // ✅ Step 3: Show Selected Priority
                  Text("Selected Priority: ${_priority.name.toUpperCase()}",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

                  SizedBox(height: 20),

                  FilledButton(
                      onPressed: () {
                        if (_FormGlobalKey.currentState!.validate()) {
                          if (selectedLocation == null) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    "Please select a location on the map")));
                            return;
                          }

                          final report = Report(
                              anonUserId: widget.token,
                              title: _title.text,
                              description: _description.text,
                              landmark: _landmark.text,
                              priority: _priority.name,
                              status: _status.name, // this page doesn't concern with changing of status
                              cords: {
                                "latitude": selectedLocation!.latitude,
                                "longitude": selectedLocation!.longitude
                              },
                              time: FieldValue.serverTimestamp());

                          try {
                            _dbservice.report_submit(report);

                            // Clear input fields after successful submission
                            _title.clear();
                            _description.clear();
                            _landmark.clear();
                            setState(() {
                              selectedLocation = null; // Remove map marker
                              _priority = Priority.low; // Reset priority
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Report submitted successfully! ✅")));

                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Failed to submit report ❌")));
                          }
                        }
                      },
                      child: Text("Submit")),
                ],
              )),
        ));
  }
}

class Report {
  final String anonUserId;
  final String title;
  final String description;
  final String landmark;
  final String priority;
  final Map<String, dynamic> cords;
  final FieldValue time;
  final String status;

  Report(
      {required this.anonUserId,
      required this.title,
      required this.description,
      required this.landmark,
      required this.priority,
      required this.status,
      required this.cords,
      required this.time});

  Map<String, dynamic> toMap() => {
        "anonUserId": anonUserId,
        "title": title,
        "description": description,
        "landmark": landmark,
        "priority": priority,
        "status":status,
        "cords": cords,
        "created_time": time,
      };
}
