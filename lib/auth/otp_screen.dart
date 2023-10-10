
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import 'Components/otpTextField.dart';

class OtpScreen extends StatefulWidget {
  final otpController = TextEditingController();
  final auth = FirebaseAuth.instance;
  bool loading = false;
  bool otpIsValid = true;
  void verifyphone;
  String verificationID;
  int? token;
  OtpScreen(
      {super.key,
      required this.verificationID,
      required this.token,
      required this.verifyphone});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {


// Create a Firestore collection for the user
  Future<void> createFirestoreCollectionForUser() async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final CollectionReference userVideosCollection =
          FirebaseFirestore.instance.collection('users/${user.uid}/videos');
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: const BoxDecoration(gradient: gradientColor),
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
              child: otpTextField(widget: widget),
            ),
            ElevatedButton(
                onPressed: () {
                  widget.verifyphone;
                },
                child: const Text("Did not get otp, resend?")),
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
                    widget.loading = true;
                  });
                  final credential = PhoneAuthProvider.credential(
                      verificationId: widget.verificationID,
                      smsCode: widget.otpController.text);
                  try {
                    await widget.auth.signInWithCredential(credential);
                    // ignore: use_build_context_synchronously
                    Navigator.pushNamedAndRemoveUntil(
                        context, "videosScreen", (route) => false);
                  } catch (e) {
                    setState(() {
                      AwesomeSnackbarContent(
                          title: "Error",
                          message: "Verification Failed" + e.toString(),
                          contentType: ContentType.failure);

                      widget.otpIsValid = false;
                      widget.loading = false;
                    });
                  }
                  await createFirestoreCollectionForUser();
                },
                child: widget.loading == true
                    ? const CircularProgressIndicator(
                        color: Colors.grey,
                      )
                    : const Text("Get Started"))
          ],
        ),
      ),
    );
  }
}


