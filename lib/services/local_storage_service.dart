import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/result_model.dart';

class LocalStorageService {
  static const String _historyKey = 'analysis_history';
  
  static Future<void> saveAnalysis(ResultModel result, File imageFile) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getAnalysisHistory();
    
    // Sauvegarder l'image localement
    final appDir = await getApplicationDocumentsDirectory();
    final imageDir = Directory('${appDir.path}/analyses');
    if (!await imageDir.exists()) {
      await imageDir.create(recursive: true);
    }
    
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final imagePath = '${imageDir.path}/$timestamp.jpg';
    await imageFile.copy(imagePath);
    
    // Sauvegarder les métadonnées
    final analysis = {
      'id': timestamp,
      'imagePath': imagePath,
      'result': result.toJson(),
      'date': DateTime.now().toIso8601String(),
    };
    
    history.insert(0, analysis);
    // Garder seulement les 50 dernières analyses
    if (history.length > 50) {
      history.removeLast();
    }
    
    final jsonList = history.map((e) => jsonEncode(e)).toList();
    await prefs.setStringList(_historyKey, jsonList);
  }
  
  static Future<List<Map<String, dynamic>>> getAnalysisHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_historyKey) ?? [];
    
    return jsonList.map((jsonStr) {
      final Map<String, dynamic> decoded = jsonDecode(jsonStr);
      // Convertir le résultat en ResultModel
      decoded['result'] = ResultModel.fromJson(decoded['result']);
      return decoded;
    }).toList();
  }
  
  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
    
    // Supprimer les images
    final appDir = await getApplicationDocumentsDirectory();
    final imageDir = Directory('${appDir.path}/analyses');
    if (await imageDir.exists()) {
      await imageDir.delete(recursive: true);
    }
  }
}
