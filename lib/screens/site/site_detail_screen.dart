import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:osrc_plus/services/site_service.dart';
import 'package:osrc_plus/services/worker_data.dart';

class SiteDetailScreen extends StatefulWidget {
  final String siteName;

  const SiteDetailScreen({super.key, required this.siteName});

  @override
  State<SiteDetailScreen> createState() => _SiteDetailScreenState();
}

class _SiteDetailScreenState extends State<SiteDetailScreen> {
  final ImagePicker _picker = ImagePicker();
  String? _pickedImagePath;
  bool _isUploading = false;
  String? _uploadResultUrl;

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source, imageQuality: 85);
    if (image != null) {
      _pickedImagePath = image.path;
      _uploadResultUrl = null;
      WorkerData.addSiteImage(widget.siteName, image.path);
      setState(() {});
    }
  }

  Future<void> _uploadSelectedImage() async {
    if (_pickedImagePath == null) return;

    setState(() => _isUploading = true);
    final uploaded = await SiteService.uploadSiteImage(widget.siteName, _pickedImagePath!);
    setState(() {
      _isUploading = false;
      _uploadResultUrl = uploaded;
    });

    final snackBar = SnackBar(
      content: Text(uploaded != null
          ? 'Image ready for upload at: $uploaded'
          : 'Upload preparation failed. Please retry.'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _pickVideo(ImageSource source) async {
    final XFile? video = await _picker.pickVideo(source: source);
    if (video != null) {
      WorkerData.addSiteVideo(widget.siteName, video.path);
      setState(() {});
    }
  }

  void _showAddMediaDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1F1F1F),
        title: const Text('Add Media', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Pick Image from Gallery', style: TextStyle(color: Colors.white)),
              leading: const Icon(Icons.photo_library, color: Color(0xFFD4AF37)),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              title: const Text('Take Image with Camera', style: TextStyle(color: Colors.white)),
              leading: const Icon(Icons.camera_alt, color: Color(0xFFD4AF37)),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              title: const Text('Pick Video from Gallery', style: TextStyle(color: Colors.white)),
              leading: const Icon(Icons.video_library, color: Color(0xFFD4AF37)),
              onTap: () {
                Navigator.of(context).pop();
                _pickVideo(ImageSource.gallery);
              },
            ),
            ListTile(
              title: const Text('Record Video with Camera', style: TextStyle(color: Colors.white)),
              leading: const Icon(Icons.videocam, color: Color(0xFFD4AF37)),
              onTap: () {
                Navigator.of(context).pop();
                _pickVideo(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final images = WorkerData.getSiteImages(widget.siteName);
    final videos = WorkerData.getSiteVideos(widget.siteName);

    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0B),
      appBar: AppBar(
        title: Text(widget.siteName),
        backgroundColor: const Color(0xFFD4AF37),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_pickedImagePath != null) ...[
              const Text('Preview Selected Image', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              AspectRatio(
                aspectRatio: 16 / 9,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(File(_pickedImagePath!), fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.cloud_upload, color: Colors.black),
                      label: const Text('Prepare Upload', style: TextStyle(color: Colors.black)),
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD4AF37)),
                      onPressed: _isUploading ? null : _uploadSelectedImage,
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (_isUploading)
                    const SizedBox(height: 36, width: 36, child: CircularProgressIndicator(color: Color(0xFFD4AF37))),
                ],
              ),
              if (_uploadResultUrl != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Upload placeholder URL: $_uploadResultUrl',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
              const SizedBox(height: 20),
            ],

            const Text('Images', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (images.isEmpty)
              const Text('No images added yet', style: TextStyle(color: Colors.white60))
            else
              ...images.map((img) => ListTile(
                    title: Text(img, style: const TextStyle(color: Colors.white)),
                    leading: const Icon(Icons.image, color: Color(0xFFD4AF37)),
                    tileColor: const Color(0xFF1F1F1F),
                  )),
            const SizedBox(height: 20),
            const Text('Videos', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (videos.isEmpty)
              const Text('No videos added yet', style: TextStyle(color: Colors.white60))
            else
              ...videos.map((vid) => ListTile(
                    title: Text(vid, style: const TextStyle(color: Colors.white)),
                    leading: const Icon(Icons.videocam, color: Color(0xFFD4AF37)),
                    tileColor: const Color(0xFF1F1F1F),
                  )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddMediaDialog,
        backgroundColor: const Color(0xFFD4AF37),
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}