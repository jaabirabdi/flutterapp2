import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ApplyLanguageScreen extends StatefulWidget {
  const ApplyLanguageScreen({Key? key}) : super(key: key);

  @override
  _ApplyLanguageScreenState createState() => _ApplyLanguageScreenState();
}

class _ApplyLanguageScreenState extends State<ApplyLanguageScreen> {
  final _formKey = GlobalKey<FormState>();

  String _userName = '';
  String _courseName = '';
  String _location = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Apply for Language'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Your Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _userName = value;
                  });
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(labelText: 'Course Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the course name';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _courseName = value;
                  });
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(labelText: 'Location'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your location';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _location = value;
                  });
                },
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Apply'),
              ),
       
            ],
          ),
        ),
      ),
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Save data to Firestore
      try {
        await FirebaseFirestore.instance.collection('LanguageApplications').doc(FirebaseAuth.instance.currentUser!.uid).collection('mylanguage').add(
      
         {
           'userName': _userName,
          'courseName': _courseName,
          'location': _location,
          'timestamp': Timestamp.now(),
         }
     

        );

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Application submitted successfully')),
        );

        // Clear form fields
        setState(() {
          _userName = '';
          _courseName = '';
          _location = '';
        });
      } catch (e) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit application: $e')),
        );
      }
    }
  }
}
