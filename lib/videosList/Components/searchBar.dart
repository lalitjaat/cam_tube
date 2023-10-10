import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../cameraScreen/singleVideoScreen.dart';

class searchBar extends StatefulWidget {
  const searchBar({
    super.key,
  });

  @override
  State<searchBar> createState() => _searchBarState();
}

class _searchBarState extends State<searchBar> {
  late TextEditingController _searchController;
  late Stream<QuerySnapshot> _searchResults;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchResults = FirebaseFirestore.instance
        .collection("UserData")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Videos")
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 30, top: 10, bottom: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Column(
                children: [
                  SizedBox(
                    width: 310,
                    height: 30,
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          _searchResults = FirebaseFirestore.instance
                              .collection('UserData')
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .collection("Videos")
                              .where('title', isGreaterThanOrEqualTo: value)
                              .snapshots();
                        });
                      },
                      onEditingComplete: () {
                        showModalBottomSheet(
                          backgroundColor: Color.fromARGB(255, 156, 90, 218),
                          context: context,
                          builder: (context) => StreamBuilder<QuerySnapshot>(
                            stream: _searchResults,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Container(
                                    alignment: Alignment.center,
                                    height: 500,
                                    width: MediaQuery.of(context).size.width,
                                    child: const CircularProgressIndicator());
                              }

                              if (snapshot.hasError) {
                                return Container(
                                    alignment: Alignment.center,
                                    height: 500,
                                    width: MediaQuery.of(context).size.width,
                                    child: Text('Error: ${snapshot.error}'));
                              }

                              if (!snapshot.hasData ||
                                  snapshot.data!.docs.isEmpty) {
                                return Container(
                                    alignment: Alignment.center,
                                    height: 500,
                                    width: MediaQuery.of(context).size.width,
                                    child: const Text('No results found.'));
                              }

                              return Expanded(
                                child: ListView.builder(
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (context, index) {
                                    var document = snapshot.data!.docs[index];
                                    var title = document['title'];
                                    var thumbnail = document['thumbnailUrl'];
                                    var videoUrl = document['videoUrt'];
                                    var Category = document['category'];

                                    // Display the search results as desired
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
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 15, horizontal: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.all(9),
                                              clipBehavior: Clip.antiAlias,
                                              width: 200,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10)),
                                              child: Image.network(
                                                thumbnail,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            Text(
                                              title,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const Divider()
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        );
                      },
                      keyboardType: TextInputType.name,
                      expands: true,
                      maxLines: null,
                      minLines: null,
                      decoration: InputDecoration(
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.horizontal(
                                left: Radius.circular(50),
                                right: Radius.circular(50))),
                        prefixIcon: const Icon(
                          CupertinoIcons.search,
                          color: Colors.black,
                          size: 18,
                        ),
                        hintText: "Search",
                        hintStyle: const TextStyle(color: Colors.black),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 20),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              width: 1, color: Colors.black), //<-- SEE HERE
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Text(
                "Filter",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 17,
                    color: Colors.black),
              )
            ],
          ),
        ],
      ),
    );
  }
}
