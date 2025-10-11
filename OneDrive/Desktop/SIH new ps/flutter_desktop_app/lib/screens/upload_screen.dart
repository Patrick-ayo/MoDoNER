import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class UploadScreen extends StatefulWidget {
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  PlatformFile? _pickedFile;
  String? _projectType;
  String _language = 'English';

  void _pickFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf','doc','docx']);
    if (result != null) {
      setState(() => _pickedFile = result.files.first);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Upload DPR Document', style: Theme.of(context).textTheme.displayMedium),
          SizedBox(height: 8),
          Text('Upload your DPR for AI-powered assessment', style: Theme.of(context).textTheme.bodyMedium),
          SizedBox(height: 24),
          
          // Upload Guidelines
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Upload Guidelines', style: Theme.of(context).textTheme.headlineSmall),
                  SizedBox(height: 8),
                  Text('• Supported formats: PDF, DOC, DOCX'),
                  Text('• Max file size: 50 MB'),
                  Text('• Languages: English, Hindi, Assamese'),
                  Text('• Processing: 2-4 hours'),
                ],
              ),
            ),
          ),
          
          SizedBox(height: 16),

          // File picker
          GestureDetector(
            onTap: _pickFile,
            child: Container(
              width: double.infinity,
              height: 120,
              alignment: Alignment.center,
              decoration: BoxDecoration(border: Border.all(color: Theme.of(context).colorScheme.primary), borderRadius: BorderRadius.circular(8)),
              child: _pickedFile == null
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
Icon(Icons.report, size: 40, color: Theme.of(context).textTheme.titleMedium?.color),
                      SizedBox(height: 8),
                      Text('Tap to select DPR document', style: TextStyle(color: Theme.of(context).textTheme.titleMedium?.color)),
                    ],
                  )
                : Text(_pickedFile!.name),
            ),
          ),

          SizedBox(height: 16),

          // Project Type
          Text('Project Type *', style: Theme.of(context).textTheme.titleMedium),
          Wrap(
            spacing: 8,
            children: ['Road Construction','Healthcare','Tourism','Education','Infrastructure']
              .map((type) => ChoiceChip(
                label: Text(type),
                selected: _projectType==type,
                onSelected: (_) => setState(() => _projectType = type),
              )).toList(),
          ),

          SizedBox(height: 16),

          // Language
          Text('Document Language', style: Theme.of(context).textTheme.titleMedium),
          Wrap(
            spacing: 8,
            children: ['English','Hindi','Assamese']
              .map((lang) => ChoiceChip(
                label: Text(lang),
                selected: _language==lang,
                onSelected: (_) => setState(() => _language = lang),
              )).toList(),
          ),

          SizedBox(height: 24),

          ElevatedButton(
            onPressed: (_pickedFile!=null && _projectType!=null) ? (){} : null,
            child: Text('Upload & Start Assessment'),
          ),
        ],
      ),
    );
  }
}
