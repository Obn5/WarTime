import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../models/question.dart';
import '../models/quiz_set.dart';
import '../models/topic.dart';

class TopicPack {
  final String name;
  final String emoji;
  final int categoryId;
  final String difficulty;
  final int amount;
  final String description;

  const TopicPack({
    required this.name,
    required this.emoji,
    required this.categoryId,
    required this.difficulty,
    required this.amount,
    required this.description,
  });
}

class DownloadService {
  static const List<TopicPack> catalog = [
    TopicPack(
      name: 'Anime & Manga',
      emoji: '🎌',
      categoryId: 31,
      difficulty: 'medium',
      amount: 30,
      description: 'Characters, series, and lore from the anime world.',
    ),
    TopicPack(
      name: 'Video Games',
      emoji: '🎮',
      categoryId: 15,
      difficulty: 'medium',
      amount: 30,
      description: 'Classics, titles, and gaming trivia.',
    ),
    TopicPack(
      name: 'Movies',
      emoji: '🎬',
      categoryId: 11,
      difficulty: 'medium',
      amount: 30,
      description: 'Hollywood, directors, and iconic scenes.',
    ),
    TopicPack(
      name: 'Science & Nature',
      emoji: '🔬',
      categoryId: 17,
      difficulty: 'medium',
      amount: 30,
      description: 'Biology, physics, chemistry, and earth sciences.',
    ),
    TopicPack(
      name: 'History',
      emoji: '🏛️',
      categoryId: 23,
      difficulty: 'medium',
      amount: 30,
      description: 'Ancient civilizations to modern events.',
    ),
    TopicPack(
      name: 'Geography',
      emoji: '🌍',
      categoryId: 22,
      difficulty: 'medium',
      amount: 30,
      description: 'Countries, capitals, and world landmarks.',
    ),
    TopicPack(
      name: 'Music',
      emoji: '🎵',
      categoryId: 12,
      difficulty: 'medium',
      amount: 30,
      description: 'Artists, albums, and music history.',
    ),
    TopicPack(
      name: 'Sports',
      emoji: '⚽',
      categoryId: 21,
      difficulty: 'medium',
      amount: 30,
      description: 'Champions, records, and sports facts.',
    ),
    TopicPack(
      name: 'Computers',
      emoji: '💻',
      categoryId: 18,
      difficulty: 'medium',
      amount: 30,
      description: 'Tech, programming, and computer science.',
    ),
    TopicPack(
      name: 'Mythology',
      emoji: '⚡',
      categoryId: 20,
      difficulty: 'medium',
      amount: 30,
      description: 'Gods, heroes, and ancient legends.',
    ),
  ];

  static Future<QuizSet?> download(TopicPack pack) async {
    final uri = Uri.parse(
      'https://opentdb.com/api.php'
      '?amount=${pack.amount}'
      '&category=${pack.categoryId}'
      '&difficulty=${pack.difficulty}'
      '&type=multiple',
    );

    final response = await http.get(uri).timeout(const Duration(seconds: 15));
    if (response.statusCode != 200) return null;

    final data = json.decode(response.body) as Map<String, dynamic>;
    if ((data['response_code'] as int) != 0) return null;

    final results = data['results'] as List;
    final questions = results
        .map((r) => _convertQuestion(r as Map<String, dynamic>))
        .toList();

    final topic = Topic(
      id: pack.name.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '_'),
      name: pack.name,
      description: pack.description,
      difficulty: _capitalize(pack.difficulty),
      questions: questions,
    );

    return QuizSet(name: pack.name, topics: [topic]);
  }

  static Question _convertQuestion(Map<String, dynamic> raw) {
    final question = _decode(raw['question'] as String);
    final correct = _decode(raw['correct_answer'] as String);
    final wrongs = (raw['incorrect_answers'] as List)
        .map((e) => _decode(e as String))
        .toList();

    final options = [...wrongs, correct]..shuffle(Random());
    final correctIndex = options.indexOf(correct);

    final category = (raw['category'] as String? ?? '');
    final tag = category
        .split(':')
        .last
        .trim()
        .toUpperCase()
        .replaceAll(RegExp(r'[^A-Z0-9]'), '_');

    return Question(
      question: question,
      options: options,
      correctIndex: correctIndex,
      explanation: 'The correct answer is: $correct',
      tags: [tag],
    );
  }

  static String _decode(String s) => s
      .replaceAll('&amp;', '&')
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .replaceAll('&quot;', '"')
      .replaceAll('&#039;', "'")
      .replaceAll('&ldquo;', '“')
      .replaceAll('&rdquo;', '”')
      .replaceAll('&lsquo;', '‘')
      .replaceAll('&rsquo;', '’')
      .replaceAll('&hellip;', '…')
      .replaceAll('&ndash;', '–')
      .replaceAll('&mdash;', '—')
      .replaceAll('&eacute;', 'é')
      .replaceAll('&egrave;', 'è')
      .replaceAll('&agrave;', 'à')
      .replaceAll('&aacute;', 'á')
      .replaceAll('&uuml;', 'ü')
      .replaceAll('&ouml;', 'ö')
      .replaceAll('&auml;', 'ä')
      .replaceAll('&ntilde;', 'ñ');

  static String _capitalize(String s) =>
      s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';
}
