import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../videosList/Components/singleVideoCard.dart';

enum DataSourceType { network }

class SingleVideoScreen extends StatefulWidget {
  final String url;
  final String title;
  final String category;

  const SingleVideoScreen(
      {super.key,
      required this.url,
      required this.category,
      required this.title});

  @override
  State<SingleVideoScreen> createState() => _SingleVideoScreenState();
}

class _SingleVideoScreenState extends State<SingleVideoScreen> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  @override
  void initState() {
    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.url));
    super.initState();
    _chewieController = ChewieController(
        autoPlay: true,
        videoPlayerController: _videoPlayerController,
        aspectRatio: 16 / 9);
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
           backgroundColor: Color.fromARGB(211, 156, 90, 218),
          title: const Text("Video"),
        ),
        body: singleVideoCard(chewieController: _chewieController, widget: widget, widget1: widget),
      ),
    );
  }
}
