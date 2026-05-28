import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/quiz_set.dart';
import '../models/topic.dart';
import '../models/question.dart';

enum QuizPhase { idle, answering, revealing, quintetStats, complete }

class QuizProvider extends ChangeNotifier {
  QuizSet? _quizSet;
  Topic? _selectedTopic;
  List<Question> _questions = [];
  int _currentIndex = 0;
  int _correctStreak = 0;
  int _totalCorrect = 0;
  int _totalAttempts = 0;
  int? _selectedAnswer;
  QuizPhase _phase = QuizPhase.idle;

  // Quintet (every 5 questions)
  int _quintetCount = 0;
  int _quintetCorrect = 0;
  final List<Map<String, dynamic>> _quintetHistory = [];

  // XP / level (persists across quizzes in session)
  int _xp = 0;

  // Per-quiz stats
  int _bestStreak = 0;
  int _totalTimeMs = 0;
  DateTime? _questionStart;

  // Getters
  QuizSet? get quizSet => _quizSet;
  Topic? get selectedTopic => _selectedTopic;
  Question? get currentQuestion =>
      _questions.isEmpty ? null : _questions[_currentIndex];
  int get correctStreak => _correctStreak;
  int get totalCorrect => _totalCorrect;
  int get totalAttempts => _totalAttempts;
  int? get selectedAnswer => _selectedAnswer;
  QuizPhase get phase => _phase;
  int get quintetCorrect => _quintetCorrect;
  List<Map<String, dynamic>> get quintetHistory =>
      List.unmodifiable(_quintetHistory);
  int get bestStreak => _bestStreak;
  int get totalTimeMs => _totalTimeMs;
  int get xp => _xp;
  int get level => (_xp ~/ 100) + 1;
  double get accuracy =>
      _totalAttempts == 0 ? 0.0 : _totalCorrect / _totalAttempts;
  int get avgTimeMs =>
      _totalAttempts == 0 ? 0 : (_totalTimeMs / _totalAttempts).round();

  void loadFromJson(String jsonString) {
    try {
      final data = json.decode(jsonString) as Map<String, dynamic>;
      _quizSet = QuizSet.fromJson(data);
      _selectedTopic = null;
      _phase = QuizPhase.idle;
      notifyListeners();
    } catch (e) {
      debugPrint('JSON parse error: $e');
    }
  }

  void selectTopic(Topic topic) {
    _selectedTopic = topic;
    notifyListeners();
  }

  void startQuiz() {
    if (_selectedTopic == null) return;
    _questions = List.from(_selectedTopic!.questions)..shuffle(Random());
    _currentIndex = 0;
    _correctStreak = 0;
    _totalCorrect = 0;
    _totalAttempts = 0;
    _selectedAnswer = null;
    _quintetCount = 0;
    _quintetCorrect = 0;
    _quintetHistory.clear();
    _bestStreak = 0;
    _totalTimeMs = 0;
    _questionStart = DateTime.now();
    _phase = QuizPhase.answering;
    notifyListeners();
  }

  void submitAnswer(int index) {
    if (_phase != QuizPhase.answering || _selectedAnswer != null) return;

    if (_questionStart != null) {
      _totalTimeMs +=
          DateTime.now().difference(_questionStart!).inMilliseconds;
    }

    _selectedAnswer = index;
    _totalAttempts++;
    _quintetCount++;

    final isCorrect = index == _questions[_currentIndex].correctIndex;
    if (isCorrect) {
      _totalCorrect++;
      _correctStreak++;
      _quintetCorrect++;
      _xp += 10;
      if (_correctStreak > _bestStreak) _bestStreak = _correctStreak;
    } else {
      _correctStreak = 0;
    }

    _phase = QuizPhase.revealing;
    notifyListeners();
  }

  void nextQuestion() {
    if (_correctStreak >= 10) {
      _phase = QuizPhase.complete;
      notifyListeners();
      return;
    }
    if (_quintetCount >= 5) {
      _quintetHistory.add({
        'correct': _quintetCorrect,
        'total': _quintetCount,
        'streak': _correctStreak,
      });
      _quintetCount = 0;
      _quintetCorrect = 0;
      _phase = QuizPhase.quintetStats;
      notifyListeners();
      return;
    }
    _advance();
  }

  void continueAfterQuintet() => _advance();

  void _advance() {
    _currentIndex = (_currentIndex + 1) % _questions.length;
    _selectedAnswer = null;
    _questionStart = DateTime.now();
    _phase = QuizPhase.answering;
    notifyListeners();
  }

  void reset() {
    _selectedTopic = null;
    _selectedAnswer = null;
    _phase = QuizPhase.idle;
    notifyListeners();
  }
}
