import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:osrc_plus/services/worker_data.dart';
import 'package:osrc_plus/screens/site/site_detail_screen.dart';

class AddSiteScreen extends StatefulWidget {
  const AddSiteScreen({super.key});

  @override
  State<AddSiteScreen> createState() => _AddSiteScreenState();
}

class _AddSiteScreenState extends State<AddSiteScreen> {
  final _siteNameController = TextEditingController();
  final _locationController = TextEditingController();

  void _addSite() async {
    final name = _siteNameController.text.trim();
    final location = _locationController.text.trim();
    if (name.isEmpty) return;

    WorkerData.addSite(name, location: location.isNotEmpty ? location : null);
    _siteNameController.clear();
    _locationController.clear();
    setState(() {});
    Navigator.of(context).pop();
  }

  void _showAddSiteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1F1F1F),
        title: const Text('Add New Site', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _siteNameController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Site Name',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFD4AF37))),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _locationController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Location (optional)',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFD4AF37))),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: _addSite,
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD4AF37)),
            child: const Text('Add', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _siteNameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0B),
      appBar: AppBar(
        title: const Text('Sites'),
        backgroundColor: const Color(0xFFD4AF37),
      ),
      body: WorkerData.sites.isEmpty
          ? const Center(
              child: Text(
                'No sites added yet.\nTap + to add a site.',
                style: TextStyle(color: Colors.white60, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            )
          : ListView.builder(
              itemCount: WorkerData.sites.length,
              itemBuilder: (context, index) {
                final site = WorkerData.sites[index];
                return ListTile(
                  title: Text(site.siteName, style: const TextStyle(color: Colors.white)),
                  subtitle: site.location != null ? Text(site.location!, style: const TextStyle(color: Colors.white70)) : null,
                  leading: const Icon(Icons.folder, color: Color(0xFFD4AF37)),
                  tileColor: const Color(0xFF1F1F1F),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SiteDetailScreen(siteName: site.siteName),
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddSiteDialog,
        backgroundColor: const Color(0xFFD4AF37),
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}