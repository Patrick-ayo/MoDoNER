import 'package:flutter/material.dart';

// Helper widget for a single note item
class _NoteItem extends StatelessWidget {
  final String text;
  final String user;
  final String date;

  const _NoteItem({required this.text, required this.user, required this.date});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      color: Theme.of(context).cardColor,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(text, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 4),
            Text(
              'by $user on $date',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}

// The pop-up widget that displays the list of notes
class NotesListPopup extends StatelessWidget {
  final List<Map<String, dynamic>> notes;

  const NotesListPopup({super.key, required this.notes});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Project Notes', style: Theme.of(context).textTheme.headlineSmall),
      content: SizedBox(
        width: 400, // Fixed width for a good dialog size
        height: 400,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final note = notes[index];
                  return _NoteItem(
                    text: note['text'],
                    user: note['user'],
                    date: note['date'],
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              maxLines: null,
              decoration: InputDecoration(
                hintText: 'Add a new note...',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    // TODO: Implement note adding logic
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),
            // SizedBox(
            //   width: double.infinity,
            //   child: ElevatedButton(
            //     onPressed: () {
            //       // TODO: Implement note adding logic
            //     },
            //     child: const Text('Add Note'),
            //   ),
            // ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}

// The button widget that triggers the pop-up
class NotesButton extends StatelessWidget {
  final List<Map<String, dynamic>> notes;

  const NotesButton({super.key, required this.notes});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => NotesListPopup(notes: notes),
        );
      },
      icon: const Icon(Icons.note_add),
      label: const Text('Add/View Notes'),
    );
  }
}