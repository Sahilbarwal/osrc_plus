import 'package:flutter/material.dart';
import 'package:osrc_plus/services/worker_data.dart';

class AddAdvanceScreen extends StatefulWidget {
  final String workerName;
  const AddAdvanceScreen({super.key, required this.workerName});

  @override
  State<AddAdvanceScreen> createState() => _AddAdvanceScreenState();
}

class _AddAdvanceScreenState extends State<AddAdvanceScreen> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _saveAdvance() {
    final amountStr = _amountController.text.trim();
    final note = _noteController.text.trim();
    final amount = double.tryParse(amountStr);

    if (amount != null && amount > 0) {
      WorkerData.addAdvance(
        widget.workerName,
        amount,
        note: note.isEmpty ? null : note,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Advance Added: ₹${amount.toStringAsFixed(2)}")),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0B),
      appBar: AppBar(
        title: Text("Add Advance - ${widget.workerName}"),
        backgroundColor: const Color(0xFFD4AF37),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Amount (₹)",
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFD4AF37)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _noteController,
              style: const TextStyle(color: Colors.white),
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: "Reason (Optional)",
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFD4AF37)),
                ),
                hintText: "e.g., Medical emergency",
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveAdvance,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD4AF37),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text(
                "Add Advance",
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}