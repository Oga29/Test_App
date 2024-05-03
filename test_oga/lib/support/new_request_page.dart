import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:test_oga/support/support_request_bloc.dart';

class NewRequestPage extends StatefulWidget {
  const NewRequestPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  NewRequestPageState createState() => NewRequestPageState();
}

class NewRequestPageState extends State<NewRequestPage> {
  final TextEditingController messageController = TextEditingController();
  List<String> selectedImages = [];
  List<String> selectedDocuments = [];

  void _selectImages() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );
    if (result != null) {
      setState(() {
        selectedImages = result.paths.where((path) => path != null).toList().cast<String>();
      });
    }
  }

  void _selectDocuments() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: true,
    );
    if (result != null) {
      setState(() {
        selectedDocuments = result.paths.where((path) => path != null).toList().cast<String>();
      });
    }
  }

  @override
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Support Request'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: messageController,
              decoration: const InputDecoration(labelText: 'Message'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _selectImages,
              child: const Text('Select Images'),
            ),
            ElevatedButton(
              onPressed: _selectDocuments,
              child: const Text('Select PDF Documents'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final message = messageController.text;
                if (message.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a message')),
                  );
                } else {
                  BlocProvider.of<SupportRequestBloc>(context).add(
                    CreateRequestEvent(
                      message: message,
                      images: selectedImages,
                      documents: selectedDocuments,
                    ),
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text('Create Support Request'),
            ),
          ],
        ),
      ),
    );
  }
}
