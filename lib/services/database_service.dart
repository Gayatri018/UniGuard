import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uniguard/screens/report_page.dart';

class Database {
  final _fire = FirebaseFirestore.instance;

  report_submit(Report report) {
    try{
      _fire.collection("reports").add(report.toMap());
    }catch(e){
      log( e.toString() as num );
    }
  }
}