import 'package:flutter/material.dart';
import 'package:uniguard/services/database_service.dart';


void main() => runApp(MaterialApp(
  home: ReportFrom(),
));

class ReportFrom extends StatefulWidget {



  @override
  _ReportFormState createState() => _ReportFormState();

}

class _ReportFormState extends State<ReportFrom> {

  final _dbservice = Database();

  final String token = '';
  final GlobalKey<FormState> _FormGlobalKey = GlobalKey<FormState>();
  final TextEditingController _title = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _landmark = TextEditingController();
  final TextEditingController _priority = TextEditingController();
  final TextEditingController _cords = TextEditingController();



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
                  TextField(
                    controller: _landmark,
                    decoration: const InputDecoration(
                        label: Text("Landmark"), border: OutlineInputBorder()),
                  ),
                  SizedBox(height: 20),

                  FilledButton(onPressed: () {
                    final report = Report(title: _title.text, description: _description.text, landmark: _landmark.text, priority: _priority.text, cords: _cords.text);
                    _dbservice.report_submit(report);
                  },
                      child: Text("Submit")),
                ],
              )),
        ));
  }
}

class Report {
  final String title;
  final String description;
  final String landmark;
  final String priority;
  final String cords;

  Report({required this.title, required this.description, required this.landmark, required this.priority, required this.cords});

  Map<String, dynamic> ReportToMap() => {
    "title": title,
    "description": description,
    "landmark": landmark,
    "priority": priority,
    "cords": cords
  };
}


