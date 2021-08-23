import 'package:duolibras/Network/Models/Section.dart';

abstract class APISectionProtocol {
  Future<List<Section>> getSectionsFromTrail();
}
