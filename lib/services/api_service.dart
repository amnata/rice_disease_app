import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/result_model.dart';

class ApiService {
  // ⚠️ REMPLACEZ PAR L'IP DE VOTRE SERVEUR ⚠️
  static const String baseUrl = "http://192.168.1.100:5000";
  
  Future<ResultModel> predict(File imageFile) async {
    // Créer la requête multipart
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/predict'),
    );
    
    request.files.add(
      await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
        filename: 'image.jpg',
      ),
    );
    
    // Envoyer la requête
    final response = await request.send();
    final responseData = await response.stream.bytesToString();
    final json = jsonDecode(responseData);
    
    if (response.statusCode != 200) {
      throw Exception("Erreur API : ${json['error'] ?? 'Erreur inconnue'}");
    }
    
    return ResultModel.fromJson(json);
  }
  
  Future<bool> checkHealth() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/health'));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
