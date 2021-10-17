import 'package:duolibras/Services/Models/module.dart';

abstract class APIModuleProtocol {
  Future<List<Module>> getModulesFromSectionId(String sectionId);
}
