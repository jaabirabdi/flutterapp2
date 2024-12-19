import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Authscreen extends StatefulWidget {
  const Authscreen({super.key});

  @override
  State<Authscreen> createState() => _authScState();
}

class _authScState extends State<Authscreen> {

  final formeky= GlobalKey<FormState>();
  String username = "";
  String email ="";
  String password ="";

  bool isLoginPage = false;

  BeginAuth(){
   final isvlaid= formeky.currentState!.validate();
   FocusScope.of(context).unfocus();
   if(isvlaid) {
    formeky.currentState!.save();
    submitToFirebase(email,password,username);
   }
  }

  submitToFirebase(String email, String password, String username)async{
    final auth=FirebaseAuth.instance;

    try{
      if(isLoginPage){
        UserCredential userCredential= await auth.signInWithEmailAndPassword(email: email, password: password);

      }
      else{
      UserCredential userCredential=  await auth.createUserWithEmailAndPassword(email: email, password: password);
      print("Usercredential $userCredential");
      String uid = userCredential.user!.uid;
      print("Usercredential $uid");
      await FirebaseFirestore.instance.collection("user").doc(uid).set({
        'username': username,
        'email': email,
      });
      }
    }on FirebaseAuthException catch(error){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message??"Authentication Failed"),),);
    }

  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Form(
        key: formeky,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if(!isLoginPage)
            TextFormField(
              key: ValueKey("username"),
              validator: (value) {
                if(value==null|| value.isEmpty || value.length<4){
                  return "Enter at least 4 characters";
                }
                return null;
              },
              onSaved: (value){
                username = value!;
              },
              decoration: const InputDecoration(
                hintText: "Username",
                border:OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
              ),
            ),
            //Email textfotmfield
            SizedBox(height: 12,),
            TextFormField(
              key: ValueKey("email"),
              validator: (value) {
                if(value==null|| value.isEmpty || !value.contains("@")){
                  return "Enter valid email";
                }
                return null;
              },
              onSaved: (value){
                email = value!;
              },
              decoration: const InputDecoration(
                hintText: "Email",
                border:OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
              ),
            ),
           // password textform feild
           SizedBox(height: 12,),
            TextFormField(
              key: ValueKey("password"),
              validator: (value) {
                if(value==null|| value.isEmpty || value.length<6){
                  return "Enter valid password";
                }
                return null;
              },
              onSaved: (value){
                password = value!;
              },
              decoration: const InputDecoration(
                hintText: "Password",
                border:OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
              ),
            ), 
            SizedBox(
              height: 16,
            ),
             SizedBox(
              height: 46,
              width: double.infinity,
               child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent,
                    foregroundColor: Colors.white70),
                      
                onPressed: BeginAuth,
                child: isLoginPage?Text("Login"):Text("Singup"),
            ),
             ),
             SizedBox(height: 12,),
             TextButton(onPressed: (){
              setState(() {
                isLoginPage = !isLoginPage;
              });
             }, child:isLoginPage?Text("Not a member? ")
             : Text("Already a member"),
             )
          ],
          ),
        ),
      ),
    );
  }
}