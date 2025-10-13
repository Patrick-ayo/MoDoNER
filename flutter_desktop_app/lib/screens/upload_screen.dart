import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import '../provider/analysis_provider.dart';
import 'analysis_screen.dart';

class UploadScreen extends StatefulWidget {
  final PlatformFile? initialFile;

  const UploadScreen({super.key, this.initialFile});

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  PlatformFile? _pickedFile;
  String? _projectType;
  String _docType = 'DPR';
  final _commentCtrl = TextEditingController();
  String _language = 'English';

  @override
  void initState() {
    super.initState();
    _pickedFile = widget.initialFile;
  }

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  void _pickFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf','doc','docx']);
    if (result != null) {
      setState(() => _pickedFile = result.files.first);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/logo.png', width: 36, height: 36, errorBuilder: (_, __, ___) => const Icon(Icons.upload_file)),
            const SizedBox(width: 12),
            const Text('Upload DPR Document'),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Upload your DPR for AI-powered assessment', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 16),

            // Upload Guidelines
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Upload Guidelines', style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 8),
                    const Text('• Supported formats: PDF, DOC, DOCX'),
                    const Text('• Max file size: 50 MB'),
                    const Text('• Languages: English, Hindi, Assamese'),
                    const Text('• Processing: 2-4 hours'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // File picker area
            InkWell(
              onTap: _pickFile,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: double.infinity,
                height: 140,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withAlpha((0.04 * 255).round()), blurRadius: 6, offset: const Offset(0,2)),
                  ],
                ),
                child: _pickedFile == null
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.folder_open, size: 40, color: Theme.of(context).colorScheme.primary),
                        const SizedBox(height: 8),
                        Text('Tap to select DPR document', style: TextStyle(color: Theme.of(context).textTheme.titleMedium?.color)),
                      ],
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.insert_drive_file, size: 36),
                        const SizedBox(height: 8),
                        Text(_pickedFile!.name),
                      ],
                    ),
              ),
            ),

            const SizedBox(height: 16),

            // Project Type
            Text('Project Type *', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  spacing: 8,
                  children: ['Road Construction','Healthcare','Tourism','Education','Infrastructure']
                    .map((type) => ChoiceChip(
                      label: Text(type),
                      selected: _projectType==type,
                      selectedColor: Theme.of(context).colorScheme.primary.withAlpha((0.12 * 255).round()),
                      onSelected: (_) => setState(() => _projectType = type),
                    )).toList(),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Document Type (DPR / UC)
            Text('Document Type', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  spacing: 8,
                  children: ['DPR','UC']
                    .map((t) => ChoiceChip(
                      label: Text(t),
                      selected: _docType==t,
                      onSelected: (_) => setState(() => _docType = t),
                    )).toList(),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Comments / Notes
            Text('Comments / Notes', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            TextFormField(controller: _commentCtrl, maxLines: 3, decoration: const InputDecoration(hintText: 'Optional notes for the reviewer or AI')),


            // Language
            Text('Document Language', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  spacing: 8,
                  children: ['English','Hindi','Assamese']
                    .map((lang) => ChoiceChip(
                      label: Text(lang),
                      selected: _language==lang,
                      selectedColor: Theme.of(context).colorScheme.primary.withAlpha((0.12 * 255).round()),
                      onSelected: (_) => setState(() => _language = lang),
                    )).toList(),
                ),
              ),
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                    child: ElevatedButton.icon(
                    onPressed: (_pickedFile!=null && _projectType!=null) ? () async {
                      // call analysis provider
                      final title = _pickedFile?.name ?? 'Uploaded Document';
                      final provider = context.read<AnalysisProvider>();
                      final result = await provider.analyzeDocument(title: title, docType: _docType, comment: _commentCtrl.text.isNotEmpty ? _commentCtrl.text : null);
                      // navigate to analysis screen for result
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => AnalysisScreen(result: result)));
                    } : null,
                    icon: const Icon(Icons.upload_file),
                    label: const Text('Upload & Start Assessment'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
