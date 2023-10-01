import 'dart:ffi';

import 'package:cam_tube/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OtpScreen extends StatefulWidget {
  String verificationID;
  int? token;
  OtpScreen({super.key, required this.verificationID, required this.token});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {





// ...

// Create a Firestore collection for the user
Future<void> createFirestoreCollectionForUser() async {
  final User? user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    final CollectionReference userVideosCollection =
        FirebaseFirestore.instance.collection('users/${user.uid}/videos');
    // You can also set up security rules in Firebase to ensure privacy of data.
  }
}




  final otpController = TextEditingController();
  final auth = FirebaseAuth.instance;
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 142, 33, 243),
              Color.fromARGB(255, 76, 130, 175)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Center(
                child: Text(
              "Enter OTP Number",
              style: TextStyle(fontSize: 30, color: Colors.white),
            )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
              child: TextFormField(
                controller: otpController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                      hintText: "Enter OTP Number",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(10),
                              right: Radius.circular(10)),
                          borderSide:
                              BorderSide(color: Colors.white, width: 1)))),
            ),
            ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          10.0), // Adjust the radius as needed
                    ),
                  ),
                ),
                onPressed: () async {
                  setState(() {
                    loading = true;
                  });
                  final credential = PhoneAuthProvider.credential(
                      verificationId: widget.verificationID,
                      smsCode: otpController.text);
                  try {
                    await auth.signInWithCredential(credential);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyApp()));
                  } catch (e) {
                    loading = false;
                    print(e.toString());
                  }
                  await createFirestoreCollectionForUser();
                },
                child: loading == true ? const CircularProgressIndicator(color: Colors.white,): const Text("Login"))
          ],
        ),
      ),
    );
  }
}
