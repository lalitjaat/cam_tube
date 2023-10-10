import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cam_tube/auth/otp_screen.dart';
import 'package:cam_tube/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'Components/loginTextField.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Future<void> verifyPhone() async {
    await auth.verifyPhoneNumber(
        phoneNumber: phoneNumberController.text.toString(),
        verificationCompleted: (_) {
          AwesomeSnackbarContent(
              title: "Success!!",
              message: "Verification SuccessFull ",
              contentType: ContentType.success);

          setState(() {
            loading = false;
            Error = false;
          });
        },
        verificationFailed: (e) {
          setState(() {
            loading = false;
            Error = true;
          });

          AwesomeSnackbarContent(
              title: "Error",
              message: "Verification Failed$e",
              contentType: ContentType.failure);
        },
        codeSent: (String verificationID, int? token) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OtpScreen(
                        verifyphone: verifyPhone(),
                        verificationID: verificationID,
                        token: token,
                      )));
          setState(() {
            loading = false;
          });
        },
        codeAutoRetrievalTimeout: (e) {
          setState(() {
            loading = false;
            Error = true;
          });
          AwesomeSnackbarContent(
              title: "Error",
              message: "Timeouuuut" + e.toString(),
              contentType: ContentType.warning);
        });
  }

  final phoneNumberController = TextEditingController(text: "+91");

  bool loading = false;
  bool Error = false;
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: const BoxDecoration(
          gradient: gradientColor
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Center(
                child: Text(
              "Login",
              style: TextStyle(fontSize: 30, color: Colors.white),
            )),
            loginTextField(phoneNumberController: phoneNumberController, Error: Error),
            ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          10.0), // Adjust the radius as needed
                    ),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    loading = true;
                  });
                  verifyPhone();
                },
                child: loading == true
                    ? const CircularProgressIndicator(
                        color: Colors.grey,
                      )
                    : const Text("Next"))
          ],
        ),
      ),
    );
  }
}
