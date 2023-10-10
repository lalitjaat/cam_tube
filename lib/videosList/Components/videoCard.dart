
import 'package:cam_tube/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../cameraScreen/singleVideoScreen.dart';
import 'searchBar.dart';

class videoCard extends StatelessWidget {
  const videoCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: gradientColor
      ),
      child: Column(
        children: [
          const searchBar(),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('UserData')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection("Videos")
                    .snapshots(),
                builder:
                    (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                  if (streamSnapshot.hasError) {
                    return const Center(
                        child: CircularProgressIndicator());
                  }
    
                  if (streamSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
    
                  final data = streamSnapshot.data;
                  if (data == null || data.docs.isEmpty) {
                    return const Center(child: Text('No Videos available.'));
                  }
    
                  // Process and display the data here
                  return ListView.builder(
                    itemCount: data.docs.length,
                    itemBuilder: (context, index) {
                      final DocumentSnapshot documentSnapshot =
                          streamSnapshot.data!.docs[index];
    
                      final videoUrl = documentSnapshot['videoUrt'];
    
                      final title = documentSnapshot['title'];
                      final Category = documentSnapshot['category'];
                      final Location = documentSnapshot['location'];
                      final thumbnail = documentSnapshot['thumbnailUrl'];
    
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SingleVideoScreen(
                                        url: videoUrl,
                                        title: title,
                                        category: Category,
                                      )));
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(125, 154, 89, 215),
                                borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                    child: Material(
                                  borderRadius: BorderRadius.circular(10),
                                  elevation: 16,
                                  child: Container(
                                    clipBehavior: Clip.antiAlias,
                                    height: 300,
                                    width: 350,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Image.network(
                                      thumbnail,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )),
                                Row(
                                  textBaseline: TextBaseline.alphabetic,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const CircleAvatar(
                                      child: Icon(
                                        Icons.person_2_outlined,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                SizedBox(
                                                  width: 180,
                                                  child: Text(title,
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: GoogleFonts.lato(
                                                          textStyle:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      17))),
                                                ),
                                                Text(Location,
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 17)),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Text("Username",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 14)),
                                                const Text("45K views",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 14)),
                                                const Text("#days ago",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 14)),
                                                Text(Category,
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 14)),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                      );
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }
}
