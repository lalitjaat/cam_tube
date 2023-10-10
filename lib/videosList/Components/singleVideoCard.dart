import 'package:cam_tube/constants.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import '../../cameraScreen/singleVideoScreen.dart';
import '../videosScreen.dart';

class singleVideoCard extends StatelessWidget {
  const singleVideoCard({
    super.key,
    required ChewieController chewieController,
    required this.widget,
    required this.widget1,
  }) : _chewieController = chewieController;

  final ChewieController _chewieController;
  final SingleVideoScreen widget;
  final SingleVideoScreen widget1;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: const BoxDecoration(
          gradient: gradientColor
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 0.0),
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                      height: 240,
                      width: 500,
                      child: Chewie(
                        controller: _chewieController,
                      )),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 13.0),
                    child: SizedBox(
                        height: 50,
                        child: Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 13.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      20.0), // Adjust the radius as needed
                                ),
                              ),
                            ),
                            onPressed: () {},
                            child: const Icon(Icons.thumb_up)),
                        ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      20.0), // Adjust the radius as needed
                                ),
                              ),
                            ),
                            onPressed: () {},
                            child: const Icon(Icons.thumb_down)),
                        ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      20.0), // Adjust the radius as needed
                                ),
                              ),
                            ),
                            onPressed: () {},
                            child: const Row(
                              children: [
                                Icon(Icons.share),
                                Text(" SHARE"),
                              ],
                            ))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 13.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "45k views",
                        ),
                        const Text("1 day ago"),
                        Text(widget.category)
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 13.0, vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const CircleAvatar(
                            child: Icon(Icons.person_2_rounded)),
                        const Text("#UserName"),
                        ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      20.0), // Adjust the radius as needed
                                ),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          videosScreen()));
                            },
                            child: const Text("View All Videos"))
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
