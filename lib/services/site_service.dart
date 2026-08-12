import 'package:osrc_plus/models/site_model.dart';

class SiteService {
  // TODO: Replace this map with Firestore collection 'sites'.
  static final Map<String, SiteModel> _sites = {};

  static Future<bool> addSite(SiteModel site) async {
    // Placeholder implementation.
    _sites[site.id] = site;
    return true;
  }

  static Future<List<SiteModel>> getSites() async {
    // TODO: Implement Firestore query.
    return _sites.values.toList();
  }

  static Future<SiteModel?> getSiteById(String id) async {
    return _sites[id];
  }

  static Future<bool> removeSite(String id) async {
    if (_sites.containsKey(id)) {
      _sites.remove(id);
      return true;
    }
    return false;
  }

  static Future<String?> uploadSiteImage(String siteId, String localPath) async {
    // TODO: Use Firebase Storage, e.g. FirebaseStorage.instance.ref('sites/$siteId/').putFile(file)
    // For now we only return the temp path so UI can manage preview/flow.
    if (!_sites.containsKey(siteId) || localPath.isEmpty) {
      return null;
    }

    // In a real app, save the uploaded URL later (FireStore doc update after Storage upload)
    return localPath;
  }
}


