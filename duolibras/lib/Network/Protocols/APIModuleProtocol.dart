import 'package:duolibras/Network/Models/Module.dart';

abstract class APIModuleProtocol {
  Future<List<Module>> getModulesFromSectionId(String sectionId);
}
