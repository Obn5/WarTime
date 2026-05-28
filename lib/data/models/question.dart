class Question {
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;
  final String? category;
  final String? formula;
  final List<String> tags;

  const Question({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
    this.category,
    this.formula,
    this.tags = const [],
  });

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        question: json['question'] as String,
        options: List<String>.from(json['options'] as List),
        correctIndex: json['correct'] as int,
        explanation: json['explanation'] as String,
        category: json['category'] as String?,
        formula: json['formula'] as String?,
        tags: json['tags'] != null
            ? List<String>.from(json['tags'] as List)
            : const [],
      );
}
