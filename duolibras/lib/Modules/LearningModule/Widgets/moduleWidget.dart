import 'package:flutter/material.dart';

class MaduleWidget extends StatelessWidget {
  // const MaduleWidget({Key? key}) : super(key: key);
  final isLocked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                backgroundColor: Colors.grey[600],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow),
                value: 0.6,
                strokeWidth: 60,
              ),
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 40,
              ),
              CircleAvatar(
                child: Container(
                    height: 50,
                    child: Image.network(
                        "https://firebasestorage.googleapis.com/v0/b/libras-tcc.appspot.com/o/ImagensTeste%2Fsaude.png?alt=media&token=b846521d-14f3-4b77-83e2-95c99fe8ad62")),
                radius: 35,
                backgroundColor: Colors.blue[400],
              ),
              if (isLocked)
                Stack(alignment: Alignment.center, children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey,
                    radius: 50,
                  ),
                  CircleAvatar(
                    child: Container(height: 50, child: Icon(Icons.lock)),
                    radius: 35,
                    backgroundColor: Colors.grey,
                  )
                ])
            ],
          ),
          SizedBox(height: 15),
          Text("verb to Be",
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal))
        ],
      ),
    );
  }
}
