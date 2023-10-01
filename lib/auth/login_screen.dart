import 'package:cam_tube/auth/otp_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final phoneNumberController = TextEditingController();

  bool loading = false;
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 142, 33, 243),
              Color.fromARGB(255, 76, 130, 175)
            ], // Define your gradient colors
            begin: Alignment.topLeft, // Define the gradient's starting point
            end: Alignment.bottomRight, // Define the gradient's ending point
          ),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
              child: TextFormField(
                  controller: phoneNumberController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                      hintText: "+91 Enter Mobile Number",
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
                onPressed: () {
                  setState(() {
                    loading = true;
                  });

                  auth.verifyPhoneNumber(
                      phoneNumber: phoneNumberController.text.toString(),
                      verificationCompleted: (_) {
                        setState(() {
                          loading = false;
                        });
                      },
                      verificationFailed: (e) {
                        print("Verification Failed"+e.toString());
                      },
                      codeSent: (String verificationID, int? token) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OtpScreen(
                                      verificationID: verificationID,
                                      token: token,
                                    )));
                        setState(() {
                          loading = false;
                        });
                      },
                      codeAutoRetrievalTimeout: (e) {
                        print("Timeouuuut"+e.toString());
                      });
                },
                child: loading == true
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text("Get OTP"))
          ],
        ),
      ),
    );
  }
}
