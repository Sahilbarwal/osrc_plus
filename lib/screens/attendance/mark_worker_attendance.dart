import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:osrc_plus/models/attendance_hive_model.dart';
import 'package:osrc_plus/screens/attendance/add_advance_screen.dart';
import 'package:osrc_plus/screens/attendance/advance_history_screen.dart';
import 'package:osrc_plus/services/attendance_service.dart';
import 'package:osrc_plus/services/worker_data.dart';
import 'package:osrc_plus/utils/image_helper.dart';
import 'package:osrc_plus/utils/storage_helper.dart';

class MarkWorkerAttendance extends StatefulWidget {
  final String workerName;
  const MarkWorkerAttendance({super.key, required this.workerName});

  @override
  State<MarkWorkerAttendance> createState() => _MarkWorkerAttendanceState();
}

class _MarkWorkerAttendanceState extends State<MarkWorkerAttendance> {
  String selectedStatus = "Present";
  DateTime selectedDate = DateTime.now();
  File? capturedImage;
  
  final List<Map<String, dynamic>> attendanceRecords = [];

  String get formattedDate => DateFormat('yyyy-MM-dd').format(selectedDate);
  String get formattedTime => DateFormat('HH:mm').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    _loadAttendanceFromHive();
  }

  /// Load attendance records from Hive for the current worker
  Future<void> _loadAttendanceFromHive() async {
    try {
      // Fetch all records from Hive (to get keys)
      final box = Hive.box<AttendanceHiveModel>('attendanceBox');
      
      if (mounted) {
        setState(() {
          // Clear existing records and populate with Hive data
          attendanceRecords.clear();
          
          // Iterate through box entries to get both key and value
          for (int i = 0; i < box.length; i++) {
            final record = box.getAt(i);
            if (record != null && record.name == widget.workerName) {
              // Load image file if path exists
              File? imageFile;
              if (record.imagePath.isNotEmpty) {
                imageFile = File(record.imagePath);
                // Check if file exists before adding
                if (!imageFile.existsSync()) {
                  imageFile = null;
                }
              }
              
              attendanceRecords.add({
                'key': i, // Store Hive key for deletion
                'name': record.name,
                'date': record.date,
                'time': record.time,
                'status': '', // Status not stored in Hive, keep empty
                'image': imageFile,
                'imagePath': record.imagePath,
              });
            }
          }
        });
      }
    } catch (e) {
      debugPrint('Error loading attendance from Hive: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading attendance: $e')),
        );
      }
    }
  }

  /// Delete a single attendance record from Hive and update UI
  Future<void> _deleteAttendanceRecord(int key) async {
    try {
      await AttendanceService.deleteAttendance(key);
      
      if (mounted) {
        // Remove from local list and rebuild UI
        await _loadAttendanceFromHive();
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Record deleted successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting record: $e')),
        );
      }
    }
  }

  /// Show confirmation dialog before deleting
  void _showDeleteConfirmation(int key, String date, String time) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1F1F1F),
        title: const Text(
          'Delete Record?',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Delete attendance record from $date at $time?\nThis action cannot be undone.',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFFD4AF37)),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteAttendanceRecord(key);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2035),
    );
    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  Future<void> markAttendanceWithImage() async {
    // Capture image from camera
    File? image = await ImageHelper.captureImageFromCamera();
    
    if (image != null) {
      // Save image locally using StorageHelper
      String? savedImagePath = await StorageHelper.saveAttendanceImage(image.path);
      
      if (savedImagePath != null) {
        setState(() => capturedImage = File(savedImagePath));
        
        // Add to local in-memory list for UI display
        attendanceRecords.add({
          'name': widget.workerName,
          'date': formattedDate,
          'time': formattedTime,
          'status': selectedStatus,
          'image': File(savedImagePath),
          'imagePath': savedImagePath,
        });
        
        // Save to Hive (persistent local storage)
        try {
          await AttendanceService.saveAttendance(
            name: widget.workerName,
            date: formattedDate,
            time: formattedTime,
            imagePath: savedImagePath,
          );

          // Also save to WorkerData for legacy compatibility
          WorkerData.markAttendance(widget.workerName, formattedDate, selectedStatus);
          
          // Reload attendance records from Hive to update UI
          await _loadAttendanceFromHive();
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Attendance recorded with image on $formattedDate")),
            );
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Error saving attendance: $e")),
            );
          }
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to save image")),
        );
      }
    }
  }

  void saveAttendance() async {
    // Save to WorkerData for legacy compatibility
    WorkerData.markAttendance(widget.workerName, formattedDate, selectedStatus);
    
    // Save to Hive with empty image path (no image captured)
    try {
      await AttendanceService.saveAttendance(
        name: widget.workerName,
        date: formattedDate,
        time: formattedTime,
        imagePath: '', // No image for this record
      );

      // Reload attendance records from Hive to update UI
      await _loadAttendanceFromHive();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Saved $selectedStatus on $formattedDate")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error saving attendance: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final category = WorkerData.getWorkerCategory(widget.workerName);

    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0B),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.workerName),
            Text(
              category,
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFD4AF37),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Selector
            Row(
              children: [
                const Text("Date:", style: TextStyle(color: Colors.white)),
                const SizedBox(width: 8),
                Text(
                  formattedDate,
                  style: const TextStyle(
                    color: Color(0xFFD4AF37),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: pickDate,
                  child: const Text(
                    "Change Date",
                    style: TextStyle(color: Color(0xFFD4AF37)),
                  ),
                )
              ],
            ),
            const SizedBox(height: 15),

            // Attendance Status
            _buildRadio("Present"),
            _buildRadio("Absent"),
            _buildRadio("Half Day"),

            const SizedBox(height: 15),

            // Captured Image Preview
            if (capturedImage != null) ...[
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFD4AF37)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Captured Image:",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: _buildImageWidget(capturedImage!),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
            ],

            // Action Buttons
            _buildButton("Capture with Camera", markAttendanceWithImage, color: Colors.green),
            _buildButton("Save Attendance", saveAttendance, color: Colors.blue),
            _buildButton("Add Advance", () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddAdvanceScreen(workerName: widget.workerName),
                ),
              );
            }),
            _buildButton("Advance History", () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AdvanceHistoryScreen(workerName: widget.workerName),
                ),
              );
            }),

            const SizedBox(height: 15),

            // Attendance Records
            Text(
              "Attendance Records (${attendanceRecords.length})",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: attendanceRecords.isEmpty
                  ? const Center(
                      child: Text(
                        "No records yet",
                        style: TextStyle(color: Colors.white70),
                      ),
                    )
                  : ListView.builder(
                      itemCount: attendanceRecords.length,
                      itemBuilder: (context, index) {
                        final record = attendanceRecords[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1F1F1F),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFD4AF37), width: 0.5),
                          ),
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: record['image'] != null
                                  ? SizedBox(
                                      width: 50,
                                      height: 50,
                                      child: _buildImageWidget(
                                        record['image'] as File,
                                        width: 50,
                                        height: 50,
                                      ),
                                    )
                                  : Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFD4AF37),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Icon(
                                        Icons.image_not_supported,
                                        color: Colors.black,
                                      ),
                                    ),
                            ),
                            title: Text(
                              record['name'] as String,
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              "${record['date']} at ${record['time']} - ${record['status']}",
                              style: const TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () => _showDeleteConfirmation(
                                record['key'] as int,
                                record['date'] as String,
                                record['time'] as String,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadio(String value) {
    return RadioListTile<String>(
      title: Text(value, style: const TextStyle(color: Colors.white)),
      value: value,
      groupValue: selectedStatus,
      activeColor: const Color(0xFFD4AF37),
      onChanged: (val) {
        if (val != null) {
          setState(() => selectedStatus = val);
        }
      },
    );
  }

  Widget _buildButton(
    String text,
    VoidCallback onTap, {
    Color color = const Color(0xFFD4AF37),
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          onPressed: onTap,
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  /// Builds image widget with proper error handling and persistence.
  /// 
  /// Loads image from file path and handles file not found errors.
  /// Images persist across widget rebuilds.
  Widget _buildImageWidget(
    File imageFile, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
  }) {
    return Image.file(
      imageFile,
      width: width ?? double.infinity,
      height: height ?? 120,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: width ?? double.infinity,
          height: height ?? 120,
          decoration: BoxDecoration(
            color: const Color(0xFF2a2a2a),
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: Colors.red, size: 30),
              SizedBox(height: 8),
              Text(
                "Failed to load image",
                style: TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ],
          ),
        );
      },
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        // Ensures smooth image loading with proper frame rebuilding
        return child;
      },
    );
  }
}