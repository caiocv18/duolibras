import 'package:duolibras/Services/Models/section.dart';

abstract class APISectionProtocol {
  Future<List<Section>> getSectionsFromTrail();
}
