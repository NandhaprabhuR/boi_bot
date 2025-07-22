import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:collection/collection.dart';
import '../models/history_item.dart';
import '../services/storage_service.dart'; // Import the new service

class HistoryController extends GetxController {
  final _historyItems = <HistoryItem>[].obs;
  var selectedFilterDate = Rxn<DateTime>();
  final StorageService _storageService = StorageService();

  @override
  void onInit() {
    super.onInit();
    _loadHistoryFromStorage(); // Load history when the controller is initialized
  }

  void _loadHistoryFromStorage() async {
    _historyItems.value = await _storageService.loadHistory();
  }

  // A computed list that will be displayed in the UI (no changes here)
  List<dynamic> get displayList {
    // ... same as before
    List<HistoryItem> filteredItems;
    if (selectedFilterDate.value != null) {
      filteredItems = _historyItems.where((item) {
        final itemDate = DateTime(item.timestamp.year, item.timestamp.month, item.timestamp.day);
        final filterDate = DateTime(selectedFilterDate.value!.year, selectedFilterDate.value!.month, selectedFilterDate.value!.day);
        return itemDate.isAtSameMomentAs(filterDate);
      }).toList();
    } else {
      filteredItems = _historyItems.toList();
    }
    if (filteredItems.isEmpty) return [];
    final groupedByDate = groupBy(filteredItems, (HistoryItem item) => DateTime(item.timestamp.year, item.timestamp.month, item.timestamp.day));
    final listWithHeaders = <dynamic>[];
    final sortedDates = groupedByDate.keys.toList()..sort((a, b) => b.compareTo(a));
    for (var date in sortedDates) {
      listWithHeaders.add(date);
      listWithHeaders.addAll(groupedByDate[date]!);
    }
    return listWithHeaders;
  }

  // This method now also SAVES the history
  void addHistoryItem(HistoryItem item) {
    _historyItems.insert(0, item);
    _storageService.saveHistory(_historyItems); // Save the updated list
  }

  // No changes to filter methods
  Future<void> applyDateFilter(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedFilterDate.value ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      selectedFilterDate.value = pickedDate;
    }
  }

  void clearFilter() {
    selectedFilterDate.value = null;
  }
}