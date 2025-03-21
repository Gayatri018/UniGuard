import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:firebase_storage/firebase_storage.dart";
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddSpeakerForm extends StatefulWidget {

  // final String token;
  //
  // AddSpeakerForm({required this.token});

  @override
  _AddSpeakerFormState createState() => _AddSpeakerFormState();
}

class _AddSpeakerFormState extends State<AddSpeakerForm> {
  final _formKey = GlobalKey<FormState>();

  String name = '';
  String designation = '';
  String experience = '';
  String about = '';
  String link = '';
  File? _image;
  String? imageUrl;

  final picker = ImagePicker();

  // Pick Image from Gallery
  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Upload Image to Firebase Storage
  Future<String?> uploadImage() async {
    if (_image == null) return null;
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref = FirebaseStorage.instance.ref().child('speaker_images/$fileName.jpg');
      await ref.putFile(_image!);
      return await ref.getDownloadURL();
    } catch (e) {
      // print("Error uploading image: $e");
      return null;
    }
  }

  // Submit Form Data to Firestore
  Future<void> submitData() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    try {
      String? uploadedImageUrl = await uploadImage();
      await FirebaseFirestore.instance.collection('community_names').add({
        'name': name,
        'designation': designation,
        'experience': experience,
        'about': about,
        'link': link,
        'imageUrl': uploadedImageUrl ?? '',
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Speaker added successfully!')),
      );

      _formKey.currentState!.reset();
      setState(() {
        _image = null;
      });

    } catch (e) {
      // print("Error adding speaker: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding speaker')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                GestureDetector(
                  onTap: pickImage,
                  child: _image == null
                      ? Container(
                          height: 150,
                          width: 150,
                          color: Colors.grey[300],
                          child: Icon(Icons.camera_alt, size: 50),
                        )
                      : Image.file(_image!, height: 150, width: 150, fit: BoxFit.cover),
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: "Name",
                      floatingLabelStyle: TextStyle(
                        color: Color(0xFF8D0E02),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF8D0E02))
                    ),
                  ),
                  validator: (value) => value!.isEmpty ? "Enter speaker name" : null,
                  onSaved: (value) => name = value!,
                ),
                SizedBox(height: 20,),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: "Designation",
                    floatingLabelStyle: TextStyle(
                      color: Color(0xFF8D0E02),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF8D0E02))
                    ),
                  ),
                  validator: (value) => value!.isEmpty ? "Enter designation" : null,
                  onSaved: (value) => designation = value!,
                ),
                SizedBox(height: 20,),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: "Experience (years)",
                    floatingLabelStyle: TextStyle(
                      color: Color(0xFF8D0E02),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF8D0E02))
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? "Enter experience" : null,
                  onSaved: (value) => experience = value!,
                ),
                SizedBox(height: 20,),
                TextFormField(
                  decoration: InputDecoration(
                      floatingLabelStyle: TextStyle(
                        color: Color(0xFF8D0E02),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF8D0E02))
                      ),
                      labelText: "About Speaker"
                  ),
                  maxLines: 3,
                  validator: (value) => value!.isEmpty ? "Enter details" : null,
                  onSaved: (value) => about = value!,
                ),
                SizedBox(height: 20,),
                TextFormField(
                  decoration: InputDecoration(
                      floatingLabelStyle: TextStyle(
                        color: Color(0xFF8D0E02),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF8D0E02))
                      ),
                      labelText: "Google Meet Link"),
                  validator: (value) => value!.isEmpty ? "Enter Google Meet Link" : null,
                  onSaved: (value) => link = value!,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: submitData,
                  child: Text("Add Speaker"),

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF8D0E02),
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
