import 'package:uuid/uuid.dart';

class Exercise {
  final String question;
  final String answer;
  final double score;
  final Uuid id;

  const Exercise(
      {required this.question,
      required this.answer,
      required this.score,
      required this.id});

  factory Exercise.fromMap(Map<String, dynamic> parsedJson) {
    return Exercise(
        question: parsedJson["question"],
        answer: parsedJson["answer"],
        score: parsedJson["score"],
        id: parsedJson["id"]);
  }

  factory Exercise.fromDynamicMap(Map<dynamic, dynamic> parsedJson) {
    return Exercise(
        question: parsedJson["question"],
        answer: parsedJson["answer"],
        score: parsedJson["score"],
        id: parsedJson["id"]);
  }
}
