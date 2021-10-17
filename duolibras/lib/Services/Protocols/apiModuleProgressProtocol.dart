import 'package:duolibras/Services/Models/moduleProgress.dart';

abstract class APIModuleProgressProtocol {
  Future<List<ModuleProgress>> getModulesProgress();
  Future<bool> postModuleProgress(ModuleProgress moduleProgress);
}
