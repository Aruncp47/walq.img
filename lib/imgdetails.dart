import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as path;
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';

class ImageDetailPage extends StatelessWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const ImageDetailPage({
    super.key,
    required this.imageUrls,
    required this.initialIndex,
  });

  static const platform = MethodChannel('com.walqfoodindustries.walqimg/media');

  Future<void> _downloadImage(BuildContext context, String imageUrl) async {
    try {
      // Request storage permissions
      final permissionStatus = await Permission.manageExternalStorage.request();
      if (permissionStatus.isGranted) {
        // Define the Downloads directory path
        final directory = Directory('/storage/emulated/0/Download');

        // Check if the directory exists, if not, create it
        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }

        // Decode the URL and extract the filename
        final decodedUrl = Uri.decodeComponent(imageUrl);
        final fileName = path.basename(Uri.parse(decodedUrl).path);

        // Create the full file path in the Downloads directory
        final filePath = path.join(directory.path, fileName);

        // Download the image using Dio
        final response = await Dio().download(imageUrl, filePath);

        // Check if the download was successful
        if (response.statusCode == 200) {
          // Notify the media scanner about the new file
          await platform.invokeMethod('scanFile', {'path': filePath});

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                duration: Duration(seconds: 1),
                content: Text('Image downloaded to $filePath')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                duration: Duration(seconds: 1),
                content: Text('Failed to download image')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              duration: Duration(seconds: 1),
              content:
                  Text('Storage permission is required to download the image')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(duration: Duration(seconds: 3), content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.orange,
            Colors.deepOrangeAccent,
            Colors.orangeAccent,
            Colors.white
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.white70,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text(
            'Image Detail',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: PageView.builder(
          controller: PageController(initialPage: initialIndex),
          itemCount: imageUrls.length,
          itemBuilder: (context, index) {
            final imageUrl = imageUrls[index];
            final fileName =
                path.basename(Uri.parse(Uri.decodeComponent(imageUrl)).path);

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    fileName.replaceAll('%20', ' '),
                    // Replace any remaining %20 with space
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Center(
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.contain,
                      errorWidget: (context, url, error) => const Center(
                        child: Text(
                          'Failed to load image',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
                  child: SizedBox(
                    height: 50,
                    width: 300,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 10,
                        backgroundColor: Colors.deepOrangeAccent,
                      ),
                      onPressed: () => _downloadImage(context, imageUrl),
                      child: const Text(
                        "Download",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 30, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
