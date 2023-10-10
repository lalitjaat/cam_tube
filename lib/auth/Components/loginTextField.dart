
import 'package:flutter/material.dart';

class loginTextField extends StatelessWidget {
  const loginTextField({
    super.key,
    required this.phoneNumberController,
    required this.Error,
  });

  final TextEditingController phoneNumberController;
  final bool Error;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      child: TextFormField(
          controller: phoneNumberController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              errorText:
                  Error == true ? "Check Your Phone Number" : null,
              hintText: "+91 Enter Mobile Number",
              filled: true,
              fillColor: Colors.white,
              border: const OutlineInputBorder(
                  borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(10),
                      right: Radius.circular(10)),
                  borderSide:
                      BorderSide(color: Colors.white, width: 1)))),
    );
  }
}
