import 'package:osrc_plus/models/site_model.dart';

import 'package:osrc_plus/models/site_model.dart';
import 'package:osrc_plus/models/user_model.dart';

class WorkerData {
  static List<UserModel> workers = [];
  static Map<String, String> workerCategories = {};
  static Map<String, Map<String, String>> attendance = {};
  static Map<String, List<Map<String, dynamic>>> advances = {};

  static List<SiteModel> sites = [];
  static Map<String, List<String>> siteImages = {};
  static Map<String, List<String>> siteVideos = {};

  // New list for attendance records with time
  static List<Map<String, dynamic>> attendanceRecords = [];

  static void addWorker(String name, String phone, double salaryPerDay, String category) {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) return;
    final worker = UserModel(
      id: trimmedName,
      name: trimmedName,
      phone: phone.trim(),
      role: 'worker',
      salaryPerDay: salaryPerDay,
      assignedSite: null,
    );
    if (!workers.any((w) => w.id == trimmedName)) {
      workers.add(worker);
      workerCategories[trimmedName] = category;
    }
  }

  static void addSite(String siteName, {String? location}) {
    final name = siteName.trim();
    if (name.isEmpty) return;
    final site = SiteModel(
      id: name,
      siteName: name,
      location: location,
    );
    if (!sites.any((s) => s.id == name)) {
      sites.add(site);
    }
  }

  static void addSiteImage(String siteName, String imageUrl) {
    final site = siteName.trim();
    final url = imageUrl.trim();
    if (site.isEmpty || url.isEmpty) return;
    addSite(site); // This will add if not exists
    siteImages.putIfAbsent(site, () => []);
    if (!siteImages[site]!.contains(url)) {
      siteImages[site]!.add(url);
    }
  }

  static void addSiteVideo(String siteName, String videoUrl) {
    final site = siteName.trim();
    final url = videoUrl.trim();
    if (site.isEmpty || url.isEmpty) return;
    addSite(site);
    siteVideos.putIfAbsent(site, () => []);
    if (!siteVideos[site]!.contains(url)) {
      siteVideos[site]!.add(url);
    }
  }

  static List<String> getSiteImages(String siteName) => siteImages[siteName.trim()] ?? [];
  static List<String> getSiteVideos(String siteName) => siteVideos[siteName.trim()] ?? [];
  static List<Map<String, dynamic>> getAttendanceRecordsForUser(String name) {
    return attendanceRecords.where((record) => record['name'] == name).toList();
  }

  static Map<String, String> getAttendanceMapForUser(String name) => attendance[name] ?? {};

  static String getWorkerCategory(String name) => workerCategories[name] ?? "Uncategorized";

  static void markAttendance(String name, String date, String status) {
    attendance.putIfAbsent(name, () => {});
    attendance[name]![date] = status;

    // Add to records list with time
    final now = DateTime.now();
    final time = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    attendanceRecords.add({
      'name': name,
      'date': date,
      'time': time,
      'status': status,
    });
  }

  static Map<String, int> getAttendanceDays(String name, DateTime from, DateTime to) {
    int present = 0, half = 0;
    final records = attendance[name] ?? {};
    for (final entry in records.entries) {
      final date = DateTime.tryParse(entry.key);
      if (date != null && !date.isBefore(from) && !date.isAfter(to)) {
        if (entry.value == "Present") present++;
        else if (entry.value == "Half Day") half++;
      }
    }
    return {'present': present, 'half': half};
  }

  static int getPresentDays(String name) {
    return getAttendanceDays(name, DateTime(2023), DateTime(2035))['present']!;
  }

static void addAdvance(String workerName, double amount, {String? note}) {
  advances.putIfAbsent(workerName, () => []);
  advances[workerName]!.add({
    'amount': amount,
    'date': DateTime.now().toIso8601String(),
    'note': (note?.trim() ?? '').isNotEmpty ? note!.trim() : null,
  });
}

  static List<Map<String, dynamic>> getAdvanceHistory(String name) => advances[name] ?? [];

  static double getTotalAdvance(String name) {
    double total = 0.0;
    for (var record in getAdvanceHistory(name)) {
      if (record['amount'] is num) total += (record['amount'] as num).toDouble();
    }
    return total;
  }
}