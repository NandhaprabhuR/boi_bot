import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/history_item.dart';

class StorageService {
  static const _historyKey = 'sms_history';

  // Save the entire history list to storage
  Future<void> saveHistory(List<HistoryItem> history) async {
    final prefs = await SharedPreferences.getInstance();
    // 1. Convert each HistoryItem object to a JSON map, then encode it to a string.
    final List<String> historyJson =
        history.map((item) => jsonEncode(item.toJson())).toList();
    // 2. Save the list of JSON strings to shared_preferences.
    await prefs.setStringList(_historyKey, historyJson);
  }

  // Load the history list from storage
  Future<List<HistoryItem>> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    // 1. Get the list of JSON strings from shared_preferences.
    final List<String>? historyJson = prefs.getStringList(_historyKey);

    if (historyJson == null) {
      return []; // Return an empty list if nothing is saved yet
    }

    // 2. Decode each JSON string back into a HistoryItem object.
    return historyJson
        .map((item) => HistoryItem.fromJson(jsonDecode(item)))
        .toList();
  }
}