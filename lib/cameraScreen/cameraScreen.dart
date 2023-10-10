import 'dart:io';

import 'package:cam_tube/videoForm/UploadForm.dart';
import 'package:cam_tube/videosList/videosScreen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_thumbnail/video_thumbnail.dart' as thumb;
import 'package:video_thumbnail/video_thumbnail.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              ElevatedButton(
                  onPressed: () {
                    getVideoFile(ImageSource.camera);
                  },
                  child: const Text("Open Camera")),
                  ElevatedButton(
                  onPressed: () {
 Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => videosScreen(),
        ),
      );                  },
                  child: const Text("Videos"))
            ],
          ),
        ),
      ),
    );
  }
}
