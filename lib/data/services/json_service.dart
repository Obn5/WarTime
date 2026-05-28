import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import '../../core/constants.dart';
import '../models/quiz_set.dart';
import 'saved_quiz_service.dart';

class JsonService {
  static QuizSet? parse(String jsonString) {
    try {
      final data = json.decode(jsonString) as Map<String, dynamic>;
      return QuizSet.fromJson(data);
    } catch (_) {
      return null;
    }
  }

  static Future<QuizSet?> loadSample() async {
    final raw = await rootBundle.loadString(AppConstants.sampleAssetPath);
    return parse(raw);
  }

  static Future<QuizSet?> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
      withData: true,
    );
    if (result == null || result.files.single.bytes == null) return null;
    final raw = utf8.decode(result.files.single.bytes!);
    final quizSet = parse(raw);
    if (quizSet != null) {
      await SavedQuizService.save(quizSet.name, raw);
    }
    return quizSet;
  }

  static Future<QuizSet?> loadSaved(SavedQuizMeta meta) async {
    final raw = await SavedQuizService.readContent(meta.filename);
    if (raw == null) return null;
    return parse(raw);
  }
}
