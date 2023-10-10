import 'package:cloud_firestore/cloud_firestore.dart';

class video {
  String? UserID;
  String? videoID;

  String? title;
  String? description;
  String? category;
  String? location;
  String? videoUrl;
  String? thumbnailUrl;

  video(
      {this.UserID,
      this.category,
      this.description,
      this.location,
      this.thumbnailUrl,
      this.title,
      this.videoID,
      this.videoUrl});

  Map<String, dynamic> tojson() => {
        "UserID": UserID,
        "videoID": videoID,
        "title": title,
        "description": description,
        "category": category,
        "location": location,
        "videoUrt": videoUrl,
        "thumbnailUrl": thumbnailUrl,
      };

  static video fromDocumentSnapshot(DocumentSnapshot snapshot) {
    var docSnapshot = snapshot.data() as Map<String, dynamic>;
    return video(
      UserID: docSnapshot["UserID"],
      videoID: docSnapshot["videoID"],
      title: docSnapshot["title"],
      description: docSnapshot["description"],
      category: docSnapshot["category"],
      location: docSnapshot["location"],
      videoUrl: docSnapshot["videoUrt"],
      thumbnailUrl: docSnapshot["thumbnailUrl"],
    );
  }
}
