import 'package:duolibras/Services/Models/exercise.dart';

abstract class APIExerciseProtocol {
  Future<List<Exercise>> getExercisesFromModuleId(
      String sectionId, String moduleId, int level);

  Future<List<Exercise>> getANumberOfExercisesFromModuleId(
      String sectionId, String moduleId, int quantity);
}
