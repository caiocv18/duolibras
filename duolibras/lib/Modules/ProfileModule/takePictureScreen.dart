import 'package:camera/camera.dart';
import 'package:duolibras/Services/Models/Providers/userProvider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    Key? key,
    required this.camera,
  }) : super(key: key);

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: defaultTargetPlatform == TargetPlatform.iOS ? ImageFormatGroup.bgra8888 : ImageFormatGroup.yuv420);

    _initializeControllerFuture = _controller.initialize();

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          return 
              LayoutBuilder(builder: (ctx, constraint) => buildBody(snapshot, constraint)); 
            },
      ),
    );
  }

  Widget buildBody(AsyncSnapshot snapshot, BoxConstraints constraints) {
    var cameraRatio = 1.0;
    try {
      cameraRatio = _controller.value.aspectRatio;
    } catch (e) {
    }
    final size = MediaQuery.of(context).size;
    var scale = size.aspectRatio * cameraRatio;

    // to prevent scaling down, invert the value
    if (scale < 1) scale = 1 / scale;

    return Container(
      width: constraints.maxWidth,
      height: constraints.maxHeight,
      child: Center(
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Transform.scale(scale: scale, child: snapshot.connectionState == ConnectionState.done ?
              CameraPreview(_controller) : CircularProgressIndicator()),
            
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              SizedBox(height: constraints.maxHeight * 0.05),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: GestureDetector(child: Icon(Icons.close, color: Colors.white, size: 30), onTap: ()  {
                  Navigator.of(context).pop();
                }),
              ),
              SizedBox(height: constraints.maxHeight * 0.75),
              GestureDetector(
                onTap: () => _takePhoto(),
                child: Center(
                  child: Stack(alignment: AlignmentDirectional.center, 
                    children: [
                      Container(width: constraints.maxWidth * 0.2, height: constraints.maxWidth * 0.2, 
                        decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
                      Container(width: constraints.maxWidth * 0.17, height: constraints.maxWidth * 0.18, 
                        decoration: BoxDecoration(color: Colors.transparent, shape: BoxShape.circle, border: Border.all(color: Colors.black)))
                  ]),
                ),
              )
            ])
          ]
        ),
      ),
    );
  }

  void _takePhoto() async {
    try {
        await _initializeControllerFuture;
        final image = await _controller.takePicture();
        final provider = Provider.of<UserModel>(context, listen: false);
        provider.setImageUrl(image.path);
        Navigator.of(context).pop(image.path);
      } catch (e) {
        print(e);
      }
  }

}
