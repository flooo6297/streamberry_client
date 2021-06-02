import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:streamberry_client/src/app.dart';
import 'package:hive/hive.dart';

class CachedImage extends StatefulWidget {

  final String image;

  const CachedImage(this.image, {Key? key}) : super(key: key);

  @override
  _CachedImageState createState() => _CachedImageState();
}

class _CachedImageState extends State<CachedImage> {

  late Uint8List imageBytes;
  
  late Box<Map<dynamic, dynamic>> cachedImages;
  
  @override
  Widget build(BuildContext context) {
    if (cachedImages.containsKey(widget.image)) {
      var imageData = cachedImages.get(widget.image)!;
      imageBytes = base64Decode(imageData['data']!);
      return Image.memory(imageBytes);
      cachedImages.put(widget.image, {'data': cachedImages.get(widget.image)!['data']!, 'lastUsed': '${DateTime.now().millisecondsSinceEpoch}'});
    } else {
      if (widget.image.isNotEmpty) {
        App.socketOf(context).write(jsonEncode({'getImage': widget.image}));
      }
      return Container();
    }
  }

  @override
  void initState() {

    cachedImages = Hive.box('cached_images');

    App.broadcastOf(context).listen((data) {
      final serverMessage = String.fromCharCodes(data);
      List<dynamic> serverMessageContentMapList = jsonDecode('[${serverMessage.replaceAll('}{', '},{')}]');

      for (var serverMessageContentMap in serverMessageContentMapList) {
        if (serverMessageContentMap is Map<String, dynamic>) {
          if (serverMessageContentMap.containsKey('imageResponse')) {
            Map<String, dynamic> imageResponse = (serverMessageContentMap['imageResponse'] as Map<String, dynamic>);
            if (imageResponse['image'] as String == widget.image) {
              cachedImages.put(widget.image, {'data': imageResponse['data']! as String, 'lastUsed': '${DateTime.now().millisecondsSinceEpoch}'});
              setState(() {
              });
            }
          }
        }
      }


    });

    super.initState();
  }


}