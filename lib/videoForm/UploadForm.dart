import 'dart:io';
import 'dart:typed_data';
import 'package:cam_tube/videoForm/uploadController.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:video_player/video_player.dart';

class UploadForm extends StatefulWidget {
  final File videoFile;
  final String videoPath;
  Uint8List? thumbnailBytes;

  @override
  UploadForm(
      {super.key,
      required this.videoFile,
      required this.videoPath,
      required this.thumbnailBytes});

  bool isloading = true;

  @override
  State<UploadForm> createState() => _UploadFormState();
}

class _UploadFormState extends State<UploadForm> {
  String? currentCity;
  String? currentCountry;
  File? _thumbnailFile;

  Future<void> _checkLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;
    permission = await Geolocator.requestPermission();

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      const Text('Location services are disabled');
      return;
    } else {
      widget.isloading = false;
    }

    // Check location permission status
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permission denied');
        return;
      }
    }

    if (permission == LocationPermission.denied) {
      print('Location permission denied forever');
      return Future<void>(
        () {
          return const Center(child: CircularProgressIndicator());
        },
      );
    }
    widget.isloading = false;
    _fetchLocationAndAddress();
  }

  Future<void> _fetchLocationAndAddress() async {
    try {
      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        setState(() {
          currentCity = placemarks[0].locality ?? '';
          currentCountry = placemarks[0].country ?? '';
        });
      }
    } catch (e) {
      Text('$e');
    }
  }

  TextEditingController titleTexteditingController = TextEditingController();
  TextEditingController descriptionTexteditingController = TextEditingController();
  TextEditingController categoryTexteditingController = TextEditingController();
  TextEditingController locationTexteditingController = TextEditingController();
  VideoPlayerController? playerController;
  UploadController videoUploadController = UploadController();

  bool uploadComplete = false;
  @override
  void initState() {
    _checkLocationPermission();
    super.initState();
    setState(() {
      playerController = VideoPlayerController.file(widget.videoFile);
    });
    playerController!.initialize();
  }

  @override
  void dispose() {
    super.dispose();
    playerController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 1.6,
              width: MediaQuery.of(context).size.width,
              child: Image.memory(widget.thumbnailBytes!),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: titleTexteditingController,
                decoration: const InputDecoration(
                  labelText: "Title",
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(10),
                          right: Radius.circular(10))),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: descriptionTexteditingController,
                decoration: const InputDecoration(
                  labelText: "Description",
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(10),
                          right: Radius.circular(10))),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: categoryTexteditingController,
                decoration: const InputDecoration(
                  labelText: "Category",
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(10),
                          right: Radius.circular(10))),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: currentCity == null
                  ? const Center(child: CircularProgressIndicator())
                  : TextFormField(
                      initialValue: '$currentCity, $currentCountry',
                      readOnly: true,
                      cursorColor: Colors.black,
                      decoration: const InputDecoration(
                        labelText: "Location",
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.horizontal(
                                left: Radius.circular(10),
                                right: Radius.circular(10))),
                        prefixStyle: TextStyle(color: Colors.black),
                      ),
                    ),
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
                    uploadComplete = true;
                  });

                  videoUploadController.saveVideoInformationToFirestoreDatabase(
                      titleTexteditingController.text,
                      descriptionTexteditingController.text,
                      categoryTexteditingController.text,
                      "$currentCity, $currentCountry",
                      widget.videoPath,
                      context);
                },
                child: uploadComplete == false
                    ? const Text("Post")
                    : const Text("Uploading..."))
          ],
        ),
      ),
    );
  }
}
