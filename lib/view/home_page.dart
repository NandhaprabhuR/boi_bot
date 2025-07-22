import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../models/customer.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SMS Sender Bot'),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Error message display
            Obx(() {
              if (controller.errorMessage.isNotEmpty) {
                return Container(
                  padding: const EdgeInsets.all(12.0),
                  margin: const EdgeInsets.only(bottom: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Colors.red.shade700, width: 1.5),
                  ),
                  child: Text(
                    controller.errorMessage.value,
                    style: TextStyle(color: Colors.red.shade800, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                );
              }
              return const SizedBox.shrink();
            }),

            // Message input field
            TextField(
              onChanged: controller.updateMessage,
              decoration: InputDecoration(
                labelText: 'Message to send',
                hintText: 'Enter your message here...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.message, color: Colors.blueAccent),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              ),
              maxLines: 5,
              minLines: 3,
              keyboardType: TextInputType.multiline,
            ),
            const SizedBox(height: 20),

            // Buttons
            Obx(() => ElevatedButton.icon(
                  onPressed: controller.isLoading.value ? null : () => controller.importContacts(context),
                  icon: controller.isLoading.value && controller.customers.isEmpty
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Icon(Icons.upload_file),
                  label: controller.isLoading.value && controller.customers.isEmpty ? const Text('Importing...') : const Text('Import Contacts from Excel'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                )),
            const SizedBox(height: 10),

            Obx(() => ElevatedButton.icon(
                  onPressed: controller.isLoading.value || controller.customers.isEmpty || controller.messageToSend.value.trim().isEmpty
                      ? null
                      : () => controller.sendSmsToAll(context),
                  icon: controller.isLoading.value && controller.customers.isNotEmpty
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Icon(Icons.send),
                  label: controller.isLoading.value && controller.customers.isNotEmpty ? const Text('Launching SMS Apps...') : const Text('Launch SMS for All Contacts'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                )),
            const SizedBox(height: 20),

            // Contact List Section
            Expanded(
              child: Obx(() {
                if (controller.customers.isEmpty) {
                  return Center(
                    child: Text(
                      'Import an Excel file to see your contacts here.',
                      style: TextStyle(color: Colors.grey[600], fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
                      child: Text(
                        'Imported Contacts (${controller.customers.length})',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: controller.customers.length,
                        itemBuilder: (context, index) {
                          final customer = controller.customers[index];
                          return _buildContactCard(customer);
                        },
                      ),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard(Customer customer) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade50,
          child: Icon(Icons.person_outline, color: Colors.blue.shade700),
        ),
        title: Text(customer.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        subtitle: Text(customer.phoneNumber, style: TextStyle(color: Colors.grey.shade700, fontSize: 14)),
      ),
    );
  }
}

