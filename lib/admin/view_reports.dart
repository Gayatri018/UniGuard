import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uniguard/admin/report_details.dart';
// import 'package:uniguard/screens/report_page.dart';
import 'package:uniguard/admin/community.dart';
import 'package:uniguard/admin/resolved.dart';

class ViewReports extends StatefulWidget {
  @override
  State<ViewReports> createState() => _ViewReportsState();
}

class _ViewReportsState extends State<ViewReports> {

  int _currentIndex = 0;

  // List of pages corresponding to bottom navigation items
  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages.addAll([
      Reports(),
      Resolved(),
      AddSpeakerForm(),
    ]);
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Panel"),
        foregroundColor: Colors.white,
        backgroundColor: Color(0xFF8D0E02),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF8D0E02),
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home, color: Colors.white),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check),
            activeIcon: Icon(Icons.check_circle, color: Colors.white),
            label: 'Resolved Reports',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.messenger_outline_rounded),
            activeIcon: Icon(Icons.messenger, color: Colors.white),
            label: 'Community',
          ),
        ],
      ),
      body: _pages[_currentIndex],
    );
  }
}

// class Reports extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//      return Column(
//        children: [
//          Card(
//            margin: EdgeInsets.all(20),
//            color: Colors.grey[300],
//            elevation: 3,
//            child: Padding(
//              padding: const EdgeInsets.all(20.0),
//              child: Text(
//                "Admins can review the details, update the status, and use Google Maps to locate the spot.",
//                style: TextStyle(fontSize: 16),
//              ),
//            ),
//          ),
//          Expanded(
//            child: StreamBuilder<QuerySnapshot>(
//             stream: FirebaseFirestore.instance.collection('reports').snapshots(),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return Center(child: CircularProgressIndicator());
//               }
//               if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                 return Center(child: Text("No reports found."));
//               }
//
//               var reports = snapshot.data!.docs;
//
//               return ListView.builder(
//                 padding: EdgeInsets.all(10),
//                 itemCount: reports.length,
//                 itemBuilder: (context, index) {
//                   var report = reports[index].data() as Map<String, dynamic>;
//
//                   return Column(
//                     children: [
//                       ListTile(
//                         title: Text(report['title']),
//                         subtitle: Text("Status: ${report['status']}"),
//                         trailing: Icon(Icons.arrow_forward),
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => ReportDetails(
//                                 reportId: reports[index].id,
//                                 reportData: report,
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                       Divider(color: Color(0xFF8D0E02), thickness: 0.5,)
//                     ],
//                   );
//                 },
//               );
//             },
//                ),
//          ),
//        ],
//      );
//   }
//
// }

class Reports extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          margin: EdgeInsets.all(20),
          color: Colors.grey[300],
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              "Admins can review the details, update the status, and use Google Maps to locate the spot.",
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('reports').where('status', isEqualTo: 'pending').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text("No reports found."));
              }

              // 🔹 Categorizing reports by priority
              List<QueryDocumentSnapshot> lowPriority = [];
              List<QueryDocumentSnapshot> mediumPriority = [];
              List<QueryDocumentSnapshot> highPriority = [];

              for (var doc in snapshot.data!.docs) {
                var report = doc.data() as Map<String, dynamic>;
                switch (report['priority']) {
                  case 'low':
                    lowPriority.add(doc);
                    break;
                  case 'medium':
                    mediumPriority.add(doc);
                    break;
                  case 'high':
                    highPriority.add(doc);
                    break;
                  default:
                    break;
                }
              }

              return ListView(
                padding: EdgeInsets.all(20),
                children: [
                  Text("Pending Reports", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 20,),
                  if (highPriority.isNotEmpty) _buildPrioritySection("🔴 High Priority", highPriority, context),
                  if (mediumPriority.isNotEmpty) _buildPrioritySection("🟠 Medium Priority", mediumPriority, context),
                  if (lowPriority.isNotEmpty) _buildPrioritySection("🟢 Low Priority", lowPriority, context),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  /// Builds a section for each priority level
  Widget _buildPrioritySection(String title, List<QueryDocumentSnapshot> reports, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 15),
        Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        ...reports.map((reportDoc) {
          var report = reportDoc.data() as Map<String, dynamic>;
          return Column(
            children: [
              ListTile(
                title: Text(report['title']),
                subtitle: Text("Status: ${report['status']}"),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReportDetails(
                        reportId: reportDoc.id,
                        reportData: report,
                      ),
                    ),
                  );
                },
              ),
              Divider(color: Color(0xFF8D0E02), thickness: 0.5),
            ],
          );
        }).toList(),
      ],
    );
  }
}
