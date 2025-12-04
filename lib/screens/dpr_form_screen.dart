import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../models/project.dart';
import '../models/dpr.dart';
import '../providers/dpr_provider.dart';

class DprFormScreen extends StatefulWidget {
  static const routeName = '/dpr-form';
  const DprFormScreen({super.key});

  @override
  State<DprFormScreen> createState() => _DprFormScreenState();
}

class _DprFormScreenState extends State<DprFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descCtrl = TextEditingController();
  final _workerCtrl = TextEditingController();
  DateTime _date = DateTime.now();
  String _weather = 'Sunny';
  Project? _selectedProject;
  final _picker = ImagePicker();
  final List<XFile> _images = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arg = ModalRoute.of(context)?.settings.arguments;
    if (arg is Project && _selectedProject == null) {
      _selectedProject = arg;
    } else {
      // Default to first project if none passed
      final projects = context.read<DprProvider>().projects;
      _selectedProject = projects.isNotEmpty ? projects.first : null;
    }
  }

  @override
  void dispose() {
    _descCtrl.dispose();
    _workerCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final remaining = 3 - _images.length;
    if (remaining <= 0) return;
    final picked = await _picker.pickMultiImage(imageQuality: 75);
    if (picked.isNotEmpty) {
      setState(() {
        _images.addAll(picked.take(remaining));
      });
    }
  }

  void _removeImage(int index) {
    setState(() => _images.removeAt(index));
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 1),
      initialDate: _date,
    );
    if (picked != null) setState(() => _date = picked);
  }

  void _submit() {
    if (_selectedProject == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No project selected')),
      );
      return;
    }
    if (!_formKey.currentState!.validate()) return;

    final dpr = Dpr(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      projectId: _selectedProject!.id,
      date: _date,
      weather: _weather,
      workDescription: _descCtrl.text.trim(),
      workerCount: int.parse(_workerCtrl.text),
      imagePaths: _images.map((x) => x.path).toList(),
    );

    context.read<DprProvider>().addDpr(dpr);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('DPR submitted successfully')),
    );

    setState(() {
      _descCtrl.clear();
      _workerCtrl.clear();
      _images.clear();
      _date = DateTime.now();
      _weather = 'Sunny';
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DprProvider>();
    final projects = provider.projects;
    final history = _selectedProject == null
        ? const <Dpr>[]
        : provider.dprsByProject(_selectedProject!.id);

    return Scaffold(
      appBar: AppBar(title: const Text('DPR Form')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          LayoutBuilder(builder: (context, constraints) {
                            const gap = 12.0;
                            final isWide = constraints.maxWidth >= 600;
                            final left = DropdownButtonFormField<Project>(
                              value: _selectedProject,
                              items: projects
                                  .map((p) => DropdownMenuItem(
                                        value: p,
                                        child: Text(p.name),
                                      ))
                                  .toList(),
                              onChanged: (p) => setState(() {
                                _selectedProject = p;
                              }),
                              decoration: const InputDecoration(
                                labelText: 'Project',
                              ),
                              validator: (v) =>
                                  v == null ? 'Please select a project' : null,
                            );
                            final right = InkWell(
                              onTap: _pickDate,
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  labelText: 'Date',
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(_formatDate(_date)),
                                    const Icon(Icons.calendar_today),
                                  ],
                                ),
                              ),
                            );
                            if (isWide) {
                              return Row(
                                children: [
                                  Expanded(child: left),
                                  const SizedBox(width: gap),
                                  Expanded(child: right),
                                ],
                              );
                            }
                            return Column(
                              children: [
                                left,
                                const SizedBox(height: gap),
                                right,
                              ],
                            );
                          }),
                          const SizedBox(height: 12),
                          LayoutBuilder(builder: (context, constraints) {
                            const gap = 12.0;
                            final isWide = constraints.maxWidth >= 600;
                            final left = DropdownButtonFormField<String>(
                              value: _weather,
                              items: const [
                                'Sunny',
                                'Cloudy',
                                'Rainy',
                                'Windy',
                              ]
                                  .map(
                                    (w) => DropdownMenuItem(
                                      value: w,
                                      child: Text(w),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (w) => setState(() => _weather = w!),
                              decoration: const InputDecoration(
                                labelText: 'Weather',
                              ),
                            );
                            final right = TextFormField(
                              controller: _workerCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Worker Count',
                                prefixIcon: Icon(Icons.people_outline),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) {
                                  return 'Worker count is required';
                                }
                                final n = int.tryParse(v);
                                if (n == null || n <= 0) {
                                  return 'Enter a valid positive number';
                                }
                                return null;
                              },
                            );
                            if (isWide) {
                              return Row(
                                children: [
                                  Expanded(child: left),
                                  const SizedBox(width: gap),
                                  Expanded(child: right),
                                ],
                              );
                            }
                            return Column(
                              children: [
                                left,
                                const SizedBox(height: gap),
                                right,
                              ],
                            );
                          }),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _descCtrl,
                            maxLines: 4,
                            decoration: const InputDecoration(
                              labelText: 'Work Description',
                              alignLabelWithHint: true,
                            ),
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? 'Description is required'
                                : null,
                          ),
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                FilledButton.icon(
                                  onPressed: _images.length >= 3 ? null : _pickImages,
                                  icon: const Icon(Icons.photo_library_outlined),
                                  label: Text('Add Photos (${_images.length}/3)'),
                                ),
                                ...List.generate(_images.length, (i) {
                                  final file = File(_images[i].path);
                                  return Stack(
                                    alignment: Alignment.topRight,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.file(
                                          file,
                                          width: 90,
                                          height: 90,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      IconButton(
                                        style: IconButton.styleFrom(
                                          backgroundColor:
                                              Theme.of(context).colorScheme.surface,
                                        ),
                                        onPressed: () => _removeImage(i),
                                        icon: const Icon(Icons.close),
                                      )
                                    ],
                                  );
                                })
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton.icon(
                              onPressed: _submit,
                              icon: const Icon(Icons.send),
                              label: const Text('Submit'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Submitted DPR History',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                if (history.isEmpty)
                  const Text('No DPRs yet. Submissions will appear here.')
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: history.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, i) {
                      final d = history[i];
                      return ListTile(
                        tileColor: Theme.of(context).colorScheme.surface,
                        title: Text('${_formatDate(d.date)} • ${d.weather} • Workers: ${d.workerCount}'),
                        subtitle: Text(d.workDescription),
                        trailing: d.imagePaths.isEmpty
                            ? null
                            : CircleAvatar(
                                radius: 14,
                                child: Text('${d.imagePaths.length}'),
                              ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime d) => '${d.day.toString().padLeft(2, '0')}-${d.month.toString().padLeft(2, '0')}-${d.year}';
}
