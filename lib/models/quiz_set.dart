import 'topic.dart';

class QuizSet {
  final String name;
  final List<Topic> topics;

  const QuizSet({required this.name, required this.topics});

  factory QuizSet.fromJson(Map<String, dynamic> json) => QuizSet(
        name: json['name'] as String,
        topics: (json['topics'] as List)
            .map((t) => Topic.fromJson(t as Map<String, dynamic>))
            .toList(),
      );
}
