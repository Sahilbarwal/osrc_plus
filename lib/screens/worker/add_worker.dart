import 'package:flutter/material.dart';
import 'package:osrc_plus/services/worker_data.dart';
import 'package:osrc_plus/widgets/widgets.dart';

class AddWorkerScreen extends StatefulWidget {
  const AddWorkerScreen({super.key});

  @override
  State<AddWorkerScreen> createState() => _AddWorkerScreenState();
}

class _AddWorkerScreenState extends State<AddWorkerScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _salaryController = TextEditingController();
  String _selectedCategory = "Labour";

  static const List<String> _categories = [
    "Labour",
    "Electrician",
    "Carpenter",
    "Mason",
    "Plumber",
    "Painter",
    "Supervisor",
    "Other"
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _salaryController.dispose();
    super.dispose();
  }

  void _saveWorker() {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final salaryText = _salaryController.text.trim();
    final salary = double.tryParse(salaryText) ?? 0.0;

    if (name.isNotEmpty && salary > 0) {
      WorkerData.addWorker(name, phone, salary, _selectedCategory);
      // Clear fields
      _nameController.clear();
      _phoneController.clear();
      _salaryController.clear();
      setState(() {});
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter valid name and salary")),
      );
    }
  }

  void _showAddWorkerDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1F1F1F),
        title: const Text('Add New Worker', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
              controller: _nameController,
              labelText: 'Worker Name',
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _phoneController,
              labelText: 'Phone',
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _salaryController,
              labelText: 'Salary per Day',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Category',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFD4AF37)),
                ),
              ),
              dropdownColor: const Color(0xFF1F1F1F),
              items: _categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category, style: const TextStyle(color: Colors.white)),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedCategory = value);
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: _saveWorker,
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD4AF37)),
            child: const Text('Add', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0B),
      appBar: AppBar(
        title: const Text('Workers'),
        backgroundColor: const Color(0xFFD4AF37),
      ),
      body: WorkerData.workers.isEmpty
          ? const Center(
              child: Text(
                'No workers added yet.\nTap + to add a worker.',
                style: TextStyle(color: Colors.white60, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            )
          : ListView.builder(
              itemCount: WorkerData.workers.length,
              itemBuilder: (context, index) {
                final worker = WorkerData.workers[index];
                final category = WorkerData.getWorkerCategory(worker.name);
                return ListTile(
                  title: Text(worker.name, style: const TextStyle(color: Colors.white)),
                  subtitle: Text(
                    '${worker.phone.isNotEmpty ? worker.phone : 'No phone'} • Salary: \$${worker.salaryPerDay.toStringAsFixed(2)}/day • $category',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  leading: const Icon(Icons.person, color: Color(0xFFD4AF37)),
                  tileColor: const Color(0xFF1F1F1F),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddWorkerDialog,
        backgroundColor: const Color(0xFFD4AF37),
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}