import 'package:duolibras/Network/Models/Exercise.dart';

abstract class APIExerciseProtocol {
  Future<List<Exercise>> getExercisesFromModuleId(
      String? sectionId, String moduleId, int level);

  Future<List<Exercise>> getANumberOfExercisesFromModuleId(
      String? sectionId, String moduleId, int quantity);
}
