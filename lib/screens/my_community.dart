import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SpeakerDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
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

                // Handle missing data safely
                var imageUrl = speaker['imageUrl'] ?? '';
                var name = speaker['name'] ?? 'Unknown Speaker';
                var designation = speaker['designation'] ?? 'No designation';
                var experience = speaker['experience'] ?? '0';
                var about = speaker['about'] ?? 'No details available';
                var link = speaker['link'] ?? '';

                return Card(
                  color: Color(0xFF8D0E02),
                  margin: EdgeInsets.all(10),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          imageUrl.isNotEmpty
                              ? Image.network(imageUrl, height: 150, width: double.infinity, fit: BoxFit.cover)
                              : SizedBox(height: 150, child: Center(child: Icon(Icons.image, size: 50, color: Colors.white,))),
                          SizedBox(height: 10),
                          Text(name.toUpperCase(), style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                          Text(designation, style: TextStyle(fontSize: 16, color: Colors.grey[400])),
                          SizedBox(height: 5),
                          Text("Experience: $experience years", style: TextStyle(color: Colors.white),),
                          SizedBox(height: 5),
                          Text(about, style: TextStyle(color: Colors.white),),
                          SizedBox(height: 10),
                          if (link.isNotEmpty)
                            GestureDetector(
                              onTap: () async {
                                final url = Uri.parse(link);
                                if (await canLaunchUrl(url)) {
                                  await launchUrl(url, mode: LaunchMode.externalApplication);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Could not open link")),
                                  );
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Text("Join the Meeting", style: TextStyle(color: Color(0xFF8D0E02), fontWeight: FontWeight.bold)),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
