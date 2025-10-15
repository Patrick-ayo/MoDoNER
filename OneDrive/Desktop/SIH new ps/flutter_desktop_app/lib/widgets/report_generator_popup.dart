import 'package:flutter/material.dart';

class ReportGeneratorPopup extends StatefulWidget {
  const ReportGeneratorPopup({super.key});

  @override
  State<ReportGeneratorPopup> createState() => _ReportGeneratorPopupState();
}

class _ReportGeneratorPopupState extends State<ReportGeneratorPopup> {
  // Mock data for the file list
  final List<Map<String, dynamic>> _files = [
    {'name': 'DPR_Project_Alpha_2024.pdf', 'type': 'PDF', 'size': '5.2 MB'},
    {'name': 'Q2_Financials.xlsx', 'type': 'Excel', 'size': '1.1 MB'},
    {'name': 'Safety_Audit_Report.docx', 'type': 'Document', 'size': '0.8 MB'},
    {'name': 'Compliance_Checklist.csv', 'type': 'CSV', 'size': '120 KB'},
    {'name': 'NH-152_Corridor_Details.pdf', 'type': 'PDF', 'size': '3.5 MB'},
    {'name': 'Timeline_Update.pptx', 'type': 'PPT', 'size': '2.4 MB'},
  ];

  // State to track selected files
  final List<String> _selectedFiles = [];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 400,
        height: 500,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Select Reports', style: Theme.of(context).textTheme.headlineSmall),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.of(context).pop()),
              ],
            ),
            const Divider(height: 1.0),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _files.length,
                itemBuilder: (context, index) {
                  final file = _files[index];
                  final isSelected = _selectedFiles.contains(file['name']);
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Checkbox(
                      value: isSelected,
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            _selectedFiles.add(file['name']);
                          } else {
                            _selectedFiles.remove(file['name']);
                          }
                        });
                      },
                    ),
                    title: Text(file['name']!, style: Theme.of(context).textTheme.bodyLarge),
                    subtitle: Text('${file['type']} • ${file['size']!}', style: Theme.of(context).textTheme.bodySmall),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedFiles.isEmpty
                    ? null
                    : () {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Generating report for: ${_selectedFiles.join(', ')}')),
                        );
                      },
                child: const Text('Generate Report'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}