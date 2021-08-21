import 'package:duolibras/Network/Models/Module.dart';

abstract class APIModuleProtocol {
  Future<Module> getModuleFromId(String moduleId);
}
