import 'package:duolibras/Network/Models/ModuleProgress.dart';

abstract class APIModuleProgressProtocol {
  Future<List<ModuleProgress>> getModulesProgress();
  Future<bool> postModulesProgress(List<ModuleProgress> modulesProgress);
}
