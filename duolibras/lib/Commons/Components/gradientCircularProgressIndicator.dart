// import 'package:duolibras/Commons/Extensions/color_extension.dart';
// import 'package:flutter/material.dart';

// class GradientCircularProgressIndicator extends StatelessWidget {
//   final int max;
//   final int current;
//   final Gradient gradient;
//   final Color backgroundColor;
//   final double radius;

//   const GradientCircularProgressIndicator(
//       {Key? key,
//       required this.max,
//       required this.current,
//       required this.radius,
//       required this.backgroundColor,
//       required this.gradient})
//       : super(key: key);

//   static const TWO_PI = 3.14 * 2;

//   @override
//   Widget build(BuildContext context) {
//     final size = 200.0;

//     return 
//                Container(
//                 width: size,
//                 height: size,
//                 child: Stack(
//                   children: [
//                     ShaderMask(
//                       shaderCallback: (rect){
//                         return SweepGradient(
//                             startAngle: 0.0,
//                             endAngle: TWO_PI,
//                             stops: [0.3, 0.1],
//                             center: Alignment.center,
//                             colors: [HexColor.fromHex("4982F6"), HexColor.fromHex("2CC4FC")]
//                         ).createShader(rect);
//                       },
//                       child: Container(
//                         width: size,
//                         height: size,
//                         decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             gradient: gradient,
//                         ),
//                       ),
//                     ),
//                     Center(
//                       child: Container(
//                         width: size-40,
//                         height: size-40,
//                         decoration: BoxDecoration(
//                             color: Colors.white,
//                             shape: BoxShape.circle
//                         ),
//                         // child: Center(child: Text("$percentage",
//                         //   style: TextStyle(fontSize: 40),)),
//                       ),
//                     )
//                   ],
//                 ),
//               );
    
//   }
// }