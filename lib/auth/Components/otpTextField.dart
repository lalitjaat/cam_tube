
import 'package:flutter/material.dart';

import '../otp_screen.dart';

class otpTextField extends StatefulWidget {
  const otpTextField({
    super.key,
    required this.widget,
  });

  final OtpScreen widget;

  @override
  State<otpTextField> createState() => _otpTextFieldState();
}

class _otpTextFieldState extends State<otpTextField> {
  String otpValidation() {
    if (widget.widget.otpController.text.length > 6 ||
        widget.widget.otpController.text.length < 6) {
      setState(() {
        widget.widget.loading = false;
      });
      return "OTP must be 6 digits long";
    } else if (widget.widget.otpController.text.isEmpty) {
      setState(() {
        widget.widget.loading = false;
      });
      return "Please Enter OTP Number";
    } else if (widget.widget.otpIsValid == false) {
      setState(() {
        widget.widget.loading = false;
      });
      return "OTP is not Valid";
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.widget.otpController,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
          errorText: otpValidation(),
          hintText: "Enter OTP Number",
          filled: true,
          fillColor: Colors.white,
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(10), right: Radius.circular(10)),
              borderSide: BorderSide(color: Colors.white, width: 1))),
    );
  }
}
