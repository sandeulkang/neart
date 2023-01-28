import 'dart:convert';
import 'model_json.dart';

List<JsonModel> parseJson(String responseBody) {
  final parsed = jsonDecode(jsonEncode(responseBody)).cast<Map<String, dynamic>();
  return parsed.map<JsonModel>((json) => JsonModel.fromJson(json)).toList();
}