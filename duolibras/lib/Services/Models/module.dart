import 'package:duolibras/Commons/Extensions/color_extension.dart';
import 'package:flutter/material.dart';

class Module {
  final String title;
  final int minProgress;
  final int maxProgress;
  final String id;
  final String iconUrl;
  final String backgroundImageUrl;
  final Color color;
  late String mlModelName;
  late String mlLabelsName;

   Module(
      {required this.title,
      required this.minProgress,
      required this.maxProgress,
      required this.id,
      required this.iconUrl,
      required this.backgroundImageUrl,
      required this.color
    });

  factory Module.fromMap(Map<String, dynamic> parsedJson, String docId) {
    return Module(
      title: parsedJson["title"],
      minProgress: parsedJson["minProgress"],
      maxProgress: parsedJson["maxProgress"],
      id: docId,
      iconUrl: parsedJson["iconUrl"],
      backgroundImageUrl: parsedJson["backgroundImageUrl"],
      color: HexColor.fromHex(parsedJson["color"])
    );
  }
}
