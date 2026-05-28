import 'question.dart';

class Topic {
  final String id;
  final String name;
  final String description;
  final String difficulty;
  final List<Question> questions;

  const Topic({
    required this.id,
    required this.name,
    this.description = '',
    this.difficulty = 'Medium',
    required this.questions,
  });

  factory Topic.fromJson(Map<String, dynamic> json) => Topic(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String? ?? '',
        difficulty: json['difficulty'] as String? ?? 'Medium',
        questions: (json['questions'] as List)
            .map((q) => Question.fromJson(q as Map<String, dynamic>))
            .toList(),
      );
}
