import 'package:duolibras/Network/Models/ModuleProgress.dart';

abstract class APIModuleProgressProtocol {
  Future<List<ModuleProgress>> getModulesProgress();
  Future<bool> postModuleProgress(ModuleProgress moduleProgress);
}
