import 'package:duolibras/Network/Models/Exercise.dart';

abstract class APIExerciseProtocol {
  Future<List<Exercise>> getExercisesFromModuleId(
      String? sectionId, String moduleId);
}
