import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'imgdetails.dart';

class Pulsespg extends StatefulWidget {
  const Pulsespg({super.key});

  @override
  State<Pulsespg> createState() => _PulsespgState();
}

class _PulsespgState extends State<Pulsespg> {
  List<String> folders = [];
  List<String> imageUrls = [];
  List<String> imageNames = [];
  List<String> filteredImageUrls = [];
  List<String> filteredImageNames = [];
  bool isLoading = true;
  String errorMessage = '';
  bool isViewingFolders = true;
  bool isSearching = false;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchFolders();
  }

  Future<void> fetchFolders() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() {
          errorMessage = 'User is not authenticated. Please sign in first.';
          isLoading = false;
        });
        return;
      }

      final ListResult result =
          await FirebaseStorage.instance.ref('pulses').listAll();
      final List<String> folderNames =
          result.prefixes.map((Reference ref) => ref.name).toList();

      setState(() {
        folders = folderNames;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load folders. Please try again later.';
        isLoading = false;
      });
    }
  }

  Future<void> fetchImagesFromFolder(String folderName) async {
    setState(() {
      isLoading = true;
      isViewingFolders = false;
    });

    try {
      final ListResult result =
          await FirebaseStorage.instance.ref('pulses/$folderName').listAll();
      final List<ImageData> imageData =
          await Future.wait(result.items.map((Reference ref) async {
        final String url = await ref.getDownloadURL();
        final String name = ref.name;
        return ImageData(url: url, name: name);
      }).toList());

      setState(() {
        imageUrls = imageData.map((data) => data.url).toList();
        imageNames = imageData.map((data) => data.name).toList();
        filteredImageUrls = imageUrls;
        filteredImageNames = imageNames;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load images. Please try again later.';
        isLoading = false;
      });
    }
  }

  void _viewImage(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageDetailPage(
          imageUrls: filteredImageUrls,
          initialIndex: index,
        ),
      ),
    );
  }

  void _filterImages(String query) {
    List<String> tempUrls = [];
    List<String> tempNames = [];

    if (query.isNotEmpty) {
      for (int i = 0; i < imageNames.length; i++) {
        if (imageNames[i].toLowerCase().contains(query.toLowerCase())) {
          tempUrls.add(imageUrls[i]);
          tempNames.add(imageNames[i]);
        }
      }
    } else {
      tempUrls = imageUrls;
      tempNames = imageNames;
    }

    setState(() {
      searchQuery = query;
      filteredImageUrls = tempUrls;
      filteredImageNames = tempNames;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.orange,
            Colors.orangeAccent,
            Colors.orangeAccent,
            Colors.white
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.white70,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () {
              if (isViewingFolders) {
                Navigator.pop(context);
              } else {
                setState(() {
                  isViewingFolders = true;
                });
              }
            },
            icon: const Icon(Icons.arrow_back),
          ),
          title: !isViewingFolders
              ? !isSearching
                  ? const Text(
                      'Pulses Page',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  : TextField(
                      onChanged: (value) {
                        _filterImages(value);
                      },
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Search Images',
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                    )
              : const Text(
                  'Pulses Page',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
          actions: [
            if (!isViewingFolders)
              IconButton(
                icon: Icon(isSearching ? Icons.close : Icons.search),
                onPressed: () {
                  setState(() {
                    isSearching = !isSearching;
                    if (!isSearching) {
                      filteredImageUrls = imageUrls;
                      filteredImageNames = imageNames;
                      searchQuery = '';
                    }
                  });
                },
              ),
          ],
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : errorMessage.isNotEmpty
                ? Center(child: Text(errorMessage))
                : isViewingFolders
                    ? GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5,
                        ),
                        itemCount: folders.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () => fetchImagesFromFolder(folders[index]),
                            child: Card(
                              child: Center(
                                child: Text(
                                  folders[index],
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5,
                        ),
                        itemCount: filteredImageUrls.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () => _viewImage(index),
                            child: Card(
                              color: Colors.white,
                              child: Column(
                                children: [
                                  Expanded(
                                    child: CachedNetworkImage(
                                      imageUrl: filteredImageUrls[index],
                                      fit: BoxFit.cover,
                                      errorWidget: (context, url, error) =>
                                          const Center(
                                        child: Text(
                                          'Failed to load image',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      filteredImageNames[index],
                                      style: const TextStyle(
                                        fontSize: 12,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
      ),
    );
  }
}

class ImageData {
  final String url;
  final String name;

  ImageData({required this.url, required this.name});
}
