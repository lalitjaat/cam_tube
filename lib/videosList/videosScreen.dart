import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_thumbnail/video_thumbnail.dart' as thumb;
import 'package:video_thumbnail/video_thumbnail.dart';
import '../videoForm/UploadForm.dart';
import 'Components/videoCard.dart';

class videosScreen extends StatefulWidget {
  @override
  State<videosScreen> createState() => _videosScreenState();
}

class _videosScreenState extends State<videosScreen> {
   @override
  void initState() {
    super.initState();
checkConnection();  }

  bool internetAccess = true;

Future<bool> checkInternetConnectivity() async {
  var connectivityResult = await Connectivity().checkConnectivity();
  return connectivityResult != ConnectivityResult.none;
}

Future<void> checkConnection() async {
  try {
    if (await checkInternetConnectivity()) {
     

    } else {
      setState(() {
        internetAccess =false;
      });
      // Handle no internet connection
     
    }
  } catch (e) {
    setState(() {
        internetAccess =false;
      });
    // Handle network-related errors

    // Display an error message to the user
    // ...
  }
}


  getVideoFile(ImageSource sourceImg) async {
    final videoFile = await ImagePicker().pickVideo(source: sourceImg);
    final thumbnail = await VideoThumbnail.thumbnailData(
      video: videoFile!.path,
      imageFormat: thumb.ImageFormat.JPEG,
      maxWidth: 300,
      quality: 50, // Adjust the quality as needed
    );
    if (videoFile != null) {
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UploadForm(
            videoFile: File(videoFile.path),
            videoPath: videoFile.path,
            thumbnailBytes: thumbnail,
          ),
        ),
      );
    }
  }

  String videoID = DateTime.now().millisecondsSinceEpoch.toString();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(211, 156, 90, 218),
        title: const Text('Videos List'),
      ),
      body: internetAccess == false ? Center(child: Text("Check your internet connection")) : videoCard(),
      floatingActionButton: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FloatingActionButton(
              onPressed: () {
                getVideoFile(ImageSource.camera);
              },
              child: const Text(
                "+",
                style: TextStyle(fontSize: 25),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
