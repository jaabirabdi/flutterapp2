import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Modify extends StatefulWidget {
  const Modify({
    Key? key,
    this.userName,
    this.courseName,
    this.location,
    required this.docToEdit,
  }) : super(key: key);

  final String? userName;
  final String? courseName;
  final String? location;
  final String docToEdit;

  @override
  _ModifyState createState() => _ModifyState();
}

class _ModifyState extends State<Modify> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _courseController;
  late TextEditingController _locationController;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.userName ?? "");
    _courseController = TextEditingController(text: widget.courseName ?? "");
    _locationController = TextEditingController(text: widget.location ?? "");
  }

  @override
  void dispose() {
    _nameController.dispose();
    _courseController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  updateLanguageApplications() async {
    if (_nameController.text.isEmpty ||
        _courseController.text.isEmpty ||
        _locationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("All fields are required")),
      );
      return;
    }

    if (widget.docToEdit.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Document to edit is not specified")),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('LanguageApplications')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('mylanguage')
          .doc(widget.docToEdit)
          .update({
        'userName': _nameController.text,
        'courseName': _courseController.text,
        'location': _locationController.text,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Successfully edited")),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating application: $e")),
      );
    }
  }

  deleteLanguageApplication() async {
    if (widget.docToEdit.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Document to delete is not specified")),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('LanguageApplications')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('mylanguage')
          .doc(widget.docToEdit)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Successfully deleted")),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error deleting application: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Modify Your Apply"),
        backgroundColor: const Color.fromARGB(255, 255, 0, 183),
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
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Your Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _courseController,
                decoration: InputDecoration(labelText: 'Course Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the course name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(labelText: 'Location'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your location';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: updateLanguageApplications,
                child: Text("Update"),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: deleteLanguageApplication,
                child: Text("Delete"),
                style: ElevatedButton.styleFrom(iconColor: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}