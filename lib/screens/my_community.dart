import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SpeakerDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Speakers")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('community_names').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No speakers found."));
          }

          var speakers = snapshot.data!.docs;

          return ListView.builder(
            itemCount: speakers.length,
            itemBuilder: (context, index) {
              var speaker = speakers[index].data() as Map<String, dynamic>;

              return Card(
                margin: EdgeInsets.all(10),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      speaker['imageUrl'] != null && speaker['imageUrl']!.isNotEmpty
                          ? Image.network(speaker['imageUrl'], height: 150, width: double.infinity, fit: BoxFit.cover)
                          : SizedBox(height: 150, child: Center(child: Icon(Icons.image, size: 50))),
                      SizedBox(height: 10),
                      Text(speaker['name'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text(speaker['designation'], style: TextStyle(fontSize: 16, color: Colors.grey)),
                      SizedBox(height: 5),
                      Text("Experience: ${speaker['experience']} years"),
                      SizedBox(height: 5),
                      Text(speaker['about']),
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: () async {
                          final url = Uri.parse(speaker['link']);
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Could not open link")),
                            );
                          }
                        },
                        child: Text(
                          "Join Google Meet",
                          style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
