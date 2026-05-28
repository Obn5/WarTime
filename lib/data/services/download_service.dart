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
  final String description;

  const TopicPack({
    required this.name,
    required this.emoji,
    required this.categoryId,
    required this.description,
  });
}

class DownloadService {
  static const List<TopicPack> catalog = [
    // Entertainment
    TopicPack(name: 'Anime & Manga',       emoji: '🎌', categoryId: 31, description: 'Characters, series, and lore from the anime world.'),
    TopicPack(name: 'Video Games',         emoji: '🎮', categoryId: 15, description: 'Classics, titles, and gaming trivia.'),
    TopicPack(name: 'Movies',              emoji: '🎬', categoryId: 11, description: 'Hollywood, directors, and iconic scenes.'),
    TopicPack(name: 'Television',          emoji: '📺', categoryId: 14, description: 'TV shows, characters, and broadcast history.'),
    TopicPack(name: 'Music',               emoji: '🎵', categoryId: 12, description: 'Artists, albums, and music history.'),
    TopicPack(name: 'Cartoon & Animation', emoji: '🎞️', categoryId: 32, description: 'Western cartoons and animated series.'),
    TopicPack(name: 'Comics',              emoji: '💬', categoryId: 29, description: 'Superheroes, manga, and comic book lore.'),
    TopicPack(name: 'Board Games',         emoji: '🎲', categoryId: 16, description: 'Strategy, classics, and tabletop trivia.'),
    TopicPack(name: 'Musicals & Theatre',  emoji: '🎭', categoryId: 13, description: 'Broadway, West End, and stage productions.'),
    TopicPack(name: 'Books',               emoji: '📚', categoryId: 10, description: 'Literature, authors, and classic novels.'),
    TopicPack(name: 'Celebrities',         emoji: '⭐', categoryId: 26, description: 'Famous people, pop culture, and stars.'),
    // Science & Knowledge
    TopicPack(name: 'General Knowledge',   emoji: '🧠', categoryId:  9, description: 'A wide mix of trivia and fun facts.'),
    TopicPack(name: 'Science & Nature',    emoji: '🔬', categoryId: 17, description: 'Biology, physics, chemistry, and earth sciences.'),
    TopicPack(name: 'Computers',           emoji: '💻', categoryId: 18, description: 'Tech, programming, and computer science.'),
    TopicPack(name: 'Mathematics',         emoji: '📐', categoryId: 19, description: 'Numbers, logic, and mathematical puzzles.'),
    TopicPack(name: 'Gadgets',             emoji: '📱', categoryId: 30, description: 'Tech gadgets, devices, and inventions.'),
    // World & Culture
    TopicPack(name: 'History',             emoji: '🏛️', categoryId: 23, description: 'Ancient civilizations to modern events.'),
    TopicPack(name: 'Geography',           emoji: '🌍', categoryId: 22, description: 'Countries, capitals, and world landmarks.'),
    TopicPack(name: 'Mythology',           emoji: '⚡', categoryId: 20, description: 'Gods, heroes, and ancient legends.'),
    TopicPack(name: 'Politics',            emoji: '🗳️', categoryId: 24, description: 'Governments, elections, and world politics.'),
    TopicPack(name: 'Art',                 emoji: '🎨', categoryId: 25, description: 'Paintings, artists, and art movements.'),
    // Sports & Life
    TopicPack(name: 'Sports',              emoji: '⚽', categoryId: 21, description: 'Champions, records, and sports facts.'),
    TopicPack(name: 'Animals',             emoji: '🐾', categoryId: 27, description: 'Wildlife, pets, and animal kingdom trivia.'),
    TopicPack(name: 'Vehicles',            emoji: '🚗', categoryId: 28, description: 'Cars, planes, trains, and transport history.'),
  ];

  static Future<Topic?> downloadTopic(TopicPack pack, String difficulty) async {
    final uri = Uri.parse(
      'https://opentdb.com/api.php'
      '?amount=30'
      '&category=${pack.categoryId}'
      '&difficulty=$difficulty'
      '&type=multiple',
    );

    final response = await http.get(uri).timeout(const Duration(seconds: 15));
    if (response.statusCode != 200) return null;

    final data = json.decode(response.body) as Map<String, dynamic>;
    if ((data['response_code'] as int) != 0) return null;

    final results = data['results'] as List;
    if (results.isEmpty) return null;

    final questions = results
        .map((r) => _convertQuestion(r as Map<String, dynamic>))
        .toList();

    final diffLabel = _capitalize(difficulty);
    return Topic(
      id: '${pack.name.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '_')}_$difficulty',
      name: '${pack.name} · $diffLabel',
      description: pack.description,
      difficulty: diffLabel,
      questions: questions,
    );
  }

  // Keep for backward compat (single-topic QuizSet)
  static Future<QuizSet?> download(TopicPack pack) async {
    final topic = await downloadTopic(pack, 'medium');
    if (topic == null) return null;
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
