import 'package:duolibras/Network/Models/Section.dart';

abstract class APISectionProtocol {
  Future<Section> getSectionFromId(String sectionId);
}
