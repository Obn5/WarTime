import 'dart:math';
import 'package:flutter/foundation.dart';
import '../core/constants.dart';
import '../data/models/question.dart';
import '../data/models/quiz_set.dart';
import '../data/models/topic.dart';

enum QuizPhase { idle, answering, revealing, quintetStats, levelComplete, complete }

class QuizProvider extends ChangeNotifier {
  QuizSet? _quizSet;
  Topic? _selectedTopic;
  List<Question> _allTopicQuestions = [];
  List<Question> _questions = [];
  int _currentIndex = 0;
  int _correctStreak = 0;
  int _totalCorrect = 0;
  int _totalAttempts = 0;
  int? _selectedAnswer;
  QuizPhase _phase = QuizPhase.idle;

  // Level system
  int _levelIndex = 0;
  bool _isLeveledTopic = false;
  final Set<int> _seenIndices = {};
  static const int _levelSize = 20;

  // Quintet tracking
  int _quintetCount = 0;
  int _quintetCorrect = 0;
  final List<Map<String, dynamic>> _quintetHistory = [];

  // XP / level (session-wide)
  int _xp = 0;

  // Per-quiz stats
  int _bestStreak = 0;
  int _totalTimeMs = 0;
  DateTime? _questionStart;

  // ── Getters ───────────────────────────────────────────────
  QuizSet? get quizSet => _quizSet;
  Topic? get selectedTopic => _selectedTopic;
  Question? get currentQuestion =>
      _questions.isEmpty ? null : _questions[_currentIndex];
  int get correctStreak => _correctStreak;
  int get totalCorrect => _totalCorrect;
  int get totalAttempts => _totalAttempts;
  int? get selectedAnswer => _selectedAnswer;
  QuizPhase get phase => _phase;
  List<Map<String, dynamic>> get quintetHistory =>
      List.unmodifiable(_quintetHistory);
  int get bestStreak => _bestStreak;
  int get totalTimeMs => _totalTimeMs;
  int get xp => _xp;
  int get level => (_xp ~/ AppConstants.xpPerLevel) + 1;
  double get accuracy =>
      _totalAttempts == 0 ? 0.0 : _totalCorrect / _totalAttempts;
  int get avgTimeMs =>
      _totalAttempts == 0 ? 0 : (_totalTimeMs / _totalAttempts).round();

  // Level getters
  bool get isLeveledTopic => _isLeveledTopic;
  int get currentLevelIndex => _levelIndex;
  int get totalLevels => _isLeveledTopic
      ? (_allTopicQuestions.length / _levelSize).ceil()
      : 1;
  bool get hasNextLevel => _isLeveledTopic && _levelIndex < totalLevels - 1;
  int get levelQuestionsTotal => _questions.length;
  int get levelQuestionsSeen => _seenIndices.length;

  // ── Actions ───────────────────────────────────────────────

  void loadQuizSet(QuizSet quizSet) {
    _quizSet = quizSet;
    _selectedTopic = null;
    _phase = QuizPhase.idle;
    notifyListeners();
  }

  void selectTopic(Topic topic) {
    _selectedTopic = topic;
    notifyListeners();
  }

  void startQuiz() {
    if (_selectedTopic == null) return;
    _allTopicQuestions = List.from(_selectedTopic!.questions);
    _isLeveledTopic = _allTopicQuestions.length >= 100;
    _levelIndex = 0;
    _xp = 0;
    _bestStreak = 0;
    _totalTimeMs = 0;
    _totalCorrect = 0;
    _totalAttempts = 0;
    _loadLevel();
  }

  void _loadLevel() {
    if (_isLeveledTopic) {
      final start = _levelIndex * _levelSize;
      final end = min(start + _levelSize, _allTopicQuestions.length);
      _questions =
          List.from(_allTopicQuestions.sublist(start, end))..shuffle(Random());
    } else {
      _questions = List.from(_allTopicQuestions)..shuffle(Random());
    }
    _currentIndex = 0;
    _correctStreak = 0;
    _selectedAnswer = null;
    _quintetCount = 0;
    _quintetCorrect = 0;
    _quintetHistory.clear();
    _seenIndices.clear();
    _questionStart = DateTime.now();
    _phase = QuizPhase.answering;
    notifyListeners();
  }

  void advanceToNextLevel() {
    _levelIndex++;
    _loadLevel();
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
    _seenIndices.add(_currentIndex);

    final isCorrect = index == _questions[_currentIndex].correctIndex;
    if (isCorrect) {
      _totalCorrect++;
      _correctStreak++;
      _quintetCorrect++;
      _xp += AppConstants.xpPerCorrect;
      if (_correctStreak > _bestStreak) _bestStreak = _correctStreak;
    } else {
      _correctStreak = 0;
    }

    _phase = QuizPhase.revealing;
    notifyListeners();
  }

  void nextQuestion() {
    // Streak goal reached
    if (_correctStreak >= AppConstants.streakGoal) {
      _phase = hasNextLevel ? QuizPhase.levelComplete : QuizPhase.complete;
      notifyListeners();
      return;
    }
    // All level questions seen → level complete
    if (_isLeveledTopic && _seenIndices.length >= _questions.length) {
      _phase = hasNextLevel ? QuizPhase.levelComplete : QuizPhase.complete;
      notifyListeners();
      return;
    }
    // Quintet checkpoint
    if (_quintetCount >= AppConstants.quintetSize) {
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

  void reset() {
    _selectedTopic = null;
    _selectedAnswer = null;
    _phase = QuizPhase.idle;
    notifyListeners();
  }

  void _advance() {
    _currentIndex = (_currentIndex + 1) % _questions.length;
    _selectedAnswer = null;
    _questionStart = DateTime.now();
    _phase = QuizPhase.answering;
    notifyListeners();
  }
}
