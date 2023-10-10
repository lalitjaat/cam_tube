import 'package:flutter/cupertino.dart';

const Gradient gradientColor = LinearGradient(
            colors: [
              Color.fromARGB(131, 142, 33, 243),
              Color.fromARGB(64, 76, 130, 175)
            ], // Define your gradient colors
            begin:
                Alignment.topLeft, // Define the gradient's starting point
            end:
                Alignment.bottomRight, // Define the gradient's ending point
          );