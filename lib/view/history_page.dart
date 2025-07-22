import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/history_controller.dart';
import '../models/history_item.dart';

class HistoryPage extends StatelessWidget {
  HistoryPage({super.key});

  final HistoryController historyController = Get.find<HistoryController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        backgroundColor: Colors.black,
        actions: [
          Obx(() => IconButton(
                icon: Icon(
                  Icons.filter_list,
                  color: historyController.selectedFilterDate.value != null ? Colors.amberAccent : Colors.white,
                ),
                tooltip: 'Filter by Date',
                onPressed: () => historyController.applyDateFilter(context),
              )),
          Obx(() {
            if (historyController.selectedFilterDate.value == null) {
              return const SizedBox.shrink();
            }
            return IconButton(
              icon: const Icon(Icons.clear),
              tooltip: 'Clear Filter',
              onPressed: () => historyController.clearFilter(),
            );
          }),
        ],
      ),
      body: Obx(() {
        final displayList = historyController.displayList;
        if (displayList.isEmpty) {
          return Center(
            child: Text(
              historyController.selectedFilterDate.value != null ? 'No messages found for this date.' : 'No messages have been sent yet.',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: displayList.length,
          itemBuilder: (context, index) {
            final item = displayList[index];
            if (item is DateTime) {
              return _buildDateHeader(item, context);
            }
            if (item is HistoryItem) {
              return _buildHistoryCard(item);
            }
            return const SizedBox.shrink();
          },
        );
      }),
    );
  }

  Widget _buildDateHeader(DateTime date, BuildContext context) {
    String formattedDate;
    final today = DateTime.now();
    final yesterday = today.subtract(const Duration(days: 1));

    if (date.year == today.year && date.month == today.month && date.day == today.day) {
      formattedDate = 'Today';
    } else if (date.year == yesterday.year && date.month == yesterday.month && date.day == yesterday.day) {
      formattedDate = 'Yesterday';
    } else {
      formattedDate = DateFormat.yMMMMd().format(date);
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      child: Text(
        formattedDate,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.black54, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildHistoryCard(HistoryItem item) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.blueAccent,
          child: Icon(Icons.person, color: Colors.white),
        ),
        title: Text(item.customer.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.customer.phoneNumber),
            const SizedBox(height: 4),
            Text('Message: "${item.message}"', style: const TextStyle(fontStyle: FontStyle.italic)),
            const SizedBox(height: 4),
            Text(
              'Sent: ${DateFormat.jm().format(item.timestamp.toLocal())}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}