import 'package:cam_tube/videoForm/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:video_compress/video_compress.dart';

class UploadController {
  bool uploadComplete = false;
  compressVideo(String videoFilePath) async {
    final compressVideoFilePath = await VideoCompress.compressVideo(
        videoFilePath,
        quality: VideoQuality.LowQuality);
    return compressVideoFilePath!.file;
  }

  uploadVideotoFirebase(String videoID, String videoFilePath) async {
    UploadTask videoUpload = FirebaseStorage.instance
        .ref()
        .child("ALl Videos")
        .child(videoID)
        .putFile(await compressVideo(videoFilePath));

    TaskSnapshot snapshot = await videoUpload;

    String videoUrl = await snapshot.ref.getDownloadURL();
    return videoUrl;
  }

  getVideoThumbnail(String videoFilePath) async {
    final thumbnailImage = await VideoCompress.getFileThumbnail(videoFilePath);
    return thumbnailImage;
  }

  uploadThumbnailtoFirebase(String videoID, String videoFilePath) async {
    UploadTask thumbnailUpload = FirebaseStorage.instance
        .ref()
        .child("ALl Thumbnails")
        .child(videoID)
        .putFile(await getVideoThumbnail(videoFilePath));

    TaskSnapshot snapshot = await thumbnailUpload;

    String thumbnailUrl = await snapshot.ref.getDownloadURL();
    return thumbnailUrl;
  }

  saveVideoInformationToFirestoreDatabase(
      String title,
      String description,
      String category,
      String location,
      String videoFilePath,
      BuildContext context) async {
    try {
      String videoID = DateTime.now().millisecondsSinceEpoch.toString();
      String videoUrl = await uploadVideotoFirebase(videoID, videoFilePath);
      String thumbnailUrl =
          await uploadThumbnailtoFirebase(videoID, videoFilePath);

      video videoObject = video(
        UserID: FirebaseAuth.instance.currentUser!.uid,
        title: title,
        description: description,
        category: category,
        location: location,
        videoID: videoID,
        videoUrl: videoUrl,
        thumbnailUrl: thumbnailUrl,
      );
      final userUID = FirebaseAuth.instance.currentUser!.uid;


      final userDocRef =
          FirebaseFirestore.instance.collection("UserData").doc(userUID);
      final userDocSnapshot = await userDocRef.get();

      if (userDocSnapshot.exists) {
        // The user's document exists, so update it with the new video data
        await userDocRef.update({videoID: videoObject.tojson()});
      } else {
        // The user's document does not exist, so create it with the new video data
        await userDocRef.collection("Videos").doc().set(videoObject.tojson());
      }
    } catch (e) {
      Text(e.toString());
    }
    uploadComplete = true;
Navigator.pushNamedAndRemoveUntil(context, "videosUploadedScreen", (route) => false);

  }

}

//Video Sucess Screen
class videoUploadedScreen extends StatelessWidget {
  const videoUploadedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        Navigator.pushNamedAndRemoveUntil(context, "videosScreen", (route) => false);
return true;
      },
      child: const Scaffold(
        body: Center(
          child: Text("Video Uploaded Successfully!!"),
        ),
      ),
    );
  }
}
