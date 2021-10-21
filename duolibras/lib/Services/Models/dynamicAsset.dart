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

  const DynamicAsset ({required this.id, required this.assetType, required this.path});

  factory DynamicAsset.fromMap(Map<String, dynamic> parsedJson, String docId) {
    return DynamicAsset(
          id: docId,
          assetType: AssetTypesExtension.createEnum(parsedJson["assetType"]),
          path: parsedJson["path"],
        );
  }
}