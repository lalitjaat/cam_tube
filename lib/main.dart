import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cam_tube/auth/login_screen.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  cameras = await availableCameras();
  await Permission.camera.request();

  runApp(const MaterialApp(home: LoginScreen()));
}

class MyApp extends StatefulWidget {
   MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final user = FirebaseAuth.instance.currentUser;

void islogin(BuildContext context){
if (user != null){

Timer (const Duration (seconds: 3),
()=> Navigator .push(context, MaterialPageRoute(builder: (context) => HomeScreen ())));
}else{
  Timer (const Duration (seconds: 3),
()=> Navigator .push(context, MaterialPageRoute(builder: (context) => LoginScreen ())));
}
}



  @override
  Widget build(BuildContext context) {
    return 
    HomeScreen();
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Camera App'),
        ),
        body: 
        Center(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  final cameraController = CameraController(
                    cameras[
                        0],
                    ResolutionPreset.high,
                  );

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CameraScreen(cameraController: cameraController),
                    ),
                  );
                },
                child: const Text('Open Camera'),
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideosListScreen(),
                      ),
                    );
                  },
                  child: const Text("Videos List"))
            ],
          ),
        ),
      ),
    );
  }
}

class CameraScreen extends StatefulWidget {
  final CameraController cameraController;

  const CameraScreen({Key? key, required this.cameraController})
      : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  bool isRecording = false;
  late VideoPlayerController videoController;
  bool isVideoSaved = false;
  String videoPath = '';
  String title = '';
  String description = '';
  String category = '';
  String location = '';

  @override
  void initState() {
    super.initState();
    widget.cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });

    videoController = VideoPlayerController.network('');
  }

  Future<void> _startRecording() async {
    final cameraController = widget.cameraController;

    if (!cameraController.value.isInitialized) {
      return;
    }

    final tempDir = await getTemporaryDirectory();
    videoPath = '${tempDir.path}/${DateTime.now()}.mp4';

    try {
      await cameraController.startVideoRecording();
      setState(() {
        isRecording = true;
      });
    } catch (e) {
      print('Error starting video recording: $e');
    }
  }

  Future<void> _stopRecording() async {
    final cameraController = widget.cameraController;



Future<void> addVideoToFirestore(String videoTitle, String videoDescription, String videoCategory, String videoLocation) async {
  final CollectionReference videosRef = FirebaseFirestore.instance.collection('videos');

  try {
    await videosRef.add({
      'title': videoTitle,
      'description': videoDescription,
      'category': videoCategory,
      'location': videoLocation,
    });
    print('Video metadata added to Firestore');
  } catch (e) {
    print('Error adding video metadata: $e');
  }
}





Future<void> uploadVideoToFirebaseStorage(String videoPath, String videoTitle) async {
  final Reference storageRef = FirebaseStorage.instance.ref().child('videos/$videoTitle.mp4');
  final File videoFile = File(videoPath);

  try {
    await storageRef.putFile(videoFile);
    print('Video uploaded to Firebase Storage');
  } catch (e) {
    print('Error uploading video: $e');
  }
}








    await cameraController.stopVideoRecording();

    setState(() {
      isRecording = false;
    });

    // Play the recorded video
    videoController = VideoPlayerController.file(File(videoPath))
      ..initialize().then((_) {
        setState(() {});
      });

    // Show a dialog to save the video with title and description
    // ignore: use_build_context_synchronously
    await showDialog(
      context: context,
      builder: (_) => VideoSaveDialog(
        description: description,
        category: category,
        location: location,
        title: title,
        videoPath: videoPath,
        
        onVideoSaved: () async{

// Upload the video to Firebase Storage
        await uploadVideoToFirebaseStorage(videoPath, title);

        // Store video metadata in Firestore
        await addVideoToFirestore(title, description, category, location);


          setState(() {
            isVideoSaved = true;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.cameraController.value.isInitialized) {
      return Container();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera Screen'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                CameraPreview(widget.cameraController),
                if (isVideoSaved)
                  AspectRatio(
                    aspectRatio: videoController.value.aspectRatio,
                    child: VideoPlayer(videoController),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: isRecording ? _stopRecording : _startRecording,
            child: isRecording
                ? const Text('Stop Recording')
                : const Text('Start Recording'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    widget.cameraController.dispose();
    videoController.dispose();
    super.dispose();
  }
}

class VideoSaveDialog extends StatelessWidget {
  final String videoPath;
  String title;
  String description;
  String category;
  String location;
  final Function onVideoSaved;

  VideoSaveDialog({
    required this.videoPath,
    required this.title,
    required this.description,
    required this.category,
    required this.location,
    required this.onVideoSaved,
  });

  @override
  Widget build(BuildContext context) {
    return 
    AlertDialog(
        title: Text('Save Video'),
        content: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: 'Title'),
                onChanged: (value) {
                  title = value;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Description'),
                onChanged: (value) {
                  description = value;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Category'),
                onChanged: (value) {
                  category = value;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Location'),
                onChanged: (value) {
                  location = value;
                },
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Save video and metadata
// Upload video to Firebase Storage and save metadata in Firestore
Future<void> uploadVideoAndMetadata(String videoPath, String title, String description, String category, String location) async {
  // Upload video to Firebase Storage (similar to previous example)
  // ...

  // Save video metadata in Firestore under the user's collection
  final User? user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    final CollectionReference userVideosCollection = FirebaseFirestore.instance.collection('users/${user.uid}/videos');

    try {
      await userVideosCollection.add({
        'title': title,
        'description': description,
        'category': category,
        'location': location,
        'videoUrl': videoPath, // Store the URL to the uploaded video
      });

      print('Video and metadata added to user collection');
    } catch (e) {
      print('Error adding video and metadata: $e');
    }
  }
}


              Navigator.of(context).pop();
            },
            child: Text('Save'),
          ),
        ],
      );
  }
}



class VideosListScreen extends StatefulWidget {
  @override
  _VideosListScreenState createState() => _VideosListScreenState();
}

class _VideosListScreenState extends State<VideosListScreen> {
  List<Map<String, dynamic>> videos = [];
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _loadVideosFromCache();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _loadVideosFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    final videoList = <Map<String, dynamic>>[];

    for (final key in keys) {
      final videoInfo = json.decode(prefs.getString(key) ?? '');
      videoList.add(videoInfo);
    }

    setState(() {
      videos = videoList;
    });
  }

  // ... Rest of the _VideosListScreenState code

  Future<void> _playVideo(String videoPath) async {
    final videoFile = File(videoPath);

    if (await videoFile.exists()) {
      final controller = VideoPlayerController.file(videoFile);
      await controller.initialize();
      await controller.setVolume(1.0);
      await controller.play();

      setState(() {
        _controller?.dispose();
        _controller = controller;
      });
    } else {
      // Handle the case where the video file does not exist.
      print('Video file does not exist: $videoPath');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Videos List'),
      ),
      body: ListView.builder(
        itemCount: videos.length,
        itemBuilder: (context, index) {
          final video = videos[index];
          final title = video['title'];
          final description = video['description'];
          final videoPath = video['path'];

          return ListTile(
            title: Text(title ?? 'No Title'),
            subtitle: Text(description ?? 'No Description'),
            onTap: () {
              _playVideo(videoPath);
            },
          );
        },
      ),
    );
  }
}
