import 'package:flutter/foundation.dart';
import 'package:osrc_plus/models/site_model.dart';
import 'package:osrc_plus/services/worker_data.dart';

class SiteProvider extends ChangeNotifier {
  List<SiteModel> get sites => WorkerData.sites;

  void addSite(String siteName, {String? location}) {
    WorkerData.addSite(siteName, location: location);
    notifyListeners();
  }

  List<String> siteImages(String siteName) => WorkerData.getSiteImages(siteName);
  List<String> siteVideos(String siteName) => WorkerData.getSiteVideos(siteName);

  void addImage(String siteName, String imageUrl) {
    WorkerData.addSiteImage(siteName, imageUrl);
    notifyListeners();
  }

  void addVideo(String siteName, String videoUrl) {
    WorkerData.addSiteVideo(siteName, videoUrl);
    notifyListeners();
  }
}
