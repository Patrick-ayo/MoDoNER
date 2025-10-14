import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/metric_card.dart';
import '../provider/admin_provider.dart';
import '../models/user.dart';

class AdminScreen extends StatefulWidget {
  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final _feedbackCtrl = TextEditingController();
  final _feedbackEmailCtrl = TextEditingController();
  final _contactEmailCtrl = TextEditingController();
  final _contactPhoneCtrl = TextEditingController();

  @override
  void dispose() {
    _feedbackCtrl.dispose();
    _feedbackEmailCtrl.dispose();
    _contactEmailCtrl.dispose();
    _contactPhoneCtrl.dispose();
    super.dispose();
  }

  Widget _buildOverview(BuildContext context) {
    // Use LayoutBuilder to create a responsive split that adapts to width
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      final columns = width > 900 ? 4 : (width > 600 ? 2 : 1);
      return GridView.count(
        crossAxisCount: columns,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        children: const [
          MetricCard(icon: Icons.cloud_done, title: 'Uptime', value: '99.8%', borderColor: Colors.green),
          MetricCard(icon: Icons.person, title: 'Active Users', value: '24', borderColor: Colors.blue),
          MetricCard(icon: Icons.queue, title: 'Queue', value: '7', borderColor: Colors.orange),
          MetricCard(icon: Icons.storage, title: 'Storage', value: '67%', borderColor: Color(0xFF059669)),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final admin = context.watch<AdminProvider>();

    // populate contact controllers when opening
    _contactEmailCtrl.text = admin.contactEmail;
    _contactPhoneCtrl.text = admin.contactPhone;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('System Administration', style: Theme.of(context).textTheme.displayMedium),
        const SizedBox(height: 8),
        Text('Manage users and settings', style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 24),

        Text('System Overview', style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 12),
        _buildOverview(context),

        const SizedBox(height: 24),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Left column: Access management & Backup
          Expanded(
            flex: 2,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Access Management', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(children: [
                    for (final u in admin.users)
                      ListTile(
                        title: Text(u.name),
                        subtitle: Text('${u.email} • ${u.role}'),
                        trailing: Wrap(spacing: 8, children: [
                          DropdownButton<String>(
                            value: u.role,
                            onChanged: (v) {
                              if (v != null) context.read<AdminProvider>().updateUserRole(u.id, v);
                            },
                            items: ['Admin', 'Editor', 'Viewer'].map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.redAccent),
                            onPressed: () => showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Confirm delete'),
                                content: Text('Delete user ${u.name}?'),
                                actions: [
                                  TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
                                  TextButton(onPressed: () {
                                    context.read<AdminProvider>().removeUser(u.id);
                                    Navigator.of(ctx).pop();
                                  }, child: const Text('Delete'))
                                ],
                              ),
                            ),
                          ),
                        ]),
                      ),
                    const SizedBox(height: 8),
                    Align(alignment: Alignment.centerRight, child: ElevatedButton.icon(onPressed: () {
                      // add a simple user for demo
                      final newUser = User(id: DateTime.now().millisecondsSinceEpoch.toString(), name: 'New User', email: 'new@example.com', role: 'Viewer');
                      context.read<AdminProvider>().addUser(newUser);
                    }, icon: const Icon(Icons.person_add), label: const Text('Add user'))),
                  ]),
                ),
              ),

              const SizedBox(height: 16),
              Text('Accuracy & Backup', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(children: [
                    const Text('Accuracy controls and backup operations.'),
                    const SizedBox(height: 8),
                    Row(children: [
                      ElevatedButton.icon(onPressed: () async {
                        final ok = await context.read<AdminProvider>().performBackup();
                        if (ok) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Backup completed')));
                      }, icon: const Icon(Icons.backup), label: const Text('Backup System')),
                      const SizedBox(width: 8),
                      OutlinedButton.icon(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Run accuracy check (mock)'))), icon: const Icon(Icons.check_circle_outline), label: const Text('Run Accuracy Check')),
                    ])
                  ]),
                ),
              ),
            ]),
          ),

          const SizedBox(width: 16),

          // Right column: Contact + Feedback
          Expanded(
            flex: 1,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Contact & Emergency', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(children: [
                    TextFormField(controller: _contactEmailCtrl, decoration: const InputDecoration(labelText: 'Support Email')),
                    const SizedBox(height: 8),
                    TextFormField(controller: _contactPhoneCtrl, decoration: const InputDecoration(labelText: 'Support Phone')),
                    const SizedBox(height: 12),
                    Align(alignment: Alignment.centerRight, child: ElevatedButton(onPressed: () {
                      context.read<AdminProvider>().updateContact(email: _contactEmailCtrl.text, phone: _contactPhoneCtrl.text);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Contact updated')));
                    }, child: const Text('Save'))),
                  ]),
                ),
              ),

              const SizedBox(height: 16),
              Text('Feedback', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(children: [
                    TextFormField(controller: _feedbackEmailCtrl, decoration: const InputDecoration(labelText: 'Your email (optional)')),
                    const SizedBox(height: 8),
                    TextFormField(controller: _feedbackCtrl, maxLines: 4, decoration: const InputDecoration(labelText: 'Message')),
                    const SizedBox(height: 12),
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      TextButton(onPressed: () { _feedbackCtrl.clear(); _feedbackEmailCtrl.clear(); }, child: const Text('Clear')),
                      const SizedBox(width: 8),
                      ElevatedButton(onPressed: () async {
                        final ok = await context.read<AdminProvider>().submitFeedback(_feedbackEmailCtrl.text, _feedbackCtrl.text);
                        if (ok) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Feedback submitted')));
                          _feedbackCtrl.clear();
                          _feedbackEmailCtrl.clear();
                        }
                      }, child: const Text('Send')),
                    ])
                  ]),
                ),
              ),
            ]),
          )
        ]),
      ]),
    );
  }
}
