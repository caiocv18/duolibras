import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duolibras/Commons/Utils/utils.dart';
import 'package:duolibras/Services/Firebase/firebaseErrors.dart';

enum AssetTypes {
  mlModel,
  none
}

extension AssetTypesExtension on AssetTypes {
  static AssetTypes createEnum(String rawValue) {
    try {
      return AssetTypes.values.firstWhere((e) {
        return e.toString().replaceAll("AssetTypes.", "") == rawValue;
      });
    } on StateError {
      return AssetTypes.none;
    }
  }
}

class DynamicAsset {
  final String id;
  final AssetTypes assetType;
  final String path;
  final DateTime lastUpdate;

  const DynamicAsset ({required this.id, required this.assetType, required this.path, required this.lastUpdate});

  factory DynamicAsset.fromMap(Map<String, dynamic> parsedJson, String docId) {
    Timestamp? timestamp = Utils.tryCast(parsedJson["lastUpdate"], fallback: null);
    if (timestamp == null) {
      throw FirebaseErrors.GetDynamicAssetsError;
    }

    return DynamicAsset(
          id: docId,
          assetType: AssetTypesExtension.createEnum(parsedJson["assetType"]),
          path: parsedJson["path"],
          lastUpdate: DateTime.fromMicrosecondsSinceEpoch(timestamp.microsecondsSinceEpoch) 
        );
  }
}