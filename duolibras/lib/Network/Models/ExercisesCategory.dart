enum ExercisesCategory {
  multipleChoicesImage,
  multipleChoicesText,
  ml,
  mlSpelling,
  writing,
  content,
  none
}

extension ExercisesCategoryExtension on ExercisesCategory {
  static ExercisesCategory createEnum(String rawValue) {
    try {
      return ExercisesCategory.values.firstWhere((e) {
        return e.toString().replaceAll("ExercisesCategory.", "") == rawValue;
      });
    } on StateError {
      return ExercisesCategory.none;
    }
  }
}
