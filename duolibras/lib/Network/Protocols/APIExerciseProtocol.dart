import 'package:duolibras/Network/Models/Exercise.dart';

abstract class APIExerciseProtocol {
  Future<Exercise> getExerciseFromId(String exerciseId);
}
