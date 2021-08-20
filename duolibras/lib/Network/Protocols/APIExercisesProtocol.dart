import 'package:duolibras/Network/Models/Exercise.dart';

abstract class APIExercisesProtocol {
  Future<List<Exercise>> getExercises();
}
