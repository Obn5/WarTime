import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class SavedQuizMeta {
  final String name;
  final String filename;
  final DateTime savedAt;

  SavedQuizMeta({
    required this.name,
    required this.filename,
    required this.savedAt,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'filename': filename,
        'savedAt': savedAt.toIso8601String(),
      };

  factory SavedQuizMeta.fromJson(Map<String, dynamic> j) => SavedQuizMeta(
        name: j['name'] as String,
        filename: j['filename'] as String,
        savedAt: DateTime.parse(j['savedAt'] as String),
      );
}

class SavedQuizService {
  static const _indexName = 'saved_index.json';

  static Future<Directory> _quizDir() async {
    final base = await getApplicationDocumentsDirectory();
    final dir = Directory('${base.path}/saved_quizzes');
    if (!await dir.exists()) await dir.create(recursive: true);
    return dir;
  }

  static Future<File> _indexFile() async {
    final dir = await _quizDir();
    return File('${dir.path}/$_indexName');
  }

  static Future<List<SavedQuizMeta>> list() async {
    try {
      final f = await _indexFile();
      if (!await f.exists()) return [];
      final raw = await f.readAsString();
      final list = json.decode(raw) as List;
      return list
          .map((e) => SavedQuizMeta.fromJson(e as Map<String, dynamic>))
          .toList()
        ..sort((a, b) => b.savedAt.compareTo(a.savedAt));
    } catch (_) {
      return [];
    }
  }

  static Future<void> save(String name, String rawJson) async {
    final dir = await _quizDir();
    final ts = DateTime.now().millisecondsSinceEpoch;
    final safe = name.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');
    final filename = '${safe}_$ts.json';

    await File('${dir.path}/$filename').writeAsString(rawJson);

    final metas = await list();
    // avoid duplicate names — keep latest only
    metas.removeWhere((m) => m.name == name);
    metas.insert(
        0, SavedQuizMeta(name: name, filename: filename, savedAt: DateTime.now()));

    final idx = await _indexFile();
    await idx.writeAsString(
        json.encode(metas.map((e) => e.toJson()).toList()));
  }

  static Future<String?> readContent(String filename) async {
    try {
      final dir = await _quizDir();
      final f = File('${dir.path}/$filename');
      if (!await f.exists()) return null;
      return await f.readAsString();
    } catch (_) {
      return null;
    }
  }

  static Future<void> delete(String filename) async {
    final dir = await _quizDir();
    final f = File('${dir.path}/$filename');
    if (await f.exists()) await f.delete();

    final metas = await list();
    metas.removeWhere((m) => m.filename == filename);
    final idx = await _indexFile();
    await idx.writeAsString(
        json.encode(metas.map((e) => e.toJson()).toList()));
  }
}
