import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SMS Sender Bot (Gateway)'), // Updated title
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (controller.errorMessage.isNotEmpty)
                Container(
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
                ),

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

              ElevatedButton.icon(
                onPressed: controller.isLoading.value ? null : () => controller.importContacts(context),
                icon: controller.isLoading.value && controller.customers.isEmpty
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Icon(Icons.upload_file),
                label: controller.isLoading.value && controller.customers.isEmpty
                    ? const Text('Importing...')
                    : const Text('Import Contacts from Excel'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  elevation: 5,
                ),
              ),
              const SizedBox(height: 10),

              Text(
                '${controller.customers.length} contacts imported.',
                style: const TextStyle(fontSize: 16, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Changed button text for clarity
              ElevatedButton.icon(
                onPressed: controller.isLoading.value || controller.customers.isEmpty || controller.messageToSend.value.trim().isEmpty
                    ? null
                    : controller.sendSmsToAll, // No context needed for gateway send
                icon: controller.isLoading.value && controller.customers.isNotEmpty
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Icon(Icons.send),
                label: controller.isLoading.value && controller.customers.isNotEmpty
                    ? const Text('Sending Bulk SMS...')
                    : const Text('Send Bulk SMS via Gateway'), // Updated button text
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  elevation: 5,
                ),
              ),
              const SizedBox(height: 20),

              Expanded(
                child: controller.customers.isEmpty
                    ? Center(
                        child: Text(
                          'No contacts to display. Import from Excel.',
                          style: TextStyle(color: Colors.grey[600], fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : ListView.builder(
                        itemCount: controller.customers.length,
                        itemBuilder: (context, index) {
                          final customer = controller.customers[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.blueAccent.withOpacity(0.1),
                                child: Icon(Icons.person, color: Colors.blueAccent),
                              ),
                              title: Text(customer.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              subtitle: Text(customer.phoneNumber, style: TextStyle(color: Colors.grey[700])),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}








// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../controllers/home_controller.dart';

// // HomePage is the main UI for the application.
// class HomePage extends StatelessWidget {
//   HomePage({Key? key}) : super(key: key);

//   // Initialize the HomeController using Get.put
//   final HomeController controller = Get.put(HomeController());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('SMS Sender Bot'),
//         backgroundColor: Colors.blueAccent,
//         elevation: 0,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Obx(
//           () => Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               // Display error messages if any
//               if (controller.errorMessage.isNotEmpty)
//                 Container(
//                   padding: const EdgeInsets.all(12.0),
//                   margin: const EdgeInsets.only(bottom: 16.0),
//                   decoration: BoxDecoration(
//                     color: Colors.red.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(10.0),
//                     border: Border.all(color: Colors.red.shade700, width: 1.5),
//                   ),
//                   child: Text(
//                     controller.errorMessage.value,
//                     style: TextStyle(color: Colors.red.shade800, fontWeight: FontWeight.bold),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),

//               // Message input field
//               TextField(
//                 onChanged: controller.updateMessage,
//                 decoration: InputDecoration(
//                   labelText: 'Message to send',
//                   hintText: 'Enter your message here...',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12.0),
//                     borderSide: BorderSide.none, // No border for a cleaner look
//                   ),
//                   prefixIcon: const Icon(Icons.message, color: Colors.blueAccent),
//                   filled: true,
//                   fillColor: Colors.grey[100],
//                   contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
//                 ),
//                 maxLines: 5,
//                 minLines: 3,
//                 keyboardType: TextInputType.multiline,
//               ),
//               const SizedBox(height: 20),

//               // Import Contacts Button
//               ElevatedButton.icon(
//                 onPressed: controller.isLoading.value ? null : () => controller.importContacts(context), // Pass context
//                 icon: controller.isLoading.value && controller.customers.isEmpty // Only show loading for import
//                     ? const SizedBox(
//                         width: 20,
//                         height: 20,
//                         child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
//                       )
//                     : const Icon(Icons.upload_file),
//                 label: controller.isLoading.value && controller.customers.isEmpty
//                     ? const Text('Importing...')
//                     : const Text('Import Contacts from Excel'),
//                 style: ElevatedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(vertical: 15),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12.0),
//                   ),
//                   backgroundColor: Colors.green,
//                   foregroundColor: Colors.white,
//                   textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   elevation: 5,
//                 ),
//               ),
//               const SizedBox(height: 10),

//               // Display imported contacts count
//               Text(
//                 '${controller.customers.length} contacts imported.',
//                 style: const TextStyle(fontSize: 16, color: Colors.black87),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 20),

//               // Send SMS Button
//               ElevatedButton.icon(
//                 onPressed: controller.isLoading.value || controller.customers.isEmpty || controller.messageToSend.value.trim().isEmpty
//                     ? null // Disable if loading, no contacts, or no message
//                     : () => controller.sendSmsToAll(context), // Pass context
//                 icon: controller.isLoading.value && controller.customers.isNotEmpty // Only show loading for send
//                     ? const SizedBox(
//                         width: 20,
//                         height: 20,
//                         child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
//                       )
//                     : const Icon(Icons.send),
//                 label: controller.isLoading.value && controller.customers.isNotEmpty
//                     ? const Text('Launching SMS Apps...')
//                     : const Text('Launch SMS for All Contacts'),
//                 style: ElevatedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(vertical: 15),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12.0),
//                   ),
//                   backgroundColor: Colors.blueAccent,
//                   foregroundColor: Colors.white,
//                   textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   elevation: 5,
//                 ),
//               ),
//               const SizedBox(height: 20),

//               // Optional: Display list of imported contacts
//               Expanded(
//                 child: controller.customers.isEmpty
//                     ? Center(
//                         child: Text(
//                           'No contacts to display. Import from Excel.',
//                           style: TextStyle(color: Colors.grey[600], fontSize: 16),
//                           textAlign: TextAlign.center,
//                         ),
//                       )
//                     : ListView.builder(
//                         itemCount: controller.customers.length,
//                         itemBuilder: (context, index) {
//                           final customer = controller.customers[index];
//                           return Card(
//                             margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
//                             elevation: 3,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12.0),
//                             ),
//                             child: ListTile(
//                               leading: CircleAvatar(
//                                 backgroundColor: Colors.blueAccent.withOpacity(0.1),
//                                 child: Icon(Icons.person, color: Colors.blueAccent),
//                               ),
//                               title: Text(customer.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//                               subtitle: Text(customer.phoneNumber, style: TextStyle(color: Colors.grey[700])),
//                             ),
//                           );
//                         },
//                       ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }