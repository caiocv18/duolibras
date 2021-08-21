import 'package:duolibras/Network/Models/ExercisesCategory.dart';

class Exercise {
  final String question;
  final String correctAnswer;
  final List<String> answers;
  final int score;
  final String id;
  final ExercisesCategory category;

  const Exercise(
      {required this.question,
      required this.correctAnswer,
      required this.answers,
      required this.score,
      required this.id,
      required this.category});

  factory Exercise.fromMap(Map<String, dynamic> parsedJson, String docId) {
    return Exercise(
        question: parsedJson["question"],
        correctAnswer: parsedJson["correctAnswer"],
        answers: parsedJson["answers"].cast<String>(),
        score: parsedJson["score"],
        id: docId,
        category:
            ExercisesCategoryExtension.createEnum(parsedJson["category"]));
  }
}
