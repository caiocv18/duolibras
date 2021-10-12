import 'package:duolibras/Network/Models/ExercisesCategory.dart';

class Exercise {
  final String? question;
  final String correctAnswer;
  final List<String>? answers;
  final int? score;
  final String id;
  final ExercisesCategory category;
  final String mediaUrl;
  final int level;
  final String? title;
  final String? description;
  final int order;

  const Exercise(
      {required this.question,
      required this.correctAnswer,
      required this.answers,
      required this.score,
      required this.id,
      required this.level,
      required this.category,
      required this.mediaUrl,
      required this.title,
      required this.description,
      required this.order
      });

  factory Exercise.fromMap(Map<String, dynamic> parsedJson, String docId) {
    return Exercise(
          question: parsedJson["question"],
          correctAnswer: parsedJson["correctAnswer"],
          answers: (parsedJson["answers"] ?? []).cast<String>(),
          score: parsedJson["score"],
          id: docId,
          level: parsedJson["level"],
          mediaUrl: parsedJson["mediaUrl"],
          category: ExercisesCategoryExtension.createEnum(parsedJson["category"]), 
          description: parsedJson["description"], 
          title: parsedJson["title"],
          order: parsedJson["order"]
        );
  }
}
