import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uniguard/screens/report_page.dart';

class Database {
  final FirebaseFirestore _fire = FirebaseFirestore.instance;

  /// Checks if the user has reached the daily report limit (5 reports per day)
  Future<bool> canSubmitReport(String anonUserId) async {
    try {
      DateTime now = DateTime.now();
      DateTime startOfDay = DateTime(now.year, now.month, now.day);

      // Fetch all reports by this user (No filtering by date in Firestore)
      QuerySnapshot userReports = await _fire
          .collection("reports")
          .where("anonUserId", isEqualTo: anonUserId)
          .get(); // 🔹 Removed created_time filter to avoid index error

      // Manually filter reports created today
      int todayReports = userReports.docs.where((doc) {
        Timestamp createdTime = doc["created_time"];
        DateTime reportDate = createdTime.toDate();
        return reportDate.isAfter(startOfDay); // Check if it's today
      }).length;

      return todayReports < 5; // Allow if less than 5
    } catch (e, stackTrace) {
      log("Error checking report limit: $e", error: e, stackTrace: stackTrace);
      return false; // Default to false if there's an error
    }
  }

  /// Submits a report if the user has not exceeded the limit
  Future<void> reportSubmit(Report report) async {
    try {
      bool canSubmit = await canSubmitReport(report.anonUserId);
      if (!canSubmit) {
        log("Report submission denied: Daily limit reached.");
        return;
      }

      // Proceed with submitting the report
      await _fire.collection("reports").add(report.toMap());
      log("Report submitted successfully");
    } catch (e, stackTrace) {
      log("Error submitting report: $e", error: e, stackTrace: stackTrace);
    }
  }
}
