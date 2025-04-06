import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uniguard/admin/report_details.dart';
import 'package:uniguard/admin/community.dart';
import 'package:uniguard/admin/resolved.dart';
import 'admin_login.dart';
import 'discarded_reports.dart';

class ViewReports extends StatefulWidget {
  @override
  State<ViewReports> createState() => _ViewReportsState();
  final String adminEmail;
  const ViewReports({Key? key, required this.adminEmail}) : super(key: key);
}

class _ViewReportsState extends State<ViewReports> {
  int _currentIndex = 0;

  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages.addAll([
      Reports(),
      Resolved(),
      AddSpeakerForm(),
      DiscardedReports(),
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
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            tooltip: "Logout",
            onPressed: () async {
              // Firebase sign out
              await FirebaseAuth.instance.signOut();
              // Navigate back to admin login
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => AdminLoginPage()),
                    (route) => false,
              );
            },
          )
        ],
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
          BottomNavigationBarItem(
            icon: Icon(Icons.delete_outline),
            activeIcon: Icon(Icons.delete, color: Colors.white),
            label: 'Discarded Reports',
          ),
        ],
      ),
      body: _pages[_currentIndex],
    );
  }
}

class Reports extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Summary Card for Report Counts
        FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance.collection('reports').where('status', isEqualTo: 'discarded').get(),
          builder: (context, discardedSnapshot) {
            if (discardedSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            int discardedCount = discardedSnapshot.data?.docs.length ?? 0;

            return FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance.collection('reports').where('status', isEqualTo: 'resolved').get(),
              builder: (context, resolvedSnapshot) {
                if (resolvedSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                int resolvedCount = resolvedSnapshot.data?.docs.length ?? 0;

                return StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('reports').where('status', isEqualTo: 'pending').snapshots(),
                  builder: (context, pendingSnapshot) {
                    if (pendingSnapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    int highPriorityCount = 0;
                    int mediumPriorityCount = 0;
                    int lowPriorityCount = 0;

                    for (var doc in pendingSnapshot.data!.docs) {
                      var report = doc.data() as Map<String, dynamic>;
                      switch (report['priority']) {
                        case 'high':
                          highPriorityCount++;
                          break;
                        case 'medium':
                          mediumPriorityCount++;
                          break;
                        case 'low':
                          lowPriorityCount++;
                          break;
                        default:
                          break;
                      }
                    }

                    return Card(
                      margin: EdgeInsets.all(15),
                      color: Colors.white,
                      elevation: 3,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            Text(
                              "Admins can review the details, update the status, and use Google Maps to locate the spot.",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildSummaryTile("🔴 High", highPriorityCount),
                                _buildSummaryTile("🟠 Medium", mediumPriorityCount),
                                _buildSummaryTile("🟢 Low", lowPriorityCount),
                              ],
                            ),
                            SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildSummaryTile("✅ Resolved", resolvedCount),
                                _buildSummaryTile("🗑️ Discarded", discardedCount),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
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
                  SizedBox(height: 20),
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

  /// Builds a summary tile for the report count
  Widget _buildSummaryTile(String label, int count) {
    return Column(
      children: [
        Text(count.toString(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
        Text(label, style: TextStyle(fontSize: 14, color: Colors.black)),
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
          return ListTile(
            title: Text(report['title']),
            subtitle: Text("Status: ${report['status']}"),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ReportDetails(reportId: reportDoc.id, reportData: report)));
            },
          );
        }).toList(),
      ],
    );
  }
}
